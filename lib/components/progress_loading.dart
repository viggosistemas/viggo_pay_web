import 'package:flutter/material.dart';

class ProgressLoading extends StatelessWidget {
  const ProgressLoading({
    required this.color,
    super.key,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Carregando...',
          style: TextStyle(color: color),
        ),
        const SizedBox(
          height: 10,
        ),
        CircularProgressIndicator(color: color),
      ],
    );
  }
}
