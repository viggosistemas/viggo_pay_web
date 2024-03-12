import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_transferencia_view_model.dart';

class FormFieldsAlterarSenhaPix extends StatefulWidget {
  const FormFieldsAlterarSenhaPix({
    super.key,
    required this.viewModel,
    required this.jaTemSenha,
  });

  final MatrizTransferenciaViewModel viewModel;
  final bool jaTemSenha;

  @override
  State<FormFieldsAlterarSenhaPix> createState() =>
      _FormFieldsAlterarSenhaPixState();
}

class _FormFieldsAlterarSenhaPixState extends State<FormFieldsAlterarSenhaPix> {
  final senhaAntigaFieldController = TextEditingController();
  final novaSenhaFieldController = TextEditingController();
  final confirmarSenhaFieldController = TextEditingController();
  var senhaAntigaVisible = false;
  var novaSenhaVisible = false;
  var confirmarSenhaVisible = false;

  contentSenhaAntiga() {
    return Column(
      children: [
        StreamBuilder<String>(
          stream: widget.viewModel.formSenha.senhaAntiga,
          builder: (context, snapshot) {
            senhaAntigaFieldController.value =
                senhaAntigaFieldController.value.copyWith(text: snapshot.data);
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
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.jaTemSenha) contentSenhaAntiga(),
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
                    novaSenhaVisible ? Icons.visibility : Icons.visibility_off,
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
            confirmarSenhaFieldController.value = confirmarSenhaFieldController
                .value
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
    );
  }
}
