import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_view_model.dart';

class EditInfoEndereco extends StatelessWidget {
  const EditInfoEndereco({
    super.key,
    required this.viewModel,
  });

  final MatrizViewModel viewModel;

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
    estadoController.text = viewModel.estadoAddress;

    List<Widget> contentFirstLine(BoxConstraints constraints) {
      return [
        SizedBox(
          width: constraints.maxWidth >= 960 ? constraints.maxWidth * 0.1 : constraints.maxWidth,
          child: StreamBuilder<String>(
            stream: viewModel.formAddress.cep.field,
            builder: (context, snapshot) {
              cepController.value = cepController.value.copyWith(text: snapshot.data);
              return Focus(
                onFocusChange: (hasFocus) {
                  if (!hasFocus && cepController.text.isNotEmpty) {
                    viewModel.searchViaCep(cepController.text);
                  }
                },
                child: TextFormField(
                  // onChanged: (value) {
                  //   _txtAmountValue = value;
                  // },
                  controller: cepController,
                  decoration: InputDecoration(
                    labelText: 'CEP',
                    border: const OutlineInputBorder(),
                    errorText: snapshot.error?.toString(),
                  ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, CepInputFormatter()],
                  onChanged: (value) {
                    viewModel.formAddress.cep.onValueChange(value);
                    if (value.isEmpty) {
                      viewModel.formAddress.cidade.onValueChange('');
                      viewModel.formAddress.estado.onValueChange('');
                      cidadeController.value = cidadeController.value.copyWith(text: '');
                    }
                  },
                ),
              );
            },
          ),
        ),
        SizedBox(
          width: constraints.maxWidth >= 960 ? 10 : 0,
          height: constraints.maxWidth >= 960 ? 0 : 10,
        ),
        SizedBox(
          width: constraints.maxWidth >= 960 ? constraints.maxWidth * 0.1 : constraints.maxWidth,
          child: StreamBuilder<String>(
            stream: viewModel.formAddress.cidade.field,
            builder: (context, snapshot) {
              estadoController.text = viewModel.estadoAddress;
              cidadeController.value = cidadeController.value.copyWith(text: '${snapshot.data}/${estadoController.text}');
              return TextFormField(
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
              );
            },
          ),
          // StreamBuilder<String>(
          //     stream: viewModel.formAddress.estado,
          //     builder: (context, snapshot) {
          //       estadoController.value =
          //           estadoController.value.copyWith(text: snapshot.data);
          //       return TextFormField(
          //           // onChanged: (value) {
          //           //   _txtAmountValue = value;
          //           // },
          //           controller: estadoController,
          //           decoration: InputDecoration(
          //             labelText: 'Estado',
          //             border: const OutlineInputBorder(),
          //             errorText: snapshot.error?.toString(),
          //           ),
          //           onChanged: (value) {
          //             viewModel.formAddress.onEstadoChange(value);
          //           });
          //     }),
        ),
        SizedBox(
          width: constraints.maxWidth >= 960 ? 10 : 0,
          height: constraints.maxWidth >= 960 ? 0 : 10,
        ),
        SizedBox(
          width: constraints.maxWidth >= 960 ? constraints.maxWidth * 0.6 : constraints.maxWidth,
          child: StreamBuilder<String>(
            stream: viewModel.formAddress.logradouro.field,
            builder: (context, snapshot) {
              logradouroController.value = logradouroController.value.copyWith(text: snapshot.data);
              return TextFormField(
                // onChanged: (value) {
                //   _txtAmountValue = value;
                // },
                controller: logradouroController,
                decoration: InputDecoration(
                  labelText: 'Logradouro',
                  border: const OutlineInputBorder(),
                  errorText: snapshot.error?.toString(),
                ),
                onChanged: (value) {
                  viewModel.formAddress.logradouro.onValueChange(value);
                },
              );
            },
          ),
        ),
      ];
    }

    List<Widget> contentSecondLine(BoxConstraints constraints) {
      return [
        SizedBox(
          width: constraints.maxWidth >= 960 ? constraints.maxWidth * 0.3 : constraints.maxWidth,
          child: StreamBuilder<String>(
              stream: viewModel.formAddress.bairro.field,
              builder: (context, snapshot) {
                bairroController.value = bairroController.value.copyWith(text: snapshot.data);
                return TextFormField(
                    // onChanged: (value) {
                    //   _txtAmountValue = value;
                    // },
                    controller: bairroController,
                    decoration: InputDecoration(
                      labelText: 'Bairro',
                      border: const OutlineInputBorder(),
                      errorText: snapshot.error?.toString(),
                    ),
                    onChanged: (value) {
                      viewModel.formAddress.bairro.onValueChange(value);
                    });
              }),
        ),
        SizedBox(
          width: constraints.maxWidth >= 960 ? 10 : 0,
          height: constraints.maxWidth >= 960 ? 0 : 10,
        ),
        SizedBox(
          width: constraints.maxWidth >= 960 ? constraints.maxWidth * 0.4 : constraints.maxWidth,
          child: StreamBuilder<String>(
              stream: viewModel.formAddress.complemento.field,
              builder: (context, snapshot) {
                complementoController.value = complementoController.value.copyWith(text: snapshot.data);
                return TextFormField(
                    // onChanged: (value) {
                    //   _txtAmountValue = value;
                    // },
                    controller: complementoController,
                    decoration: InputDecoration(
                      labelText: 'Complemento',
                      border: const OutlineInputBorder(),
                      errorText: snapshot.error?.toString(),
                    ),
                    onChanged: (value) {
                      viewModel.formAddress.complemento.onValueChange(value);
                    });
              }),
        ),
        SizedBox(
          width: constraints.maxWidth >= 960 ? 10 : 0,
          height: constraints.maxWidth >= 960 ? 0 : 10,
        ),
        SizedBox(
          width: constraints.maxWidth >= 960 ? constraints.maxWidth * 0.1 : constraints.maxWidth,
          child: StreamBuilder<String>(
              stream: viewModel.formAddress.numero.field,
              builder: (context, snapshot) {
                numeroController.value = numeroController.value.copyWith(text: snapshot.data);
                return TextFormField(
                    // onChanged: (value) {
                    //   _txtAmountValue = value;
                    // },
                    controller: numeroController,
                    decoration: InputDecoration(
                      labelText: 'Nº',
                      border: const OutlineInputBorder(),
                      errorText: snapshot.error?.toString(),
                    ),
                    onChanged: (value) {
                      viewModel.formAddress.numero.onValueChange(value);
                    });
              }),
        ),
      ];
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: constraints.maxWidth >= 960
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
            SizedBox(
              width: double.infinity,
              child: constraints.maxWidth >= 960
                  ? Row(
                      children: contentSecondLine(constraints),
                    )
                  : Column(
                      children: contentSecondLine(constraints),
                    ),
            ),
            // const SizedBox(
            //   height: 10,
            // ),
            // StreamBuilder<String>(
            //     stream: viewModel.formAddress.pais,
            //     builder: (context, snapshot) {
            //       paisController.value =
            //           paisController.value.copyWith(text: snapshot.data);
            //       return TextFormField(
            //           // onChanged: (value) {
            //           //   _txtAmountValue = value;
            //           // },
            //           controller: paisController,
            //           decoration: InputDecoration(
            //             labelText: 'País',
            //             border: const OutlineInputBorder(),
            //             errorText: snapshot.error?.toString(),
            //           ),
            //           onChanged: (value) {
            //             viewModel.formAddress.onPaisChange(value);
            //           });
            //     }),
          ],
        );
      },
    );
  }
}
