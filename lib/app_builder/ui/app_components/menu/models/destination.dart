import 'package:flutter/material.dart';

class Destination {
  Destination(
    this.label,
    this.icon,
    this.index,
    this.selectedIcon,
    this.route,
    this.backEndUrl,
    this.methodUrl,
    this.iconName
  );

  final String label;
  final String route;
  final int index;
  Widget? icon;
  Widget? selectedIcon;
  List<String>? backEndUrl;
  List<String>? methodUrl;
  IconData? iconName;
}
