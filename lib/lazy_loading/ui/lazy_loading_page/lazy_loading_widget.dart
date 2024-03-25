import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/components/progress_loading.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/lazy_loading/ui/lazy_loading_view_model.dart';
import 'package:viggo_pay_admin/utils/constants.dart';

// ignore: must_be_immutable
class LazyLoadingWidget extends StatelessWidget {
  LazyLoadingWidget({
    super.key,
    required this.onNavigateTo,
  });

  final Function onNavigateTo;
  LazyLoadingViewModel viewModel = locator.get<LazyLoadingViewModel>();

  returnUrl(bool isLogged) {
    var url = Uri.base.toString();
    var name = url.split('#');
    var urlName = '';
    if (name.length == 2) {
      urlName = name[1];
    } else {
      urlName = isLogged ? Routes.WORKSPACE : Routes.LOGIN_PAGE;
    }
    return urlName;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: viewModel.isLogged,
        builder: (context, snapshot) {
          if (snapshot.data == true && snapshot.data != null) {
            onNavigateTo(returnUrl(true));
          } else if (snapshot.data == false && snapshot.data != null) {
            onNavigateTo(returnUrl(false));
          } else {
            viewModel.checkAppState();
          }

          return Container(
            color: Theme.of(context).colorScheme.primary,
            width: double.infinity,
            height: double.infinity,
            child: ProgressLoading(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
          );
        });
  }
}
