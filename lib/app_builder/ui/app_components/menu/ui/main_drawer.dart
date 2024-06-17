import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:viggo_core_frontend/route/data/models/route_api_dto.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_builder_view_model.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/menu/models/destination.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/menu/ui/menu_view_model.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/utils/constants.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({
    super.key,
    required this.onSelectScreen,
  });

  final void Function(String identifier) onSelectScreen;

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  List<Destination> destinations = <Destination>[];
  List<ListTile> navDestinations = <ListTile>[];
  AppBuilderViewModel appViewModel = locator.get<AppBuilderViewModel>();
  final viewModel = MenuViewModel(menuItems: menuItems);

  _buildMenu(
    List<RouteApiDto> routes,
    int screenIndex,
  ) {
    destinations = viewModel.createMenu(routes);
    navDestinations = destinations.map(
      (Destination destination) {
        var index = destinations.indexWhere((element) => destination.label == element.label);
        return ListTile(
          selected: screenIndex == index,
          selectedColor: Theme.of(context).colorScheme.primary,
          selectedTileColor: Theme.of(context).colorScheme.primary,
          onTap: () {
            appViewModel.setScreenIndex(index);
            widget.onSelectScreen(destination.route);
          },
          leading: Icon(
            destination.iconName,
            size: 18,
            color: screenIndex == index ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.primary,
          ),
          title: Text(
            destination.label,
            style: GoogleFonts.roboto(
              color: screenIndex == index ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.primary,
              fontSize: 18,
            ),
          ),
        );
      },
    ).toList();
  }

  @override
  Widget build(context) {
    return StreamBuilder<int>(
        stream: appViewModel.indexSelected,
        builder: (context, index) {
          if (index.data == null) {
            appViewModel.getScreenIndex();
            return const CircularProgressIndicator();
          } else {
            return StreamBuilder<List<RouteApiDto>?>(
                stream: appViewModel.routesDto,
                builder: (context, routes) {
                  if (routes.data == null) {
                    appViewModel.getRoutes();
                  } else {
                    _buildMenu(routes.data!, index.data!);
                  }
                  return Drawer(
                    child: Column(
                      children: [
                        DrawerHeader(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.primary.withOpacity(0.75),
                              Theme.of(context).colorScheme.primary,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomCenter,
                          )),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/images/logo.png',
                                width: 80,
                                height: 80,
                              ),
                            ],
                          ),
                        ),
                        ...navDestinations,
                      ],
                    ),
                  );
                });
          }
        });
  }
}

List<Destination> menuItems = [
  Destination(
    'Empresas',
    null,
    4,
    null,
    Routes.DOMAIN_ACCOUNTS,
    ['/domain_accounts'],
    ['/GET'],
    Icons.domain_outlined,
  ),
  Destination(
    'Chaves pix',
    null,
    6,
    null,
    Routes.PIX,
    ['/pix_to_sends'],
    ['/POST'],
    Icons.key_outlined,
  ),
  Destination(
    'Informações da matriz',
    null,
    2,
    null,
    Routes.MATRIZ,
    ['/pay_facs/cashout_via_pix'],
    ['/POST'],
    Icons.domain_add_outlined,
  ),
  Destination(
    'Transações da matriz',
    null,
    5,
    null,
    Routes.MATRIZ_TRANSFERENCIA,
    ['/pay_facs/get_saldo'],
    ['/POST'],
    Icons.transfer_within_a_station_outlined,
  ),
  Destination(
    'Funcionário',
    null,
    3,
    null,
    Routes.FUNCIONARIO,
    ['/funcionarios'],
    ['/POST'],
    Icons.engineering_outlined,
  ),
  Destination(
    'Extrato da conta',
    null,
    7,
    null,
    Routes.EXTRATO,
    ['/pay_facs/get_extrato'],
    ['/POST'],
    Icons.history_outlined,
  ),
];
