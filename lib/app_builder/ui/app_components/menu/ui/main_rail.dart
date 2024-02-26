import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_builder_view_model.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/menu/models/destination.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/menu/ui/menu_view_model.dart';
import 'package:viggo_pay_admin/utils/constants.dart';
import 'package:viggo_pay_core_frontend/route/data/models/route_api_dto.dart';

class MainRail extends StatefulWidget {
  const MainRail({
    super.key,
    required this.onSelectScreen,
  });

  final void Function(String identifier) onSelectScreen;

  @override
  State<MainRail> createState() => _MainRailState();
}

class _MainRailState extends State<MainRail> {
  List<Destination> destinations = <Destination>[];
  List<NavigationRailDestination> navDestinations =
      <NavigationRailDestination>[];
  final viewModel = MenuViewModel(menuItems: menuItems);

  var screenIndex = 0;

  _buildMenu(List<RouteApiDto> routes) {
    destinations = viewModel.createMenu(routes);
    navDestinations = destinations.map(
      (Destination destination) {
        return NavigationRailDestination(
          label: Text(destination.label),
          icon: Tooltip(
            message: destination.label,
            showDuration: const Duration(milliseconds: 2),
            child: destination.icon!,
          ),
          selectedIcon: Tooltip(
            message: destination.label,
            showDuration: const Duration(milliseconds: 2),
            child: destination.selectedIcon!,
          ),
        );
      },
    ).toList();
  }

  @override
  Widget build(context) {
    final viewModel = Provider.of<AppBuilderViewModel>(context);

    return StreamBuilder<List<RouteApiDto>?>(
      stream: viewModel.routesDto,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          viewModel.getRoutes();
        } else {
          _buildMenu(snapshot.data!);
        }
        return StreamBuilder<int>(
          stream: viewModel.indexSelected,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              viewModel.getScreenIndex();
            }
            return NavigationRail(
              minWidth: 50,
              destinations: navDestinations,
              selectedIndex: snapshot.data,
              useIndicator: true,
              groupAlignment: -1,
              selectedIconTheme: IconThemeData(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              indicatorColor: Theme.of(context).colorScheme.primary,
              onDestinationSelected: (int index) {
                // setState(() {
                //   screenIndex = index;
                // });
                viewModel.setScreenIndex(index);
                widget.onSelectScreen(destinations[index].route);
              },
            );
          },
        );
      },
    );
  }
}

List<Destination> menuItems = [
  Destination(
    'Empresas',
    const Icon(Icons.domain_outlined),
    2,
    const Icon(Icons.domain_outlined),
    Routes.DOMAIN_ACCOUNTS,
    ['/domain_accounts'],
    ['/GET'],
    null,
  ),
  Destination(
    'Chaves pix',
    const Icon(Icons.key_outlined),
    3,
    const Icon(Icons.key_outlined),
    Routes.PIX,
    ['/pix_to_sends'],
    ['/GET'],
    null,
  ),
  // Destination(
  //   'Transação entre contas',
  //   Icon(
  //     Icons.transfer_within_a_station_outlined,
  //   ),
  //   4,
  //   Icon(
  //     Icons.transfer_within_a_station_outlined,
  //   ),
  //   Routes.TRANSACAO_CONTA,
  //   ['/pay_facs/cashout_via_pix'],
  //   ['/POST'],
  //   null,
  // ),
  Destination(
    'Histórico de transações',
    const Icon(
      Icons.history_outlined,
    ),
    5,
    const Icon(
      Icons.history_outlined,
    ),
    Routes.HISTORICO,
    ['/pay_facs/get_transacoes'],
    ['/POST'],
    null,
  ),
];
