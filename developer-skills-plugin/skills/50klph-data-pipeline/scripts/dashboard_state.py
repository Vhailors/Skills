#!/usr/bin/env python3
"""
Dashboard State Calculator

Determines what dashboard components should update based on job state/phase.
Implements debouncing logic to avoid overwhelming the frontend.

Usage:
    from dashboard_state import DashboardStateManager

    manager = DashboardStateManager()
    updates = manager.calculate_updates(job, new_log)

    # updates = {
    #     'phase_indicator': True,  # Update phase indicator
    #     'kanban_board': False,    # Don't update kanban
    #     'logs': True,             # Send log to logs panel
    #     'insights': False,        # Don't update insights
    #     'artifacts': False,       # Don't scan artifacts yet
    # }
"""

from datetime import datetime, timedelta
from typing import Dict, Optional, Literal
from dataclasses import dataclass, field


PhaseType = Literal['idle', 'specify', 'plan', 'tasks', 'implement', 'test', 'review', 'deploy']


@dataclass
class JobState:
    """Current state of a job"""
    job_id: int
    status: str  # pending, in_progress, completed, failed
    current_phase: PhaseType
    started_at: Optional[datetime] = None
    last_update: Optional[datetime] = None
    lines_written: int = 0


@dataclass
class DashboardUpdate:
    """What to update on the dashboard"""
    phase_indicator: bool = False
    kanban_board: bool = False
    logs_panel: bool = False
    insights_panel: bool = False
    artifacts_viewer: bool = False
    job_progress: bool = False
    metrics: bool = False


class DashboardStateManager:
    """
    Manages dashboard state updates with debouncing

    Prevents overwhelming the frontend with too many updates
    while ensuring critical updates are delivered immediately.
    """

    def __init__(self):
        # Track last update time per component
        self.last_updates: Dict[str, datetime] = {}

        # Debounce intervals (in seconds)
        self.debounce_intervals = {
            'phase_indicator': 2,     # Update phase every 2s max
            'kanban_board': 5,        # Update kanban every 5s max
            'logs_panel': 0.5,        # Logs update fast (500ms)
            'insights_panel': 15 * 60,  # Insights every 15 minutes
            'artifacts_viewer': 30,   # Artifacts every 30s
            'job_progress': 1,        # Progress every 1s
            'metrics': 10,            # Metrics every 10s
        }

        # Phase transition matrix - what components update on phase change
        self.phase_components = {
            'idle': ['phase_indicator', 'kanban_board'],
            'specify': ['phase_indicator', 'kanban_board', 'artifacts_viewer'],
            'plan': ['phase_indicator', 'kanban_board', 'artifacts_viewer'],
            'tasks': ['phase_indicator', 'kanban_board', 'artifacts_viewer'],
            'implement': ['phase_indicator', 'kanban_board', 'job_progress', 'artifacts_viewer'],
            'test': ['phase_indicator', 'kanban_board', 'job_progress'],
            'review': ['phase_indicator', 'kanban_board', 'artifacts_viewer'],
            'deploy': ['phase_indicator', 'kanban_board', 'job_progress'],
        }

    def _should_update_component(self, component: str, force: bool = False) -> bool:
        """
        Check if component should be updated based on debounce interval

        Args:
            component: Component name (e.g., 'phase_indicator')
            force: If True, ignore debouncing (for critical updates)

        Returns:
            True if component should be updated
        """
        if force:
            return True

        now = datetime.utcnow()
        last_update = self.last_updates.get(component)

        if not last_update:
            # Never updated, allow update
            return True

        interval = self.debounce_intervals.get(component, 5)
        elapsed = (now - last_update).total_seconds()

        return elapsed >= interval

    def _mark_updated(self, component: str):
        """Mark component as updated"""
        self.last_updates[component] = datetime.utcnow()

    def calculate_updates(
        self,
        job: JobState,
        event_type: Literal['log', 'phase_change', 'status_change', 'progress'],
        force: bool = False
    ) -> DashboardUpdate:
        """
        Calculate which dashboard components should update

        Args:
            job: Current job state
            event_type: Type of event triggering the update
            force: Force update regardless of debouncing

        Returns:
            DashboardUpdate with flags for each component
        """
        updates = DashboardUpdate()

        if event_type == 'log':
            # Log events only update logs panel (with debouncing)
            if self._should_update_component('logs_panel', force):
                updates.logs_panel = True
                self._mark_updated('logs_panel')

        elif event_type == 'phase_change':
            # Phase changes trigger multiple components (forced)
            components = self.phase_components.get(job.current_phase, [])

            for component in components:
                if self._should_update_component(component, force=True):
                    setattr(updates, component, True)
                    self._mark_updated(component)

            # Always update metrics on phase change
            updates.metrics = True
            self._mark_updated('metrics')

        elif event_type == 'status_change':
            # Status changes (pending -> in_progress -> completed)
            # Update everything (forced)
            for component in ['phase_indicator', 'kanban_board', 'job_progress', 'metrics']:
                setattr(updates, component, True)
                self._mark_updated(component)

            # If completed, scan artifacts
            if job.status == 'completed':
                updates.artifacts_viewer = True
                self._mark_updated('artifacts_viewer')

        elif event_type == 'progress':
            # Progress updates (lines written, etc.)
            if self._should_update_component('job_progress', force):
                updates.job_progress = True
                self._mark_updated('job_progress')

            if self._should_update_component('metrics', force):
                updates.metrics = True
                self._mark_updated('metrics')

        return updates

    def should_generate_insight(self, job: JobState) -> bool:
        """
        Determine if an insight should be generated for observer agent

        Uses 15-minute debouncing as requested
        """
        return self._should_update_component('insights_panel', force=False)

    def reset_component_timer(self, component: str):
        """Reset debounce timer for a component (useful for testing)"""
        if component in self.last_updates:
            del self.last_updates[component]


# Example usage
if __name__ == '__main__':
    manager = DashboardStateManager()

    job = JobState(
        job_id=1,
        status='in_progress',
        current_phase='implement',
        started_at=datetime.utcnow(),
        lines_written=1500
    )

    # Test different event types
    print("Phase change:")
    updates = manager.calculate_updates(job, 'phase_change')
    print(f"  {updates}\n")

    print("Log event:")
    updates = manager.calculate_updates(job, 'log')
    print(f"  {updates}\n")

    print("Status change:")
    job.status = 'completed'
    updates = manager.calculate_updates(job, 'status_change')
    print(f"  {updates}\n")

    print("Should generate insight?")
    print(f"  {manager.should_generate_insight(job)}")
