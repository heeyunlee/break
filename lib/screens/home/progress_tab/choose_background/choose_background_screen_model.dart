import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/widgets/get_snackbar_widget.dart';
import 'package:workout_player/widgets/show_adaptive_modal_bottom_sheet.dart';

final chooseBackgroundScreenModelModel = ChangeNotifierProvider(
  (ref) => ChooseBackgroundScreenModel(),
);

class ChooseBackgroundScreenModel with ChangeNotifier {
  AuthService? auth;
  FirestoreDatabase? database;

  ChooseBackgroundScreenModel({
    this.auth,
    this.database,
  }) {
    final container = ProviderContainer();
    auth = container.read(authServiceProvider2);
    database = container.read(databaseProvider2(auth!.currentUser?.uid));
  }

  int? _selectedImageIndex;
  PickedFile? _pickedImageFile;
  File? _image;

  int? get selectedImageIndex => _selectedImageIndex;
  PickedFile? get pickedImageFile => _pickedImageFile;
  File? get image => _image;

  void setselectedImageIndex(int? index) {
    _selectedImageIndex = index;
    notifyListeners();
  }

  Future<void> showModalBottomSheet(BuildContext context) async {
    await showAdaptiveModalBottomSheet(
      context,
      firstActionText: 'Camera',
      isFirstActionDefault: true,
      firstActionOnPressed: () => _openCamera(context),
      secondActionText: 'Album',
      isSecondActionDefault: true,
      secondActionOnPressed: () => _openGallery(context),
    );
  }

  void _openGallery(BuildContext context) async {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    _pickedImageFile = pickedFile;
    if (_pickedImageFile != null) {
      _image = File(pickedImageFile!.path);
    }

    Navigator.of(context).pop();

    notifyListeners();
  }

  void _openCamera(BuildContext context) async {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
    );
    _pickedImageFile = pickedFile;
    if (_pickedImageFile != null) {
      _image = File(pickedImageFile!.path);
    }
    Navigator.of(context).pop();

    notifyListeners();
  }

  Future<void> initSelectedImageIndex() async {
    final user = await database!.getUserDocument(auth!.currentUser!.uid);

    _selectedImageIndex = user!.backgroundImageIndex;
    notifyListeners();
  }

  Future<void> updateBackground(BuildContext context) async {
    final user = {
      'backgroundImageIndex': _selectedImageIndex,
    };

    await database!.updateUser(auth!.currentUser!.uid, user);

    Navigator.of(context).pop();

    getSnackbarWidget(
      S.current.updateBackgroundSnackbarTitle,
      S.current.updateBackgroundSnackbarMessage,
    );
  }
}
