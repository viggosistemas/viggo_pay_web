import 'dart:async';

import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/domain_account/ui/edit_domain_accounts/config_domain_accounts/config_domain_accounts_form_fields.dart';
import 'package:viggo_pay_admin/pix_to_send/domain/usecases/update_pix_to_send_use_case.dart';
import 'package:viggo_pay_admin/pix_to_send/ui/edit_pix_to_send/edit_pix_to_sends_form/edit_form_fields.dart';

class EditPixToSendViewModel extends ChangeNotifier {
  bool isLoading = false;

  final UpdatePixToSendUseCase updatePixToSend;

  final EditPixToSendFormFields form = EditPixToSendFormFields();
  final ConfigDomainAccountFormFields formConfig =
      ConfigDomainAccountFormFields();

  final StreamController<String> _streamControllerError =
      StreamController<String>.broadcast();
  Stream<String> get isError => _streamControllerError.stream;

  final StreamController<bool> _streamControllerSuccess =
      StreamController<bool>.broadcast();
  Stream<bool> get isSuccess => _streamControllerSuccess.stream;

  EditPixToSendViewModel({
    required this.updatePixToSend,
  });

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
      'alias': formFields!['alias']
    };

    var result = await updatePixToSend.invoke(id: id!, body: data);
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
