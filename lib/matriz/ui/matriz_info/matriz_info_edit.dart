import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_builder_view_model.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_api_dto.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_info/edit-info-documentos/edit-info-documentos.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_info/edit-info-empresa/edit_info_empresa.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_info/edit-info-endereco/edit_info_endereco.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_info/edit-taxa-empresa/edit_taxa_empresa.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_view_model.dart';
import 'package:viggo_pay_admin/utils/constants.dart';
import 'package:viggo_pay_admin/utils/show_msg_snackbar.dart';

class MatrizInfoEdit extends StatefulWidget {
  const MatrizInfoEdit({super.key});

  @override
  State<MatrizInfoEdit> createState() => _MatrizInfoEditState();
}

class _MatrizInfoEditState extends State<MatrizInfoEdit> {
  int currentStep = 0;
  MatrizViewModel viewModel = locator.get<MatrizViewModel>();

  @override
  Widget build(BuildContext context) {
    navigateToWorkspace() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AppBuilderViewModel appBuilder = locator.get<AppBuilderViewModel>();
        appBuilder.setScreenIndex(0);
        Navigator.of(context).pushNamed(Routes.WORKSPACE);
      });
    }

    onSubmitTaxa() {
      viewModel.submitConfig(showInfoMessage, context);
    }

    onSubmitDocuments() {
      viewModel.onSendFiles(showInfoMessage, context);
    }

    onSubmit() {
      onSubmitTaxa();
      onSubmitDocuments();
      viewModel.submit(showInfoMessage, context);
    }

    viewModel.isSuccess.listen((value) {
      showInfoMessage(
        context,
        2,
        Colors.green,
        'Conta editada com sucesso!',
        'X',
        () {},
        Colors.white,
      );
      navigateToWorkspace();
    });

    viewModel.isError.listen(
      (value) {
        showInfoMessage(
          context,
          2,
          Colors.red,
          value,
          'X',
          () {},
          Colors.white,
        );
      },
    );

    updateFormValeus() {
      var formFields = viewModel.form.getFields();
      var formAddressFields = viewModel.formAddress.getFields();
      var formTaxa = viewModel.formConfig.getFields();

      viewModel.form.onClientTaxIdChange(
          formFields!['client_tax_identifier_tax_id'] ?? '');
      viewModel.form.onClientNameChange(formFields['client_name'] ?? '');
      viewModel.form
          .onClientMobilePhoneChange(formFields['client_mobile_phone'] ?? '');
      viewModel.form.onClientMobilePhoneCountryChange(
          formFields['client_mobile_phone_country'] ?? '');
      viewModel.form.onClientEmailChange(formFields['client_email'] ?? '');

      viewModel.formAddress.onLogradouroChange(
          formAddressFields!['billing_address_logradouro'] ?? '');
      viewModel.formAddress
          .onNumeroChange(formAddressFields['billing_address_numero'] ?? '');
      viewModel.formAddress.onComplementoChange(
          formAddressFields['billing_address_complemento'] ?? '');
      viewModel.formAddress
          .onBairroChange(formAddressFields['billing_address_bairro'] ?? '');
      viewModel.formAddress
          .onCidadeChange(formAddressFields['billing_address_cidade'] ?? '');
      viewModel.formAddress
          .onEstadoChange(formAddressFields['billing_address_estado'] ?? '');
      viewModel.formAddress
          .onCepChange(formAddressFields['billing_address_cep'] ?? '');
      viewModel.formAddress
          .onPaisChange(formAddressFields['billing_address_pais'] ?? '');

      viewModel.formConfig.onTaxaChange(formTaxa!['taxa']!.toString());
      viewModel.formConfig
          .onPorcentagemChange(formTaxa['porcentagem'].toString() == 'true');
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 200.0,
        vertical: 20.0,
      ),
      alignment: Alignment.topCenter,
      width: double.infinity,
      child: StreamBuilder<DomainAccountApiDto>(
          stream: viewModel.matriz,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              viewModel.getEntities();
              return const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Carregando...'),
                  SizedBox(
                    height: 10,
                  ),
                  CircularProgressIndicator(),
                ],
              );
            } else {
              return Card(
                elevation: 8,
                margin: const EdgeInsets.all(18),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    height: double.maxFinite,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          const Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Perfil da Matriz',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(Icons.domain_add_outlined),
                            ],
                          ),
                          Divider(
                            height: 10,
                            thickness: 0,
                            indent: 0,
                            endIndent: 0,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: Theme.of(context).colorScheme,
                            ),
                            child: Stepper(
                              // type: StepperType.horizontal,
                              currentStep: currentStep,
                              margin: const EdgeInsets.all(50),
                              // onStepTapped: (index) {
                              //   setState(() {
                              //     currentStep = index;
                              //     updateFormValeus();
                              //   });
                              // },
                              onStepContinue: () {
                                if (currentStep != 3) {
                                  setState(() {
                                    currentStep++;
                                    updateFormValeus();
                                  });
                                }
                              },
                              onStepCancel: () {
                                if (currentStep != 0) {
                                  setState(() {
                                    currentStep--;
                                    updateFormValeus();
                                  });
                                }
                              },
                              controlsBuilder: (BuildContext context,
                                  ControlsDetails details) {
                                return Row(
                                  children: details.stepIndex != 3
                                      ? <Widget>[
                                          TextButton(
                                            onPressed: details.onStepCancel,
                                            style: ButtonStyle(
                                              foregroundColor:
                                                  MaterialStateColor
                                                      .resolveWith((states) =>
                                                          details.stepIndex == 0
                                                              ? Colors.grey
                                                              : Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .primary),
                                            ),
                                            child: const Text('Anterior'),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          details.stepIndex == 0
                                              ? StreamBuilder<bool>(
                                                  stream:
                                                      viewModel.form.isValid,
                                                  builder: (context, snapshot) {
                                                    return TextButton(
                                                      onPressed: snapshot
                                                                      .data ==
                                                                  true &&
                                                              snapshot.data !=
                                                                  null
                                                          ? details
                                                              .onStepContinue
                                                          : () {},
                                                      style: ButtonStyle(
                                                        foregroundColor: MaterialStateColor.resolveWith(
                                                            (states) => snapshot
                                                                            .data ==
                                                                        true &&
                                                                    snapshot.data !=
                                                                        null
                                                                ? Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .primary
                                                                : Colors.grey),
                                                      ),
                                                      child:
                                                          const Text('Próximo'),
                                                    );
                                                  })
                                              : details.stepIndex == 2
                                                  ? StreamBuilder<
                                                          List<
                                                              Map<String,
                                                                  dynamic>>>(
                                                      stream:
                                                          viewModel.fileList,
                                                      builder:
                                                          (context, snapshot) {
                                                        return TextButton(
                                                          onPressed: snapshot
                                                                          .data !=
                                                                      null &&
                                                                  snapshot.data!
                                                                      .isNotEmpty
                                                              ? details
                                                                  .onStepContinue
                                                              : () {},
                                                          style: ButtonStyle(
                                                            foregroundColor: MaterialStateColor.resolveWith((states) => snapshot
                                                                            .data !=
                                                                        null &&
                                                                    snapshot
                                                                        .data!
                                                                        .isNotEmpty
                                                                ? Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .primary
                                                                : Colors.grey),
                                                          ),
                                                          child: const Text(
                                                              'Próximo'),
                                                        );
                                                      })
                                                  : StreamBuilder<bool>(
                                                      stream: viewModel
                                                          .formAddress.isValid,
                                                      builder:
                                                          (context, snapshot) {
                                                        return TextButton(
                                                          onPressed: snapshot
                                                                          .data ==
                                                                      true &&
                                                                  snapshot.data !=
                                                                      null
                                                              ? details
                                                                  .onStepContinue
                                                              : () {},
                                                          style: ButtonStyle(
                                                            foregroundColor: MaterialStateColor.resolveWith((states) => snapshot
                                                                            .data ==
                                                                        true &&
                                                                    snapshot.data !=
                                                                        null
                                                                ? Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .primary
                                                                : Colors.grey),
                                                          ),
                                                          child: const Text(
                                                              'Próximo'),
                                                        );
                                                      })
                                        ]
                                      : <Widget>[
                                          TextButton(
                                            onPressed: details.onStepCancel,
                                            child: const Text('Anterior'),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          TextButton(
                                            onPressed: () => onSubmit(),
                                            child: const Text('Salvar'),
                                          ),
                                        ],
                                );
                              },
                              connectorColor: MaterialStateColor.resolveWith(
                                (states) =>
                                    Theme.of(context).colorScheme.primary,
                              ),
                              stepIconBuilder: (stepIndex, stepState) {
                                if (stepIndex == 0) {
                                  return Icon(
                                    Icons.domain_outlined,
                                    color: stepState == StepState.indexed
                                        ? Theme.of(context)
                                            .colorScheme
                                            .onPrimary
                                        : Theme.of(context).colorScheme.primary,
                                  );
                                }
                                if (stepIndex == 1) {
                                  return Icon(
                                    Icons.location_on_outlined,
                                    color: stepState == StepState.indexed
                                        ? Theme.of(context)
                                            .colorScheme
                                            .onPrimary
                                        : Theme.of(context).colorScheme.primary,
                                  );
                                }
                                if (stepIndex == 2) {
                                  return Icon(
                                    Icons.file_upload_sharp,
                                    color: stepState == StepState.indexed
                                        ? Theme.of(context)
                                            .colorScheme
                                            .onPrimary
                                        : Theme.of(context).colorScheme.primary,
                                  );
                                }
                                if (stepIndex == 3) {
                                  return Icon(
                                    Icons.percent_outlined,
                                    color: stepState == StepState.indexed
                                        ? Theme.of(context)
                                            .colorScheme
                                            .onPrimary
                                        : Theme.of(context).colorScheme.primary,
                                  );
                                }
                                return const Icon(Icons.edit_outlined);
                              },
                              steps: [
                                Step(
                                  isActive: currentStep == 0,
                                  title: const Text('Editando informações'),
                                  content:
                                      EditInfoEmpresa(viewModel: viewModel),
                                ),
                                Step(
                                  isActive: currentStep == 1,
                                  title: const Text('Editando endereço'),
                                  content:
                                      EditInfoEndereco(viewModel: viewModel),
                                ),
                                Step(
                                  isActive: currentStep == 2,
                                  title: const Text('Editando documentos'),
                                  content:
                                      EditInfoDocumentos(viewModel: viewModel),
                                ),
                                Step(
                                  isActive: currentStep == 3,
                                  title: const Text('Editando taxa'),
                                  content:
                                      EditTaxaEmpresa(viewModel: viewModel),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          }),
    );
  }
}