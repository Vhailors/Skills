#!/usr/bin/env python3
"""
Data Pipeline Debugger

Helps diagnose where data gets stuck in the pipeline:
Script → Backend → Database → SSE → Frontend

Usage:
    python debug_pipeline.py --job-id 123
    python debug_pipeline.py --check-all
"""

import asyncio
import sys
from pathlib import Path
from datetime import datetime, timedelta
from typing import List, Dict, Optional


async def check_script_output(job_id: int, project_path: Path) -> Dict:
    """
    Check if script generated files

    Returns:
        {
            'files_exist': bool,
            'file_count': int,
            'latest_mtime': datetime,
            'files': List[str]
        }
    """
    if not project_path.exists():
        return {
            'files_exist': False,
            'file_count': 0,
            'latest_mtime': None,
            'files': []
        }

    # Find all generated files (excluding .git, node_modules, etc.)
    files = []
    latest_mtime = None

    for file_path in project_path.rglob('*'):
        if file_path.is_file():
            # Skip unwanted directories
            if any(skip in str(file_path) for skip in ['.git', 'node_modules', '__pycache__', '.specify']):
                continue

            files.append(str(file_path))
            mtime = datetime.fromtimestamp(file_path.stat().st_mtime)

            if not latest_mtime or mtime > latest_mtime:
                latest_mtime = mtime

    return {
        'files_exist': len(files) > 0,
        'file_count': len(files),
        'latest_mtime': latest_mtime,
        'files': files[:10]  # Show first 10
    }


async def check_backend_logs(job_id: int, db_path: Path) -> Dict:
    """
    Check if backend stored logs in database

    Returns:
        {
            'logs_exist': bool,
            'log_count': int,
            'latest_timestamp': datetime,
            'sample_logs': List[str]
        }
    """
    import sqlite3

    if not db_path.exists():
        return {
            'logs_exist': False,
            'log_count': 0,
            'latest_timestamp': None,
            'sample_logs': []
        }

    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()

    # Check log_entries table
    cursor.execute(
        "SELECT COUNT(*) FROM log_entries WHERE job_id = ?",
        (job_id,)
    )
    count = cursor.fetchone()[0]

    # Get latest timestamp
    cursor.execute(
        "SELECT MAX(timestamp) FROM log_entries WHERE job_id = ?",
        (job_id,)
    )
    latest = cursor.fetchone()[0]

    # Get sample logs
    cursor.execute(
        "SELECT message, level, timestamp FROM log_entries WHERE job_id = ? ORDER BY timestamp DESC LIMIT 5",
        (job_id,)
    )
    sample_logs = cursor.fetchall()

    conn.close()

    return {
        'logs_exist': count > 0,
        'log_count': count,
        'latest_timestamp': datetime.fromisoformat(latest) if latest else None,
        'sample_logs': [f"[{level}] {msg}" for msg, level, _ in sample_logs]
    }


async def check_artifacts_scanned(job_id: int, db_path: Path, project_path: Path) -> Dict:
    """
    Check if artifact scanner found and tracked files

    Returns:
        {
            'artifacts_exist': bool,
            'artifact_count': int,
            'sample_artifacts': List[str]
        }
    """
    import sqlite3

    if not db_path.exists():
        return {
            'artifacts_exist': False,
            'artifact_count': 0,
            'sample_artifacts': []
        }

    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()

    # Check artifacts table for files in this project's directory
    project_str = str(project_path)
    cursor.execute(
        "SELECT COUNT(*) FROM artifacts WHERE file_path LIKE ?",
        (f"{project_str}%",)
    )
    count = cursor.fetchone()[0]

    # Get sample artifacts
    cursor.execute(
        "SELECT file_name, artifact_type, created_at FROM artifacts WHERE file_path LIKE ? ORDER BY created_at DESC LIMIT 5",
        (f"{project_str}%",)
    )
    sample_artifacts = cursor.fetchall()

    conn.close()

    return {
        'artifacts_exist': count > 0,
        'artifact_count': count,
        'sample_artifacts': [f"{name} ({type_})" for name, type_, _ in sample_artifacts]
    }


