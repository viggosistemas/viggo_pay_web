import 'package:flutter/material.dart';
import 'package:pair/pair.dart';
import 'package:viggo_core_frontend/route/data/models/route_api_dto.dart';
import 'package:viggo_core_frontend/user/domain/usecases/get_user_use_case.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/menu/models/destination.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/utils/constants.dart';

class MenuViewModel {
  MenuViewModel({
    getUserFromSettings,
    menuItems,
  }) {
    if (menuItems != null) {
      this.menuItems = menuItems;
    }
    if (getUserFromSettings != null) {
      this.getUserFromSettings = getUserFromSettings;
    }
  }

  GetUserUseCase getUserFromSettings = locator.get<GetUserUseCase>();
  List<Destination> menuItems = [];

  List<Destination> createMenu(
    List<RouteApiDto> routes,
  ) {
    List<Destination> menu = [];
    var userDto = getUserFromSettings.invoke();

    menu.add(Destination(
      'Início',
      const Icon(Icons.home_outlined),
      0,
      const Icon(Icons.home_outlined),
      Routes.WORKSPACE,
      null,
      null,
      Icons.home_outlined,
    ));

    List<Destination> dymamicsMenus = buildMenu(routes, menuItems);
    var isSysadmin = userDto!.roles!.where((e) => e.name.toUpperCase() == 'SYSADMIN').toList().isNotEmpty;
    var isSuporte = userDto.roles!.where((e) => e.name.toUpperCase() == 'SUPORTE').toList().isNotEmpty;

    if (isSysadmin || isSuporte) {
      menu.addAll(createSysadminMenu(routes));
    } else {
      menu.addAll(createAdminMenu(routes));
    }

    if (dymamicsMenus.isNotEmpty) {
      dymamicsMenus.sort((a, b) => a.index.compareTo(b.index));
      menu.addAll(dymamicsMenus);
    }

    menu.sort((a, b) => a.index.compareTo(b.index));

    return menu;
  }

  List<Destination> buildMenu(
    List<RouteApiDto> routes,
    List<Destination> itens,
  ) {
    List<Destination> menu = [];
    List<Pair<String, String>> grantURLs = getGrantURLs(
      routes,
      itens.map((v) => v.backEndUrl).toList(),
      false,
    );
    for (var rota in grantURLs) {
      int itemIndex = itens.indexWhere((v) => v.backEndUrl!.contains(rota.key) && v.methodUrl!.contains(rota.value));
      if (itemIndex >= 0) menu.add(itens[itemIndex]);
    }
    return menu;
  }

  List<Pair<String, String>> getGrantURLs(
    List<RouteApiDto> routes,
    List<dynamic> urls,
    bool checkRoutes,
  ) {
    List<Pair<String, String>> grantURLs = [];
    if (checkRoutes) {
      for (var route in routes) {
        for (var url in urls) {
          if (url.name == route.url && url.method == route.method) {
            grantURLs.add(Pair(route.url, '/${route.method.name}'));
          }
        }
      }
    } else {
      for (var route in routes) {
        for (var urlCompare in urls) {
          if (urlCompare.contains(route.url) && !grantURLs.contains(route.url)) {
            grantURLs.add(Pair(route.url, '/${route.method.name}'));
          }
        }
      }
    }
    return grantURLs;
  }

  List<Destination> createSysadminMenu(List<RouteApiDto> routes) {
    List<Destination> submenu = buildMenu(routes, [
      Destination(
        'Usuários',
        const Icon(Icons.person_outline),
        1,
        const Icon(Icons.person_outline),
        Routes.USERS,
        ['/users'],
        ['/GET'],
        Icons.person_outline,
      ),
      Destination(
        'Aplicação',
        const Icon(Icons.domain_outlined),
        2,
        const Icon(Icons.domain_outlined),
        Routes.APPLICATIONS,
        ['/applications'],
        ['/GET'],
        Icons.domain_outlined,
      ),
      Destination(
        'Rota',
        const Icon(Icons.route_outlined),
        3,
        const Icon(Icons.route_outlined),
        Routes.ROUTES,
        ['/routes'],
        ['/GET'],
        Icons.route_outlined,
      ),
      Destination(
        'Papéis de Usuário',
        const Icon(Icons.supervisor_account_outlined),
        4,
        const Icon(Icons.supervisor_account_outlined),
        Routes.ROLES,
        ['/roles/<id>'],
        ['/GET'],
        Icons.supervisor_account_outlined,
      ),
      Destination(
        'Organização',
        const Icon(Icons.cases_outlined),
        5,
        const Icon(Icons.cases_outlined),
        Routes.DOMAINS,
        ['/domains'],
        ['/GET'],
        Icons.cases_outlined,
      ),
      Destination(
        'Usuários por domínio',
        const Icon(Icons.engineering_outlined),
        6,
        const Icon(Icons.engineering_outlined),
        Routes.USERS_FOR_DOMAIN,
        ['/domains/<id>/settings'],
        ['/DELETE'],
        Icons.engineering_outlined,
      ),
      Destination(
        'Domínios por matriz',
        const Icon(Icons.account_tree_outlined),
        7,
        const Icon(Icons.account_tree_outlined),
        Routes.MATRIZ_DOMAIN,
        ['/domain_account_taxas/<id>'],
        ['/DELETE'],
        Icons.account_tree_outlined,
      ),
    ]);
    return submenu;
  }

  List<Destination> createAdminMenu(List<RouteApiDto> routes) {
    List<Destination> submenu = buildMenu(routes, [
      Destination(
        'Usuários',
        const Icon(Icons.person_outline),
        1,
        const Icon(Icons.person_outline),
        Routes.USERS,
        ['/users'],
        ['/GET'],
        Icons.person_outline,
      ),
    ]);

    return submenu;
  }
}
