#!/usr/bin/env python3
"""
Log Parser for AgenticSpecKit Output

Filters and classifies logs from speckit subprocess output to make them
user-friendly while hiding implementation details.

Usage:
    from log_parser import parse_log_line, should_show_to_user

    result = parse_log_line(raw_line)
    if should_show_to_user(result):
        # Send to dashboard
        save_log(result['message'], result['level'])
"""

import re
from typing import Optional, Dict, Literal
from dataclasses import dataclass


@dataclass
class ParsedLog:
    """Parsed log entry"""
    message: str
    level: Literal['info', 'warning', 'error', 'debug']
    phase: Optional[str]  # specify, plan, implement, test, review
    should_display: bool
    is_progress: bool  # True if this is a progress indicator


class LogParser:
    """Parser for AgenticSpecKit subprocess logs"""

    def __init__(self):
        # Path sanitization - remove absolute paths
        self.path_pattern = re.compile(r'/mnt/c/Users/[^/]+/Documents/[^/\s]+/')

        # Phase detection patterns
        self.phase_patterns = {
            'specify': re.compile(r'(?:specifying|specification|/speckit\.specify|spec\.md)', re.IGNORECASE),
            'plan': re.compile(r'(?:planning|plan\.md|/speckit\.plan)', re.IGNORECASE),
            'tasks': re.compile(r'(?:tasks\.md|/speckit\.tasks|generating tasks)', re.IGNORECASE),
            'implement': re.compile(r'(?:implementing|implementation|/speckit\.implement)', re.IGNORECASE),
            'test': re.compile(r'(?:testing|running tests|test suite)', re.IGNORECASE),
            'review': re.compile(r'(?:reviewing|code review)', re.IGNORECASE),
        }

        # Patterns to HIDE from users (implementation details)
        self.hide_patterns = [
            re.compile(r'DEBUG:'),  # Debug logs
            re.compile(r'Traceback \(most recent call last\)'),  # Only show error summary
            re.compile(r'site-packages'),  # Python internals
            re.compile(r'__pycache__'),  # Cache details
            re.compile(r'\.pyc'),  # Bytecode
            re.compile(r'aiosqlite'),  # Database connection details
            re.compile(r'executing functools\.partial'),  # SQLAlchemy internals
            re.compile(r'uvicorn'),  # Server internals (unless error)
        ]

        # Patterns that indicate PROGRESS (show sparingly)
        self.progress_patterns = [
            re.compile(r'(\d+)%'),  # Percentage progress
            re.compile(r'(\d+)/(\d+)'),  # X/Y progress
            re.compile(r'Step (\d+) of (\d+)'),
            re.compile(r'Creating file: (.+)'),
            re.compile(r'Writing (.+)'),
            re.compile(r'Installing'),
        ]

        # ERROR patterns (always show)
        self.error_patterns = [
            re.compile(r'ERROR:', re.IGNORECASE),
            re.compile(r'Exception:', re.IGNORECASE),
            re.compile(r'Failed', re.IGNORECASE),
            re.compile(r'Error', re.IGNORECASE),
        ]

    def sanitize_paths(self, text: str) -> str:
        """Remove absolute paths to hide implementation details"""
        return self.path_pattern.sub('', text)

    def detect_phase(self, text: str) -> Optional[str]:
        """Detect which workflow phase this log is from"""
        for phase, pattern in self.phase_patterns.items():
            if pattern.search(text):
                return phase
        return None

    def should_hide(self, text: str) -> bool:
        """Check if this log should be hidden from users"""
        for pattern in self.hide_patterns:
            if pattern.search(text):
                return True
        return False

    def is_progress_log(self, text: str) -> bool:
        """Check if this is a progress indicator"""
        for pattern in self.progress_patterns:
            if pattern.search(text):
                return True
        return False

    def is_error(self, text: str) -> bool:
        """Check if this is an error message"""
        for pattern in self.error_patterns:
            if pattern.search(text):
                return True
        return False

    def parse(self, raw_line: str) -> ParsedLog:
        """
        Parse a raw log line into a structured ParsedLog

        Args:
            raw_line: Raw log output from speckit subprocess

        Returns:
            ParsedLog with classification and filtering applied
        """
        # Sanitize paths first
        sanitized = self.sanitize_paths(raw_line.strip())

        # Detect level
        if self.is_error(sanitized):
            level = 'error'
        elif 'WARNING:' in sanitized or 'WARN:' in sanitized:
            level = 'warning'
        elif 'DEBUG:' in sanitized:
            level = 'debug'
        else:
            level = 'info'

        # Detect phase
        phase = self.detect_phase(sanitized)

        # Determine if should display
        if self.should_hide(sanitized):
            should_display = False
        elif level == 'error':
            should_display = True  # Always show errors
        elif level == 'debug':
            should_display = False  # Never show debug
        else:
            should_display = True

        # Check if progress indicator
        is_progress = self.is_progress_log(sanitized)

        return ParsedLog(
            message=sanitized,
            level=level,
            phase=phase,
            should_display=should_display,
            is_progress=is_progress
        )


# Singleton instance
_parser = LogParser()


def parse_log_line(raw_line: str) -> Dict:
    """
    Parse a raw log line (convenience function)

    Returns dict compatible with LogEntry schema
    """
    result = _parser.parse(raw_line)
    return {
        'message': result.message,
        'level': result.level,
        'phase': result.phase,
        'should_display': result.should_display,
        'is_progress': result.is_progress
    }


def should_show_to_user(parsed_log: Dict) -> bool:
    """Check if parsed log should be shown to user"""
    return parsed_log['should_display']


def extract_phase(parsed_log: Dict) -> Optional[str]:
    """Extract detected phase from parsed log"""
    return parsed_log['phase']


# Example usage
if __name__ == '__main__':
    test_logs = [
        "DEBUG: aiosqlite executing functools.partial",  # Should hide
        "Creating file: /mnt/c/Users/Bob/Documents/project/src/main.py",  # Should show (sanitized)
        "ERROR: Failed to generate specification",  # Should show
        "Implementing feature: User authentication (Step 3/5)",  # Should show
        "INFO: Writing plan.md",  # Should show
    ]

    for log in test_logs:
        result = parse_log_line(log)
        print(f"\nInput: {log}")
        print(f"Output: {result}")
        print(f"Show?: {should_show_to_user(result)}")
