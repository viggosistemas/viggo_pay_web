import 'package:flutter/material.dart';

void showInfoMessage(
  BuildContext context,
  int duration,
  Color panelClass,
  String contentMsg,
  String actionMsg,
  Function() action,
  Color actionColor,
) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: Duration(seconds: duration),
      backgroundColor: panelClass,
      content: Text(
        contentMsg,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      action: SnackBarAction(
        label: actionMsg,
        textColor: actionColor,
        onPressed: action,
      ),
    ),
  );
}
