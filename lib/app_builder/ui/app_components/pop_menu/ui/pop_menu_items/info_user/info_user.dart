import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:viggo_core_frontend/user/data/models/user_api_dto.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/pop_menu/ui/pop_menu_view_model.dart';
import 'package:viggo_pay_admin/components/hover_button.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/utils/show_msg_snackbar.dart';

class InfoUserDialog {
  InfoUserDialog({required this.context});

  final BuildContext context;
  final viewModel = locator.get<PopMenuViewModel>();

  Widget? getImagem(String? photoId) {
    if (photoId != null && photoId.isNotEmpty) {
      return CircleAvatar(
        backgroundImage: NetworkImage(
          viewModel.parseImage.invoke(photoId),
        ),
      );
    } else if (viewModel.user!.photoId != null &&
        viewModel.user!.photoId!.isNotEmpty) {
      return CircleAvatar(
        backgroundImage: NetworkImage(
          viewModel.parseImage.invoke(viewModel.user!.photoId!),
        ),
      );
    } else {
      return const CircleAvatar(
        backgroundImage: AssetImage(
          'assets/images/avatar.png',
        ),
      );
    }
  }

  Future showFormDialog() {
    final nickNameController = TextEditingController();
    viewModel.form.nickname.onValueChange(viewModel.user!.nickname ?? '');

    showMsgError(String value) {
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

    onUploadPhoto() async {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        allowedExtensions: ['png', 'jpg', 'wbp', 'jpeg'],
        type: FileType.custom,
      );

      if (result != null) {
        for (var element in result.files) {
          viewModel.uploadPhoto(
            element,
            showMsgError,
          );
        }
      }
    }

    onSubmit() {
      viewModel.onSubmit(showInfoMessage, context);
      // Navigator.of(context).pop();
    }

    viewModel.isSuccess.listen((value) {
      showInfoMessage(
        context,
        2,
        Colors.green,
        'Usuário alterado com sucesso!',
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
            child: AlertDialog(
              insetPadding: const EdgeInsets.all(10),
              title: Row(
                children: [
                  Text(
                    'Informações do usuário',
                    style: Theme.of(ctx).textTheme.titleMedium!.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Icon(
                    Icons.person_outline,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
              content: SizedBox(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      StreamBuilder<UserApiDto>(
                          stream: viewModel.userController,
                          builder: (context, snapshot) {
                            return Center(
                              child: SizedBox(
                                height: 100,
                                width: 100,
                                child: getImagem(snapshot.data?.photoId),
                              ),
                            );
                          }),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OnHoverButton(
                            child: IconButton(
                              onPressed: () {
                                if (viewModel.user!.photoId != null) {
                                  return viewModel.removePhoto();
                                }
                              },
                              icon: const Icon(Icons.delete_outline),
                              style: IconButton.styleFrom(
                                backgroundColor: viewModel.user!.photoId != null
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          OnHoverButton(
                            child: IconButton(
                              onPressed: () => onUploadPhoto(),
                              icon: const Icon(Icons.camera_alt_outlined),
                              style: IconButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      StreamBuilder<String>(
                        stream: viewModel.form.nickname.field,
                        builder: (context, snapshot) {
                          nickNameController.value = nickNameController.value
                              .copyWith(text: snapshot.data);
                          return TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Nickname',
                              border: const OutlineInputBorder(),
                              errorText: snapshot.error?.toString(),
                            ),
                            controller: nickNameController,
                            onChanged: (value) {
                              viewModel.form.nickname.onValueChange(value);
                            },
                            // onFieldSubmitted: (value) {
                            //   if (_validateForm()) {
                            //     viewModel.onSearch(
                            //       _domainController.text,
                            //       _userController.text,
                            //       _passwordController.text,
                            //       showInfoMessage,
                            //       context,
                            //     );
                            //   }
                            // },
                          );
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(viewModel.user!.name),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.mail_outline,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(viewModel.user!.email),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OnHoverButton(
                      child: TextButton.icon(
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
                      ),
                    ),
                    OnHoverButton(
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextButton.icon(
                          icon: const Icon(
                            Icons.save_alt_outlined,
                            size: 20,
                          ),
                          label: const Text('Salvar'),
                          onPressed: () => onSubmit(),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.green,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
