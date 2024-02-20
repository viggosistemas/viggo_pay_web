import 'dart:async';

import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/pop_menu/ui/pop_menu_items/info_user/info_user_form_fields.dart';
import 'package:viggo_pay_core_frontend/user/domain/usecases/update_user_use_case.dart';

class PopMenuViewModel extends ChangeNotifier {
  final UpdateUserUseCase userUpdateUseCase;
  final InfoUserFormFields form = InfoUserFormFields();
  bool isLoading = false;

  final StreamController<bool> _streamController =
      StreamController<bool>.broadcast();

  final StreamController<String> _streamControllerError =
      StreamController<String>.broadcast();

  Stream<bool> get isSuccess => _streamController.stream;
  Stream<String> get isError => _streamControllerError.stream;

  PopMenuViewModel({
    required this.userUpdateUseCase,
  });

  void notifyLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  void onSubmit(
    Function showMsg,
    BuildContext context,
  ) async {
    notifyLoading();

    Map<String, dynamic> params = {
      'nickname': '',
    };
    var formFields = form.getFields();
    params['nickname'] = formFields?['nickname'] ?? '';

    // var result = await restorePassword.invoke(body: params);
    // if (result.isLeft) {
    //   if (!_streamControllerError.isClosed) {
    //     _streamControllerError.sink.add(result.left.message);
    //     notifyLoading();
    //   }
    // } else {
    //   if (!_streamController.isClosed) {
    //     _streamController.sink.add(result.right);
    //     notifyLoading();
    //   }
    // }
  }
}
