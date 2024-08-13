// utils
import 'package:flutter/material.dart';

class AppDialog {
  // Progress bar dialog
  static void showProgressBar(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const Center(
        child: CircularProgressIndicator(
          color: Color.fromARGB(255, 27, 240, 255),
        ),
      ),
    );
  }

  // Alert dialog
  static void showAlertDialog(
      BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
        );
      },
    );
  }
}
