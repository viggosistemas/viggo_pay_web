import 'dart:async';

import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/domain_account/ui/edit_domain_accounts/config_domain_accounts/config_domain_accounts_form_fields.dart';
import 'package:viggo_pay_admin/pix_to_send/domain/usecases/create_pix_to_send_use_case.dart';
import 'package:viggo_pay_admin/pix_to_send/domain/usecases/update_pix_to_send_use_case.dart';
import 'package:viggo_pay_admin/pix_to_send/ui/edit_pix_to_send/edit_pix_to_sends_form/edit_form_fields.dart';
import 'package:viggo_pay_core_frontend/domain/domain/usecases/get_domain_from_settings_use_case.dart';

class EditPixToSendViewModel extends ChangeNotifier {
  bool isLoading = false;

  final UpdatePixToSendUseCase updatePixToSend;
  final CreatePixToSendUseCase createPixToSend;
  final GetDomainFromSettingsUseCase getDomainFromSettings;

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
    required this.createPixToSend,
    required this.getDomainFromSettings,
  });

  get domainAccountID {
    var domainDto = getDomainFromSettings.invoke();

    if (domainDto != null) {
      return domainDto.id;
    }
  }

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
    dynamic result;
    var formFields = form.getFields()!;

    Map<String, dynamic> data = {
      'domain_account_id': domainAccountID,
      'alias': formFields['alias'],
      'psp_id': formFields['pspId'],
      'tax_identifier_tax_id': formFields['taxIdentifierTaxId'],
      'tax_identifier_country': formFields['taxIdentifierCountry'],
      'end_to_end_id_query': formFields['endToEndIdQuery'],
      'account_destination_branch': formFields['accountDestinationBranch'],
      'account_destination_account': formFields['accountDestinationAccount'],
      'account_destination_account_type': formFields['accountDestinationAccountType'],
    };

    if (id != null) {
      data.addEntries(
        <String, dynamic>{'id': id}.entries,
      );
    }
    if (id != null) {
      result = await updatePixToSend.invoke(
        id: id,
        body: data,
      );
    } else {
      result = await createPixToSend.invoke(body: data);
    }

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
