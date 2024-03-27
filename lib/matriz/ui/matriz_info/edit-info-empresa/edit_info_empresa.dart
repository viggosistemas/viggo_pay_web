import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_view_model.dart';

// ignore: must_be_immutable
class EditInfoEmpresa extends StatelessWidget {
  EditInfoEmpresa({
    super.key,
    required this.viewModel,
  });

  final MatrizViewModel viewModel;
  FocusNode focusNode = FocusNode();
  
  @override
  Widget build(context) {
    final clientNameFieldControll = TextEditingController();
    final clientTaxIdFieldController = MaskedTextController(
      mask: '##.###.###/####-##',
      translator: {'#': RegExp(r'[0-9a-zA-Z@\.\-_]')},
    );
    // final clientTaxCountryFieldController = TextEditingController();
    final clientMobilePhoneFieldControll = TextEditingController();
    final clientMobilePhoneCountryFieldControll = TextEditingController(
        text: viewModel.matrizAccount.clientMobilePhoneCountry);
    final clientEmailFieldControll = TextEditingController();

    return Column(
      children: [
        StreamBuilder<String>(
          stream: viewModel.form.clientTaxId.field,
          builder: (context, snapshot) {
            clientTaxIdFieldController.value =
                clientTaxIdFieldController.value.copyWith(text: snapshot.data);
            return TextFormField(
              // readOnly: snapshot.data != null,
              decoration: InputDecoration(
                labelText: 'CNPJ *',
                border: const OutlineInputBorder(),
                errorText: snapshot.error?.toString(),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: false,
              ),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              controller: clientTaxIdFieldController,
              onChanged: (value) {
                viewModel.form.clientTaxId.onValueChange(value
                    .replaceAll('.', '')
                    .replaceAll('-', '')
                    .replaceAll('/', ''));
              },
            );
          },
        ),
        const SizedBox(
          height: 10,
        ),
        StreamBuilder<String>(
            stream: viewModel.form.clientName.field,
            builder: (context, snapshot) {
              clientNameFieldControll.value =
                  clientNameFieldControll.value.copyWith(text: snapshot.data);
              return TextFormField(
                  // onChanged: (value) {
                  //   _txtAmountValue = value;
                  // },
                  controller: clientNameFieldControll,
                  decoration: InputDecoration(
                    labelText: 'Empresa *',
                    border: const OutlineInputBorder(),
                    errorText: snapshot.error?.toString(),
                  ),
                  onChanged: (value) {
                    viewModel.form.clientName.onValueChange(value);
                  });
            }),
        const SizedBox(
          height: 10,
        ),
        StreamBuilder<String>(
            stream: viewModel.form.clientMobilePhone.field,
            builder: (context, snapshot) {
              clientMobilePhoneFieldControll.value =
                  clientMobilePhoneFieldControll.value
                      .copyWith(text: snapshot.data);
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
                languageCode: "pt",
                disableLengthCheck: true,
                controller: clientMobilePhoneFieldControll,
                initialCountryCode: clientMobilePhoneCountryFieldControll.text,
                pickerDialogStyle: PickerDialogStyle(
                  searchFieldInputDecoration: const InputDecoration(
                    label: Text('Buscar país'),
                    border: OutlineInputBorder(),
                  ),
                ),
                onChanged: (value) {
                  viewModel.form.clientMobilePhone.onValueChange(value.number);
                  viewModel.form.clientMobilePhoneCountry
                      .onValueChange(value.countryISOCode);
                  viewModel.form.clientTaxCountry
                      .onValueChange(value.countryISOCode);
                },
                onCountryChanged: (country) {
                  viewModel.form.clientMobilePhoneCountry
                      .onValueChange(country.code);
                  viewModel.form.clientTaxCountry.onValueChange(country.code);
                },
              );
            }),
        // StreamBuilder<String>(
        //     stream: viewModel.form.clientMobilePhone,
        //     builder: (context, snapshot) {
        //       clientMobilePhoneFieldControll.value =
        //           clientMobilePhoneFieldControll.value
        //               .copyWith(text: snapshot.data);
        //       return TextFormField(
        //           // onChanged: (value) {
        //           //   _txtAmountValue = value;
        //           // },
        //           controller: clientMobilePhoneFieldControll,
        //           decoration: InputDecoration(
        //             labelText: 'Telefone *',
        //             border: const OutlineInputBorder(),
        //             errorText: snapshot.error?.toString(),
        //           ),
        //           onChanged: (value) {
        //             viewModel.form.onClientMobilePhoneChange(value);
        //           });
        //     }),
        const SizedBox(
          height: 10,
        ),
        StreamBuilder<String>(
            stream: viewModel.form.clientEmail.field,
            builder: (context, snapshot) {
              clientEmailFieldControll.value =
                  clientEmailFieldControll.value.copyWith(text: snapshot.data);
              return TextFormField(
                  // onChanged: (value) {
                  //   _txtAmountValue = value;
                  // },
                  controller: clientEmailFieldControll,
                  decoration: InputDecoration(
                    labelText: 'E-mail *',
                    border: const OutlineInputBorder(),
                    errorText: snapshot.error?.toString(),
                  ),
                  onChanged: (value) {
                    viewModel.form.clientEmail.onValueChange(value);
                  });
            }),
      ],
    );
  }
}
