import 'package:flutter/material.dart';

class AlterarSenhaDialog {
  final BuildContext context;
  AlterarSenhaDialog({required this.context});

  Future<void> showFormDialog(message) {
    return showDialog(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        content: Padding(
          padding: const EdgeInsets.only(top: 14),
          child: Text(
            message,
            textAlign: TextAlign.center,
            overflow: TextOverflow.clip,
          ),
        ),
        actions: <Widget>[
          Center(
            child: TextButton(
              child: const Text('Entendi'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
