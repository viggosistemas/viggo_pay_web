import 'package:flutter/material.dart';

class Destination {
  const Destination(this.label, this.icon, this.selectedIcon);

  final String label;
  final Widget icon;
  final Widget selectedIcon;
}

class MainRail extends StatelessWidget {
  const MainRail({
    super.key,
    required this.onSelectScreen,
  });

  final void Function(String identifier) onSelectScreen;

  @override
  Widget build(context) {
    var screenIndex = 0;

    const List<Destination> destinations = <Destination>[
      Destination(
        'Home',
        Icon(Icons.home_outlined),
        Icon(Icons.home_outlined),
      ),
      Destination(
        'Empresas',
        Icon(Icons.domain_outlined),
        Icon(Icons.domain_outlined),
      ),
    ];

    return NavigationRail(
      minWidth: 50,
      destinations: destinations.map(
        (Destination destination) {
          return NavigationRailDestination(
            label: Text(destination.label),
            icon: destination.icon,
            selectedIcon: destination.selectedIcon,
          );
        },
      ).toList(),
      selectedIndex: screenIndex,
      useIndicator: true,
      onDestinationSelected: (int index) {
        onSelectScreen(destinations[index].label);
      },
    );
  }
}
