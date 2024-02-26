import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/pop_menu/ui/pop_menu_view_model.dart';

class FormFieldsAlterarSenha extends StatefulWidget {
  const FormFieldsAlterarSenha({
    super.key,
    required this.viewModel,
  });

  final PopMenuViewModel viewModel;

  @override
  State<FormFieldsAlterarSenha> createState() => _FormFieldsAlterarSenhaState();
}

class _FormFieldsAlterarSenhaState extends State<FormFieldsAlterarSenha> {
  final formKey = GlobalKey<FormState>();
  final senhaAntigaFieldController = TextEditingController();
  final novaSenhaFieldController = TextEditingController();
  final confirmarSenhaFieldController = TextEditingController();
  var senhaAntigaVisible = false;
  var novaSenhaVisible = false;
  var confirmarSenhaVisible = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          StreamBuilder<String>(
            stream: widget.viewModel.formSenha.senhaAntiga,
            builder: (context, snapshot) {
              senhaAntigaFieldController.value = senhaAntigaFieldController
                  .value
                  .copyWith(text: snapshot.data);
              return TextFormField(
                decoration: InputDecoration(
                  labelText: 'Senha antiga *',
                  border: const OutlineInputBorder(),
                  errorText: snapshot.error?.toString(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      senhaAntigaVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        senhaAntigaVisible = !senhaAntigaVisible;
                      });
                    },
                  ),
                ),
                controller: senhaAntigaFieldController,
                onChanged: (value) {
                  widget.viewModel.formSenha.onSenhaAntigaChange(value);
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
                obscureText: !senhaAntigaVisible,
                autocorrect: false,
                enableSuggestions: false,
              );
            },
          ),
          const SizedBox(
            height: 10,
          ),
          StreamBuilder<String>(
            stream: widget.viewModel.formSenha.novaSenha,
            builder: (context, snapshot) {
              novaSenhaFieldController.value =
                  novaSenhaFieldController.value.copyWith(text: snapshot.data);
              return TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nova senha *',
                  border: const OutlineInputBorder(),
                  errorText: snapshot.error?.toString(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      novaSenhaVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        novaSenhaVisible = !novaSenhaVisible;
                      });
                    },
                  ),
                ),
                controller: novaSenhaFieldController,
                onChanged: (value) {
                  widget.viewModel.formSenha.onNovaSenhaChange(value);
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
                obscureText: !novaSenhaVisible,
                autocorrect: false,
                enableSuggestions: false,
              );
            },
          ),
          const SizedBox(
            height: 10,
          ),
          StreamBuilder<String>(
            stream: widget.viewModel.formSenha.confirmarSenha,
            builder: (context, snapshot) {
              confirmarSenhaFieldController.value =
                  confirmarSenhaFieldController.value
                      .copyWith(text: snapshot.data);
              return TextFormField(
                decoration: InputDecoration(
                  labelText: 'Confirmar senha *',
                  border: const OutlineInputBorder(),
                  errorText: snapshot.error?.toString(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      confirmarSenhaVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        confirmarSenhaVisible = !confirmarSenhaVisible;
                      });
                    },
                  ),
                ),
                controller: confirmarSenhaFieldController,
                onChanged: (value) {
                  widget.viewModel.formSenha.onConfirmarSenha(value);
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
                obscureText: !confirmarSenhaVisible,
                autocorrect: false,
                enableSuggestions: false,
              );
            },
          ),
        ],
      ),
    );
  }
}
