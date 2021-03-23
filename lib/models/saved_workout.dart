// class SavedWorkout {
//   SavedWorkout({
//     this.workoutId,
//     this.isFavorite,
//   });

//   final String workoutId;
//   final bool isFavorite;

//   factory SavedWorkout.fromMap(Map<String, dynamic> data, String documentId) {
//     if (data == null) {
//       return null;
//     }
//     final bool isFavorite = data['isFavorite'];

//     return SavedWorkout(
//       workoutId: documentId,
//       isFavorite: isFavorite,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'isFavorite': isFavorite,
//     };
//   }
// }
