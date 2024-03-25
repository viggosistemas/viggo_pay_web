import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/components/hover_button.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/login/ui/fields_form/actions_remember.dart';
import 'package:viggo_pay_admin/login/ui/fields_form/fields_form.dart';
import 'package:viggo_pay_admin/login/ui/login_view_model.dart';
import 'package:viggo_pay_admin/utils/constants.dart';
import 'package:viggo_pay_admin/utils/show_msg_snackbar.dart';

class LoginForm extends StatefulWidget {
  final Function onSucess;
  const LoginForm({
    super.key,
    required this.onSucess,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  LoginViewModel viewModel = locator.get<LoginViewModel>();

  onForgetPassword() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacementNamed(Routes.FORGET_PASSWORD);
    });
  }

  Widget showImageFromUrl(
    String placeholder,
    String? domainName, {
    String? logoId,
    LoginViewModel? viewModel,
  }) {
    var url = viewModel?.parseImage.invoke(logoId!);
    if (url == null) {
      return showImageDefault(
        placeholder,
        domainName,
        viewModel: viewModel,
      );
    } else {
      return Stack(
        children: [
          Tooltip(
            message: domainName,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.7),
                    blurRadius: 8,
                    spreadRadius: 6,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 150,
                  height: 100,
                  child: FadeInImage(
                    image: NetworkImage(url),
                    placeholder: AssetImage(placeholder),
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset(placeholder, fit: BoxFit.contain);
                    },
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: OnHoverButton(
              child: IconButton(
                onPressed: () {
                  viewModel?.onClearRememberCredential();
                },
                icon: const Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget showImageDefault(
    String placeholder,
    String? domainName, {
    LoginViewModel? viewModel,
  }) {
    return Stack(
      children: [
        Tooltip(
          message: domainName,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.7),
                  blurRadius: 8,
                  spreadRadius: 6,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image(
                image: AssetImage(placeholder),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: OnHoverButton(
            child: IconButton(
              onPressed: () {
                viewModel?.onClearRememberCredential();
              },
              icon: const Icon(
                Icons.cancel,
                color: Colors.red,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget showImage(
    String? logoId,
    String? domainName,
    LoginViewModel viewModel,
  ) {
    const placeholder = 'assets/images/default-logo-login.png';
    return logoId == null
        ? showImageDefault(
            placeholder,
            domainName,
            viewModel: viewModel,
          )
        : showImageFromUrl(
            placeholder,
            domainName,
            logoId: logoId,
            viewModel: viewModel,
          );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

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

    return StreamBuilder<bool>(
      stream: viewModel.isLogged,
      builder: (context, snapshot) {
        if (snapshot.data != null && snapshot.data == true) {
          widget.onSucess();
        }

        return Column(
          children: [
            SizedBox(
              width: 200,
              child: Image.asset('assets/images/logo.png'),
            ),
            const SizedBox(
              height: 10,
            ),
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                width: deviceSize.width * 0.2,
                child: Column(
                  children: [
                    FieldsForm(
                      viewModel: viewModel,
                      showImage: showImage,
                    ),
                    ActionsRememberForget(
                      viewModel: viewModel,
                      onForgetPassword: onForgetPassword,
                    ),
                    const SizedBox(height: 20),
                    if (viewModel.isLoading)
                      const CircularProgressIndicator()
                    else
                      StreamBuilder<bool>(
                          stream: viewModel.form.isValid,
                          builder: (context, snapshot) {
                            return OnHoverButton(
                              child: Directionality(
                                textDirection: TextDirection.ltr,
                                child: ElevatedButton.icon(
                                  icon: const Icon(
                                    Icons.person_2_outlined,
                                    color: Colors.white,
                                  ),
                                  onPressed: () async {
                                    if (snapshot.data == true) {
                                      viewModel.onSubmit(
                                        showInfoMessage,
                                        context,
                                      );
                                    }
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
                                    'Acessar',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
