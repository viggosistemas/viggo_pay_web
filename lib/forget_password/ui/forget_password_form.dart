import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viggo_pay_admin/forget_password/ui/forget_password_view_model.dart';
import 'package:viggo_pay_admin/utils/show_msg_snackbar.dart';

class ForgetPassForm extends StatefulWidget {
  final Function onSucess;
  const ForgetPassForm({
    super.key,
    required this.onSucess,
  });

  @override
  State<ForgetPassForm> createState() => _ForgetPassFormState();
}

class _ForgetPassFormState extends State<ForgetPassForm> {
  final _formKey = GlobalKey<FormState>();
  final _domainController = TextEditingController();

  final _userController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final viewModel = Provider.of<ForgetPasswordViewModel>(context);

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

    return StreamBuilder<Object>(
      stream: viewModel.isLogged,
      builder: (context, snapshot) {
        if (snapshot.data != null && snapshot.data == true) {
          widget.onSucess();
        }

        return Column(
          children: [
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                width: deviceSize.width * 0.2,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Text(
                        'Recuperação de senha',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromARGB(255, 100, 94, 94),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Para recuperar sua senha, digite o domínio e seu e-mail nos campos abaixo e clique em recuperar senha.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromARGB(255, 100, 94, 94),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(height: 10),
                      StreamBuilder<String>(
                          stream: viewModel.form.domain,
                          builder: (context, snapshot) {
                            _domainController.value = _domainController.value
                                .copyWith(text: snapshot.data ?? '');
                            return TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Domínio *',
                                border: const OutlineInputBorder(),
                                errorText: snapshot.error?.toString(),
                              ),
                              controller: _domainController,
                              onChanged: (value) {
                                viewModel.form.onDomainChange(value);
                              },
                              // onFieldSubmitted: (value) {
                              //   if (_validateForm()) {
                              //     viewModel.onSearch(
                              //         _domainController.text,
                              //         _userController.text,
                              //         _passwordController.text,
                              //         showInfoMessage,
                              //         context);
                              //   }
                              // },
                            );
                          }),
                      const SizedBox(height: 10),
                      StreamBuilder<String>(
                          stream: viewModel.form.username,
                          builder: (context, snapshot) {
                            _userController.value = _userController.value
                                .copyWith(text: snapshot.data ?? '');
                            return TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Email *',
                                border: const OutlineInputBorder(),
                                errorText: snapshot.error?.toString(),
                              ),
                              controller: _userController,
                              onChanged: (value) {
                                viewModel.form.onEmailChange(value);
                              },
                              // onFieldSubmitted: (value) {
                              //   if (_validateForm()) {
                              //     viewModel.onSearch(
                              //         _domainController.text,
                              //         _userController.text,
                              //         _passwordController.text,
                              //         showInfoMessage,
                              //         context);
                              //   }
                              // },
                            );
                          }),
                      const SizedBox(height: 20),
                      if (viewModel.isLoading)
                        const CircularProgressIndicator()
                      else
                        StreamBuilder<bool>(
                          stream: viewModel.form.isValid,
                          builder: (context, snapshot) {
                            return Directionality(
                              textDirection: TextDirection.rtl,
                              child: ElevatedButton.icon(
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                                onPressed: () => {
                                  if (snapshot.data == true)
                                    viewModel.onSearch(
                                      showInfoMessage,
                                      context,
                                    )
                                },
                                style: ElevatedButton.styleFrom(
                                  fixedSize: const Size(double.maxFinite, 40),
                                  alignment: Alignment.center,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 8,
                                  ),
                                  backgroundColor: snapshot.data == true
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.grey,
                                  enabledMouseCursor: snapshot.data == true
                                      ? SystemMouseCursors.click
                                      : SystemMouseCursors.basic,
                                ),
                                label: const Text(
                                  'Recuperar senha',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      const SizedBox(
                        height: 10,
                      ),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: ElevatedButton.icon(
                          icon: const Icon(
                            Icons.home,
                            color: Colors.white,
                          ),
                          onPressed: () => widget.onSucess(),
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(double.maxFinite, 40),
                            alignment: Alignment.center,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 8,
                            ),
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                          ),
                          label: const Text(
                            'Voltar pro login',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
