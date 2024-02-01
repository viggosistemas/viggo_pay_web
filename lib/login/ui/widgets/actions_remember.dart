import 'package:flutter/material.dart';

class ActionsRememberForget extends StatefulWidget{
  ActionsRememberForget({super.key});
  
  @override
  State<StatefulWidget> createState() {
    return _ActionsRememberForget();
  }
}

class _ActionsRememberForget extends State<ActionsRememberForget> {
  var _done = false;

  @override
  Widget build(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
              value: _done,
              onChanged: (value) {
                setState(() {
                  _done = value ?? false;
                });
              },
            ),
            const SizedBox(width: 6),
            const Text('Lembrar-me'),
          ],
        ),
        TextButton(
          onPressed: () {},
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
