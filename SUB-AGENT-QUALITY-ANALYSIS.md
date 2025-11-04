# Sub-Agent Quality Impact Analysis

**Critical Question**: Where can we use sub-agents without losing quality?

**Answer**: Sub-agents are quality-SAFE for **deterministic verification** and **data gathering**, but quality-RISKY for **context-dependent decisions** and **creative problem-solving**.

---

## Executive Summary

### Quality-Safe Use Cases ✅

**Agents IMPROVE quality** (better than main conversation):
- Parallel independent checks (faster + no fatigue)
- Isolated exploration (cleaner context)
- Pattern matching (focused search)

**Agents MAINTAIN quality** (same as main conversation):
- Checklist-based verification
- Data extraction from git/files
- Structured analysis with clear criteria

### Quality-Risky Use Cases ⚠️

**Agents REDUCE quality** (worse than main conversation):
- Context-dependent decisions
- Multi-step reasoning with dependencies
- Creative problem-solving
- Learning/teaching moments
- Integration of disparate information

---

## Detailed Quality Analysis by Agent

### 1. verification-checker ✅ QUALITY-SAFE

**Why Quality is Maintained/Improved**:
- ✅ **Deterministic task**: Run test → report pass/fail (no interpretation needed)
- ✅ **Clear success criteria**: Exit code 0 = pass, non-zero = fail
- ✅ **No context dependencies**: Each check is independent
- ✅ **Speed improves quality**: Parallel execution prevents verification fatigue
- ✅ **Focused attention**: Agent only does ONE check (no distraction)

**Quality Comparison**:

| Aspect | Main Conversation | Sub-Agent | Winner |
|--------|-------------------|-----------|---------|
| Accuracy | Same (runs same commands) | Same | **Tie** |
| Completeness | May skip checks when tired | Runs all 5 checks in parallel | **Agent** ✅ |
| Speed | 5-10 min sequential | 30-60 sec parallel | **Agent** ✅ |
| Context pollution | High (15k tokens) | Low (5k tokens) | **Agent** ✅ |

**Quality Trade-offs**: NONE - This is pure win.

**Verdict**: ✅ **USE AGENTS** - Quality improves due to parallelization and focus.

---

### 2. codebase-explorer ✅ QUALITY-SAFE (with caveats)

**Why Quality is Maintained**:
- ✅ **Search task**: Finding patterns is deterministic
- ✅ **Summarization**: Agent returns locations + brief descriptions
- ✅ **Clean context**: Main conversation doesn't get polluted with search results
- ✅ **Focus**: Agent only explores, doesn't make decisions

**Quality Comparison**:

| Aspect | Main Conversation | Sub-Agent | Winner |
|--------|-------------------|-----------|---------|
| Finding files | Same (uses Glob/Grep) | Same | **Tie** |
| Context pollution | Massive (10-20k tokens) | Minimal (500-2000 tokens) | **Agent** ✅ |
| Summary quality | Manual (may miss patterns) | Structured format | **Agent** ✅ |
| Decision making | Can decide immediately | Returns data only | **Main** ⚠️ |

**Quality Trade-offs**:
- ⚠️ **Loss of serendipity**: Agent won't notice related issues while exploring
- ⚠️ **No follow-up questions**: Agent can't ask "should I also check X?"
- ✅ **Gain in focus**: Main conversation receives clean summary, makes better decisions

**When Quality Suffers**:
- ❌ Exploration requires judgment calls ("is this related?")
- ❌ User wants to learn the codebase (delegating prevents learning)
- ❌ Discovery of unexpected patterns is valuable

**When Quality Improves**:
- ✅ Simple pattern search ("find all auth middleware")
- ✅ Main conversation needs clean context for decision-making
- ✅ Exploration is preparatory (gathering data before analysis)

**Verdict**: ✅ **USE AGENTS** for data gathering, ⚠️ **AVOID** when learning/discovery is the goal.

---

### 3. changelog-generator-agent ✅ QUALITY-SAFE

