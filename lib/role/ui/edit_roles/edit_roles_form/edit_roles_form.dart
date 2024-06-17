import 'package:flutter/material.dart';
import 'package:viggo_core_frontend/role/data/models/role_api_dto.dart';
import 'package:viggo_pay_admin/components/hover_button.dart';
import 'package:viggo_pay_admin/domain_account/ui/edit_domain_accounts/edit_domain_accounts_view_model.dart';
import 'package:viggo_pay_admin/role/ui/edit_roles/edit_roles_view_model.dart';

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
      viewModel.form.name.onValueChange(entity!.name);
    }

    return Column(
      children: [
        StreamBuilder<String>(
            stream: viewModel.form.name.field,
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
                    viewModel.form.name.onValueChange(value);
                  });
            }),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StreamBuilder<String?>(
              stream: viewModel.form.multiDomain.field,
              builder: (context, snapshot) {
                return OnHoverButton(
                  child: Checkbox(
                    value: snapshot.data != null && snapshot.data!.isNotEmpty
                        ? snapshot.data!.parseBool()
                        : entity != null
                            ? entity!.dataView.name == 'MULTI_DOMAIN'
                            : false,
                    onChanged: (value) {
                      viewModel.form.multiDomain.onValueChange(value!.toString());
                    },
                  ),
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
