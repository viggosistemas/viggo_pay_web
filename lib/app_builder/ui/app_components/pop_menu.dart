import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_builder_view_model.dart';
import 'package:viggo_pay_core_frontend/domain/data/models/domain_api_dto.dart';
import 'package:viggo_pay_core_frontend/user/data/models/user_api_dto.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

class PopMenuActionsUser extends StatefulWidget {
  const PopMenuActionsUser({
    super.key,
    required this.onSelectScreen,
  });

  final void Function(String identifier) onSelectScreen;

  @override
  State<PopMenuActionsUser> createState() {
    return _PopMenuActionUser();
  }
}

class _PopMenuActionUser extends State<PopMenuActionsUser> {
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
        const PopupMenuItem<SampleItem>(
          value: SampleItem.itemOne,
          child: Row(
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
        const PopupMenuItem<SampleItem>(
          value: SampleItem.itemOne,
          child: Row(
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
      child: Expanded(
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamBuilder<UserApiDto?>(
                    stream: viewModel.userDto,
                    builder: (context, snapshot) {
                      if (snapshot.data == null) viewModel.getUser();
                      return Text(
                        snapshot.data?.name ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      );
                    }),
                StreamBuilder<DomainApiDto?>(
                    stream: viewModel.domainDto,
                    builder: (context, snapshot) {
                      if (snapshot.data == null) viewModel.getDomain();
                      return Text(
                        snapshot.data?.name ?? snapshot.data?.displayName ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      );
                    }),
              ],
            ),
            const SizedBox(
              width: 10,
            ),
            const Icon(
              Icons.arrow_drop_down,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
