# Change Log

Here is the changelog of the project, Herakles. I first created this log on version 0.3.1, so any update before that is not logged.

## 0.3.2
### New Feautres
- Added button and screen to reorder routine workouts on routines

### Bug Fix & Refactor
- Refactored AddWorkoutToRoutineScreen with ChangeNotifierProvider (riverpod)

## 0.3.1
### New Features
- Changed preview screen (simpler than before)
- Enable users to pick date for daily progress tab using table_calendar library
- Show MaterialBanner if protein goal or lifting goal is not set
- Added screens and features to add daily protein and lifting goal
- Showed horizontal line of the goal on the weekly chart
- Enable users to choose different bg for progress tab

### Bug Fix & Code Improvement
- Fixed search bar error (went from Algolia Premium to basic so had to disable personalization)
- Implemented Sign In screen model with riverpod and ChangeNotifier (separated model and ui code)

