import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_builder_view_model.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/pop_menu/ui/pop_menu_bottom_action.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/pop_menu/ui/pop_menu_items/alterar_senha/alterar_senha.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/pop_menu/ui/pop_menu_items/info_user/info_user.dart';
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

    return PopupMenuButton<SampleItem>(
      onSelected: (value) {
        setState(() {
          selectedMenu = value;
        });
      },
      initialValue: selectedMenu,
      position: PopupMenuPosition.under,
      color: Theme.of(context).cardTheme.color,
      itemBuilder: (context) => <PopupMenuEntry<SampleItem>>[
        PopupMenuItem<SampleItem>(
          value: SampleItem.itemOne,
          onTap: () async{
            var result = await InfoUserDialog(
              context: context,
            ).showFormDialog();
            if(result != null && result == true){
              widget.updateUser();
            }
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Informações do usuário'),
              Icon(
                Icons.person_outline_outlined,
                color: Colors.black,
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
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Alterar senha'),
              Icon(
                Icons.lock_outline,
                color: Colors.black,
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
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Sair'),
              Icon(
                Icons.logout_outlined,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ],
      child: PopMenuBottomAction(
        viewModel: viewModel,
      ),
    );
  }
}
