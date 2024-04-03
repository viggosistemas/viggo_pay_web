import 'package:flutter/material.dart';

class ContainerClass {
  ContainerClass();

  double maxWidthContainer(
    BoxConstraints constraints,
    BuildContext context,
    bool useDeviceSize, {
    double? percentWidth,
  }) {
    final deviceSize = MediaQuery.of(context).size;
    var percent = 0.5;

    if (percentWidth != null) percent = percentWidth;

    if (constraints.maxWidth <= 599.98) {
      return useDeviceSize ? deviceSize.width : 480;
    } else if (constraints.maxWidth >= 600 && constraints.maxWidth < 959.98) {
      return useDeviceSize ? deviceSize.width * percent : 720;
    } else if (constraints.maxWidth >= 960 && constraints.maxWidth < 1279.98) {
      return useDeviceSize ? deviceSize.width * percent : 820;
    } else if (constraints.maxWidth >= 1280 && constraints.maxWidth < 1579.98) {
      return useDeviceSize ? deviceSize.width * percent : 1080;
    } else {
      //  if (constraints.maxWidth >= 1580 && constraints.maxWidth < 1979.98)
      return useDeviceSize ? deviceSize.width * percent : 1520;
    }
  }

  double maxHeightContainer(
    BuildContext context,
    bool flexDeviceSize, {
    double? heightPlus,
  }) {
    final deviceSize = MediaQuery.of(context).size;
    double plus = 0;
    if (heightPlus != null) plus = heightPlus;
    if (!flexDeviceSize) return deviceSize.height + plus;

    if (deviceSize.height <= 599.98) {
      return 480 + plus;
    } else if (deviceSize.height >= 600 && deviceSize.height < 959.98) {
      return 720 + plus;
    } else if (deviceSize.height >= 960 && deviceSize.height < 1279.98) {
      return 720 + plus;
    } else if (deviceSize.height >= 1280 && deviceSize.height < 1579.98) {
      return 1080 + plus;
    } else {
      //  if (deviceSize.height >= 1580 && deviceSize.height < 1979.98)
      return 1080 + plus;
    }
  }
}
