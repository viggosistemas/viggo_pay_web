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
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height/1.1,
        left: MediaQuery.of(context).size.width/1.3,
        right: 20
      ),
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
