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
      viewModel.formAddress
          .onLogradouroChange(entity!.billingAddressLogradouro);
    }
    if (entity != null) {
      viewModel.formAddress.onNumeroChange(entity!.billingAddressNumero);
    }
    if (entity != null) {
      viewModel.formAddress
          .onComplementoChange(entity!.billingAddressComplemento);
    }
    if (entity != null) {
      viewModel.formAddress.onBairroChange(entity!.billingAddressBairro);
    }
    if (entity != null) {
      viewModel.formAddress.onCidadeChange(entity!.billingAddressCidade);
    }
    if (entity != null) {
      viewModel.formAddress.onEstadoChange(entity!.billingAddressEstado);
    }
    if (entity != null) {
      viewModel.formAddress.onCepChange(entity!.billingAddressCep);
    }
    if (entity != null) {
      viewModel.formAddress.onPaisChange(entity!.billingAddressPais);
    }

    return Column(
      children: [
        StreamBuilder<String>(
          stream: viewModel.formAddress.cep,
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
                  viewModel.formAddress.onCepChange(value);
                  if (value.isEmpty) {
                    viewModel.formAddress.onCidadeChange('');
                    viewModel.formAddress.onEstadoChange('');
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
          stream: viewModel.formAddress.cidade,
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
                //   viewModel.formAddress.onCidadeChange(value);
                // },
              ),
            );
          },
        ),
        const SizedBox(
          height: 10,
        ),
        StreamBuilder<String>(
          stream: viewModel.formAddress.logradouro,
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
                  viewModel.formAddress.onLogradouroChange(value);
                });
          },
        ),
        const SizedBox(
          height: 10,
        ),
        StreamBuilder<String>(
          stream: viewModel.formAddress.numero,
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
                  viewModel.formAddress.onNumeroChange(value);
                });
          },
        ),
        const SizedBox(
          height: 10,
        ),
        StreamBuilder<String>(
          stream: viewModel.formAddress.bairro,
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
                  viewModel.formAddress.onBairroChange(value);
                });
          },
        ),
        const SizedBox(
          height: 10,
        ),
        StreamBuilder<String>(
            stream: viewModel.formAddress.complemento,
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
                    viewModel.formAddress.onComplementoChange(value);
                  });
            }),
      ],
    );
  }
}
