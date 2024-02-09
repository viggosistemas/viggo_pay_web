import 'dart:async';

import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/sync/domain/usecases/get_app_state_use_case.dart';
import 'package:viggo_pay_admin/utils/constants.dart';
import 'package:viggo_pay_core_frontend/domain/data/models/domain_api_dto.dart';
import 'package:viggo_pay_core_frontend/domain/domain/usecases/get_domain_from_settings_use_case.dart';
import 'package:viggo_pay_core_frontend/route/data/models/route_api_dto.dart';
import 'package:viggo_pay_core_frontend/route/domain/usecases/get_routes_use_case.dart';
import 'package:viggo_pay_core_frontend/token/domain/usecases/get_token_use_case.dart';
import 'package:viggo_pay_core_frontend/token/domain/usecases/logout_use_case.dart';
import 'package:viggo_pay_core_frontend/user/data/models/user_api_dto.dart';
import 'package:viggo_pay_core_frontend/user/domain/usecases/get_user_use_case.dart';

class AppBuilderViewModel extends ChangeNotifier{
  final GetAppStateUseCase getAppState;
  final LogoutUseCase logout;
  final GetTokenUseCase getToken;
  final GetUserUseCase getUserFromSettings;
  final GetRoutesUseCase getRoutesFromSettings;
  final GetDomainFromSettingsUseCase getDomainFromSettings;

  final StreamController<UserApiDto?> _streamControllerUser =
      StreamController<UserApiDto?>.broadcast();

  final StreamController<DomainApiDto?> _streamControllerDomain =
      StreamController<DomainApiDto?>.broadcast();

  final StreamController<List<RouteApiDto>?> _streamControllerRoutes =
      StreamController<List<RouteApiDto>?>.broadcast();

  final StreamController<bool> _streamController =
      StreamController<bool>.broadcast();

  Stream<bool> get isLogged => _streamController.stream;
  Stream<DomainApiDto?> get domainDto => _streamControllerDomain.stream;
  Stream<UserApiDto?> get userDto => _streamControllerUser.stream;
  Stream<List<RouteApiDto>?> get routesDto => _streamControllerRoutes.stream;
  Stream<bool> get isLoggedMsg => getAppState.invoke().transform(showIsLoggedMsg);

  AppBuilderViewModel({
    required this.getAppState,
    required this.logout,
    required this.getToken,
    required this.getUserFromSettings,
    required this.getRoutesFromSettings,
    required this.getDomainFromSettings,
  }){
    getAppState.invoke().forEach((element) {
      if (!_streamController.isClosed) {
        _streamController.sink.add(element == AppStateConst.LOGGED);
      }
    });
  }

  void getDomain() {
    var domainDto = getDomainFromSettings.invoke();

    if (domainDto != null) {
      _streamControllerDomain.sink.add(domainDto);
    }
  }

  void getUser() {
    var userDto = getUserFromSettings.invoke();

    if (userDto != null) {
      _streamControllerUser.sink.add(userDto);
    }
  }

  void getRoutes() {
    var routesDto = getRoutesFromSettings.invoke();

    if (routesDto != null) {
      _streamControllerRoutes.sink.add(routesDto);
    }
  }

  Future<void> onLogout(Function onSelectScreen) async{
    await logout.invoke(tokenId: getToken.invoke()!.id);
    onSelectScreen(Routes.LOGIN_PAGE);
  }

  final showIsLoggedMsg = StreamTransformer<String, bool>.fromHandlers(
    handleData: (value, sink) {
      sink.add(value == AppStateConst.LOGGED);
    },
  );
}
