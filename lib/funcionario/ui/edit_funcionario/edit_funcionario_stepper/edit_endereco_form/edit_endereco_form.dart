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
      viewModel.formEndereco.logradouro.onValueChange(entity!.logradouro);
    }
    if (entity != null) {
      viewModel.formEndereco.numero.onValueChange(entity!.numero);
    }
    if (entity != null) {
      viewModel.formEndereco.complemento.onValueChange(entity!.complemento);
    }
    if (entity != null) {
      viewModel.formEndereco.bairro.onValueChange(entity!.bairro);
    }
    if (entity != null) viewModel.formEndereco.cep.onValueChange(entity!.cep);
    if (entity != null) {
      viewModel.formEndereco.municipio.onValueChange(entity!.municipioId);
      if (entity!.municipio != null) {
        viewModel.formEndereco.municipioName.onValueChange('${entity!.municipio!.nome}/${entity!.municipio!.siglaUf}');
      }
    }
    if (entity != null) {
      viewModel.formEndereco.pontoReferencia.onValueChange(entity!.pontoReferencia);
    }

    List<Widget> contentFirstLine(BoxConstraints constraints) {
      return [
        SizedBox(
          width: constraints.maxWidth >= 680 ? 200 : constraints.maxWidth,
          child: StreamBuilder<String>(
            stream: viewModel.formEndereco.cep.field,
            builder: (context, snapshot) {
              cepControll.value = cepControll.value.copyWith(text: snapshot.data);
              return Focus(
                onFocusChange: (hasFocus) {
                  if (!hasFocus && cepControll.text.isNotEmpty) {
                    viewModel.searchViaCep(cepControll.text);
                  }
                },
                child: TextFormField(
                    // onChanged: (value) {
                    //   _txtAmountValue = value;
                    // },
                    controller: cepControll,
                    decoration: InputDecoration(
                      labelText: 'CEP',
                      border: const OutlineInputBorder(),
                      errorText: snapshot.error?.toString(),
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly, CepInputFormatter()],
                    onChanged: (value) {
                      viewModel.formEndereco.cep.onValueChange(value);
                      if (value.isEmpty) {
                        viewModel.formEndereco.municipio.onValueChange('');
                        viewModel.formEndereco.municipioName.onValueChange('');
                        municipioControll.value = municipioControll.value.copyWith(text: '');
                      }
                    }),
              );
            },
          ),
        ),
        SizedBox(
          width: constraints.maxWidth >= 680 ? 10 : 0,
          height: constraints.maxWidth >= 680 ? 0 : 10,
        ),
        SizedBox(
          width: constraints.maxWidth >= 680 ? 470 : constraints.maxWidth,
          child: StreamBuilder<String>(
            stream: viewModel.formEndereco.municipioName.field,
            builder: (context, snapshot) {
              municipioControll.value = municipioControll.value.copyWith(text: snapshot.data);
              return TextFormField(
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
              );
            },
          ),
        ),
      ];
    }

    List<Widget> contentSecondLine(BoxConstraints constraints) {
      return [
        SizedBox(
          width: constraints.maxWidth >= 680 ? 570 : constraints.maxWidth,
          child: StreamBuilder<String>(
            stream: viewModel.formEndereco.bairro.field,
            builder: (context, snapshot) {
              bairroControll.value = bairroControll.value.copyWith(text: snapshot.data);
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
                    viewModel.formEndereco.bairro.onValueChange(value);
                  });
            },
          ),
        ),
        SizedBox(
          width: constraints.maxWidth >= 680 ? 10 : 0,
          height: constraints.maxWidth >= 680 ? 0 : 10,
        ),
        SizedBox(
          width: constraints.maxWidth >= 680 ? 100 : constraints.maxWidth,
          child: StreamBuilder<String>(
            stream: viewModel.formEndereco.numero.field,
            builder: (context, snapshot) {
              numeroControll.value = numeroControll.value.copyWith(text: snapshot.data);
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
                    viewModel.formEndereco.numero.onValueChange(value);
                  });
            },
          ),
        ),
      ];
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 700,
            child: constraints.maxWidth >= 680
                ? Row(
                    children: contentFirstLine(constraints),
                  )
                : Column(
                    children: contentFirstLine(constraints),
                  ),
          ),
          const SizedBox(
            height: 10,
          ),
          StreamBuilder<String>(
            stream: viewModel.formEndereco.logradouro.field,
            builder: (context, snapshot) {
              logradouroControll.value = logradouroControll.value.copyWith(text: snapshot.data);
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
                    viewModel.formEndereco.logradouro.onValueChange(value);
                  });
            },
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: 700,
            child: constraints.maxWidth >= 680
                ? Row(
                    children: contentSecondLine(constraints),
                  )
                : Column(
                    children: contentSecondLine(constraints),
                  ),
          ),
          const SizedBox(
            height: 10,
          ),
          StreamBuilder<String>(
            stream: viewModel.formEndereco.complemento.field,
            builder: (context, snapshot) {
              complementoControll.value = complementoControll.value.copyWith(text: snapshot.data);
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
                    viewModel.formEndereco.complemento.onValueChange(value);
                  });
            },
          ),
          const SizedBox(
            height: 10,
          ),
          StreamBuilder<String>(
            stream: viewModel.formEndereco.pontoReferencia.field,
            builder: (context, snapshot) {
              pontoReferenciaControll.value = pontoReferenciaControll.value.copyWith(text: snapshot.data);
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
                    viewModel.formEndereco.pontoReferencia.onValueChange(value);
                  });
            },
          ),
        ],
      );
    });
  }
}
