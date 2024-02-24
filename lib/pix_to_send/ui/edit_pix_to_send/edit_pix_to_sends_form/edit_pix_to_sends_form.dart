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

    final pspIdControll = TextEditingController();
    final taxIdentifierTaxIdControll = TextEditingController();
    final taxIdentifierCountryControll = TextEditingController();
    final endToEndIdQueryControll = TextEditingController();
    final accountDestinationBranchControll = TextEditingController();
    final accountDestinationAccountControll = TextEditingController();
    final accountDestinationAccountTypeControll = TextEditingController();

    if (entity != null) viewModel.form.onAliasChange(entity!.alias);
    if (entity != null) viewModel.form.onPspIdChange(entity!.pspId);
    if (entity != null) viewModel.form.onTaxIdendifierTaxIdChange(entity!.taxIdentifierTaxId);
    if (entity != null) viewModel.form.onTaxIdentifierCountryChange(entity!.taxIdentifierCountry);
    if (entity != null) viewModel.form.onEndToEndIdQueryChange(entity?.endToEndIdQuery ?? '');
    if (entity != null) viewModel.form.onAccountDestinationBranchChange(entity?.accountDestinationBranch ?? '');
    if (entity != null) viewModel.form.onAccountDestinationAccountChange(entity!.accountDestinationAccount);
    if (entity != null) viewModel.form.onAccountDestinationAccountTypeChange(entity!.accountDestinationAccountType);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        StreamBuilder<String>(
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
          },
        ),
        const SizedBox(
          height: 5,
        ),
        StreamBuilder<String>(
          stream: viewModel.form.pspId,
          builder: (context, snapshot) {
            pspIdControll.value =
                pspIdControll.value.copyWith(text: snapshot.data);
            return TextFormField(
                // onChanged: (value) {
                //   _txtAmountValue = value;
                // },
                controller: pspIdControll,
                decoration: InputDecoration(
                  labelText: 'Psp Id',
                  border: const OutlineInputBorder(),
                  errorText: snapshot.error?.toString(),
                ),
                onChanged: (value) {
                  viewModel.form.onPspIdChange(value);
                });
          },
        ),
        const SizedBox(
          height: 5,
        ),
        StreamBuilder<String>(
          stream: viewModel.form.taxIdentifierTaxId,
          builder: (context, snapshot) {
            taxIdentifierTaxIdControll.value =
                taxIdentifierTaxIdControll.value.copyWith(text: snapshot.data);
            return TextFormField(
                // onChanged: (value) {
                //   _txtAmountValue = value;
                // },
                controller: taxIdentifierTaxIdControll,
                decoration: InputDecoration(
                  labelText: 'Tax identifier Tax Id',
                  border: const OutlineInputBorder(),
                  errorText: snapshot.error?.toString(),
                ),
                onChanged: (value) {
                  viewModel.form.onTaxIdendifierTaxIdChange(value);
                });
          },
        ),
        const SizedBox(
          height: 5,
        ),
        StreamBuilder<String>(
          stream: viewModel.form.taxIdentifierCountry,
          builder: (context, snapshot) {
            taxIdentifierCountryControll.value = taxIdentifierCountryControll
                .value
                .copyWith(text: snapshot.data);
            return TextFormField(
                // onChanged: (value) {
                //   _txtAmountValue = value;
                // },
                controller: taxIdentifierCountryControll,
                decoration: InputDecoration(
                  labelText: 'Tax identifier Tax Country',
                  border: const OutlineInputBorder(),
                  errorText: snapshot.error?.toString(),
                ),
                onChanged: (value) {
                  viewModel.form.onTaxIdentifierCountryChange(value);
                });
          },
        ),
        const SizedBox(
          height: 5,
        ),
        StreamBuilder<String>(
          stream: viewModel.form.endToEndIdQuery,
          builder: (context, snapshot) {
            endToEndIdQueryControll.value =
                endToEndIdQueryControll.value.copyWith(text: snapshot.data);
            return TextFormField(
                // onChanged: (value) {
                //   _txtAmountValue = value;
                // },
                controller: endToEndIdQueryControll,
                decoration: InputDecoration(
                  labelText: 'End to end query',
                  border: const OutlineInputBorder(),
                  errorText: snapshot.error?.toString(),
                ),
                onChanged: (value) {
                  viewModel.form.onEndToEndIdQueryChange(value);
                });
          },
        ),
        const SizedBox(
          height: 5,
        ),
        StreamBuilder<String>(
          stream: viewModel.form.accountDestinationBranch,
          builder: (context, snapshot) {
            accountDestinationBranchControll.value =
                accountDestinationBranchControll.value
                    .copyWith(text: snapshot.data);
            return TextFormField(
                // onChanged: (value) {
                //   _txtAmountValue = value;
                // },
                controller: accountDestinationBranchControll,
                decoration: InputDecoration(
                  labelText: 'Account destination branch',
                  border: const OutlineInputBorder(),
                  errorText: snapshot.error?.toString(),
                ),
                onChanged: (value) {
                  viewModel.form.onAccountDestinationBranchChange(value);
                });
          },
        ),
        const SizedBox(
          height: 5,
        ),
        StreamBuilder<String>(
          stream: viewModel.form.accountDestinationAccount,
          builder: (context, snapshot) {
            accountDestinationAccountControll.value =
                accountDestinationAccountControll.value
                    .copyWith(text: snapshot.data);
            return TextFormField(
                // onChanged: (value) {
                //   _txtAmountValue = value;
                // },
                controller: accountDestinationAccountControll,
                decoration: InputDecoration(
                  labelText: 'Account Destination account',
                  border: const OutlineInputBorder(),
                  errorText: snapshot.error?.toString(),
                ),
                onChanged: (value) {
                  viewModel.form.onAccountDestinationAccountChange(value);
                });
          },
        ),
        const SizedBox(
          height: 5,
        ),
        StreamBuilder<String>(
          stream: viewModel.form.accountDestinationAccountType,
          builder: (context, snapshot) {
            accountDestinationAccountTypeControll.value =
                accountDestinationAccountTypeControll.value
                    .copyWith(text: snapshot.data);
            return TextFormField(
                // onChanged: (value) {
                //   _txtAmountValue = value;
                // },
                controller: accountDestinationAccountTypeControll,
                decoration: InputDecoration(
                  labelText: 'Account destination type',
                  border: const OutlineInputBorder(),
                  errorText: snapshot.error?.toString(),
                ),
                onChanged: (value) {
                  viewModel.form.onAccountDestinationAccountTypeChange(value);
                });
          },
        ),
      ],
    );
  }
}
