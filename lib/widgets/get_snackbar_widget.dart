import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:workout_player/constants.dart';

void getSnackbarWidget(String title, String message) {
  return Get.snackbar(
    title,
    message,
    animationDuration: Duration(milliseconds: 500),
    backgroundColor: Colors.grey[700]!.withOpacity(0.75),
    snackPosition: SnackPosition.BOTTOM,
    titleText: Text(title, style: kBodyText2Grey),
    messageText: Text(message, style: kBodyText2),
    borderRadius: 8,
    duration: Duration(seconds: 2),
  );
}
