import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:viggo_pay_admin/components/event_card.dart';

class TimelineAppTile extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final bool isPast;
  final IconData iconInfo;
  final Widget eventCard;

  const TimelineAppTile({
    super.key,
    required this.isFirst,
    required this.isLast,
    required this.isPast,
    required this.iconInfo,
    required this.eventCard,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: TimelineTile(
        isFirst: isFirst,
        isLast: isLast,
        beforeLineStyle: LineStyle(
          color: isPast
              ? const Color(0xff1f005c)
              : Colors.deepPurple.shade100,
        ),
        indicatorStyle: IndicatorStyle(
          color: isPast
              ? const Color(0xff1f005c)
              : Colors.deepPurple.shade100,
          width: 40,
          iconStyle: IconStyle(
            color: isPast
              ? Colors.white
              : Colors.deepPurple.shade100,
            iconData: iconInfo,
          ),
        ),
        endChild: EventCardTimeline(
          isPast: isPast,
          child: eventCard,
        ),
      ),
    );
  }
}
