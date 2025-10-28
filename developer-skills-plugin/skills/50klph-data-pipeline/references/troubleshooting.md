# Troubleshooting the Data Pipeline

## Common Issues and Solutions

### Issue 1: "Logs Not Showing in Dashboard"

**Symptoms:**
- Job is running but logs panel is empty
- `/jobs/{job_id}/logs` returns empty array

**Diagnosis Steps:**

1. **Check if job is actually running:**
   ```bash
   # Check database for job status
   sqlite3 workflow.db "SELECT id, status, current_phase FROM jobs WHERE id = {job_id};"
   ```

2. **Check if logs are being captured:**
   ```bash
   # Check log_entries table
   sqlite3 workflow.db "SELECT COUNT(*) FROM log_entries WHERE job_id = {job_id};"
   ```

3. **Check executor agent status:**
   - Look for executor logs in backend console
   - Should see: "✓ Job Executor V2 started"
   - Should see: "📝 Starting job {job_id}: ..."

**Common Causes:**

- **Executor not running**: Backend didn't start executor agent
  - **Fix**: Check `src/api/main.py` includes `executor_v2_loop()` in startup

- **Subprocess failed silently**: Script crashed but executor didn't catch it
  - **Fix**: Check `job.error_message` field in database

- **Transaction rollback**: Logs parsed but not committed
  - **Fix**: Check for exceptions in `log_service.create_log()`

### Issue 2: "Generated Files Not Appearing in Artifacts Viewer"

**Symptoms:**
- Script completed successfully
- Files exist in `generated_projects/{project}/`
- Artifacts viewer shows "No files found"

**Diagnosis Steps:**

1. **Verify files exist:**
   ```bash
   ls -la generated_projects/{project}/
   ```

2. **Check artifact scanner:**
   ```bash
   # Check artifacts table
   sqlite3 workflow.db "SELECT COUNT(*) FROM artifacts WHERE file_path LIKE '%{project}%';"
   ```

3. **Check scanner logs:**
   - Look for: "🔍 Scanning artifacts in: ..."
   - Look for: "✓ Artifacts scan complete"

**Common Causes:**

- **Path mismatch**: Scanner looking in wrong directory
  - **Fix**: Check `artifact_service.py` line 32 - path calculation
  - Should be 4 levels up: `service_file.parent.parent.parent.parent`

- **Scanner not running**: Artifact scanner agent didn't start
  - **Fix**: Check `src/api/main.py` includes `artifact_scanner_loop()` in startup

- **Files in excluded directory**: Scanner skips `node_modules`, `venv`, etc.
  - **Fix**: Check file isn't in excluded directories (line 88 of artifact_service.py)

### Issue 3: "Dashboard Not Updating in Real-Time"

**Symptoms:**
- Data exists in database
- Manual refresh shows new data
- SSE stream not updating automatically

**Diagnosis Steps:**

1. **Check SSE connection:**
   - Open browser DevTools → Network tab
   - Filter for "EventSource" or look for `/streams/` requests
   - Should see status "pending" with ongoing transfer

2. **Check stream messages:**
   ```bash
   sqlite3 workflow.db "SELECT * FROM stream_messages ORDER BY created_at DESC LIMIT 10;"
   ```

3. **Check for CORS issues:**
   - Look for CORS errors in browser console
   - Backend should allow frontend origin

**Common Causes:**

- **Client not subscribed**: Frontend not calling `useEventSource()`
  - **Fix**: Check component uses `use-event-source.ts` hook

- **SSE keepalive timeout**: Connection dropped due to inactivity
  - **Fix**: Stream service sends keepalive every 15s (stream_service.py line 169)

- **Message not being broadcast**: Logs stored in DB but not pushed to queue
  - **Fix**: Check `stream_service.broadcast_message()` is being called

### Issue 4: "Phase Not Updating"

**Symptoms:**
- Job shows stuck in one phase
- Logs indicate work is progressing
- `job.current_phase` not changing

**Diagnosis Steps:**

1. **Check phase detection patterns:**
   - Executor uses regex to detect phases (executor_v2.py lines 46-54)
   - Example: `/(?:implementing|implementation|/speckit\.implement)/i`

2. **Check logs for phase keywords:**
   ```bash
   sqlite3 workflow.db "SELECT message FROM log_entries WHERE job_id = {job_id} ORDER BY timestamp DESC;"
   # Look for "specifying", "planning", "implementing", etc.
   ```

**Common Causes:**

- **Phase keywords not in logs**: Script output doesn't match patterns
  - **Fix**: Update phase patterns in executor_v2.py

- **Job not being updated**: Phase detected but database not updated
  - **Fix**: Check `job_service.update_job()` is called with new phase

### Issue 5: "Logs Overwhelming Frontend"

**Symptoms:**
- Too many log updates
- Frontend performance degrading
- Users can't keep up with log flood

**Diagnosis Steps:**

1. **Check log frequency:**
   ```bash
   sqlite3 workflow.db "SELECT COUNT(*) FROM log_entries WHERE job_id = {job_id} AND timestamp > datetime('now', '-1 minute');"
   ```

2. **Check if debouncing is enabled:**
   - Should use `dashboard_state.py` for rate limiting

**Common Causes:**

- **No debouncing**: Every log sent immediately
  - **Fix**: Use `DashboardStateManager` from `dashboard_state.py`
  - Implement 15-minute debouncing for insights
  - Implement 500ms debouncing for logs

- **Implementation details shown**: Debug logs reaching users
  - **Fix**: Use `log_parser.py` to filter debug/internal logs
  - Hide SQLAlchemy internals, traceback details, etc.

## Debugging Workflow

When data isn't flowing correctly, follow this systematic approach:

### Step 1: Identify the Gap

Use `debug_pipeline.py` to check each stage:

```bash
python scripts/debug_pipeline.py --job-id {job_id}
```

This will show:
- ✅/❌ Script generated files
- ✅/❌ Backend captured logs
- ✅/❌ Artifact scanner found files
- ✅/❌ SSE streams active

### Step 2: Focus on the Failing Stage

**If "Script Output" fails:**
- Check job.error_message in database
- Look for subprocess errors in backend logs
- Verify speckit command is correct

**If "Backend Logs" fails:**
- Check executor is running
- Look for exceptions in log_service
- Verify database write permissions

**If "Artifact Scanner" fails:**
- Verify path calculation is correct
- Check scanner agent is running
- Look for file permission issues

**If "SSE Streams" fails:**
- Check stream_service is broadcasting
- Verify frontend is subscribed
- Look for CORS issues

### Step 3: Apply the Fix

Based on the gap identified:
1. Fix the code issue
2. Restart backend (if agent-related)
3. Test with new job
4. Verify data flows through entire pipeline

## Prevention

### Use Log Filtering

Always filter logs before sending to users:

```python
from scripts.log_parser import parse_log_line, should_show_to_user

result = parse_log_line(raw_line)
if should_show_to_user(result):
    await log_service.create_log(db, job_id, result['message'], result['level'])
```

### Use Debouncing

Prevent overwhelming the frontend:

```python
from scripts.dashboard_state import DashboardStateManager

manager = DashboardStateManager()
updates = manager.calculate_updates(job, 'log')

if updates.logs_panel:
    # Send to frontend
    await stream_service.broadcast_message('logs', message, 'system')
```

### Monitor Critical Paths

Set up health checks for:
1. Executor agent running
2. Artifact scanner running
3. Database write performance
4. SSE connection stability
