import 'package:flutter/material.dart';

class Destination {
  Destination(
    this.label,
    this.icon,
    this.selectedIcon,
    this.route,
    this.backEndUrl,
    this.methodUrl,
    this.iconName
  );

  final String label;
  final String route;
  Widget? icon;
  Widget? selectedIcon;
  String? backEndUrl;
  String? methodUrl;
  IconData? iconName;
}
