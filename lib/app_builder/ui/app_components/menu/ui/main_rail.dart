import 'package:flutter/material.dart';
import 'package:viggo_core_frontend/route/data/models/route_api_dto.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_builder_view_model.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/menu/models/destination.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/menu/ui/menu_view_model.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/utils/constants.dart';

class MainRail extends StatefulWidget {
  const MainRail({
    super.key,
    required this.onSelectScreen,
    required this.routes,
  });

  final void Function(String identifier) onSelectScreen;
  final List<RouteApiDto> routes;

  @override
  State<MainRail> createState() => _MainRailState();
}

class _MainRailState extends State<MainRail> {
  List<Destination> destinations = <Destination>[];
  List<NavigationRailDestination> navDestinations =
      <NavigationRailDestination>[];

  final appViewModel = locator.get<AppBuilderViewModel>();

  final viewModel = MenuViewModel(menuItems: menuItems);

  var screenIndex = 0;

  _buildMenu() {
    destinations = viewModel.createMenu(widget.routes);
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
    _buildMenu();
    return StreamBuilder<int>(
      stream: appViewModel.indexSelected,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          appViewModel.getScreenIndex();
          return const CircularProgressIndicator();
        } else {
          return NavigationRail(
            minWidth: 50,
            destinations: navDestinations,
            selectedIndex: snapshot.data,
            useIndicator: true,
            groupAlignment: -1,
            onDestinationSelected: (int index) {
              appViewModel.setScreenIndex(index);
              widget.onSelectScreen(destinations[index].route);
            },
          );
        }
      },
    );
  }
}

List<Destination> menuItems = [
  Destination(
    'Empresas',
    const Icon(Icons.domain_add_outlined),
    4,
    const Icon(Icons.domain_add_outlined),
    Routes.DOMAIN_ACCOUNTS,
    ['/domain_accounts'],
    ['/POST'],
    null,
  ),
  Destination(
    'Chaves pix',
    const Icon(Icons.key_outlined),
    6,
    const Icon(Icons.key_outlined),
    Routes.PIX,
    ['/pix_to_sends'],
    ['/POST'],
    null,
  ),
  Destination(
    'Extrato da conta',
    const Icon(
      Icons.history_outlined,
    ),
    7,
    const Icon(
      Icons.history_outlined,
    ),
    Routes.EXTRATO,
    ['/pay_facs/get_extrato'],
    ['/POST'],
    null,
  ),
  Destination(
    'Informações da matriz',
    const Icon(
      Icons.business_center_outlined,
    ),
    2,
    const Icon(
      Icons.business_center_outlined,
    ),
    Routes.MATRIZ,
    ['/pay_facs/cashout_via_pix'],
    ['/POST'],
    null,
  ),
  Destination(
    'Transferência entre contas',
    const Icon(
      Icons.move_up_outlined,
    ),
    5,
    const Icon(
      Icons.move_up_outlined,
    ),
    Routes.MATRIZ_TRANSFERENCIA,
    ['/pay_facs/get_saldo'],
    ['/POST'],
    null,
  ),
  Destination(
    'Funcionário',
    const Icon(
      Icons.engineering_outlined,
    ),
    3,
    const Icon(
      Icons.engineering_outlined,
    ),
    Routes.FUNCIONARIO,
    ['/funcionarios'],
    ['/POST'],
    null,
  ),
];
