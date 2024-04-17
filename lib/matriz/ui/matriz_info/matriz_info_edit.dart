import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_builder_view_model.dart';
import 'package:viggo_pay_admin/components/hover_button.dart';
import 'package:viggo_pay_admin/components/progress_loading.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_api_dto.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_info/edit-info-documentos/edit_info_documentos.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_info/edit-info-empresa/edit_info_empresa.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_info/edit-info-endereco/edit_info_endereco.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_info/edit-taxa-empresa/edit_taxa_empresa.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_view_model.dart';
import 'package:viggo_pay_admin/utils/constants.dart';
import 'package:viggo_pay_admin/utils/container.dart';
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

    onSubmit() {
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

    viewModel.errorMessage.listen(
      (value) {
        if (value.isNotEmpty && context.mounted) {
          viewModel.clearError();
          showInfoMessage(
            context,
            2,
            Colors.red,
            value,
            'X',
            () {},
            Colors.white,
          );
        }
      },
    );

    updateFormValeus() {
      var formFields = viewModel.form.getValues();
      var formAddressFields = viewModel.formAddress.getValues();
      var formTaxa = viewModel.formConfig.getValues();

      viewModel.form.clientTaxId.onValueChange(formFields!['client_tax_identifier_tax_id'] ?? '');
      viewModel.form.clientName.onValueChange(formFields['client_name'] ?? '');
      viewModel.form.clientMobilePhone.onValueChange(formFields['client_mobile_phone'] ?? '');
      viewModel.form.clientMobilePhoneCountry.onValueChange(formFields['client_mobile_phone_country'] ?? '');
      viewModel.form.clientEmail.onValueChange(formFields['client_email'] ?? '');

      viewModel.formAddress.logradouro.onValueChange(formAddressFields!['billing_address_logradouro'] ?? '');
      viewModel.formAddress.numero.onValueChange(formAddressFields['billing_address_numero'] ?? '');
      viewModel.formAddress.complemento.onValueChange(formAddressFields['billing_address_complemento'] ?? '');
      viewModel.formAddress.bairro.onValueChange(formAddressFields['billing_address_bairro'] ?? '');
      viewModel.formAddress.cidade.onValueChange(formAddressFields['billing_address_cidade'] ?? '');
      viewModel.formAddress.estado.onValueChange(formAddressFields['billing_address_estado'] ?? '');
      viewModel.formAddress.cep.onValueChange(formAddressFields['billing_address_cep'] ?? '');
      viewModel.formAddress.pais.onValueChange(formAddressFields['billing_address_pais'] ?? '');

      viewModel.formConfig.taxa.onValueChange(formTaxa!['taxa']!.toString());
      viewModel.formConfig.porcentagem.onValueChange(formTaxa['porcentagem'].toString().parseBool().toString());
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          elevation: 8,
          margin: const EdgeInsets.all(18),
          child: StreamBuilder<DomainAccountApiDto>(
            stream: viewModel.matriz,
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                viewModel.getEntities();
                return ProgressLoading(
                  color: Theme.of(context).colorScheme.primary,
                );
              } else {
                return Container(
                  padding: const EdgeInsets.all(10.0),
                  constraints: constraints,
                  width: constraints.maxWidth >= 600 ? 450 : ContainerClass().maxWidthContainer(constraints, context, false),
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
                              hoverColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
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
                              controlsBuilder: (BuildContext context, ControlsDetails details) {
                                return Row(
                                  children: details.stepIndex != 3
                                      ? <Widget>[
                                          OnHoverButton(
                                            child: TextButton(
                                              onPressed: details.onStepCancel,
                                              style: ButtonStyle(
                                                foregroundColor: MaterialStateColor.resolveWith(
                                                    (states) => details.stepIndex == 0 ? Colors.grey : Theme.of(context).colorScheme.primary),
                                              ),
                                              child: const Text('Anterior'),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          details.stepIndex == 0
                                              ? StreamBuilder<bool>(
                                                  stream: viewModel.form.isValid,
                                                  builder: (context, snapshot) {
                                                    return OnHoverButton(
                                                      child: TextButton(
                                                        onPressed: snapshot.data == true && snapshot.data != null ? details.onStepContinue : () {},
                                                        style: ButtonStyle(
                                                          foregroundColor: MaterialStateColor.resolveWith((states) =>
                                                              snapshot.data == true && snapshot.data != null
                                                                  ? Theme.of(context).colorScheme.primary
                                                                  : Colors.grey),
                                                        ),
                                                        child: const Text('Próximo'),
                                                      ),
                                                    );
                                                  })
                                              : details.stepIndex == 2
                                                  ? StreamBuilder<bool>(
                                                      stream: viewModel.fileListValid,
                                                      builder: (context, snapshot) {
                                                        return OnHoverButton(
                                                          child: TextButton(
                                                            onPressed: snapshot.data == true ? details.onStepContinue : () {},
                                                            style: ButtonStyle(
                                                              foregroundColor: MaterialStateColor.resolveWith(
                                                                (states) =>
                                                                    snapshot.data == true ? Theme.of(context).colorScheme.primary : Colors.grey,
                                                              ),
                                                            ),
                                                            child: const Text('Próximo'),
                                                          ),
                                                        );
                                                      })
                                                  : StreamBuilder<bool>(
                                                      stream: viewModel.formAddress.isValid,
                                                      builder: (context, snapshot) {
                                                        return OnHoverButton(
                                                          child: TextButton(
                                                            onPressed:
                                                                snapshot.data == true && snapshot.data != null ? details.onStepContinue : () {},
                                                            style: ButtonStyle(
                                                              foregroundColor: MaterialStateColor.resolveWith((states) =>
                                                                  snapshot.data == true && snapshot.data != null
                                                                      ? Theme.of(context).colorScheme.primary
                                                                      : Colors.grey),
                                                            ),
                                                            child: const Text('Próximo'),
                                                          ),
                                                        );
                                                      })
                                        ]
                                      : <Widget>[
                                          OnHoverButton(
                                            child: TextButton(
                                              onPressed: details.onStepCancel,
                                              child: const Text('Anterior'),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          OnHoverButton(
                                            child: TextButton(
                                              onPressed: () => onSubmit(),
                                              child: const Text('Salvar'),
                                            ),
                                          ),
                                        ],
                                );
                              },
                              connectorColor: MaterialStateColor.resolveWith(
                                (states) => Theme.of(context).colorScheme.primary,
                              ),
                              stepIconBuilder: (stepIndex, stepState) {
                                if (stepIndex == 0) {
                                  return Icon(
                                    Icons.domain_outlined,
                                    color: stepState == StepState.indexed
                                        ? Theme.of(context).colorScheme.onPrimary
                                        : Theme.of(context).colorScheme.primary,
                                  );
                                }
                                if (stepIndex == 1) {
                                  return Icon(
                                    Icons.location_on_outlined,
                                    color: stepState == StepState.indexed
                                        ? Theme.of(context).colorScheme.onPrimary
                                        : Theme.of(context).colorScheme.primary,
                                  );
                                }
                                if (stepIndex == 2) {
                                  return Icon(
                                    Icons.file_upload_sharp,
                                    color: stepState == StepState.indexed
                                        ? Theme.of(context).colorScheme.onPrimary
                                        : Theme.of(context).colorScheme.primary,
                                  );
                                }
                                if (stepIndex == 3) {
                                  return Icon(
                                    Icons.percent_outlined,
                                    color: stepState == StepState.indexed
                                        ? Theme.of(context).colorScheme.onPrimary
                                        : Theme.of(context).colorScheme.primary,
                                  );
                                }
                                return const Icon(Icons.edit_outlined);
                              },
                              steps: [
                                Step(
                                  isActive: currentStep == 0,
                                  title: const Text('Editando informações'),
                                  content: EditInfoEmpresa(viewModel: viewModel),
                                ),
                                Step(
                                  isActive: currentStep == 1,
                                  title: const Text('Editando endereço'),
                                  content: EditInfoEndereco(viewModel: viewModel),
                                ),
                                Step(
                                  isActive: currentStep == 2,
                                  title: const Text('Editando documentos'),
                                  content: EditInfoDocumentos(viewModel: viewModel, constraints: constraints),
                                ),
                                Step(
                                  isActive: currentStep == 3,
                                  title: const Text('Editando taxa'),
                                  content: EditTaxaEmpresa(viewModel: viewModel),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }
}
