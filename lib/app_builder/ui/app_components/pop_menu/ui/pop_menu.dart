import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_builder_view_model.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/pop_menu/ui/pop_menu_bottom_action.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/pop_menu/ui/pop_menu_items/alterar_senha.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/pop_menu/ui/pop_menu_items/info_user/info_user.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

class PopUpMenuUser extends StatefulWidget {
  const PopUpMenuUser({
    super.key,
    required this.onSelectScreen,
  });

  final void Function(String identifier) onSelectScreen;

  @override
  State<PopUpMenuUser> createState() {
    return _PopMenuActionUser();
  }
}

class _PopMenuActionUser extends State<PopUpMenuUser> {
  SampleItem? selectedMenu;

  @override
  Widget build(context) {
    final viewModel = Provider.of<AppBuilderViewModel>(context);

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
          onTap: () {
            InfoUserDialog(
              context: context,
            ).showFormDialog();
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
          value: SampleItem.itemOne,
          onTap: () {
            AlterarSenhaDialog(
              context: context,
            ).showFormDialog('alterar senha');
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
          value: SampleItem.itemOne,
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
