import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_api_dto.dart';
import 'package:viggo_pay_admin/domain_account/ui/edit_domain_accounts/edit_domain_accounts_view_model.dart';

// ignore: must_be_immutable
class EditDomainAccountsForm extends StatelessWidget {
  EditDomainAccountsForm({
    super.key,
    required this.viewModel,
    entity,
  }) {
    if (entity != null) {
      this.entity = entity;
    }
  }

  final EditDomainAccountViewModel viewModel;
  late DomainAccountApiDto entity;

  @override
  Widget build(context) {
    final clientNameFieldControll = TextEditingController();
    clientNameFieldControll.text = entity.clientName;

    return StreamBuilder<String>(
        stream: viewModel.form.clientName,
        builder: (context, snapshot) {
          clientNameFieldControll.value =
              clientNameFieldControll.value.copyWith(text: snapshot.data);
          return TextFormField(
              // onChanged: (value) {
              //   _txtAmountValue = value;
              // },
              controller: clientNameFieldControll,
              decoration: InputDecoration(
                labelText: 'Cliente',
                border: const OutlineInputBorder(),
                errorText: snapshot.error?.toString(),
              ),
              onChanged: (value) {
                viewModel.form.onClientNameChange(value);
              });
        });
  }
}
