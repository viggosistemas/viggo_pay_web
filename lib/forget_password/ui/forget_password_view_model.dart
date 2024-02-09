import 'dart:async';

import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/forget_password/ui/forget_password_form_fields.dart';

class ForgetPasswordViewModel extends ChangeNotifier{
  final ForgetPassWordFormFields form = ForgetPassWordFormFields();
  bool isLoading = false;

  final StreamController<bool> _streamController =
      StreamController<bool>.broadcast();

  final StreamController<String> _streamControllerError =
      StreamController<String>.broadcast();
      
  Stream<bool> get isLogged => _streamController.stream;
  Stream<String> get isError => _streamControllerError.stream;

  ForgetPasswordViewModel();

  void notifyLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  void onSearch(
    Function showMsg,
    BuildContext context,
  ) async {
    // var formFields = form.getFields();
    // print(formFields);
    // LoginCommand loginCommand = LoginCommand();
    // loginCommand.domainName = formFields?['domain'] ?? '';
    // loginCommand.username = formFields?['username'] ?? '';
    // loginCommand.password = formFields?['password'] ?? '';

    // var result = await login.invoke(loginCommand: loginCommand);
    // if (result.isLeft) {
    //   if (!_streamControllerError.isClosed) {
    //     _streamControllerError.sink.add(result.left.message);
    //   }
    // } else {
    //   var rememberCredentials = form.getRememberFields();
    //   if(rememberCredentials != null){
    //     setRememberCredential.invoke(rememberCredentials);
    //   }
    //   setToken.invoke(result.right);
    //   await funGetDomainByName(loginCommand.domainName);
    // }
  }
}