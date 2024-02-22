import 'dart:async';

import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/domain_account/domain/usecases/update_domain_account_use_case.dart';
import 'package:viggo_pay_admin/domain_account/ui/edit_domain_accounts/edit_domain_accounts_form/edit_form_fields.dart';

class EditDomainAccountViewModel extends ChangeNotifier {
  bool isLoading = false;
  
  final UpdateDomainAccountUseCase updateDomainAccount;

  final EditDomainAccountFormFields form = EditDomainAccountFormFields();

  final StreamController<String> _streamControllerError = StreamController<String>.broadcast();
  Stream<String> get isError => _streamControllerError.stream;

  final StreamController<bool> _streamControllerSuccess = StreamController<bool>.broadcast();
  Stream<bool> get isSuccess => _streamControllerSuccess.stream;

  EditDomainAccountViewModel({required this.updateDomainAccount});

  void notifyLoading() {
    isLoading = !isLoading;
    // notifyListeners();
  }

  void submit(
    String? id,
    Function showMsg,
    BuildContext context,
  ) async {
    notifyLoading();
    var formFields = form.getFields();

    Map<String, dynamic> data = {
      'id': id,
      'client_name': formFields!['client_name']
    };

    var result = await updateDomainAccount.invoke(id: id!, body: data);
    if (result.isLeft) {
      if (!_streamControllerError.isClosed) {
        _streamControllerError.sink.add(result.left.message);
        notifyLoading();
      }
    } else {
      if (!_streamControllerSuccess.isClosed) {
        _streamControllerSuccess.sink.add(true);
        notifyLoading();
      }
    }
  }
}
