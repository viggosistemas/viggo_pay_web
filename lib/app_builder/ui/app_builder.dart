import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_builder_view_model.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/app_bar.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/menu/main_rail.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/pop_menu.dart';
import 'package:viggo_pay_core_frontend/user/data/models/user_api_dto.dart';

class AppBuilder extends StatelessWidget {
  const AppBuilder({super.key, required this.child});

  final Widget child;

  @override
  Widget build(context) {
    final viewModel = Provider.of<AppBuilderViewModel>(context);

    void setScreen(String? route) {
      //TODO: SE ESTIVER LOGGED NO APP STATE NAO DEVE SAIR PRA LOGIN DEVE SE MANTER NO DASHBOARD
      if (route == 'LOGIN_PAGE') {
        Navigator.of(context).pushNamedAndRemoveUntil(route!, (r) => false);
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed(route!);
      });
    }

    Widget getAvatar(String? photoId) {
      if (photoId == null) {
        return const CircleAvatar(
          backgroundImage: NetworkImage(
            'assets/images/avatar.png',
          ),
        );
      } else {
        var photoUrl = viewModel.parseImage.invoke(photoId);
        return CircleAvatar(
          backgroundImage: NetworkImage(
            photoUrl,
          ),
        );
      }
    }

    return StreamBuilder<UserApiDto?>(
        stream: viewModel.userDto,
        builder: (context, snapshot) {
          if (snapshot.data == null) viewModel.getUser();
          return Scaffold(
            appBar: AppBarPrivate(
              toolbarHeight: 50,
              // showDrawerOrBack: true, TODO: USAR NO DRAWER
              actions: [
                getAvatar(snapshot.data?.photoId),
                const SizedBox(
                  width: 20,
                ),
                PopMenuActionsUser(
                  onSelectScreen: setScreen,
                )
              ],
            ),
            // TODO: USAR NO DRAWER
            // drawer: MainDrawer(
            //   onSelectScreen: setScreen,
            // ),
            // body: child,
            body: SafeArea(
              bottom: false,
              top: false,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: MainRail(
                      onSelectScreen: setScreen,
                    ),
                  ),
                  const VerticalDivider(thickness: 1, width: 1),
                  child,
                ],
              ),
            ),
          );
        });
  }
}
