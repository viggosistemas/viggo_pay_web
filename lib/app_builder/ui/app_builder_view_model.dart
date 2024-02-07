import 'dart:async';

import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/sync/domain/usecases/get_app_state_use_case.dart';
import 'package:viggo_pay_admin/utils/constants.dart';
import 'package:viggo_pay_core_frontend/token/domain/usecases/get_token_use_case.dart';
import 'package:viggo_pay_core_frontend/token/domain/usecases/logout_use_case.dart';

class AppBuilderViewModel extends ChangeNotifier{
  final GetAppStateUseCase getAppState;
  final LogoutUseCase logout;
  final GetTokenUseCase getToken;

  final StreamController<bool> _streamController =
      StreamController<bool>.broadcast();

  Stream<bool> get isLogged => _streamController.stream;
  
  AppBuilderViewModel({
    required this.getAppState,
    required this.logout,
    required this.getToken,
  }){
    getAppState.invoke().forEach((element) {
      if (!_streamController.isClosed) {
        _streamController.sink.add(element == AppStateConst.LOGGED);
      }
    });
  }

  Future<void> onLogout(Function onSelectScreen) async{
    await logout.invoke(tokenId: getToken.invoke()!.id);
    onSelectScreen('Logout');
  }
}
