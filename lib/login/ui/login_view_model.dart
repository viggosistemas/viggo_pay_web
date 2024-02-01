// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/sync/domain/usecases/get_app_state_use_case.dart';
import 'package:viggo_pay_admin/utils/constants.dart';
import 'package:viggo_pay_core_frontend/domain/data/models/domain_api_dto.dart';
import 'package:viggo_pay_core_frontend/domain/domain/usecases/get_domain_fom_settings_use_case.dart';
import 'package:viggo_pay_core_frontend/domain/domain/usecases/search_domain_by_name_use_case.dart';
import 'package:viggo_pay_core_frontend/image/domain/usecases/parse_image_url_use_case.dart';
import 'package:viggo_pay_core_frontend/token/data/models/login_command.dart';
import 'package:viggo_pay_core_frontend/token/domain/usecases/login_use_case.dart';
import 'package:viggo_pay_core_frontend/token/domain/usecases/set_token_use_case.dart';

class LoginViewModel extends ChangeNotifier {
  final GetAppStateUseCase getAppState;
  final GetDomainFromSettingsUseCase getDomainFromSettings;
  final LoginUseCase login;
  final SearchDomainByNameUseCase getDomainByName;
  final SetTokenUseCase setToken;
  final ParseImageUrlUseCase parseImage;
  bool isLoading = false;
  DomainApiDto? domainDto;

  final StreamController<bool> _streamCotroller = StreamController<bool>.broadcast();
  final StreamController<String> _streamCotrollerError = StreamController<String>.broadcast();

  Stream<bool> get isLogged => _streamCotroller.stream;
  Stream<String> get isError => _streamCotrollerError.stream;

  LoginViewModel({
    required this.getAppState,
    required this.getDomainFromSettings,
    required this.login,
    required this.setToken,
    required this.parseImage,
    required this.getDomainByName
  }) {
    domainDto = getDomainFromSettings.invoke();
    
    if(domainDto == null) funGetDomainByName();

    getAppState.invoke().forEach((element) {
      if (!_streamCotroller.isClosed) {
        _streamCotroller.sink.add(element == AppStateConst.LOGGED);
      }
    });
  }

  Future<void> funGetDomainByName() async{
    var result = await getDomainByName.invoke(name: 'viggo_pro');
    if(result.isLeft){
      if(!_streamCotrollerError.isClosed){
        _streamCotrollerError.sink.add(result.left.message);
      }
    }else{
      domainDto = result.right;
      notifyListeners();
    }
  }

  void _notifyLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  void onSearch(
    String username,
    String password,
    Function showMsg,
    BuildContext context,
  ) async {
    _notifyLoading();

    LoginCommand loginCommand = LoginCommand();
    loginCommand.domainName = domainDto?.name ?? '';
    loginCommand.username = username;
    loginCommand.password = password;

    var result = await login.invoke(loginCommand: loginCommand);
    _notifyLoading();
    if (result.isLeft) {
      if(!_streamCotrollerError.isClosed){
        _streamCotrollerError.sink.add(result.left.message);
      }
    } else {
      setToken.invoke(result.right);
    }
  }
}
