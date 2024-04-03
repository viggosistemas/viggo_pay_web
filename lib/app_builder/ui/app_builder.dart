import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viggo_core_frontend/domain/data/models/domain_api_dto.dart';
import 'package:viggo_core_frontend/route/data/models/route_api_dto.dart';
import 'package:viggo_core_frontend/user/data/models/user_api_dto.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_builder_view_model.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/menu/ui/main_drawer.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/menu/ui/main_rail.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/pop_menu/ui/pop_menu.dart';
import 'package:viggo_pay_admin/components/hover_button.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/themes/theme_view_model.dart';
import 'package:viggo_pay_admin/utils/constants.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

class AppBuilder extends StatefulWidget {
  const AppBuilder({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<AppBuilder> createState() => _AppBuilderState();
}

class _AppBuilderState extends State<AppBuilder> {
  ThemeViewModel themeViewModel = locator.get<ThemeViewModel>();
  AppBuilderViewModel viewModel = locator.get<AppBuilderViewModel>();
  SharedPreferences sharedPrefs = locator.get<SharedPreferences>();
  SampleItem? selectedItem;

  var iconMode = Icons.dark_mode_outlined;
  dynamic colorIconMode = Colors.white;
  bool isActioned = false;

  @override
  Widget build(context) {
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

    Widget getAvatar(UserApiDto user) {
      if (user.photoId != null) {
        var photoUrl = viewModel.parseImage.invoke(user.photoId!);
        return Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(photoUrl),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                StreamBuilder<DomainApiDto?>(
                    stream: viewModel.domainDto,
                    builder: (context, snapshot) {
                      if (snapshot.data == null) {
                        viewModel.getDomain();
                        return const CircularProgressIndicator();
                      } else {
                        return Text(
                          snapshot.data?.name ?? snapshot.data?.displayName ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        );
                      }
                    }),
              ],
            ),
          ],
        );
      } else {
        return Row(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage(
                'assets/images/avatar.png',
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                StreamBuilder<DomainApiDto?>(
                    stream: viewModel.domainDto,
                    builder: (context, snapshot) {
                      if (snapshot.data == null) {
                        viewModel.getDomain();
                        return const CircularProgressIndicator();
                      } else {
                        return Text(
                          snapshot.data?.name ?? snapshot.data?.displayName ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        );
                      }
                    }),
              ],
            ),
          ],
        );
      }
    }

    return StreamBuilder<UserApiDto?>(
      stream: viewModel.userDto,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          viewModel.getUser();
          return const CircularProgressIndicator();
        } else {
          return LayoutBuilder(builder: (context, constraints) {
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: constraints.maxWidth <= 960,
                toolbarHeight: 70,
                title: GestureDetector(
                  onTap: () {
                    sharedPrefs.setString('SELECTED_INDEX', jsonEncode(0));
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.of(context).pushReplacementNamed(Routes.WORKSPACE);
                    });
                  },
                  child: Tooltip(
                    message: 'Ir para início',
                    child: OnHoverButton(
                      child: Image.asset(
                        themeViewModel.logoAsset(Theme.of(context).brightness),
                        width: 70,
                        height: 70,
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                ),
                shadowColor: const Color.fromRGBO(0, 0, 0, 1),
                elevation: 8,
                actions: [
                  OnHoverButton(
                    child: IconButton(
                      style: IconButton.styleFrom(
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          isActioned = true;
                          if (isDarkMode) {
                            iconMode = Icons.dark_mode_outlined;
                            colorIconMode = Colors.white;
                            themeViewModel.changeTheme(ThemeMode.light.name);
                          } else {
                            iconMode = Icons.light_mode_outlined;
                            colorIconMode = Colors.yellow;
                            themeViewModel.changeTheme(ThemeMode.dark.name);
                          }
                        });
                      },
                      icon: Icon(
                        iconMode,
                        color: colorIconMode,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  getAvatar(snapshot.data!),
                  const SizedBox(
                    width: 20,
                  ),
                  PopUpMenuUser(
                    onSelectScreen: setScreen,
                    updateUser: () {
                      viewModel.getUser();
                    },
                  )
                ],
              ),
              drawer: MainDrawer(
                onSelectScreen: setScreen,
              ),
              body: constraints.maxWidth <= 960
                  ? Center(
                      child: widget.child,
                    )
                  : SafeArea(
                      bottom: false,
                      top: false,
                      child: Row(
                        children: <Widget>[
                          StreamBuilder<List<RouteApiDto>?>(
                            stream: viewModel.routesDto,
                            builder: (context, snapshot) {
                              if (snapshot.data == null) {
                                viewModel.getRoutes();
                                return const CircularProgressIndicator();
                              } else {
                                return MainRail(
                                  routes: snapshot.data!,
                                  onSelectScreen: setScreen,
                                );
                              }
                            },
                          ),
                          const VerticalDivider(thickness: 1, width: 1),
                          Expanded(
                            child: FractionallySizedBox(
                              widthFactor: 1,
                              heightFactor: 1,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                child: widget.child,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            );
          });
        }
      },
    );
  }
}
