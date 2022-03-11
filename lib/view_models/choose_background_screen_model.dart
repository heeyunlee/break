import 'dart:io';

import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/view/widgets/widgets.dart';

class ChooseBackgroundScreenModel with ChangeNotifier {
  ChooseBackgroundScreenModel({required this.database});

  final Database database;

  int? _selectedImageIndex;
  File? _image;

  int? get selectedImageIndex => _selectedImageIndex;
  File? get image => _image;

  void setselectedImageIndex(int? index) {
    _selectedImageIndex = index;
    notifyListeners();
  }

  Future<void> initSelectedImageIndex() async {
    final user = await database.getUserDocument(database.uid!);

    _selectedImageIndex = user!.backgroundImageIndex;
    notifyListeners();
  }

  Future<void> updateBackground(BuildContext context) async {
    final user = {
      'backgroundImageIndex': _selectedImageIndex,
    };

    await database.updateUser(database.uid!, user);

    Navigator.of(context).pop();

    getSnackbarWidget(
      S.current.updateBackgroundSnackbarTitle,
      S.current.updateBackgroundSnackbarMessage,
    );
  }
}
