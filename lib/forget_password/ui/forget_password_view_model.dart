import 'dart:async';

import 'package:flutter/material.dart';
import 'package:viggo_core_frontend/base/base_view_model.dart';
import 'package:viggo_core_frontend/user/domain/usecases/restore_password_use_case.dart';
import 'package:viggo_pay_admin/forget_password/ui/forget_password_form_fields.dart';

class ForgetPasswordViewModel extends BaseViewModel {
  final RestorePasswordUseCase restorePassword;
  final ForgetPassWordFormFields form = ForgetPassWordFormFields();

  final StreamController<bool> _streamController =
      StreamController<bool>.broadcast();

  final StreamController<String> _streamControllerError =
      StreamController<String>.broadcast();

  Stream<bool> get isSuccess => _streamController.stream;
  Stream<String> get isError => _streamControllerError.stream;

  ForgetPasswordViewModel({
    required this.restorePassword,
  });

  void onSubmit(
    Function showMsg,
    BuildContext context,
  ) async {
    if(isLoading) return;
    setLoading();

    Map<String, dynamic> params = {
      'domain_name': '',
      'email': '',
    };
    var formFields = form.getValues();
    params['domain_name'] = formFields?['domain'] ?? '';
    params['email'] = formFields?['email'] ?? '';

    var result = await restorePassword.invoke(body: params);
    if (result.isLeft) {
      if (!_streamControllerError.isClosed) {
        _streamControllerError.sink.add(result.left.message);
        setLoading();
      }
    } else {
      if (!_streamController.isClosed) {
        _streamController.sink.add(true);
        setLoading();
      }
    }
  }
}
