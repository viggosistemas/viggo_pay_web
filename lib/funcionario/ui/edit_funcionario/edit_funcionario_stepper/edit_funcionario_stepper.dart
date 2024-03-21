import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/funcionario/data/models/funcionario_api_dto.dart';
import 'package:viggo_pay_admin/funcionario/ui/edit_funcionario/edit_funcionario_stepper/edit_contato_form/edit_contato_form.dart';
import 'package:viggo_pay_admin/funcionario/ui/edit_funcionario/edit_funcionario_stepper/edit_endereco_form/edit_endereco_form.dart';
import 'package:viggo_pay_admin/funcionario/ui/edit_funcionario/edit_funcionario_stepper/edit_funcionario_form/edit_funcionario_form.dart';
import 'package:viggo_pay_admin/funcionario/ui/edit_funcionario/funcionario_view_model.dart';
import 'package:viggo_pay_admin/parceiro/data/models/parceiro_api_dto.dart';

// ignore: must_be_immutable
class FuncionarioStepper extends StatefulWidget {
  FuncionarioStepper({
    super.key,
    required this.viewModel,
    required this.onSubmit,
    entity,
  }) {
    if (entity != null) {
      this.entity = entity;
    }
  }

  final EditFuncionarioViewModel viewModel;
  // ignore: avoid_init_to_null
  late FuncionarioApiDto? entity = null;
  final Function() onSubmit;

  @override
  State<FuncionarioStepper> createState() => _FuncionarioStepperState();
}

class _FuncionarioStepperState extends State<FuncionarioStepper> {
  int _index = 0;
  bool jaPreencheu = false;

  initFormEndereco() {
    var formEnderecoValues = widget.viewModel.formEndereco.getValues();
    if (formEnderecoValues == null) {
      return ParceiroEndereco.fromJson({
        'logradouro': '',
        'numero': '',
        'complemento': '',
        'bairro': '',
        'cep': '',
        'ponto_referencia': '',
        'municipio_id': '',
      });
    } else {
      if (widget.entity != null && jaPreencheu == false) {
        jaPreencheu = true;
        return widget.entity!.parceiro!.enderecos[0];
      } else {
        return ParceiroEndereco.fromJson({
          'logradouro': formEnderecoValues['logradouro'],
          'numero': formEnderecoValues['numero'],
          'complemento': formEnderecoValues['complemento'],
          'bairro': formEnderecoValues['bairro'],
          'cep': formEnderecoValues['cep'],
          'ponto_referencia': formEnderecoValues['ponto_referencia'],
          'municipio_id': formEnderecoValues['municipio'],
        });
      }
    }
  }

  initFormContato() {
    if (widget.entity != null) {
      return widget.entity!.parceiro!.contatos;
    } else {
      return List<ParceiroContato>.empty();
    }
  }

  backStep(int index, Function()? onCancel) {
    if (index == 0) {
      return TextButton.icon(
        icon: const Icon(
          Icons.cancel_outlined,
          size: 20,
        ),
        label: const Text('Cancelar'),
        onPressed: () {
          Navigator.of(context).pop();
        },
        style: TextButton.styleFrom(
          foregroundColor: Colors.red,
        ),
      );
    } else {
      return TextButton.icon(
        icon: const Icon(
          Icons.arrow_back_outlined,
          size: 20,
        ),
        label: const Text('Anterior'),
        onPressed: onCancel,
        style: TextButton.styleFrom(
          foregroundColor: Colors.red,
        ),
      );
    }
  }

  nextStep(int index, Function()? onContinue) {
    if (index == 2) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: TextButton.icon(
          icon: const Icon(
            Icons.save_alt_outlined,
            size: 20,
          ),
          label: const Text('Salvar'),
          onPressed: () => widget.onSubmit(),
          style: TextButton.styleFrom(
            foregroundColor: Colors.green,
          ),
        ),
      );
    } else {
      if (index == 0) {
        return StreamBuilder<bool>(
            stream: widget.viewModel.formDados.isValid,
            builder: (context, snapshot) {
              return Directionality(
                textDirection: TextDirection.rtl,
                child: TextButton.icon(
                  onPressed: snapshot.data == true && snapshot.data != null
                      ? onContinue
                      : () {},
                  style: ButtonStyle(
                    foregroundColor: MaterialStateColor.resolveWith((states) =>
                        snapshot.data == true && snapshot.data != null
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey),
                  ),
                  icon: const Icon(
                    Icons.arrow_back_outlined,
                    size: 20,
                  ),
                  label: const Text('Próximo'),
                ),
              );
            });
      } else {
        return StreamBuilder<bool>(
            stream: widget.viewModel.formEndereco.isValid,
            builder: (context, snapshot) {
              return Directionality(
                textDirection: TextDirection.rtl,
                child: TextButton.icon(
                  onPressed: snapshot.data == true && snapshot.data != null
                      ? onContinue
                      : () {},
                  style: ButtonStyle(
                    foregroundColor: MaterialStateColor.resolveWith((states) =>
                        snapshot.data == true && snapshot.data != null
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey),
                  ),
                  icon: const Icon(
                    Icons.arrow_back_outlined,
                    size: 20,
                  ),
                  label: const Text('Próximo'),
                ),
              );
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 700,
      height: 600,
      child: Stepper(
        currentStep: _index,
        type: StepperType.horizontal,
        onStepCancel: () {
          if (_index != 0) {
            setState(() {
              _index -= 1;
            });
          }
        },
        onStepContinue: () {
          if (_index != 2) {
            setState(() {
              _index += 1;
            });
          }
        },
        connectorColor: MaterialStateColor.resolveWith(
          (states) => Theme.of(context).colorScheme.primary,
        ),
        // onStepTapped: (int index) {
        //   setState(() {
        //     _index = index;
        //   });
        // },
        stepIconBuilder: (stepIndex, stepState) {
          if (stepIndex == 0) {
            return Icon(
              Icons.person_outline,
              color: Theme.of(context).colorScheme.onPrimary,
            );
          }
          if (stepIndex == 1) {
            return Icon(
              Icons.location_on_outlined,
              color: Theme.of(context).colorScheme.onPrimary,
            );
          }
          if (stepIndex == 2) {
            return Icon(
              Icons.phone_outlined,
              color: Theme.of(context).colorScheme.onPrimary,
            );
          }
          return const Icon(Icons.edit_outlined);
        },
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                backStep(details.stepIndex, details.onStepCancel),
                nextStep(details.stepIndex, details.onStepContinue)
              ],
            ),
          );
        },
        steps: [
          Step(
            isActive: _index == 0,
            title: const Visibility(child: Text('')),
            label: const Text('Dados'),
            content: EditFuncionarioForm(
              viewModel: widget.viewModel,
              entity: widget.entity,
            ),
          ),
          Step(
            isActive: _index == 1,
            label: const Text('Endereço'),
            title: const Visibility(child: Text('')),
            content: EditEnderecoForm(
              viewModel: widget.viewModel,
              entity: initFormEndereco(),
            ),
          ),
          Step(
            isActive: _index == 2,
            label: const Text('Contatos'),
            title: const Visibility(child: Text('')),
            content: EditContatoForm(
              viewModel: widget.viewModel,
              entity: initFormContato(),
            ),
          ),
        ],
      ),
    );
  }
}
