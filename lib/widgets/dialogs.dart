import 'package:flutter/material.dart';

class Dialogs {
  final BuildContext context;
  Dialogs({required this.context});

  Future<void> showSimpleDialog(message) {
    return showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            content: Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Text(message),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Voltar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
