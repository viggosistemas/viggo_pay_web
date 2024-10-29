// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viggo_core_frontend/base/base_view_model.dart';
import 'package:viggo_core_frontend/domain/data/models/domain_api_dto.dart';
import 'package:viggo_core_frontend/domain/domain/usecases/get_domain_from_settings_use_case.dart';
import 'package:viggo_core_frontend/domain/domain/usecases/search_domain_by_name_use_case.dart';
import 'package:viggo_core_frontend/domain/domain/usecases/set_domain_use_case.dart';
import 'package:viggo_core_frontend/image/domain/usecases/parse_image_url_use_case.dart';
import 'package:viggo_core_frontend/preferences/domain/usecases/clear_remember_credential_use_case.dart';
import 'package:viggo_core_frontend/preferences/domain/usecases/get_remember_credential_use_case.dart';
import 'package:viggo_core_frontend/preferences/domain/usecases/set_remember_credential_use_case.dart';
import 'package:viggo_core_frontend/route/data/models/route_api_dto.dart';
import 'package:viggo_core_frontend/route/domain/usecases/get_routes_use_case.dart';
import 'package:viggo_core_frontend/route/domain/usecases/set_routes_use_case.dart';
import 'package:viggo_core_frontend/token/data/models/login_command.dart';
import 'package:viggo_core_frontend/token/domain/usecases/login_use_case.dart';
import 'package:viggo_core_frontend/token/domain/usecases/set_token_use_case.dart';
import 'package:viggo_core_frontend/user/data/models/user_api_dto.dart';
import 'package:viggo_core_frontend/user/domain/usecases/get_roles_from_user_by_id_use_case.dart';
import 'package:viggo_core_frontend/user/domain/usecases/get_routes_from_user_use_case.dart';
import 'package:viggo_core_frontend/user/domain/usecases/get_user_by_id_use_case.dart';
import 'package:viggo_core_frontend/user/domain/usecases/get_user_use_case.dart';
import 'package:viggo_core_frontend/user/domain/usecases/set_user_use_case.dart';
import 'package:viggo_pay_admin/login/ui/login_form_fields.dart';
import 'package:viggo_pay_admin/sync/domain/usecases/get_app_state_use_case.dart';
import 'package:viggo_pay_admin/utils/constants.dart';

class LoginViewModel extends BaseViewModel {
  SharedPreferences sharedPrefs;
  final GetAppStateUseCase getAppState;

  final GetDomainFromSettingsUseCase getDomainFromSettings;
  final GetUserUseCase getUserFromSettings;
  final GetRoutesUseCase getRoutesFromSettings;
  final GetRememberCredentialUseCase getRememberCredential;
  final GetUserByIdUseCase getUserById;
  final GetRoutesFromUserUseCase getRoutesFromUser;
  final GetRolesFromUserIdUseCase getRolesFromUserById;

  final ClearRememberCredentialUseCase clearRememberCredential;

  final LoginUseCase login;
  final SearchDomainByNameUseCase getDomainByName;

  final SetRoutesUseCase setRoutes;
  final SetUserUseCase setUser;
  final SetTokenUseCase setToken;
  final SetDomainUseCase setDomain;
  final SetRememberCredentialUseCase setRememberCredential;

  final ParseImageUrlUseCase parseImage;

  final LoginFormFields form = LoginFormFields();

  final StreamController<DomainApiDto?> _streamControllerDomain = StreamController<DomainApiDto?>.broadcast();

  final StreamController<UserApiDto?> _streamControllerUser = StreamController<UserApiDto?>.broadcast();

  final StreamController<List<RouteApiDto>?> _streamControllerRoutes = StreamController<List<RouteApiDto>?>.broadcast();

  final StreamController<bool> _streamController = StreamController<bool>.broadcast();

  final StreamController<String> _streamControllerError = StreamController<String>.broadcast();

  Stream<bool> get isLogged => _streamController.stream;
  Stream<String> get isError => _streamControllerError.stream;
  Stream<DomainApiDto?> get domainDto => _streamControllerDomain.stream;
  Stream<UserApiDto?> get userDto => _streamControllerUser.stream;
  Stream<List<RouteApiDto>?> get routesDto => _streamControllerRoutes.stream;

