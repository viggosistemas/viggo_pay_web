import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/menu/models/destination.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/utils/constants.dart';
import 'package:viggo_pay_core_frontend/route/data/models/route_api_dto.dart';
import 'package:viggo_pay_core_frontend/user/domain/usecases/get_user_use_case.dart';

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

    if (userDto != null && userDto.name == 'sysadmin') {
      menu.addAll(createSysadminMenu(routes));
    }

    menu.addAll(createAdminMenu(routes));

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
    List<String> grantURLs = getGrantURLs(
      routes,
      itens.map((v) => v.backEndUrl).toList(),
      false,
    );
    for (var rota in grantURLs) {
      int itemIndex = itens.indexWhere((v) => v.backEndUrl!.contains(rota));
      if (itemIndex >= 0) menu.add(itens[itemIndex]);
    }
    return menu;
  }

  List<String> getGrantURLs(
    List<RouteApiDto> routes,
    List<dynamic> urls,
    bool checkRoutes,
  ) {
    List<String> grantURLs = [];
    if (checkRoutes) {
      for (var route in routes) {
        for (var url in urls) {
          if (url.name == route.url && url.method == route.method) {
            grantURLs.add(route.url);
          }
        }
      }
    } else {
      for (var route in routes) {
        for (var urlCompare in urls) {
          if (urlCompare.contains(route.url) &&
              !grantURLs.contains(route.url)) {
            grantURLs.add(route.url);
          }
        }
      }
    }
    return grantURLs;
  }

  List<Destination> createSysadminMenu(List<RouteApiDto> routes) {
    List<Destination> submenu = buildMenu(routes, [
      Destination(
        'Aplicação',
        const Icon(Icons.domain_outlined),
        2,
        const Icon(Icons.domain_outlined),
        Routes.APPLICATIONS,
        ['/applications'],
        ['/GET'],
        null,
      ),
      Destination(
        'Rota',
        const Icon(Icons.route_outlined),
        3,
        const Icon(Icons.route_outlined),
        Routes.ROUTES,
        ['/routes'],
        ['/GET'],
        null,
      ),
      Destination(
        'Papéis de Usuário',
        const Icon(Icons.supervisor_account_outlined),
        4,
        const Icon(Icons.supervisor_account_outlined),
        Routes.ROLES,
        ['/roles/<id>'],
        ['/GET'],
        null,
      ),
      Destination(
        'Organização',
        const Icon(Icons.cases_outlined),
        5,
        const Icon(Icons.cases_outlined),
        Routes.DOMAINS,
        ['/domains'],
        ['/GET'],
        null,
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
        null,
      ),
    ]);

    return submenu;
  }
}
