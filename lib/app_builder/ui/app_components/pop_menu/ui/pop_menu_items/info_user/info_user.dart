import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/pop_menu/ui/pop_menu_view_model.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/utils/show_msg_snackbar.dart';

class InfoUserDialog {
  InfoUserDialog({required this.context});

  final BuildContext context;
  final viewModel = locator.get<PopMenuViewModel>();

  Widget? getImagem() {
    if (viewModel.user!.photoId != null &&
        viewModel.user!.photoId!.isNotEmpty) {
      return CircleAvatar(
        backgroundImage: NetworkImage(
          viewModel.parseImage.invoke(viewModel.user!.photoId!),
        ),
      );
    } else {
      return const CircleAvatar(
        backgroundImage: NetworkImage(
          'assets/images/avatar.png',
        ),
      );
    }
  }

  Future<void> showFormDialog() {
    final formKey = GlobalKey<FormState>();
    final nickNameController = TextEditingController();
    viewModel.form.onNickNameChange(viewModel.user!.nickname!);

    actionUpload(PlatformFile file) {
      viewModel.uploadPhoto(file, showInfoMessage, context);
    }

    onUploadPhoto() async {
      var picked = await FilePickerWeb.platform.pickFiles(type: FileType.image);

      if (picked != null) {
        actionUpload(picked.files.first);
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
              content: Form(
                key: formKey,
                child: SizedBox(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Center(
                          child: SizedBox(
                            height: 100,
                            width: 100,
                            child: getImagem(),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                if (viewModel.user!.photoId != null)
                                  return null;
                              },
                              icon: const Icon(Icons.delete_outline),
                              style: IconButton.styleFrom(
                                backgroundColor: viewModel.user!.photoId != null
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            IconButton(
                              onPressed: () => onUploadPhoto(),
                              icon: const Icon(Icons.camera_alt_outlined),
                              style: IconButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        StreamBuilder<String>(
                          stream: viewModel.form.nickname,
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
                                viewModel.form.onNickNameChange(value);
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
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
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
                    Directionality(
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
                  ],
                ),
              ],
            ),
          );
        });
  }
}
