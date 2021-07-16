# Change Log

Hi, below is all the changes from my project, Herakles, after version 0.3.0. I didn't think of doing it before, so I have no idea what I've added/removed/changed. I regret it immensely.

## Unreleased (0.3.3)
### New Features
- Added Weekly Workout Widget (smaller and simpler version than before)
- Enabled users to reorder progress tab's widgets using reorderables package

### Bug Fix & Refactor
- Refactored CreateNewRoutineScreen with ChangeNotifierProvider (riverpod)
- Refactored ProgressTab's widgets with ChangeNotifierProvider (riverpod)
- Combined 6 streams on progress tab with RxDart
- Stopped using implicitly_animated_reorderable_list because of an error

## [0.3.2] - July 13th, 2021
### New Feautres
- Added button and screen to reorder routine workouts on routines
- Added features to set weight goal & added RecentWeightWidget on ProgressTab
- Added features to set Body Fat Percentage goal & added RecentBodyFatWidget on ProgressTab

### Bug Fix & Refactor
- Refactored AddWorkoutToRoutineScreen with ChangeNotifierProvider (riverpod)
- Changed the layout of progress tab to fit like a grid
- Used RxDart to combine two streams on DailyActivityRing
- Used ImplicitlyAnimatedList to list WorkoutSets and RoutineWorkoutCard
- Refactored WeeklyNutritionCard and WeeklyNutritionChart
- Refactored WeeklyMeasurementsCard and WeeklyMeasurementsChart

## [0.3.1] - July 2nd, 2021
### New Features
- Changed preview screen (simpler than before)
- Enable users to pick date for daily progress tab using table_calendar library
- Show MaterialBanner if protein goal or lifting goal is not set
- Added screens and features to add daily protein and lifting goal
- Showed horizontal line of the goal on the weekly chart
- Enable users to choose different background for progress tab

### Bug Fix & Refactor
- Fixed search bar error (went from Algolia Premium to basic so had to disable personalization)
- Implemented Sign In screen model with riverpod and ChangeNotifier (separated model and ui code)
- Added InfoPlist.strings to localize iOS messages
- Refactored styles files to create TextStyles.dart

[0.3.2]: https://github.com/heeyunlee/herakless/compare/db5c6992dcc41fd9f5f11160333509e97fa42019..ea1d7a2abec9c652e2e508e1326df011b1ab2e8b
[0.3.1]: https://github.com/heeyunlee/herakless/compare/42acc8b1464d163177826bd24b6bd69e9f883173..db5c6992dcc41fd9f5f11160333509e97fa42019