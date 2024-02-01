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

class AppBarPrivate extends StatelessWidget implements PreferredSizeWidget {
  const AppBarPrivate({super.key});

  @override
  Widget build(context) {
    return AppBar(
      toolbarHeight: 70,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10,),
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
      ),
      shadowColor: Colors.black,
      elevation: 8,
    );
  }

  @override
  Size get preferredSize => _PreferredAppBarSize(75, 20);
}
