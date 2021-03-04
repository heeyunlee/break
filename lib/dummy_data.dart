import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workout_player/models/workout.dart';

import 'models/user.dart';

final workoutDummyData = Workout(
  workoutId: 'workoutId',
  workoutOwnerId: 'workoutOwnerId',
  workoutOwnerUserName: 'workoutOwnerUserName',
  description: 'description',
  equipmentRequired: ['equipmentRequired'],
  mainMuscleGroup: ['mainMuscleGroup'],
  secondaryMuscleGroup: ['secondaryMuscleGroup'],
  workoutTitle: 'workoutTitle',
  difficulty: 0,
  imageUrl: 'imageUrl',
  instructions: 'imageUrl',
  isBodyWeightWorkout: true,
  isPublic: true,
  lastEditedDate: Timestamp.now(),
  secondsPerRep: 0,
  tips: 'tips',
);

final userDummyData = User(
  userName: 'John Doe',
  unitOfMass: 1,
  totalWeights: 0,
  totalNumberOfWorkouts: 0,
  signUpDate: null,
  userEmail: null,
  signUpProvider: null,
  userId: null,
);
