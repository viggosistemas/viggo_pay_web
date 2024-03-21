import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viggo_pay_admin/lazy_loading/ui/lazy_loading_view_model.dart';
import 'package:viggo_pay_admin/utils/constants.dart';

class LazyLoadingWidget extends StatelessWidget {
  const LazyLoadingWidget({
    super.key,
    required this.onNavigateTo,
  });

  final Function onNavigateTo;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LazyLoadingViewModel>(context);

    return StreamBuilder<bool>(
        stream: viewModel.isLogged,
        builder: (context, snapshot) {
          if (snapshot.data == true && snapshot.data != null) {
            var url = Uri.base.toString();
            var name = url.split('#');
            var urlName = '';
            if (name.length == 2) {
              urlName = name[1];
            } else {
              urlName = Routes.WORKSPACE;
            }
            onNavigateTo(urlName);
          } else if (snapshot.data == false && snapshot.data != null) {
            onNavigateTo(Routes.LOGIN_PAGE);
          } else {
            viewModel.checkAppState();
          }

          return Container(
            color: Theme.of(context).colorScheme.primary,
            width: double.infinity,
            height: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Carregando...',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                ),
                const SizedBox(
                  height: 10,
                ),
                CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ],
            ),
          );
        });
  }
}
