import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/components/hover_button.dart';
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
            StreamBuilder<String>(
              stream: viewModel.form.remember.field,
              builder: (context, snapshot) {
                return OnHoverButton(
                  child: Checkbox(
                    value: snapshot.data?.parseBool() ?? false,
                    onChanged: (value) {
                      viewModel.form.remember.onValueChange(value!.toString());
                    },
                  ),
                );
              }
            ),
            const SizedBox(width: 6),
            const Text('Lembrar-me'),
          ],
        ),
        OnHoverButton(
          child: TextButton(
            onPressed: onForgetPassword,
            child: const Text(
              'Esqueceu a senha?',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 16, 39, 245)),
            ),
          ),
        )
      ],
    );
  }
}
