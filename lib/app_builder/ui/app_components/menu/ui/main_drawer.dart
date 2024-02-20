import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_builder_view_model.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/menu/models/destination.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/menu/ui/menu_view_model.dart';
import 'package:viggo_pay_admin/utils/constants.dart';
import 'package:viggo_pay_core_frontend/route/data/models/route_api_dto.dart';

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

  final viewModel = MenuViewModel(menuItems: menuItems);

  var screenIndex = 0;

  _buildMenu(List<RouteApiDto> routes) {
    destinations = viewModel.createMenu(routes);
    navDestinations = destinations.map(
      (Destination destination) {
        var index = destinations
            .indexWhere((element) => destination.label == element.label);
        return ListTile(
          selected: screenIndex == index,
          selectedColor: Theme.of(context).colorScheme.primary,
          selectedTileColor: Theme.of(context).colorScheme.primary,
          onTap: () {
            setState(() {
              screenIndex = index;
            });
            widget.onSelectScreen(destination.route);
          },
          leading: Icon(
            destination.iconName,
            size: 18,
            color: screenIndex == index
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.primary,
          ),
          title: Text(
            destination.label,
            style: GoogleFonts.roboto(
              color: screenIndex == index
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.primary,
              fontSize: 18,
            ),
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
                        'assets/images/icone.png',
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(
                        width: 18,
                      ),
                      Text(
                        Constants.APP_NAME,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Colors.white,
                            ),
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
}

List<Destination> menuItems = [
  Destination(
    'Empresas',
    null,
    2,
    null,
    Routes.DOMAINS,
    ['/domain_accounts'],
    ['/GET'],
    Icons.domain_outlined,
  ),
  Destination(
    'Chaves pix',
    null,
    3,
    null,
    Routes.PIX,
    ['/pix_to_sends'],
    ['/GET'],
    Icons.key_outlined,
  ),
  Destination(
    'Transação entre contas',
    null,
    4,
    null,
    Routes.TRANSACAO_CONTA,
    ['/pay_facs/cashout_via_pix'],
    ['/POST'],
    Icons.transfer_within_a_station_outlined,
  ),
  Destination(
    'Histórico de transações',
    null,
    5,
    null,
    Routes.HISTORICO,
    ['/pay_facs/get_transacoes'],
    ['/GET'],
    Icons.history_outlined,
  ),
];
