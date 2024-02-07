import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/login/ui/login_view_model.dart';

// ignore: must_be_immutable
class ActionsRememberForget extends StatelessWidget {
  ActionsRememberForget({
    super.key,
    required this.viewModel,
    required this.onForgetPassword,
  });

  final LoginViewModel viewModel;
  void Function() onForgetPassword;

  @override
  Widget build(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StreamBuilder<bool>(
              stream: viewModel.form.remember,
              builder: (context, snapshot) {
                return Checkbox(
                  value: snapshot.data ?? false,
                  onChanged: (value) {
                    viewModel.form.onRememberChange(value!);
                  },
                );
              }
            ),
            const SizedBox(width: 6),
            const Text('Lembrar-me'),
          ],
        ),
        TextButton(
          onPressed: onForgetPassword,
          child: const Text(
            'Esqueceu a senha?',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 16, 39, 245)),
          ),
        )
      ],
    );
  }
}
