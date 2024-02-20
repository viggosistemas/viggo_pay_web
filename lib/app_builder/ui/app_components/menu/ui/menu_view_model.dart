import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/menu/models/destination.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/main.dart';
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
        Icon(
          Icons.domain_outlined,
          color: kColorScheme.primary,
        ),
        2,
        Icon(
          Icons.domain_outlined,
          color: kColorScheme.primary,
        ),
        Routes.APPLICATIONS,
        ['/applications'],
        ['/GET'],
        null,
      ),
      Destination(
        'Rota',
        Icon(
          Icons.route_outlined,
          color: kColorScheme.primary,
        ),
        3,
        Icon(
          Icons.route_outlined,
          color: kColorScheme.primary,
        ),
        Routes.ROUTES,
        ['/routes'],
        ['/GET'],
        null,
      ),
      Destination(
        'Papéis de Usuário',
        Icon(
          Icons.supervisor_account_outlined,
          color: kColorScheme.primary,
        ),
        4,
        Icon(
          Icons.supervisor_account_outlined,
          color: kColorScheme.primary,
        ),
        Routes.ROLES,
        ['/roles/<id>'],
        ['/GET'],
        null,
      ),
      Destination(
        'Organização',
        Icon(
          Icons.cases_outlined,
          color: kColorScheme.primary,
        ),
        5,
        Icon(
          Icons.cases_outlined,
          color: kColorScheme.primary,
        ),
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
        Icon(
          Icons.person_outline,
          color: kColorScheme.primary,
        ),
        1,
        Icon(
          Icons.person_outline,
          color: kColorScheme.primary,
        ),
        Routes.USERS,
        ['/users'],
        ['/GET'],
        null,
      ),
    ]);

    return submenu;
  }
}
