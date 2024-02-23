import 'dart:async';

import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_config_api_dto.dart';
import 'package:viggo_pay_admin/domain_account/domain/usecases/add_config_domain_account_use_case.dart';
import 'package:viggo_pay_admin/domain_account/domain/usecases/update_config_domain_account_use_case%20copy.dart';
import 'package:viggo_pay_admin/domain_account/domain/usecases/update_domain_account_use_case.dart';
import 'package:viggo_pay_admin/domain_account/ui/edit_domain_accounts/config_domain_accounts/config_domain_accounts_form_fields.dart';
import 'package:viggo_pay_admin/domain_account/ui/edit_domain_accounts/edit_domain_accounts_form/edit_form_fields.dart';

class EditDomainAccountViewModel extends ChangeNotifier {
  bool isLoading = false;

  final UpdateDomainAccountUseCase updateDomainAccount;
  final UpdateConfigDomainAccountUseCase updateConfigAccount;
  final AddConfigDomainAccountUseCase createConfigAccount;

  final EditDomainAccountFormFields form = EditDomainAccountFormFields();
  final ConfigDomainAccountFormFields formConfig =
      ConfigDomainAccountFormFields();

  final StreamController<String> _streamControllerError =
      StreamController<String>.broadcast();
  Stream<String> get isError => _streamControllerError.stream;

  final StreamController<bool> _streamControllerSuccess =
      StreamController<bool>.broadcast();
  Stream<bool> get isSuccess => _streamControllerSuccess.stream;

  EditDomainAccountViewModel({
    required this.updateDomainAccount,
    required this.createConfigAccount,
    required this.updateConfigAccount,
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

  void submitConfig(
    DomainAccountConfigApiDto entity,
    Function showMsg,
    BuildContext context,
  ) async {
    notifyLoading();
    dynamic result;
    var form = formConfig.getFields();
    var taxa = form!['taxa'] ?? entity.taxa;

    Map<String, dynamic> data = entity.id.isNotEmpty
        ? {
            'id': entity.id,
            "domain_account_id": entity.domainAccountId,
            "taxa": double.parse(taxa.toString()),
            "porcentagem": form['porcentagem'].toString().parseBool(),
          }
        : {
            "domain_account_id": entity.domainAccountId,
            "taxa": double.parse(taxa.toString()),
            "porcentagem": form['porcentagem'].toString().parseBool(),
          };

    if (entity.id.isNotEmpty) {
      result = await updateConfigAccount.invoke(
        id: entity.id,
        body: data,
      );
    } else {
      result = await createConfigAccount.invoke(body: data);
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

extension BoolParsing on String {
  bool parseBool() {
    return toLowerCase() == 'true';
  }
}
