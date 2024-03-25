import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/components/hover_button.dart';

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
            child: OnHoverButton(
              child: TextButton(
                child: const Text('Entendi'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  showConfirmDialog(Map<String, dynamic> data) {
    return showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return PopScope(
            canPop: false,
            onPopInvoked: (bool didPop) {
              if (didPop) return;
              Navigator.pop(context, false);
            },
            child: AlertDialog(
              insetPadding: const EdgeInsets.all(10),
              title: Row(
                children: [
                  Text(
                    data['title_text'],
                    style: Theme.of(ctx).textTheme.titleMedium!.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Icon(data['title_icon']),
                ],
              ),
              content: SizedBox(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(data['message']),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                OnHoverButton(
                  child: TextButton(
                    child: const Text('Cancelar'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                ),
                OnHoverButton(
                  child: TextButton(
                    child: const Text('Confirmar'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }
}
