import 'package:flutter/material.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/destinatario_api_dto.dart';
import 'package:viggo_pay_admin/pix_to_send/data/models/pix_to_send_api_dto.dart';
import 'package:viggo_pay_admin/pix_to_send/ui/edit_pix_to_send/edit_pix_to_sends_view_model.dart';

// ignore: must_be_immutable
class EditPixToSendsForm extends StatefulWidget {
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
  State<EditPixToSendsForm> createState() => _EditPixToSendsFormState();
}

class _EditPixToSendsFormState extends State<EditPixToSendsForm> {
  final List<Map<String, dynamic>> _items = [
    {
      'value': Aliastype.TAX_ID.name,
      'label': 'CPF/CNPJ',
    },
    {
      'value': Aliastype.EMAIL.name,
      'label': 'E-Mail',
    },
    {
      'value': Aliastype.PHONE.name,
      'label': 'Telefone',
    },
    {
      'value': Aliastype.EVP.name,
      'label': 'Chave aleatória',
    },
  ];

  contentDestinatario(DestinatarioApiDto? destinatario) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              'Proprietário',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              widget.entity != null
                  ? widget.entity!.holderName
                  : destinatario!.aliasHolderName,
              style: Theme.of(context).textTheme.titleSmall!,
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              'CPF/CNPJ',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              widget.entity != null
                  ? widget.entity!.holderTaxIdentifierTaxIdMasked
                  : destinatario!.aliasHolderTaxIdMasked,
              style: Theme.of(context).textTheme.titleSmall!,
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              'Instituição',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              widget.entity != null
                  ? widget.entity!.pspName
                  : destinatario!.pspName,
              style: Theme.of(context).textTheme.titleSmall!,
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              'Agência',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              widget.entity != null
                  ? widget.entity!.destinationBranch
                  : destinatario!.accountBranchDestination,
              style: Theme.of(context).textTheme.titleSmall!,
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              'Conta',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              widget.entity != null
                  ? widget.entity!.destinationAccount
                  : destinatario!.accountDestination,
              style: Theme.of(context).textTheme.titleSmall!,
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              'Tipo da conta',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              widget.entity != null
                  ? widget.entity!.destinationAccountType
                  : destinatario!.accountTypeDestination,
              style: Theme.of(context).textTheme.titleSmall!,
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(context) {
    final aliasFieldControll = TextEditingController();
    final aliasTypeFieldControll = TextEditingController();

    if (widget.entity != null) {
      widget.viewModel.form.onAliasChange(widget.entity!.alias);
    }
    if (widget.entity != null) {
      widget.viewModel.form.onAliasTypeChange(widget.entity!.aliasType);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        StreamBuilder<String>(
          stream: widget.viewModel.form.aliasType,
          builder: (context, snapshot) {
            aliasTypeFieldControll.value =
                aliasTypeFieldControll.value.copyWith(text: snapshot.data);
            return SelectFormField(
              type: SelectFormFieldType.dropdown,
              controller: aliasTypeFieldControll,
              items: _items,
              decoration: InputDecoration(
                labelText: 'Tipo *',
                border: const OutlineInputBorder(),
                errorText: snapshot.error?.toString(),
              ),
              onChanged: (val) {
                widget.viewModel.form.onAliasTypeChange(val);
                widget.viewModel.onDestinatarioChange(null);
              },
              onSaved: (val) {
                widget.viewModel.form.onAliasTypeChange(val ?? '');
                widget.viewModel.onDestinatarioChange(null);
              },
            );
          },
        ),
        const SizedBox(
          height: 10,
        ),
        StreamBuilder<String>(
          stream: widget.viewModel.form.alias,
          builder: (context, snapshot) {
            aliasFieldControll.value =
                aliasFieldControll.value.copyWith(text: snapshot.data);
            return TextFormField(
                // onChanged: (value) {
                //   _txtAmountValue = value;
                // },
                controller: aliasFieldControll,
                decoration: InputDecoration(
                  labelText: 'Chave *',
                  border: const OutlineInputBorder(),
                  errorText: snapshot.error?.toString(),
                ),
                onChanged: (value) {
                  widget.viewModel.form.onAliasChange(value);
                  widget.viewModel.onDestinatarioChange(null);
                });
          },
        ),
        const SizedBox(
          height: 10,
        ),
        widget.entity != null
            ? contentDestinatario(null)
            : StreamBuilder<DestinatarioApiDto?>(
                stream: widget.viewModel.destinatarioInfo,
                builder: (context, destinatarioData) {
                  if (destinatarioData.data == null) {
                    return const Visibility(
                      visible: false,
                      child: Text(''),
                    );
                  } else {
                    widget.viewModel.preencherEntity(destinatarioData.data!);
                    return contentDestinatario(destinatarioData.data!);
                  }
                }),
      ],
    );
  }
}
