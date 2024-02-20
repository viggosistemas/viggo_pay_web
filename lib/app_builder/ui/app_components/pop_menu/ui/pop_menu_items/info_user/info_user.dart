import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/pop_menu/ui/pop_menu_view_model.dart';

class InfoUserDialog {
  final BuildContext context;

  InfoUserDialog({required this.context});

  Future<void> showFormDialog() {
    final formKey = GlobalKey<FormState>();
    final nickNameController = TextEditingController();
    final viewModel = Provider.of<PopMenuViewModel>(context);

    return showDialog(
        context: context,
        builder: (BuildContext ctx) {
          Widget dialog = AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Informações do usuário',
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        fontSize: 18,
                      ),
                ),
                // IconButton(
                //   onPressed: () => Navigator.pop(context),
                //   icon: const Icon(
                //     Icons.close,
                //     color: Colors.red,
                //   ),
                // )
              ],
            ),
            content: Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 100,
                          width: 100,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                              'assets/images/avatar.png',
                            ),
                          ),
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
                            const Text('user.name'),
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
                            const Text('data'),
                          ],
                        ),
                      ],
                    ),
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
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
          return Provider<PopMenuViewModel>.value(
            value: viewModel,
            child: dialog,
          );
        });
  }
}
