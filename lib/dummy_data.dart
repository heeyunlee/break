import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workout_player/models/enum/equipment_required.dart';
import 'package:workout_player/models/enum/main_muscle_group.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/models/workout.dart';

import 'models/routine.dart';
import 'models/user.dart';

final workoutDummyData = Workout(
  workoutId: 'workoutId',
  workoutOwnerId: 'workoutOwnerId',
  workoutOwnerUserName: 'workoutOwnerUserName',
  description: 'description',
  equipmentRequired: EquipmentRequired.barbell.list,
  mainMuscleGroup: MainMuscleGroup.abs.list,
  secondaryMuscleGroup: ['secondaryMuscleGroup.chest'],
  workoutTitle: 'workoutTitle',
  difficulty: 0,
  imageUrl: 'imageUrl',
  instructions: 'imageUrl',
  isBodyWeightWorkout: true,
  isPublic: true,
  lastEditedDate: Timestamp.now(),
  secondsPerRep: 0,
  tips: 'tips',
  translated: {
    'de': 'Name des Trainings',
    'en': 'Workout Title',
    'es': 'Nombre del entrenamiento',
    'fr': 'Nom de l\'entraînement',
    'ko': '운동 이름'
  },
  location: 'Location.gym',
  workoutCreatedDate: Timestamp.now(),
);

final userDummyData = User(
  userName: 'John Doe',
  unitOfMass: 1,
  totalWeights: 0,
  totalNumberOfWorkouts: 0,
  signUpDate: Timestamp.now(),
  userEmail: 'JohnDoe@healtine.com',
  signUpProvider: 'Healtine',
  userId: 'JD',
  dailyWorkoutHistories: [],
  dailyNutritionHistories: [],
  lastLoginDate: Timestamp.now(),
  savedRoutines: [],
  savedWorkouts: [],
  displayName: 'John Doe',
);

final routineDummyData = Routine(
  lastEditedDate: Timestamp.now(),
  equipmentRequired: ['EquipmentRequired.barbell'],
  mainMuscleGroup: ['MainMuscleGroup.chest'],
  secondMuscleGroup: ['secondMuscleGroup.chest'],
  routineCreatedDate: Timestamp.now(),
  routineId: 'routineId',
  routineOwnerId: 'routineOwnerId',
  routineOwnerUserName: 'routineOwnerUserName',
  routineTitle: 'routineTitle',
  averageTotalCalories: 0,
  description: 'description',
  duration: 0,
  imageUrl: 'imageUrl',
  initialUnitOfMass: 0,
  isPublic: true,
  totalWeights: 0,
  trainingLevel: 0,
  location: 'Location.gym',
);

final routineWorkoutsDummyData = List.generate(
  3,
  (index) => RoutineWorkout(
    routineWorkoutId: 'routineWorkoutId',
    routineId: 'routineId',
    routineWorkoutOwnerId: 'routineWorkoutOwnerId',
    workoutId: 'workoutId',
    workoutTitle: 'workoutTitle',
    index: index,
    numberOfSets: 0,
    numberOfReps: 0,
    totalWeights: 0,
    isBodyWeightWorkout: true,
    duration: 0,
    secondsPerRep: 0,
    translated: {
      'de': 'Name des Trainings',
      'en': 'Workout Title',
      'es': 'Nombre del entrenamiento',
      'fr': 'Nom de l\'entraînement',
      'ko': '운동 이름'
    },
    sets: [],
  ),
);
