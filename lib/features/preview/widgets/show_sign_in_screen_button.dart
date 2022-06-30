// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:workout_player/generated/l10n.dart';
// import 'package:workout_player/providers.dart' show previewModelProvider;
// import 'package:workout_player/styles/button_styles.dart';

// class ShowSignInScreenButton extends ConsumerWidget {
//   const ShowSignInScreenButton({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final model = ref.watch(previewModelProvider);

//     return OutlinedButton(
//       style: ButtonStyles.elevated(
//         context,
//         backgroundColor: Colors.red,
//       ),
//       onPressed: () {},
//       child: Text(
//         (model.currentPageIndex == 2) ? S.current.getStarted : S.current.next,
//       ),
//     );
//   }
// }
