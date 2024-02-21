import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viggo_pay_admin/lazy_loading/ui/lazy_loading_view_model.dart';

class LazyLoadingWidget extends StatelessWidget {
  const LazyLoadingWidget({
    super.key,
    required this.onNavigateToLogin,
    required this.onNavigateToWorkSpace,
  });

  final Function onNavigateToWorkSpace;
  final Function onNavigateToLogin;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LazyLoadingViewModel>(context);

    return StreamBuilder<bool>(
        stream: viewModel.isLogged,
        builder: (context, snapshot) {
          if (snapshot.data == true) {
            onNavigateToWorkSpace();
          } else {
            onNavigateToLogin();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Carregando...',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.black),
              ),
              const SizedBox(
                height: 10,
              ),
              const CircularProgressIndicator(),
            ],
          );
        });
  }
}