**Why Quality is Maintained**:
- ✅ **Structured output**: Categorize commits by type (schema/logic/breaking)
- ✅ **Pattern matching**: Identify migration files, API changes deterministically
- ✅ **No interpretation**: Reports what changed, not why or how to fix
- ✅ **Context isolation**: Git log consumes 20-50k tokens, agent keeps main context clean

**Quality Comparison**:

| Aspect | Main Conversation | Sub-Agent | Winner |
|--------|-------------------|-----------|---------|
| Completeness | May miss commits | Systematic analysis | **Agent** ✅ |
| Categorization | Manual, inconsistent | Structured format | **Agent** ✅ |
| Context cost | 20-50k tokens | 2-3k tokens | **Agent** ✅ |
| Root cause analysis | Can analyze immediately | Only reports changes | **Main** |

**Quality Trade-offs**:
- ✅ **Gain**: Systematic, complete changelog
- ⚠️ **Loss**: Agent doesn't correlate changes with bug (main conversation does that)

**Verdict**: ✅ **USE AGENTS** - Quality is same or better, with massive context savings.

---

### 4. layer-analyzer-db/api/frontend ⚠️ QUALITY-DEPENDS

**Why Quality CAN Be Maintained**:
- ✅ **Checklist-based**: Each layer has clear verification criteria
- ✅ **Isolated focus**: Each agent only analyzes ONE layer
- ✅ **Parallel speed**: 3x faster than sequential

**Why Quality CAN Suffer**:
- ⚠️ **Integration gaps**: Agents analyze layers independently, may miss cross-layer issues
- ⚠️ **Context loss**: Agent doesn't know what main conversation is trying to achieve
- ⚠️ **False negatives**: Agent says "API looks good" but doesn't realize it's incompatible with frontend expectations

**Quality Comparison**:

| Aspect | Main Conversation | Sub-Agent | Winner |
|--------|-------------------|-----------|---------|
| Layer completeness | May miss items | Systematic checklist | **Agent** ✅ |
| Cross-layer integration | Sees full picture | Only sees one layer | **Main** ✅ |
| Speed | 8-10 min sequential | 3-4 min parallel | **Agent** ✅ |
| Context for decisions | Full context | Limited to layer | **Main** ✅ |

**Quality Trade-offs**:
- ✅ **Gain**: Faster, more complete layer-by-layer analysis
- ⚠️ **Loss**: Integration verification still needs main conversation

**Critical Success Factor**: Main conversation must verify integration AFTER receiving agent reports.

**Example - Quality Maintained**:
```
1. Launch 3 layer agents in parallel → get reports (3 min)
2. Main conversation analyzes reports:
   - DB has "favorites" table ✅
   - API has POST /favorites ✅
   - Frontend calls POST /favorites ✅
   - Integration verified ✅
```

**Example - Quality Lost (Anti-pattern)**:
```
1. Launch 3 layer agents
2. Each says "looks good" ✅✅✅
3. Main conversation assumes complete, marks done ❌
4. Reality: API returns only IDs, frontend expects full product data ❌
5. Quality lost: No integration verification
```

**Verdict**: ⚠️ **USE WITH CAUTION** - Agents gather layer data, main conversation MUST verify integration.

---

### 5. style-extractor (pixel-perfect) ⚠️ QUALITY-RISKY

**Why Quality CAN Suffer**:
- ⚠️ **Judgment calls**: Which elements are "major components"?
- ⚠️ **Visual hierarchy**: Understanding design intent requires context
- ⚠️ **Trade-offs**: When to approximate vs. extract exact values?
- ⚠️ **Learning opportunity**: Delegating prevents understanding the design

**Quality Comparison**:

| Aspect | Main Conversation | Sub-Agent | Winner |
|--------|-------------------|-----------|---------|
| Style extraction | Interactive, can ask user | Autonomous, may guess | **Main** ✅ |
| Speed | Slower | Faster | **Agent** ✅ |
| Understanding design | Learns design system | Just extracts values | **Main** ✅ |
| Completeness | May miss elements | Systematic extraction | **Agent** ✅ |

