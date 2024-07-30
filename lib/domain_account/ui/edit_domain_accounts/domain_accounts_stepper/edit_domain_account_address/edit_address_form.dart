import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_api_dto.dart';
import 'package:viggo_pay_admin/domain_account/ui/edit_domain_accounts/edit_domain_accounts_view_model.dart';

// ignore: must_be_immutable
class EditDomainAccountAddress extends StatelessWidget {
  EditDomainAccountAddress({
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

  @override
  Widget build(context) {
    final logradouroController = TextEditingController();
    final numeroController = TextEditingController();
    final complementoController = TextEditingController();
    final bairroController = TextEditingController();
    final cidadeController = TextEditingController();
    final estadoController = TextEditingController();
    final cepController = TextEditingController();
    // final paisController = TextEditingController();

    if (entity != null) {
      viewModel.formAddress.logradouro
          .onValueChange(entity!.billingAddressLogradouro);
    }
    if (entity != null) {
      viewModel.formAddress.numero.onValueChange(entity!.billingAddressNumero);
    }
    if (entity != null) {
      viewModel.formAddress.complemento
          .onValueChange(entity?.billingAddressComplemento ?? '');
    }
    if (entity != null) {
      viewModel.formAddress.bairro.onValueChange(entity?.billingAddressBairro ?? '');
    }
    if (entity != null) {
      viewModel.formAddress.cidade.onValueChange(entity!.billingAddressCidade);
    }
    if (entity != null) {
      viewModel.formAddress.estado.onValueChange(entity!.billingAddressEstado);
    }
    if (entity != null) {
      viewModel.formAddress.cep.onValueChange(entity!.billingAddressCep);
    }
    if (entity != null) {
      viewModel.formAddress.pais.onValueChange(entity!.billingAddressPais);
    }

    return Column(
      children: [
        StreamBuilder<String>(
          stream: viewModel.formAddress.cep.field,
          builder: (context, snapshot) {
            cepController.value =
                cepController.value.copyWith(text: snapshot.data);
            return TextFormField(
                // onChanged: (value) {
                //   _txtAmountValue = value;
                // },
                controller: cepController,
                readOnly: readOnly,
                decoration: InputDecoration(
                  labelText: 'CEP',
                  border: const OutlineInputBorder(),
                  errorText: snapshot.error?.toString(),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CepInputFormatter()
                ],
                onChanged: (value) {
                  viewModel.formAddress.cep.onValueChange(value);
                  if (value.isEmpty) {
                    viewModel.formAddress.cidade.onValueChange('');
                    viewModel.formAddress.estado.onValueChange('');
                    cidadeController.value =
                        cidadeController.value.copyWith(text: '');
                  }
                });
          },
        ),
        const SizedBox(
          height: 10,
        ),
        StreamBuilder<String>(
          stream: viewModel.formAddress.cidade.field,
          builder: (context, snapshot) {
            estadoController.text = viewModel.estadoAddress.isEmpty
                ? entity?.billingAddressEstado ?? ''
                : viewModel.estadoAddress;
            cidadeController.value = cidadeController.value
                .copyWith(text: '${snapshot.data}/${estadoController.text}');
            return Focus(
              onFocusChange: (hasFocus) {
                if (hasFocus && cepController.text.isNotEmpty) {
                  viewModel.searchViaCep(cepController.text);
                }
              },
              child: TextFormField(
                // onChanged: (value) {
                //   _txtAmountValue = value;
                // },
                readOnly: true,
                controller: cidadeController,
                decoration: InputDecoration(
                  labelText: 'Cidade',
                  border: const OutlineInputBorder(),
                  errorText: snapshot.error?.toString(),
                ),
                // onChanged: (value) {
                //   viewModel.formAddress.cidade.onValueChange(value);
                // },
              ),
            );
          },
        ),
        const SizedBox(
          height: 10,
        ),
        StreamBuilder<String>(
          stream: viewModel.formAddress.logradouro.field,
          builder: (context, snapshot) {
            logradouroController.value =
                logradouroController.value.copyWith(text: snapshot.data);
            return TextFormField(
                // onChanged: (value) {
                //   _txtAmountValue = value;
                // },
                controller: logradouroController,
                readOnly: readOnly,
                decoration: InputDecoration(
                  labelText: 'Logradouro',
                  border: const OutlineInputBorder(),
                  errorText: snapshot.error?.toString(),
                ),
                onChanged: (value) {
                  viewModel.formAddress.logradouro.onValueChange(value);
                });
          },
        ),
        const SizedBox(
          height: 10,
        ),
        StreamBuilder<String>(
          stream: viewModel.formAddress.numero.field,
          builder: (context, snapshot) {
            numeroController.value =
                numeroController.value.copyWith(text: snapshot.data);
            return TextFormField(
                // onChanged: (value) {
                //   _txtAmountValue = value;
                // },
                controller: numeroController,
                readOnly: readOnly,
                decoration: InputDecoration(
                  labelText: 'Nº',
                  border: const OutlineInputBorder(),
                  errorText: snapshot.error?.toString(),
                ),
                onChanged: (value) {
                  viewModel.formAddress.numero.onValueChange(value);
                });
          },
        ),
        const SizedBox(
          height: 10,
        ),
        StreamBuilder<String>(
          stream: viewModel.formAddress.bairro.field,
          builder: (context, snapshot) {
            bairroController.value =
                bairroController.value.copyWith(text: snapshot.data);
            return TextFormField(
                // onChanged: (value) {
                //   _txtAmountValue = value;
                // },
                controller: bairroController,
                readOnly: readOnly,
                decoration: InputDecoration(
                  labelText: 'Bairro',
                  border: const OutlineInputBorder(),
                  errorText: snapshot.error?.toString(),
                ),
                onChanged: (value) {
                  viewModel.formAddress.bairro.onValueChange(value);
                });
          },
        ),
        const SizedBox(
          height: 10,
        ),
        StreamBuilder<String>(
            stream: viewModel.formAddress.complemento.field,
            builder: (context, snapshot) {
              complementoController.value =
                  complementoController.value.copyWith(text: snapshot.data);
              return TextFormField(
                  // onChanged: (value) {
                  //   _txtAmountValue = value;
                  // },
                  controller: complementoController,
                  readOnly: readOnly,
                  decoration: InputDecoration(
                    labelText: 'Complemento',
                    border: const OutlineInputBorder(),
                    errorText: snapshot.error?.toString(),
                  ),
                  onChanged: (value) {
                    viewModel.formAddress.complemento.onValueChange(value);
                  });
            }),
      ],
    );
  }
}
