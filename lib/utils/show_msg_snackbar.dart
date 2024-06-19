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
  var size = MediaQuery.of(context).size;
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: size.width >= 600
          ? size.width < 1520
              ? EdgeInsets.only(bottom: size.height / 1.1, left: size.width / 1.5, right: 20)
              : EdgeInsets.only(bottom: size.height / 1.1, left: size.width / 1.3, right: 20)
          : const EdgeInsets.only(bottom: 0, left: 0, right: 0),
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