**Quality Trade-offs**:
- ✅ **Gain**: Faster extraction, more systematic
- ⚠️ **Loss**: Design understanding, ability to make judgment calls

**When Quality Suffers**:
- ❌ Complex designs with visual hierarchy
- ❌ User wants to learn the design system
- ❌ Judgment calls needed (is this hover state important?)

**When Quality Maintained**:
- ✅ Simple, structured designs (e.g., SaaS landing pages)
- ✅ Speed is critical
- ✅ User provides clear extraction criteria

**Verdict**: ⚠️ **USE SELECTIVELY** - For simple designs or when speed is critical, quality is maintained. For complex designs requiring judgment, main conversation is better.

---

## Quality Decision Framework

### Use Sub-Agents When: ✅

| Criterion | Example | Quality Impact |
|-----------|---------|----------------|
| **Task is deterministic** | Run tests, check exit code | Quality maintained |
| **Clear success criteria** | File exists? Schema has field X? | Quality maintained |
| **No context dependencies** | Each check is independent | Quality maintained |
| **Speed improves quality** | Parallel checks prevent fatigue | Quality improves |
| **Data gathering only** | Find files, extract git log | Quality maintained |
| **Checklist-based** | Verify all items in list | Quality maintained |

### Avoid Sub-Agents When: ❌

| Criterion | Example | Quality Impact |
|-----------|---------|----------------|
| **Requires judgment** | "Is this the right approach?" | Quality suffers |
| **Context-dependent** | Needs to know user's goal | Quality suffers |
| **Multi-step reasoning** | If A then B, but C changes context | Quality suffers |
| **Creative problem-solving** | Design new architecture | Quality suffers |
| **Learning opportunity** | User should understand this | Quality suffers |
| **Integration of disparate info** | Correlate bug + recent changes + user intent | Quality suffers |

---

## Specific Scenarios: Quality Analysis

### Scenario 1: /ship-check Verification

**Task**: Verify feature is complete before shipping

**Agent Approach**:
```typescript
// Launch 5 parallel checks
const [tests, integration, mockData, logging, security] = await Promise.all([...])
```

