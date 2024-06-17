import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_builder_view_model.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/pop_menu/ui/pop_menu_items/alterar_senha/alterar_senha.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/pop_menu/ui/pop_menu_items/info_user/info_user.dart';
import 'package:viggo_pay_admin/components/hover_button.dart';
import 'package:viggo_pay_admin/di/locator.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

class PopUpMenuUser extends StatefulWidget {
  const PopUpMenuUser({
    super.key,
    required this.onSelectScreen,
    required this.updateUser,
  });

  final void Function(String identifier) onSelectScreen;
  final Function updateUser;

  @override
  State<PopUpMenuUser> createState() {
    return _PopMenuActionUser();
  }
}

class _PopMenuActionUser extends State<PopUpMenuUser> {
  SampleItem? selectedMenu;
  final viewModel = locator.get<AppBuilderViewModel>();

  @override
  Widget build(context) {
    return OnHoverButton(
      child: PopupMenuButton<SampleItem>(
        onSelected: (value) {
          setState(() {
            selectedMenu = value;
          });
        },
        initialValue: selectedMenu,
        position: PopupMenuPosition.under,
        itemBuilder: (context) => <PopupMenuEntry<SampleItem>>[
          PopupMenuItem<SampleItem>(
            value: SampleItem.itemOne,
            onTap: () async {
              var result = await InfoUserDialog(
                context: context,
              ).showFormDialog();
              if (result != null && result == true) {
                widget.updateUser();
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Informações do usuário'),
                Icon(
                  Icons.person_outline_outlined,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ],
            ),
          ),
          //
          PopupMenuItem<SampleItem>(
            value: SampleItem.itemTwo,
            onTap: () {
              AlterarSenha(
                context: context,
              ).showFormDialog();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Alterar senha'),
                Icon(
                  Icons.lock_outline,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ],
            ),
          ),
          //
          PopupMenuItem<SampleItem>(
            value: SampleItem.itemThree,
            onTap: () {
              viewModel.onLogout(widget.onSelectScreen);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Sair'),
                Icon(
                  Icons.logout_outlined,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ],
            ),
          ),
        ],
        icon: const Icon(
          Icons.arrow_drop_down,
          color: Colors.white,
        ),
      ),
    );
  }
}
