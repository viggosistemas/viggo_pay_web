import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viggo_pay_admin/login/ui/login_view_model.dart';
import 'package:viggo_pay_admin/login/ui/widgets/actions_remember.dart';
import 'package:viggo_pay_admin/utils/showMsgSnackbar.dart';
import 'package:viggo_pay_core_frontend/components/show_image_from_url.dart';
import 'package:viggo_pay_core_frontend/form/validator.dart';

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
  final _formKey = GlobalKey<FormState>();
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();
  var _passwordVisible = false;

  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _validateForm() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return false;

    _formKey.currentState?.save();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final viewModel = Provider.of<LoginViewModel>(context);

    Widget showImage(String? logoId) {
      const placeholder = 'assets/images/ic_logo.png';
      return logoId == null
          ? const Image(image: AssetImage(placeholder))
          : showImageFromUrl(
              placeholder,
              url: viewModel.parseImage.invoke(logoId),
            );
    }

    viewModel.isError.listen(
      (value) {
        showInfoMessage(
          context,
          20000,
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

        return Card(
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
                  SizedBox(
                    width: 100,
                    child: showImage(viewModel.domainDto?.logoId),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    viewModel.domainDto?.displayName != null
                        ? viewModel.domainDto!.displayName
                        : 'Nome da empresa',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Usuário ou Email *',
                      border: OutlineInputBorder(),
                    ),
                    controller: _userController,
                    validator: (value) {
                      final field = value ?? '';
                      return Validator().isRequired(field);
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Senha *',
                      hintText: 'Insira sua senha',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                    controller: _passwordController,
                    validator: (value) {
                      final field = value ?? '';
                      return Validator().isRequired(field);
                    },
                    obscureText: !_passwordVisible,
                    autocorrect: false,
                    enableSuggestions: false,
                  ),
                  const SizedBox(height: 20),
                  ActionsRememberForget(),
                  const SizedBox(height: 20),
                  if (viewModel.isLoading)
                    const CircularProgressIndicator()
                  else
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: ElevatedButton.icon(
                        icon: const Icon(
                          Icons.person_2_outlined,
                          color: Colors.white,
                        ),
                        onPressed: () => {
                          if (_validateForm())
                            viewModel.onSearch(
                                _userController.text,
                                _passwordController.text,
                                showInfoMessage,
                                context)
                        },
                        style: ElevatedButton.styleFrom(
                            alignment: Alignment.center,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 8,
                            ),
                            backgroundColor:
                                Theme.of(context).colorScheme.primary),
                        label: const Text(
                          'Acessar',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
