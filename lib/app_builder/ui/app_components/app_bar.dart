import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:viggo_pay_admin/utils/constants.dart';

class _PreferredAppBarSize extends Size {
  _PreferredAppBarSize(this.toolbarHeight, this.bottomHeight)
      : super.fromHeight(
            (toolbarHeight ?? kToolbarHeight) + (bottomHeight ?? 0));

  final double? toolbarHeight;
  final double? bottomHeight;
}

// ignore: must_be_immutable
class AppBarPrivate extends StatelessWidget implements PreferredSizeWidget {
  AppBarPrivate({
    super.key,
    titleWidget,
    this.toolbarHeight = 75,
    this.bottomHeight = 20,
    this.actions = const [],
  }) : titleWidget = titleWidget ??
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/icone.png',
                  width: 40,
                  height: 40,
                ),
                Text(
                  Constants.APP_NAME,
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            );

  final Widget titleWidget;

  double toolbarHeight;
  double bottomHeight;
  List<Widget> actions = [];

  @override
  Widget build(context) {
    return AppBar(
      automaticallyImplyLeading:
          false, // remove o botao de voltar que sempre é setado
      toolbarHeight: 70,
      title: titleWidget,
      shadowColor: Colors.black,
      elevation: 8,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => _PreferredAppBarSize(toolbarHeight, bottomHeight);
}
