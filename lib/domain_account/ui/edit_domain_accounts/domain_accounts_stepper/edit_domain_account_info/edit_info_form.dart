import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_api_dto.dart';
import 'package:viggo_pay_admin/domain_account/ui/edit_domain_accounts/edit_domain_accounts_view_model.dart';

// ignore: must_be_immutable
class EditDomainAccountInfo extends StatelessWidget {
  EditDomainAccountInfo({
    super.key,
    required this.viewModel,
    required this.readOnly,
    entity,
  }) {
    if (entity != null) {
      this.entity = entity;
    }
  }

  final EditDomainAccountViewModel viewModel;
  // ignore: avoid_init_to_null
  late DomainAccountApiDto? entity = null;
  late bool readOnly = false;
  FocusNode focusNode = FocusNode();

  @override
  Widget build(context) {
    final nameFielController = TextEditingController();
    final taxIdFieldController = TextEditingController();
    final emailFieldController = TextEditingController();
    final phoneFieldController = TextEditingController();
    final countryPhoneFieldControll =
        TextEditingController(text: entity?.clientMobilePhoneCountry ?? 'BRA');

    if (entity != null) {
      viewModel.form.name.onValueChange(entity!.clientName);
    }
    if (entity != null) {
      viewModel.form.taxId.onValueChange(entity!.clientTaxIdentifierTaxId);
    }
    if (entity != null) {
      viewModel.form.email.onValueChange(entity!.clientEmail);
    }
    if (entity != null) {
      viewModel.form.phone.onValueChange(entity!.clientMobilePhone);
    }
    if (entity != null) {
      viewModel.form.countryPhone
          .onValueChange(entity!.clientMobilePhoneCountry);
    }

    return Column(
      children: [
        StreamBuilder<String>(
            stream: viewModel.form.taxId.field,
            builder: (context, snapshot) {
              taxIdFieldController.value =
                  taxIdFieldController.value.copyWith(text: snapshot.data);
              return TextFormField(
                  // onChanged: (value) {
                  //   _txtAmountValue = value;
                  // },
                  controller: taxIdFieldController,
                  readOnly: readOnly,
                  decoration: InputDecoration(
                    labelText: 'CNPJ',
                    border: const OutlineInputBorder(),
                    errorText: snapshot.error?.toString(),
                  ),
                  maxLength: 14,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: false,
                  ),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (value) {
                    viewModel.form.taxId.onValueChange(value);
                  });
            }),
        const SizedBox(
          height: 10,
        ),
        StreamBuilder<String>(
            stream: viewModel.form.name.field,
            builder: (context, snapshot) {
              nameFielController.value =
                  nameFielController.value.copyWith(text: snapshot.data);
              return TextFormField(
                  // onChanged: (value) {
                  //   _txtAmountValue = value;
                  // },
                  controller: nameFielController,
                  readOnly: readOnly,
                  decoration: InputDecoration(
                    labelText: 'Cliente',
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
            stream: viewModel.form.phone.field,
            builder: (context, snapshot) {
              phoneFieldController.value =
                  phoneFieldController.value.copyWith(text: snapshot.data);
              return IntlPhoneField(
                focusNode: focusNode,
                decoration: const InputDecoration(
                  labelText: 'Telefone *',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                  ),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  TelefoneInputFormatter()
                ],
                languageCode: 'pt_BR',
                enabled: !readOnly,
                disableLengthCheck: true,
                controller: phoneFieldController,
                showDropdownIcon: false,
                initialCountryCode:
                    countryPhoneFieldControll.text.substring(0, 2),
                readOnly: readOnly,
                pickerDialogStyle: PickerDialogStyle(
                  searchFieldInputDecoration: const InputDecoration(
                    label: Text('Buscar país'),
                    border: OutlineInputBorder(),
                  ),
                ),
                onChanged: (value) {
                  viewModel.form.phone.onValueChange(value.number);
                  viewModel.form.countryPhone
                      .onValueChange(value.countryISOCode);
                  viewModel.form.countryTax.onValueChange(value.countryISOCode);
                },
                onCountryChanged: (country) {
                  viewModel.form.countryPhone.onValueChange(country.code);
                  viewModel.form.countryTax.onValueChange(country.code);
                },
              );
            }),
        // StreamBuilder<String>(
        //     stream: viewModel.form.phone,
        //     builder: (context, snapshot) {
        //       phoneFieldController.value =
        //           phoneFieldController.value.copyWith(text: snapshot.data);
        //       return TextFormField(
        //           // onChanged: (value) {
        //           //   _txtAmountValue = value;
        //           // },
        //           controller: phoneFieldController,
        //           readOnly: readOnly,
        //           decoration: InputDecoration(
        //             labelText: 'Telefone',
        //             border: const OutlineInputBorder(),
        //             errorText: snapshot.error?.toString(),
        //           ),
        //           onChanged: (value) {
        //             viewModel.form.phone.onValueChange(value);
        //           });
        //     }),
        const SizedBox(
          height: 10,
        ),
        StreamBuilder<String>(
            stream: viewModel.form.email.field,
            builder: (context, snapshot) {
              emailFieldController.value =
                  emailFieldController.value.copyWith(text: snapshot.data);
              return TextFormField(
                  // onChanged: (value) {
                  //   _txtAmountValue = value;
                  // },
                  controller: emailFieldController,
                  readOnly: readOnly,
                  decoration: InputDecoration(
                    labelText: 'E-Mail',
                    border: const OutlineInputBorder(),
                    errorText: snapshot.error?.toString(),
                  ),
                  onChanged: (value) {
                    viewModel.form.email.onValueChange(value);
                  });
            }),
      ],
    );
  }
}
