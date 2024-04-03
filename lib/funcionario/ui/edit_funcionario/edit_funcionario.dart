import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/funcionario/data/models/funcionario_api_dto.dart';
import 'package:viggo_pay_admin/funcionario/ui/edit_funcionario/edit_funcionario_stepper/edit_funcionario_stepper.dart';
import 'package:viggo_pay_admin/funcionario/ui/edit_funcionario/funcionario_view_model.dart';
import 'package:viggo_pay_admin/utils/show_msg_snackbar.dart';

class EditFuncionario {
  EditFuncionario({required this.context});

  final BuildContext context;
  final viewModel = locator.get<EditFuncionarioViewModel>();

  clearFields() {
    viewModel.formDados.nomeRazaoSocial.onValueChange('');
    viewModel.formDados.cpfCnpj.onValueChange('');
    viewModel.formDados.apelidoNomeFantasia.onValueChange('');
    viewModel.formDados.rgInscEst.onValueChange('');
    viewModel.formDados.userId.onValueChange('');

    viewModel.formEndereco.logradouro.onValueChange('');
    viewModel.formEndereco.bairro.onValueChange('');
    viewModel.formEndereco.municipio.onValueChange('');
    viewModel.formEndereco.municipioName.onValueChange('');
    viewModel.formEndereco.complemento.onValueChange('');
    viewModel.formEndereco.cep.onValueChange('');
    viewModel.formEndereco.numero.onValueChange('');
    viewModel.formEndereco.pontoReferencia.onValueChange('');

    viewModel.formContato.contato.onValueChange('');
    viewModel.formContato.contatos.onValueChange('');
  }

  Future<void> addDialog() {
    clearFields();
    onSubmit() {
      viewModel.submit(null, showInfoMessage, context);
      // Navigator.of(context).pop();
    }

    viewModel.isSuccess.listen((value) {
      showInfoMessage(
        context,
        2,
        Colors.green,
        'Funcionário criado com sucesso!',
        'X',
        () {},
        Colors.white,
      );
      Navigator.pop(context, true);
    });

    viewModel.errorMessage.listen(
      (value) {
        if (value.isNotEmpty && context.mounted) {
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
    return showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return PopScope(
            canPop: false,
            onPopInvoked: (bool didPop) {
              if (didPop) return;
              Navigator.pop(context, true);
            },
            child: SimpleDialog(
              insetPadding: const EdgeInsets.all(10),
              title: Row(
                children: [
                  Text(
                    'Adicionando funcionário',
                    style: Theme.of(ctx).textTheme.titleMedium!.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  const Icon(Icons.person_outline),
                ],
              ),
              children: [
                FuncionarioStepper(
                  viewModel: viewModel,
                  onSubmit: onSubmit,
                ),
              ],
            ),
          );
        });
  }

  Future<void> editDialog(FuncionarioApiDto entity) {
    onSubmit() {
      viewModel.submit(entity.id, showInfoMessage, context);
      // Navigator.of(context).pop();
    }

    viewModel.isSuccess.listen((value) {
      showInfoMessage(
        context,
        2,
        Colors.green,
        'Funcionário editado com sucesso!',
        'X',
        () {},
        Colors.white,
      );
      Navigator.pop(context, true);
    });

    viewModel.errorMessage.listen(
      (value) {
        if (value.isNotEmpty && context.mounted) {
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

    return showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return PopScope(
            canPop: false,
            onPopInvoked: (bool didPop) {
              if (didPop) return;
              if (context.mounted) {
                Navigator.pop(context, true);
              }
            },
            child: SimpleDialog(
              insetPadding: const EdgeInsets.all(10),
              title: Row(
                children: [
                  Text(
                    'Editando funcionário',
                    style: Theme.of(ctx).textTheme.titleMedium!.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  const Icon(Icons.person_outline),
                ],
              ),
              children: [
                FuncionarioStepper(
                  viewModel: viewModel,
                  entity: entity,
                  onSubmit: onSubmit,
                )
              ],
            ),
          );
        });
  }
}
