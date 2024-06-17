import 'package:flutter/material.dart';
import 'package:viggo_core_frontend/application/data/models/application_api_dto.dart';
import 'package:viggo_pay_admin/application/ui/edit_applications/edit_applications_view_model.dart';

// ignore: must_be_immutable
class EditApplicationsForm extends StatelessWidget {
  EditApplicationsForm({
    super.key,
    required this.viewModel,
    entity,
  }) {
    if (entity != null) {
      this.entity = entity;
    }
  }

  final EditApplicationsViewModel viewModel;
  // ignore: avoid_init_to_null
  late ApplicationApiDto? entity = null;

  @override
  Widget build(context) {
    final nameFieldControll = TextEditingController();
    final descriptionFieldControll = TextEditingController();

    if (entity != null) {
      viewModel.form.name.onValueChange(entity!.name);
    }

    if (entity != null) {
      viewModel.form.description.onValueChange(entity!.description);
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
        const SizedBox(
          height: 10,
        ),
        StreamBuilder<String>(
            stream: viewModel.form.description.field,
            builder: (context, snapshot) {
              descriptionFieldControll.value =
                  descriptionFieldControll.value.copyWith(text: snapshot.data);
              return TextFormField(
                  // onChanged: (value) {
                  //   _txtAmountValue = value;
                  // },
                  controller: descriptionFieldControll,
                  decoration: InputDecoration(
                    labelText: 'Descrição',
                    border: const OutlineInputBorder(),
                    errorText: snapshot.error?.toString(),
                  ),
                  onChanged: (value) {
                    viewModel.form.description.onValueChange(value);
                  });
            }),
      ],
    );
  }
}
