// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:paginate_firestore/paginate_firestore.dart';

// import 'empty_content.dart';

// typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

// class PaginatedListViewBuilder<T> extends StatelessWidget {
//   final Query query;
//   final Widget emptyDisplay;
//   final Widget header;
//   final ItemWidgetBuilder<T> itemBuilder;

//   @override
//   Widget build(BuildContext context) {
//     return PaginateFirestore(
//         query: query,
//         itemBuilderType: PaginateBuilderType.listView,
//                 physics: const AlwaysScrollableScrollPhysics(),
//         emptyDisplay: emptyDisplay,
//         itemsPerPage: 10,
//         header: header,
//         footer: const SizedBox(height: 16),
//         onError: (error) => EmptyContent(
//           message: 'Something went wrong: $error',
//         ),
//         itemBuilder: (index, context, documentSnapshot) {
//           final documentId = documentSnapshot.id;
//           final data = documentSnapshot.data();
//           final routineHistory = RoutineHistory.fromMap(data, documentId);

//           return RoutineHistorySummaryFeedCard(
//             routineHistory: routineHistory,
//             onTap: () => DailySummaryDetailScreen.show(
//               context: context,
//               routineHistory: routineHistory,
//             ),
//           );
//         },
//         isLive: true,
//         listeners: [
//           refreshChangeListener,
//         ],
//       ),
//   }
// }
