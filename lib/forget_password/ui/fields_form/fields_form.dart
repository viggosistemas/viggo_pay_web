import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/forget_password/ui/forget_password_view_model.dart';

class FieldsForm extends StatefulWidget {
  const FieldsForm({
    super.key,
    required this.viewModel,
  });

  final ForgetPasswordViewModel viewModel;

  @override
  State<FieldsForm> createState() => _FieldsFormState();
}

class _FieldsFormState extends State<FieldsForm> {
  final _domainController = TextEditingController();

  final _userController = TextEditingController();

  @override
  Widget build(context) {
    return Column(
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
            stream: widget.viewModel.form.domain,
            builder: (context, snapshot) {
              _domainController.value =
                  _domainController.value.copyWith(text: snapshot.data ?? '');
              return TextFormField(
                decoration: InputDecoration(
                  labelText: 'Domínio *',
                  border: const OutlineInputBorder(),
                  errorText: snapshot.error?.toString(),
                ),
                controller: _domainController,
                onChanged: (value) {
                  widget.viewModel.form.onDomainChange(value);
                },
                // onFieldSubmitted: (value) {
                //   if (_validateForm()) {
                //     widget.viewModel.onSearch(
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
            stream: widget.viewModel.form.username,
            builder: (context, snapshot) {
              _userController.value =
                  _userController.value.copyWith(text: snapshot.data ?? '');
              return TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email *',
                  border: const OutlineInputBorder(),
                  errorText: snapshot.error?.toString(),
                ),
                controller: _userController,
                onChanged: (value) {
                  widget.viewModel.form.onEmailChange(value);
                },
                // onFieldSubmitted: (value) {
                //   if (_validateForm()) {
                //     widget.viewModel.onSearch(
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
      ],
    );
  }
}
