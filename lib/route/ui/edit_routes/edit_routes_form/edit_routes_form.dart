import 'package:flutter/material.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:viggo_pay_admin/route/ui/edit_routes/edit_routes_view_model.dart';
import 'package:viggo_pay_core_frontend/route/data/models/route_api_dto.dart';

// ignore: must_be_immutable
class EditRoutesForm extends StatelessWidget {
  EditRoutesForm({
    super.key,
    required this.viewModel,
    entity,
  }) {
    if (entity != null) {
      this.entity = entity;
    }
  }

  final EditRoutesViewModel viewModel;
  // ignore: avoid_init_to_null
  late RouteApiDto? entity = null;

  final List<Map<String, dynamic>> _items = [
    {
      'value': METHOD.PUT.name,
      'label': METHOD.PUT.name,
    },
    {
      'value': METHOD.POST.name,
      'label': METHOD.POST.name,
    },
    {
      'value': METHOD.DELETE.name,
      'label': METHOD.DELETE.name,
    },
    {
      'value': METHOD.GET.name,
      'label': METHOD.GET.name,
    },
    {
      'value': METHOD.LIST.name,
      'label': METHOD.LIST.name,
    },
  ];

  @override
  Widget build(context) {
    final nameFieldControll = TextEditingController();
    final urlFieldControll = TextEditingController();
    final methodFieldControll = TextEditingController();

    if (entity != null) {
      viewModel.form.onNameChange(entity!.name);
      viewModel.form.onUrlChange(entity!.url);
      viewModel.form.onMethodChange(entity!.method.name);
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
        const SizedBox(
          height: 10,
        ),
        StreamBuilder<String>(
            stream: viewModel.form.url,
            builder: (context, snapshot) {
              urlFieldControll.value =
                  urlFieldControll.value.copyWith(text: snapshot.data);
              return TextFormField(
                  // onChanged: (value) {
                  //   _txtAmountValue = value;
                  // },
                  controller: urlFieldControll,
                  decoration: InputDecoration(
                    labelText: 'URL',
                    border: const OutlineInputBorder(),
                    errorText: snapshot.error?.toString(),
                  ),
                  onChanged: (value) {
                    viewModel.form.onUrlChange(value);
                  });
            }),
        const SizedBox(
          height: 10,
        ),
        StreamBuilder<String>(
          stream: viewModel.form.method,
          builder: (context, snapshot) {
            methodFieldControll.value =
                methodFieldControll.value.copyWith(text: snapshot.data);
            return SelectFormField(
              type: SelectFormFieldType.dropdown,
              controller: methodFieldControll,
              items: _items,
              decoration: InputDecoration(
                labelText: 'Método *',
                border: const OutlineInputBorder(),
                suffixIcon: const Icon(Icons.arrow_drop_down),
                errorText: snapshot.error?.toString(),
              ),
              onChanged: (val) {
                viewModel.form.onMethodChange(val);
              },
              onSaved: (val) {
                viewModel.form.onMethodChange(val ?? '');
              },
            );
          },
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StreamBuilder<bool?>(
              stream: viewModel.form.bypass,
              builder: (context, snapshot) {
                return Checkbox(
                  value: snapshot.data != null
                      ? snapshot.data!
                      : entity != null
                          ? entity!.bypass
                          : false,
                  onChanged: (value) {
                    viewModel.form.onBypassChange(value!);
                  },
                );
              },
            ),
            const SizedBox(width: 6),
            const Text('Bypass'),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StreamBuilder<bool?>(
              stream: viewModel.form.sysadmin,
              builder: (context, snapshot) {
                return Checkbox(
                  value: snapshot.data != null
                      ? snapshot.data!
                      : entity != null
                          ? entity!.sysadmin
                          : false,
                  onChanged: (value) {
                    viewModel.form.onSysadminChange(value!);
                  },
                );
              },
            ),
            const SizedBox(width: 6),
            const Text('Syadmin'),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
