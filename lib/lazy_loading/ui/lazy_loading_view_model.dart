// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:viggo_core_frontend/base/base_view_model.dart';
import 'package:viggo_core_frontend/token/domain/usecases/get_token_use_case.dart';
import 'package:viggo_pay_admin/di/locator.dart';

class LazyLoadingViewModel extends BaseViewModel {
  final GetTokenUseCase getToken;
  late SharedPreferences sharedPrefs = locator.get<SharedPreferences>();

  final StreamController<bool> _streamController =
      StreamController<bool>.broadcast();

  Stream<bool> get isLogged => _streamController.stream;

  LazyLoadingViewModel({
    required this.getToken,
  }) {
    checkAppState();
  }

  void checkAppState() {
    var tokenDto = getToken.invoke();

    if (tokenDto != null) {
      _streamController.sink.add(true);
    } else {
      _streamController.sink.add(false);
    }
  }
}
