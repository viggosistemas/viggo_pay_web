import 'package:flutter/material.dart';
import 'package:viggo_core_frontend/domain/data/models/domain_api_dto.dart';
import 'package:viggo_core_frontend/user/data/models/user_api_dto.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/user/ui/edit_users/edit_users_form/edit_users_form.dart';
import 'package:viggo_pay_admin/user/ui/edit_users/edit_users_view_model.dart';
import 'package:viggo_pay_admin/utils/show_msg_snackbar.dart';

class EditUsers {
  EditUsers({
    required this.context,
    domain,
  }) {
    if (domain != null) {
      this.domain = domain;
    }
  }

  // ignore: avoid_init_to_null
  late DomainApiDto? domain = null;
  final BuildContext context;
  final viewModel = locator.get<EditUsersViewModel>();

  Future addDialog() {
    onSubmit(ctx) async {
      await viewModel.submit(null, showInfoMessage, ctx);
      Navigator.of(ctx).pop(true);
    }

    viewModel.isSuccess.listen((value) {
      showInfoMessage(
        context,
        2,
        Colors.green,
        'Usuário criado com sucesso!',
        'X',
        () {},
        Colors.white,
      );
      // Navigator.pop(context, true);
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
    return showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return PopScope(
            child: AlertDialog(
              insetPadding: const EdgeInsets.all(10),
              title: Row(
                children: [
                  Text(
                    'Adicionando usuário',
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
              content: SizedBox(
                width: 500,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      EditUsersForm(
                        viewModel: viewModel,
                        domain: domain,
                        onSubmit: () => onSubmit(ctx),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Future editDialog(UserApiDto entity) {
    onSubmit(ctx) async {
      await viewModel.submit(entity.id, showInfoMessage, ctx);
      Navigator.pop(ctx, true);
    }

    viewModel.isSuccess.listen((value) {
      showInfoMessage(
        context,
        2,
        Colors.green,
        'Usuário editado com sucesso!',
        'X',
        () {},
        Colors.white,
      );
      // Navigator.pop(context, true);
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

    return showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return PopScope(
            canPop: false,
            onPopInvoked: (bool didPop) {
              if (didPop) return;
              Navigator.pop(context, true);
            },
            child: AlertDialog(
              insetPadding: const EdgeInsets.all(10),
              title: Row(
                children: [
                  Text(
                    'Editando usuário',
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
              content: SizedBox(
                width: 500,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      EditUsersForm(
                        entity: entity,
                        viewModel: viewModel,
                        domain: domain,
                        onSubmit: () => onSubmit(ctx),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
