import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/pix_to_send/data/models/pix_to_send_api_dto.dart';
import 'package:viggo_pay_admin/pix_to_send/ui/edit_pix_to_send/edit_pix_to_sends_view_model.dart';

// ignore: must_be_immutable
class EditPixToSendsForm extends StatelessWidget {
  EditPixToSendsForm({
    super.key,
    required this.viewModel,
    entity,
  }) {
    if (entity != null) {
      this.entity = entity;
    }
  }

  final EditPixToSendViewModel viewModel;
  // ignore: avoid_init_to_null
  late PixToSendApiDto? entity = null;

  @override
  Widget build(context) {
    final aliasFieldControll = TextEditingController();
    if(entity != null) viewModel.form.onAliasChange(entity!.alias);

    return StreamBuilder<String>(
        stream: viewModel.form.alias,
        builder: (context, snapshot) {
          aliasFieldControll.value =
              aliasFieldControll.value.copyWith(text: snapshot.data);
          return TextFormField(
              // onChanged: (value) {
              //   _txtAmountValue = value;
              // },
              controller: aliasFieldControll,
              decoration: InputDecoration(
                labelText: 'Alias',
                border: const OutlineInputBorder(),
                errorText: snapshot.error?.toString(),
              ),
              onChanged: (value) {
                viewModel.form.onAliasChange(value);
              });
        });
  }
}
