import 'package:flutter/material.dart';

class Dialogs {
  final BuildContext context;
  Dialogs({required this.context});

  Future<void> showSimpleDialog(message) {
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

  Future<void> showConfirmDialog(message) {
    return showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return PopScope(
            child: AlertDialog(
              content: Padding(
                padding: const EdgeInsets.only(top: 14),
                child: Text(message),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Confirmar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }
}