async def check_sse_streams(db_path: Path) -> Dict:
    """
    Check if SSE streams have recent messages

    Returns:
        {
            'logs_stream_active': bool,
            'insights_stream_active': bool,
            'knowledge_stream_active': bool
        }
    """
    import sqlite3

    if not db_path.exists():
        return {
            'logs_stream_active': False,
            'insights_stream_active': False,
            'knowledge_stream_active': False
        }

    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()

    # Check stream_messages table for recent activity (last 5 minutes)
    five_mins_ago = (datetime.utcnow() - timedelta(minutes=5)).isoformat()

    result = {}
    for stream_type in ['logs', 'insights', 'knowledge']:
        cursor.execute(
            "SELECT COUNT(*) FROM stream_messages WHERE stream_type = ? AND created_at > ?",
            (stream_type, five_mins_ago)
        )
        count = cursor.fetchone()[0]
        result[f'{stream_type}_stream_active'] = count > 0

    conn.close()
    return result


async def diagnose_job(job_id: int):
    """
    Diagnose data pipeline for a specific job

    Checks each stage of the pipeline to identify where data gets stuck
    """
    print(f"\n{'='*60}")
    print(f"Pipeline Diagnosis for Job #{job_id}")
    print(f"{'='*60}\n")

    # Paths (adjust based on your setup)
    workspace_root = Path.cwd()
    db_path = workspace_root / "workflow.db"
    projects_root = workspace_root / "generated_projects"

    # Get project path for this job (simplified - assumes job ID matches dir name)
    # In real usage, query database for job.project_id -> project.name
    project_dirs = list(projects_root.glob('*'))
    if not project_dirs:
        print("❌ No projects found in generated_projects/")
        return

    project_path = project_dirs[0]  # Use first project for demo

    print(f"📂 Project Path: {project_path}")
    print(f"🗄️  Database Path: {db_path}\n")

    # Stage 1: Check if script generated files
    print("Stage 1: Script Output")
    print("-" * 40)
    script_result = await check_script_output(job_id, project_path)
    if script_result['files_exist']:
        print(f"✅ Files found: {script_result['file_count']}")
        print(f"   Latest modification: {script_result['latest_mtime']}")
    else:
        print(f"❌ No files found - Script may not have run or failed")
    print()

    # Stage 2: Check backend logs
    print("Stage 2: Backend Logs")
    print("-" * 40)
    logs_result = await check_backend_logs(job_id, db_path)
    if logs_result['logs_exist']:
        print(f"✅ Logs stored: {logs_result['log_count']}")
        print(f"   Latest log: {logs_result['latest_timestamp']}")
        if logs_result['sample_logs']:
            print(f"   Sample:")
            for log in logs_result['sample_logs'][:3]:
                print(f"     • {log[:100]}")
    else:
        print(f"❌ No logs in database - Executor may not be capturing output")
    print()

    # Stage 3: Check artifact scanner
    print("Stage 3: Artifact Scanner")
    print("-" * 40)
    artifacts_result = await check_artifacts_scanned(job_id, db_path, project_path)
    if artifacts_result['artifacts_exist']:
        print(f"✅ Artifacts scanned: {artifacts_result['artifact_count']}")
        if artifacts_result['sample_artifacts']:
            print(f"   Sample:")
            for artifact in artifacts_result['sample_artifacts'][:3]:
                print(f"     • {artifact}")
    else:
        print(f"❌ No artifacts found - Scanner may not have run or path mismatch")
    print()

    # Stage 4: Check SSE streams
    print("Stage 4: SSE Streams (Last 5 minutes)")
    print("-" * 40)
    streams_result = await check_sse_streams(db_path)
    for stream, active in streams_result.items():
        status = "✅" if active else "⚠️ "
        print(f"{status} {stream.replace('_', ' ').title()}: {'Active' if active else 'No recent activity'}")
    print()

    # Summary
    print("Summary")
    print("-" * 40)
    issues = []

    if not script_result['files_exist']:
        issues.append("Script did not generate files")

    if not logs_result['logs_exist']:
        issues.append("Logs not captured by backend")

    if script_result['files_exist'] and not artifacts_result['artifacts_exist']:
        issues.append("Artifact scanner not finding files (path mismatch?)")

    if not any(streams_result.values()):
        issues.append("No SSE stream activity")

    if issues:
        print("⚠️  Issues detected:")
        for issue in issues:
            print(f"   • {issue}")
    else:
        print("✅ Pipeline appears healthy!")

    print()


if __name__ == '__main__':
    import argparse

    parser = argparse.ArgumentParser(description='Debug the data pipeline')
    parser.add_argument('--job-id', type=int, help='Job ID to diagnose')
    parser.add_argument('--check-all', action='store_true', help='Check all recent jobs')

    args = parser.parse_args()

    if args.job_id:
        asyncio.run(diagnose_job(args.job_id))
    else:
        print("Usage: python debug_pipeline.py --job-id 123")
        sys.exit(1)
