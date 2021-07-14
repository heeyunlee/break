# Change Log

Hi, below is the change log of my project, Herakles.

## 0.3.3
### New Features
- Added Weekly Workout Widget (smaller and simpler version than before)

### Bug Fix & Refactor
- Refactored CreateNewRoutineScreen with ChangeNotifierProvider (riverpod)

## 0.3.2
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

## 0.3.1
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

