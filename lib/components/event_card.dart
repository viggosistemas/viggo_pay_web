import 'package:flutter/material.dart';

class EventCardTimeline extends StatelessWidget {
  final bool isPast;
  final Widget child;

  const EventCardTimeline({
    super.key,
    required this.isPast,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(25),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment(0.8, 1),
          colors: <Color>[
            Color(0xff1f005c),
            Color(0xff5b0060),
            Color(0xff870160),
            Color(0xffac255e),
            Color(0xffca485c),
            Color(0xffe16b5c),
            Color(0xfff39060),
            Color(0xffffb56b),
          ], // Gradient from https://learnui.design/tools/gradient-generator.html
          tileMode: TileMode.mirror,
        ),
        borderRadius: BorderRadius.circular(8),
        color: isPast
            ? const Color(0xff1f005c)
            : Colors.deepPurple.shade100,
      ),
      child: child,
    );
  }
}
