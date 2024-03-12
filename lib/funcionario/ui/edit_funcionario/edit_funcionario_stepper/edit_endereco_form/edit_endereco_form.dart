import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:viggo_pay_admin/funcionario/ui/edit_funcionario/funcionario_view_model.dart';
import 'package:viggo_pay_admin/parceiro/data/models/parceiro_api_dto.dart';

// ignore: must_be_immutable
class EditEnderecoForm extends StatelessWidget {
  EditEnderecoForm({
    super.key,
    required this.viewModel,
    entity,
  }) {
    if (entity != null) {
      this.entity = entity;
    }
  }

  final EditFuncionarioViewModel viewModel;
  // ignore: avoid_init_to_null
  late ParceiroEndereco? entity = null;

  @override
  Widget build(context) {
    final logradouroControll = TextEditingController();
    final numeroControll = TextEditingController();
    final complementoControll = TextEditingController();
    final bairroControll = TextEditingController();
    final cepControll = TextEditingController();
    final pontoReferenciaControll = TextEditingController();
    final municipioControll = TextEditingController();

    if (entity != null) {
      viewModel.formEndereco.onLogradouroChange(entity!.logradouro);
    }
    if (entity != null) viewModel.formEndereco.onNumeroChange(entity!.numero);
    if (entity != null) {
      viewModel.formEndereco.onComplementoChange(entity!.complemento);
    }
    if (entity != null) viewModel.formEndereco.onBairroChange(entity!.bairro);
    if (entity != null) viewModel.formEndereco.onCepChange(entity!.cep);
    if (entity != null) {
      viewModel.formEndereco.onMunicipioChange(entity!.municipioId);
      if (entity!.municipio != null) {
        viewModel.formEndereco.onMunicipioNameChange(
            '${entity!.municipio!.nome}/${entity!.municipio!.siglaUf}');
      }
    }
    if (entity != null) {
      viewModel.formEndereco.onPontoReferenciaChange(entity!.pontoReferencia);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 700,
          child: Row(
            children: [
              SizedBox(
                width: 200,
                child: StreamBuilder<String>(
                  stream: viewModel.formEndereco.cep,
                  builder: (context, snapshot) {
                    cepControll.value =
                        cepControll.value.copyWith(text: snapshot.data);
                    return TextFormField(
                        // onChanged: (value) {
                        //   _txtAmountValue = value;
                        // },
                        controller: cepControll,
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
                          viewModel.formEndereco.onCepChange(value);
                          if (value.isEmpty) {
                            viewModel.formEndereco.onMunicipioChange('');
                            viewModel.formEndereco.onMunicipioNameChange('');
                            municipioControll.value = municipioControll.value.copyWith(text: '');
                          }
                        });
                  },
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 470,
                child: StreamBuilder<String>(
                  stream: viewModel.formEndereco.municipioName,
                  builder: (context, snapshot) {
                    municipioControll.value =
                        municipioControll.value.copyWith(text: snapshot.data);
                    return Focus(
                      onFocusChange: (hasFocus) {
                        if (hasFocus && cepControll.text.isNotEmpty) {
                          viewModel.searchViaCep(cepControll.text);
                        }
                      },
                      child: TextFormField(
                        // onChanged: (value) {
                        //   _txtAmountValue = value;
                        // },
                        readOnly: true,
                        controller: municipioControll,
                        decoration: InputDecoration(
                          labelText: 'Município',
                          border: const OutlineInputBorder(),
                          errorText: snapshot.error?.toString(),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        StreamBuilder<String>(
          stream: viewModel.formEndereco.logradouro,
          builder: (context, snapshot) {
            logradouroControll.value =
                logradouroControll.value.copyWith(text: snapshot.data);
            return TextFormField(
                // onChanged: (value) {
                //   _txtAmountValue = value;
                // },
                controller: logradouroControll,
                decoration: InputDecoration(
                  labelText: 'Logradouro',
                  border: const OutlineInputBorder(),
                  errorText: snapshot.error?.toString(),
                ),
                onChanged: (value) {
                  viewModel.formEndereco.onLogradouroChange(value);
                });
          },
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: 700,
          child: Row(
            children: [
              SizedBox(
                width: 570,
                child: StreamBuilder<String>(
                  stream: viewModel.formEndereco.bairro,
                  builder: (context, snapshot) {
                    bairroControll.value =
                        bairroControll.value.copyWith(text: snapshot.data);
                    return TextFormField(
                        // onChanged: (value) {
                        //   _txtAmountValue = value;
                        // },
                        controller: bairroControll,
                        decoration: InputDecoration(
                          labelText: 'Bairro',
                          border: const OutlineInputBorder(),
                          errorText: snapshot.error?.toString(),
                        ),
                        onChanged: (value) {
                          viewModel.formEndereco.onBairroChange(value);
                        });
                  },
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 100,
                child: StreamBuilder<String>(
                  stream: viewModel.formEndereco.numero,
                  builder: (context, snapshot) {
                    numeroControll.value =
                        numeroControll.value.copyWith(text: snapshot.data);
                    return TextFormField(
                        // onChanged: (value) {
                        //   _txtAmountValue = value;
                        // },
                        controller: numeroControll,
                        decoration: InputDecoration(
                          labelText: 'Nº',
                          border: const OutlineInputBorder(),
                          errorText: snapshot.error?.toString(),
                        ),
                        onChanged: (value) {
                          viewModel.formEndereco.onNumeroChange(value);
                        });
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        StreamBuilder<String>(
          stream: viewModel.formEndereco.complemento,
          builder: (context, snapshot) {
            complementoControll.value =
                complementoControll.value.copyWith(text: snapshot.data);
            return TextFormField(
                // onChanged: (value) {
                //   _txtAmountValue = value;
                // },
                controller: complementoControll,
                decoration: InputDecoration(
                  labelText: 'Complemento',
                  border: const OutlineInputBorder(),
                  errorText: snapshot.error?.toString(),
                ),
                onChanged: (value) {
                  viewModel.formEndereco.onComplementoChange(value);
                });
          },
        ),
        const SizedBox(
          height: 10,
        ),
        StreamBuilder<String>(
          stream: viewModel.formEndereco.pontoReferencia,
          builder: (context, snapshot) {
            pontoReferenciaControll.value =
                pontoReferenciaControll.value.copyWith(text: snapshot.data);
            return TextFormField(
                // onChanged: (value) {
                //   _txtAmountValue = value;
                // },
                controller: pontoReferenciaControll,
                decoration: InputDecoration(
                  labelText: 'Ponto de referência',
                  border: const OutlineInputBorder(),
                  errorText: snapshot.error?.toString(),
                ),
                onChanged: (value) {
                  viewModel.formEndereco.onPontoReferenciaChange(value);
                });
          },
        ),
      ],
    );
  }
}
