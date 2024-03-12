import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/role/ui/edit_roles/edit_roles_view_model.dart';
import 'package:viggo_pay_core_frontend/role/data/models/role_api_dto.dart';

// ignore: must_be_immutable
class EditRolesForm extends StatelessWidget {
  EditRolesForm({
    super.key,
    required this.viewModel,
    entity,
  }) {
    if (entity != null) {
      this.entity = entity;
    }
  }

  final EditRolesViewModel viewModel;
  // ignore: avoid_init_to_null
  late RoleApiDto? entity = null;

  @override
  Widget build(context) {
    final nameFieldControll = TextEditingController();

    if (entity != null) {
      viewModel.form.onNameChange(entity!.name);
    }

    return Column(
      children: [
        StreamBuilder<String>(
            stream: viewModel.form.name,
            builder: (context, snapshot) {
              nameFieldControll.value =
                  nameFieldControll.value.copyWith(text: snapshot.data);
              return TextFormField(
                  // onChanged: (value) {
                  //   _txtAmountValue = value;
                  // },
                  controller: nameFieldControll,
                  decoration: InputDecoration(
                    labelText: 'Nome',
                    border: const OutlineInputBorder(),
                    errorText: snapshot.error?.toString(),
                  ),
                  onChanged: (value) {
                    viewModel.form.onNameChange(value);
                  });
            }),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StreamBuilder<bool?>(
              stream: viewModel.form.multiDomain,
              builder: (context, snapshot) {
                return Checkbox(
                  value: snapshot.data != null
                      ? snapshot.data!
                      : entity != null
                          ? entity!.dataView.name == 'MULTI_DOMAIN'
                          : false,
                  onChanged: (value) {
                    viewModel.form.onMultiDomainChange(value!);
                  },
                );
              },
            ),
            const SizedBox(width: 6),
            const Text('Papel multidomínio'),
          ],
        ),
      ],
    );
  }
}