**Quality Analysis**:
- ✅ **Each check is independent** (tests don't affect security scan)
- ✅ **Clear pass/fail criteria** (exit code, pattern found/not found)
- ✅ **Speed improves quality** (5-10 min → 1 min prevents "skip this check" temptation)
- ✅ **No judgment calls** (either tests pass or they don't)

**Quality Verdict**: ✅ **AGENTS IMPROVE QUALITY**

**Why**: Parallelization prevents verification fatigue. Sequential checks lead to skipping late checks when tired.

---

### Scenario 2: "Where is authentication implemented?"

**Agent Approach**:
```typescript
const findings = await Task({
  description: "Explore auth patterns",
  prompt: "codebase-explorer: Find all auth middleware, JWT handling, session management"
})
```

**Quality Analysis**:
- ✅ **Search is deterministic** (grep for "auth", "jwt", "session")
- ✅ **Clean context** (main conversation gets summary, not 10k tokens of search results)
- ⚠️ **May miss related code** (agent doesn't know to check authorization vs. authentication)
- ⚠️ **No learning** (user doesn't see how to search codebase)

**Quality Verdict**: ✅ **AGENTS MAINTAIN QUALITY** (for experienced users)

**Caveat**: If user is learning the codebase, main conversation is better (learning opportunity).

---

### Scenario 3: Debugging "Favorites feature broken"

**Agent Approach (WRONG)**:
```typescript
// ❌ ANTI-PATTERN: Delegate entire debugging to agent
const fix = await Task({
  description: "Debug favorites feature",
  prompt: "Find bug and propose fix"
})
```

**Quality Analysis**:
- ❌ **Requires context**: Why is it broken? What changed? What's the expected behavior?
- ❌ **Multi-step reasoning**: Reproduce → trace → find root cause → propose fix
- ❌ **Judgment calls**: Is this a schema issue? API issue? Frontend issue?

**Quality Verdict**: ❌ **AGENTS REDUCE QUALITY** (main conversation is much better)

**Correct Approach (HYBRID)**:
```typescript
// ✅ Use agents for DATA GATHERING only
const changelog = await Task({
  description: "Generate recent changelog",
  prompt: "Analyze last 7 days for schema/API changes to favorites"
})

// Main conversation:
// 1. Reviews changelog
// 2. Identifies likely culprit (e.g., schema change in commit abc123)
// 3. Uses systematic-debugging skill for root cause analysis
// 4. Proposes fix with full context
```

**Quality Verdict**: ✅ **HYBRID MAINTAINS QUALITY**

**Why**: Agent gathers historical data (quality-safe), main conversation does reasoning (quality-critical).

---

### Scenario 4: "Explain how authentication works"

**Agent Approach (WRONG)**:
```typescript
// ❌ ANTI-PATTERN: Delegate explanation to agent
const explanation = await Task({
  description: "Explain auth",
  prompt: "codebase-explorer: Explain how authentication works"
})
```

**Quality Analysis**:
- ❌ **Learning opportunity lost**: User should understand, not just read summary
- ❌ **No follow-up**: Agent can't answer "why did they choose JWT over sessions?"
- ❌ **Context-dependent**: Explanation quality depends on user's background knowledge

**Quality Verdict**: ❌ **AGENTS REDUCE QUALITY** (main conversation is much better)

**Why**: Teaching requires context awareness, follow-up questions, and building on user's knowledge. Agents can't do this.

**Correct Approach**:
```typescript
// ✅ Use agent for DATA GATHERING, main for TEACHING
const findings = await Task({
  description: "Find auth implementation files",
  prompt: "codebase-explorer: Find all auth-related files and key patterns"
})

// Main conversation then:
// 1. Reviews findings
// 2. Explains design rationale (why middleware pattern?)
// 3. Shows concrete examples with commentary
// 4. Asks user if they have questions
// 5. Connects to broader patterns in codebase
```

**Quality Verdict**: ✅ **HYBRID MAINTAINS QUALITY**

---

## Quality Boundaries: The "Agent Decision Tree"

```
User Request
    ↓
Is it a DETERMINISTIC task?
    ├─ YES → Is context needed for interpretation?
    │           ├─ NO → ✅ USE AGENT (quality-safe)
    │           └─ YES → ⚠️ HYBRID (agent gathers, main interprets)
    │
    └─ NO → Is it CREATIVE/REASONING task?
                ├─ YES → ❌ MAIN CONVERSATION (agents reduce quality)
                └─ NO → Is it a CHECKLIST task?
                            ├─ YES → Are items independent?
                            │           ├─ YES → ✅ USE AGENT (quality-safe)
                            │           └─ NO → ⚠️ HYBRID
                            └─ NO → ❌ MAIN CONVERSATION
```

---

## Quality Anti-Patterns to Avoid

### Anti-Pattern 1: "Agent Does Everything"

**Wrong**:
```typescript
// ❌ Delegate entire feature development to agent
const feature = await Task({
  description: "Implement favorites feature",
  prompt: "Build complete favorites: DB + API + Frontend"
})
```

**Why Quality Suffers**:
- ❌ No spec-kit workflow (skips requirements clarification)
- ❌ No integration verification (agent can't verify DB → API → Frontend)
- ❌ No user context (what does user actually want?)
- ❌ Learning opportunity lost

**Correct**:
```
Main conversation:
1. Run spec-kit workflow (constitution → specify → clarify → plan)
2. Use agents for DATA GATHERING during implementation:
   - layer-analyzer-db: Check existing schema patterns
   - codebase-explorer: Find similar features (likes, bookmarks)
3. Implement in main conversation (maintains context)
4. Use agents for VERIFICATION:
   - verification-checker: Run tests in parallel
   - layer-analyzer-*: Check each layer systematically
5. Main conversation verifies integration
```

---

### Anti-Pattern 2: "Agent Makes Architectural Decisions"

**Wrong**:
```typescript
// ❌ Ask agent to decide architecture
const architecture = await Task({
  description: "Design favorites system",
  prompt: "Should favorites use separate table or JSONB array? Decide."
})
```

**Why Quality Suffers**:
- ❌ Agent doesn't know project constraints (scale, team expertise, existing patterns)
- ❌ No user input (what are the priorities? Speed? Simplicity? Flexibility?)
- ❌ No memory of past decisions (why did we choose X pattern last time?)

**Correct**:
```
Main conversation:
1. Use /recall-pattern to find similar decisions
2. Use codebase-explorer agent to find existing table structures
3. Main conversation presents options with trade-offs
4. User chooses approach
5. Main conversation documents decision (memory observation)
```

---

### Anti-Pattern 3: "Agent Verifies Integration Without Context"

**Wrong**:
```typescript
// ❌ Agent verifies integration in isolation
const [db, api, frontend] = await Promise.all([...])

if (db.status === "✅" && api.status === "✅" && frontend.status === "✅") {
  console.log("Feature complete!") // ❌ WRONG
}
```

**Why Quality Suffers**:
- ❌ Each layer may be "complete" independently but not integrated
- ❌ Example: DB has field, API doesn't expose it, Frontend doesn't display it
- ❌ False confidence from 3x ✅

**Correct**:
```typescript
// ✅ Agents gather layer data, main verifies integration
const [db, api, frontend] = await Promise.all([...])

// Main conversation then:
// 1. Reviews all 3 reports
// 2. Checks: Does API expose all DB fields?
// 3. Checks: Does Frontend call all API endpoints?
// 4. Checks: Are there unused schema fields or orphaned endpoints?
// 5. Only then: "Feature complete"
```

---

## Quality-Safe Agent Patterns

### Pattern 1: "Parallel Independent Verification"

**Use Case**: /ship-check, pre-commit checks, CI/CD validation

**Quality Impact**: ✅ **IMPROVES QUALITY**

**Why**:
- Each check is independent (tests don't affect security scan)
- Clear pass/fail criteria (no interpretation)
- Speed prevents skipping checks due to fatigue

**Example**:
```typescript
const [tests, lint, types, security, mockData] = await Promise.all([
  Task({ description: "Run test suite", model: "haiku" }),
  Task({ description: "Run linter", model: "haiku" }),
  Task({ description: "Check types", model: "haiku" }),
  Task({ description: "Security scan", model: "haiku" }),
  Task({ description: "Mock data scan", model: "haiku" })
])

// All checks run simultaneously (5x faster)
// Main conversation aggregates results
```

---

### Pattern 2: "Exploration → Analysis" (Hybrid)

**Use Case**: "Where is X?", "How does Y work?", "Find all Z"

**Quality Impact**: ✅ **MAINTAINS QUALITY**

**Why**:
- Agent does deterministic search (quality-safe)
- Main conversation does analysis (quality-critical)
- Clean context for decision-making

**Example**:
```typescript
// Agent: Gather data
const findings = await Task({
  description: "Explore auth patterns",
  prompt: "codebase-explorer: Find all auth middleware, JWT, sessions. Return locations and patterns."
})

// Main conversation: Analyze and explain
// 1. Review findings
// 2. Explain architecture ("Middleware pattern ensures auth before handlers")
// 3. Show concrete examples with commentary
// 4. Answer user's questions
// 5. Create memory observation
```

---

### Pattern 3: "Layer Analysis → Integration Verification" (Hybrid)

**Use Case**: Full-stack integration checking

**Quality Impact**: ✅ **MAINTAINS QUALITY** (with correct verification)

**Why**:
- Agents do layer-by-layer analysis (quality-safe, faster)
- Main conversation verifies cross-layer integration (quality-critical)

**Example**:
```typescript
// Agents: Analyze each layer in parallel
const [db, api, frontend] = await Promise.all([
  Task({ description: "DB layer for favorites", model: "haiku" }),
  Task({ description: "API layer for favorites", model: "haiku" }),
  Task({ description: "Frontend layer for favorites", model: "haiku" })
])

// Main conversation: Verify integration
// 1. DB has "userId" and "productId" ✅
// 2. API returns userId and productId ✅
// 3. Frontend displays both ✅
// 4. Integration verified ✅
//
// OR detect gaps:
// 1. DB has "createdAt" field
// 2. API doesn't return "createdAt" ❌ GAP FOUND
// 3. Frontend doesn't display it ❌ GAP FOUND
// 4. Decision: Remove from DB or add to API?
```

---

### Pattern 4: "Historical Data Gathering" (Agent-Only)

**Use Case**: Changelog generation, git analysis, dependency audit

**Quality Impact**: ✅ **MAINTAINS/IMPROVES QUALITY**

**Why**:
- Purely data extraction (no interpretation)
- Agent is more systematic than manual review
- Massive context savings

**Example**:
```typescript
// Agent: Extract git history
const changelog = await Task({
  description: "Generate changelog for debugging",
  prompt: "changelog-generator-agent: Last 7 days, focus on schema/API changes",
  model: "haiku"
})

// Main conversation uses changelog for debugging
// (agent only gathered data, main does reasoning)
```

---

## When Main Conversation is Better (No Agents)

### 1. Creative Problem-Solving

**Example**: "Design a caching strategy for this API"

**Why Main is Better**:
- Requires understanding business requirements
- Trade-offs depend on user priorities (speed vs. freshness)
- Needs to consider existing architecture patterns
- User input needed for constraints

**Agent Quality Impact**: ❌ **REDUCES QUALITY** (context-blind recommendations)

---

### 2. Learning/Teaching Moments

**Example**: "Explain how this code works" or "Teach me about middleware"

**Why Main is Better**:
- Requires understanding user's knowledge level
- Follow-up questions needed
- Building on existing knowledge
- Interactive learning is more effective

**Agent Quality Impact**: ❌ **REDUCES QUALITY** (one-way information dump)

---

### 3. Multi-Step Reasoning with Dependencies

**Example**: "Debug why authentication fails for mobile app but works on web"

**Why Main is Better**:
- Requires correlating multiple information sources
- Each discovery changes investigation direction
- Needs to ask clarifying questions
- Context from previous steps informs next steps

**Agent Quality Impact**: ❌ **REDUCES QUALITY** (can't adapt investigation)

---

### 4. Architectural Decisions

**Example**: "Should we use PostgreSQL or MongoDB for this feature?"

**Why Main is Better**:
- Requires project context (team expertise, existing stack)
- Trade-offs depend on user priorities
- Needs memory of past decisions
- User should be involved in decision

**Agent Quality Impact**: ❌ **REDUCES QUALITY** (context-blind recommendations)

---

### 5. Integration of Disparate Information

**Example**: Correlating bug report + recent changes + user expectations + system constraints

**Why Main is Better**:
- Information comes from different sources (user, git, code, docs)
- Each piece of info changes interpretation of others
- Holistic understanding required
- Can't be broken into independent sub-tasks

**Agent Quality Impact**: ❌ **REDUCES QUALITY** (loses holistic view)

---

## Quality Metrics: How to Measure

### Before/After Comparison

**Metric 1: Completeness**
- **Before agents**: Did we check all 5 verification items? (Often skip 1-2 when tired)
- **With agents**: All 5 checks run in parallel (100% completeness)
- **Quality Impact**: ✅ Improved

**Metric 2: Accuracy**
- **Before agents**: Manual verification (prone to human error)
- **With agents**: Same commands, same accuracy
- **Quality Impact**: ⚠️ Same

**Metric 3: Context Awareness**
- **Before agents**: Full context in main conversation
- **With agents**: Agents have limited context
- **Quality Impact**: ⚠️ Depends on task (safe for verification, risky for reasoning)

**Metric 4: Speed**
- **Before agents**: 5-10 min sequential verification
- **With agents**: 30-60 sec parallel verification
- **Quality Impact**: ✅ Speed prevents fatigue-induced errors

**Metric 5: Learning**
- **Before agents**: User sees full process
- **With agents**: User sees only summary
- **Quality Impact**: ⚠️ Worse for learning, better for execution

---

## Conclusion: Quality Decision Matrix

| Task Type | Quality Impact | Use Agent? | Pattern |
|-----------|----------------|------------|---------|
| **Deterministic verification** (tests, linting) | ✅ Improved | YES | Parallel independent checks |
| **Data gathering** (find files, git log) | ✅ Maintained | YES | Exploration → Analysis |
| **Checklist analysis** (layer verification) | ✅ Maintained | YES (+ main verification) | Layer → Integration |
| **Historical extraction** (changelog, audit) | ✅ Improved | YES | Agent-only |
| **Creative problem-solving** (architecture, design) | ❌ Reduced | NO | Main conversation only |
| **Learning/teaching** (explain, understand) | ❌ Reduced | NO | Main conversation only |
| **Multi-step reasoning** (debugging complex issues) | ❌ Reduced | NO (agent assists) | Hybrid: agent gathers, main reasons |
| **Architectural decisions** (tech choices) | ❌ Reduced | NO | Main conversation only |
| **Integration verification** (cross-layer) | ⚠️ Depends | HYBRID | Agents analyze, main integrates |

---

## Recommended Quality-Safe Implementation

### Phase 1: Quality-Safe Agents Only

**Implement these agents (no quality risk)**:
1. ✅ `verification-checker` - Deterministic parallel checks
2. ✅ `changelog-generator-agent` - Historical data extraction
3. ✅ `codebase-explorer` - Pattern search (with main doing analysis)

**Quality guarantee**: These tasks are 100% quality-safe because they're deterministic or data-gathering only.

### Phase 2: Hybrid Agents (Require Main Verification)

**Implement with caution**:
4. ⚠️ `layer-analyzer-*` - Requires main conversation to verify integration
5. ⚠️ `diagnostic-gatherer` - Requires main conversation to correlate evidence

**Quality guarantee**: Main conversation MUST do final integration/correlation check.

### Phase 3: Advanced Agents (Context-Dependent)

**Implement only if quality verification process is in place**:
6. ⚠️ `style-extractor` - Requires validation against screenshots
7. ⚠️ `qa-validator` - Requires human judgment for "pixel-perfect"

**Quality guarantee**: Human/main conversation reviews agent output before accepting.

---

## Quality Checklist for Any Agent

Before deploying an agent, verify:

- [ ] **Task is deterministic** - Clear input → predictable output
- [ ] **Success criteria are objective** - Pass/fail can be measured
- [ ] **No context dependencies** - Agent doesn't need to know user's goal
- [ ] **No judgment calls** - No "it depends" decisions
- [ ] **No creative reasoning** - Pattern matching, not problem-solving
- [ ] **Main conversation can verify** - Agent output can be validated
- [ ] **Failure mode is safe** - Wrong answer is detectable

**If ANY checkbox is unchecked → Don't use agent, use main conversation**

---

## Final Recommendation

**Quality-Safe Agents** (implement immediately):
- ✅ verification-checker
- ✅ changelog-generator-agent
- ✅ codebase-explorer (for data gathering, not teaching)

**Quality-Depends Agents** (implement with verification protocol):
- ⚠️ layer-analyzer-* (main must verify integration)
- ⚠️ diagnostic-gatherer (main must correlate evidence)

**Quality-Risky Agents** (avoid or use only with heavy supervision):
- ❌ Any agent making architectural decisions
- ❌ Any agent doing creative problem-solving
- ❌ Any agent teaching/explaining complex concepts
- ❌ Any agent debugging without main conversation oversight

**Golden Rule**: **Agents gather data and verify facts. Main conversation reasons and decides.**