  LoginViewModel(
      {required this.sharedPrefs,
      required this.login,
      required this.parseImage,
      required this.clearRememberCredential,
      required this.getAppState,
      required this.getDomainFromSettings,
      required this.getUserFromSettings,
      required this.getRoutesFromSettings,
      required this.getRoutesFromUser,
      required this.getDomainByName,
      required this.getRememberCredential,
      required this.getUserById,
      required this.getRolesFromUserById,
      required this.setUser,
      required this.setToken,
      required this.setRoutes,
      required this.setDomain,
      required this.setRememberCredential
    }) {
    getCredentials();
    getAppState.invoke().forEach((element) {
      if (!_streamController.isClosed) {
        _streamController.sink.add(element == AppStateConst.LOGGED);
      }
    });
  }

  void getCredentials() {
    var credentials = getRememberCredential.invoke();
    if (credentials?['rememberCredentials'] == true) {
      form.domain.onValueChange(credentials?['domain_name']);
      form.username.onValueChange(credentials?['usernameOrEmail']);
      form.remember.onValueChange(credentials!['rememberCredentials'].toString());
    }
  }

  void getDomain() {
    var domainDto = getDomainFromSettings.invoke();

    if (domainDto != null) {
      _streamControllerDomain.sink.add(domainDto);
      form.domain.onValueChange(domainDto.name);
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

  void onClearRememberCredential() {
    clearRememberCredential.invoke();
    _streamControllerDomain.sink.add(null);
    form.domain.onValueChange('');
    form.username.onValueChange('');
    form.password.onValueChange('');
    form.remember.onValueChange('');
  }

  Future<void> funGetDomainByName(String domainName) async {
    var result = await getDomainByName.invoke(name: domainName);
    if (result.isLeft) {
      if (!_streamControllerError.isClosed) {
        _streamControllerError.sink.add(result.left.message);
      }
    } else {
      _streamControllerDomain.sink.add(result.right);
      setDomain.invoke(result.right);
    }
  }

  Future<void> funGetRoutesFromUser() async {
    var result = await getRoutesFromUser.invoke();
    if (result.isLeft) {
      if (!_streamControllerError.isClosed) {
        _streamControllerError.sink.add(result.left.message);
      }
    } else {
      setRoutes.invoke(result.right);
    }
  }

  Future<void> funGetRolesFromUser(UserApiDto user) async {
    var result = await getRolesFromUserById.invoke(id: user.id);
    if (result.isLeft) {
      if (!_streamControllerError.isClosed) {
        _streamControllerError.sink.add(result.left.message);
      }
    } else {
      user.roles = result.right;
      setUser.invoke(user);
    }
  }

  Future<void> funGetUserById(String userId) async {
    var result = await getUserById.invoke(id: userId, include: 'domain.application,domain.addresses.municipio,domain.addresses.pais');
    if (result.isLeft) {
      if (!_streamControllerError.isClosed) {
        _streamControllerError.sink.add(result.left.message);
      }
    } else {
      await funGetRolesFromUser(result.right);
    }
  }

  void onSubmit(
    Function showMsg,
    BuildContext context,
  ) async {
    if (isLoading) return;
    setLoading();

    var formFields = form.getValues();

    LoginCommand loginCommand = LoginCommand();
    loginCommand.domainName = formFields?['domain'] ?? '';
    loginCommand.username = formFields?['username'] ?? '';
    loginCommand.password = formFields?['password'] ?? '';
    loginCommand.natureza = 'VIGGO_PAY_WEB';

    var result = await login.invoke(loginCommand: loginCommand);
    if (result.isLeft) {
      if (!_streamControllerError.isClosed) {
        _streamControllerError.sink.add(result.left.message);
        setLoading();
      }
    } else {
      var rememberCredentials = form.getRememberFields();
      if (rememberCredentials != null) {
        setRememberCredential.invoke(rememberCredentials);
      }
      setToken.invoke(result.right);
      await funGetUserById(result.right.userId);
      await funGetRoutesFromUser();
      await funGetDomainByName(loginCommand.domainName);
      setLoading();
    }
  }

  Future<String?> getImageUrl(String? photoId) async {
    if (photoId != null) return await parseImage.invoke(photoId);
    return null;
  }
}

extension BoolParsing on String {
  bool parseBool() {
    return toLowerCase() == 'true';
  }
}
