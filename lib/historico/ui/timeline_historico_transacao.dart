import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_builder_main.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/historico/ui/components/timeline_tile.dart';
import 'package:viggo_pay_admin/historico/ui/timeline_historico_transacao_view_model.dart';

class TimelineTransacaoPage extends StatelessWidget {
  const TimelineTransacaoPage({
    Key? key,
    required this.changeTheme,
  }) : super(key: key);

  final void Function(ThemeMode themeMode) changeTheme;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator.get<HistoricoTransacaoViewModel>(),
      child: AppBuilderMain(
        changeTheme: changeTheme,
        child: Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 500.0),
            child: ListView(
              children: const [
                TimelineTransacaoTile(
                  isFirst: true,
                  isLast: false,
                  isPast: true,
                  iconInfo: Icons.monetization_on_outlined,
                  eventCard: Text('Transação evento 1!',
                      style: TextStyle(
                        color: Colors.white,
                      )),
                ),
                TimelineTransacaoTile(
                  isFirst: false,
                  isLast: false,
                  isPast: true,
                  iconInfo: Icons.monetization_on_outlined,
                  eventCard: Text('Transação evento 2!',
                      style: TextStyle(
                        color: Colors.white,
                      )),
                ),
                TimelineTransacaoTile(
                  isFirst: false,
                  isLast: true,
                  isPast: false,
                  iconInfo: Icons.monetization_on_outlined,
                  eventCard: Text('Transação evento 3!',
                      style: TextStyle(
                        color: Colors.white,
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
