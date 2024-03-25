import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/components/hover_button.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_api_dto.dart';
import 'package:viggo_pay_admin/domain_account/ui/edit_domain_accounts/domain_accounts_stepper/edit_domain_account_address/edit_address_form.dart';
import 'package:viggo_pay_admin/domain_account/ui/edit_domain_accounts/domain_accounts_stepper/edit_domain_account_documents/edit_documents.dart';
import 'package:viggo_pay_admin/domain_account/ui/edit_domain_accounts/domain_accounts_stepper/edit_domain_account_info/edit_info_form.dart';
import 'package:viggo_pay_admin/domain_account/ui/edit_domain_accounts/edit_domain_accounts_view_model.dart';

// ignore: must_be_immutable
class DomainAccountStepper extends StatefulWidget {
  DomainAccountStepper({
    super.key,
    required this.viewModel,
    required this.readOnly,
    required this.onSubmit,
    entity,
  }) {
    if (entity != null) {
      this.entity = entity;
    }
  }

  final Function onSubmit;
  final EditDomainAccountViewModel viewModel;
  // ignore: avoid_init_to_null
  late DomainAccountApiDto? entity = null;
  late bool readOnly = false;

  @override
  State<DomainAccountStepper> createState() => _DomainAccountStepperState();
}

class _DomainAccountStepperState extends State<DomainAccountStepper> {
  int currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Stepper(
      currentStep: currentStep,
      margin: const EdgeInsets.all(50),
      onStepTapped: (index) {
        setState(() {
          currentStep = index;
        });
      },
      onStepContinue: () {
        if (currentStep != 2) {
          setState(() {
            currentStep++;
          });
        }
      },
      onStepCancel: () {
        if (currentStep != 0) {
          setState(() {
            currentStep--;
          });
        }
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
            Icons.save_outlined,
            color: stepState == StepState.indexed
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.primary,
          );
        }
        return const Icon(Icons.edit_outlined);
      },
      controlsBuilder: (BuildContext context, ControlsDetails details) {
        return Row(
          children: details.stepIndex != 2
              ? <Widget>[
                  OnHoverButton(
                    child: TextButton(
                      onPressed: details.onStepCancel,
                      style: ButtonStyle(
                        foregroundColor: MaterialStateColor.resolveWith(
                            (states) => details.stepIndex == 0
                                ? Colors.grey
                                : Theme.of(context).colorScheme.primary),
                      ),
                      child: const Text('Anterior'),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  details.stepIndex == 0
                      ? StreamBuilder<bool>(
                          stream: widget.viewModel.form.isValid,
                          builder: (context, snapshot) {
                            return OnHoverButton(
                              child: TextButton(
                                onPressed:
                                    snapshot.data == true && snapshot.data != null
                                        ? details.onStepContinue
                                        : () {},
                                style: ButtonStyle(
                                  foregroundColor: MaterialStateColor.resolveWith(
                                      (states) => snapshot.data == true &&
                                              snapshot.data != null
                                          ? Theme.of(context).colorScheme.primary
                                          : Colors.grey),
                                ),
                                child: const Text('Próximo'),
                              ),
                            );
                          })
                      : details.stepIndex == 2
                          ? StreamBuilder<List<Map<String, dynamic>>>(
                              stream: widget.viewModel.fileList,
                              builder: (context, snapshot) {
                                return OnHoverButton(
                                  child: TextButton(
                                    onPressed: snapshot.data != null &&
                                            snapshot.data!.isNotEmpty
                                        ? details.onStepContinue
                                        : () {},
                                    style: ButtonStyle(
                                      foregroundColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => snapshot.data != null &&
                                                      snapshot.data!.isNotEmpty
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                  : Colors.grey),
                                    ),
                                    child: const Text('Próximo'),
                                  ),
                                );
                              })
                          : StreamBuilder<bool>(
                              stream: widget.viewModel.formAddress.isValid,
                              builder: (context, snapshot) {
                                return OnHoverButton(
                                  child: TextButton(
                                    onPressed: snapshot.data == true &&
                                            snapshot.data != null
                                        ? details.onStepContinue
                                        : () {},
                                    style: ButtonStyle(
                                      foregroundColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => snapshot.data == true &&
                                                      snapshot.data != null
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .primary
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
                      onPressed: () => !widget.readOnly ? widget.onSubmit() : {},
                      style: ButtonStyle(
                        foregroundColor: MaterialStateColor.resolveWith(
                            (states) => !widget.readOnly
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey),
                      ),
                      child: const Text('Salvar'),
                    ),
                  ),
                ],
        );
      },
      steps: [
        Step(
          isActive: currentStep == 0,
          title: const Text('Dados da empresa'),
          content: EditDomainAccountInfo(
            entity: widget.entity,
            viewModel: widget.viewModel,
            readOnly: widget.readOnly,
          ),
        ),
        Step(
          isActive: currentStep == 1,
          title: const Text('Endereço da empresa'),
          content: EditDomainAccountAddress(
            readOnly: widget.readOnly,
            entity: widget.entity,
            viewModel: widget.viewModel,
          ),
        ),
        Step(
          isActive: currentStep == 2,
          title: const Text('Documentos da empresa'),
          content: EditDomainAccountDocuments(
            readOnly: widget.readOnly,
            viewModel: widget.viewModel,
            entity: widget.entity,
          ),
        ),
      ],
    );
  }
}
