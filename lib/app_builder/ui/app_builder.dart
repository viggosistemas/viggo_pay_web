import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_builder_view_model.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/app_bar.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/menu/ui/main_rail.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/pop_menu/ui/pop_menu.dart';
import 'package:viggo_pay_core_frontend/user/data/models/user_api_dto.dart';

class AppBuilder extends StatefulWidget {
  const AppBuilder({
    super.key,
    required this.child,
    required this.changeTheme,
  });

  final void Function(ThemeMode themeMode) changeTheme;

  final Widget child;

  @override
  State<AppBuilder> createState() => _AppBuilderState();
}

class _AppBuilderState extends State<AppBuilder> {
  var iconMode = Icons.dark_mode_outlined;
  dynamic colorIconMode = Colors.white;
  bool isActioned = false;

  @override
  Widget build(context) {
    final viewModel = Provider.of<AppBuilderViewModel>(context);

    // final width = MediaQuery.of(context).size.width;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (isDarkMode && !isActioned) {
      setState(() {
        iconMode = Icons.light_mode_outlined;
        colorIconMode = Colors.yellow;
      });
    }

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
                // IconButton(
                //   style: IconButton.styleFrom(
                //     foregroundColor: Colors.white,
                //   ),
                //   onPressed: () {
                //     setState(() {
                //       isActioned = true;
                //       if (isDarkMode) {
                //         iconMode = Icons.dark_mode_outlined;
                //         colorIconMode = Colors.white;
                //         widget.changeTheme(ThemeMode.light);
                //       } else {
                //         iconMode = Icons.light_mode_outlined;
                //         colorIconMode = Colors.yellow;
                //         widget.changeTheme(ThemeMode.dark);
                //       }
                //     });
                //   },
                //   icon: Icon(
                //     iconMode,
                //     color: colorIconMode,
                //   ),
                // ),
                // const SizedBox(
                //   width: 20,
                // ),
                getAvatar(snapshot.data?.photoId),
                const SizedBox(
                  width: 20,
                ),
                PopUpMenuUser(
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
                  widget.child,
                ],
              ),
            ),
          );
        });
  }
}
