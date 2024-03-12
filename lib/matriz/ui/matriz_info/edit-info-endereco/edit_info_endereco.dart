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

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.1,
                child: StreamBuilder<String>(
                    stream: viewModel.formAddress.cep,
                    builder: (context, snapshot) {
                      cepController.value =
                          cepController.value.copyWith(text: snapshot.data);
                      return TextFormField(
                          // onChanged: (value) {
                          //   _txtAmountValue = value;
                          // },
                          controller: cepController,
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
                    }),
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.1,
                child: StreamBuilder<String>(
                    stream: viewModel.formAddress.cidade,
                    builder: (context, snapshot) {
                      estadoController.text = viewModel.estadoAddress;
                      cidadeController.value = cidadeController.value.copyWith(
                          text: '${snapshot.data}/${estadoController.text}');
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
                    }),
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
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.468,
                child: StreamBuilder<String>(
                    stream: viewModel.formAddress.logradouro,
                    builder: (context, snapshot) {
                      logradouroController.value = logradouroController.value
                          .copyWith(text: snapshot.data);
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
                            viewModel.formAddress.onLogradouroChange(value);
                          });
                    }),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: StreamBuilder<String>(
                    stream: viewModel.formAddress.bairro,
                    builder: (context, snapshot) {
                      bairroController.value =
                          bairroController.value.copyWith(text: snapshot.data);
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
                            viewModel.formAddress.onBairroChange(value);
                          });
                    }),
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: StreamBuilder<String>(
                    stream: viewModel.formAddress.complemento,
                    builder: (context, snapshot) {
                      complementoController.value = complementoController.value
                          .copyWith(text: snapshot.data);
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
                            viewModel.formAddress.onComplementoChange(value);
                          });
                    }),
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.068,
                child: StreamBuilder<String>(
                    stream: viewModel.formAddress.numero,
                    builder: (context, snapshot) {
                      numeroController.value =
                          numeroController.value.copyWith(text: snapshot.data);
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
                            viewModel.formAddress.onNumeroChange(value);
                          });
                    }),
              ),
            ],
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
  }
}
