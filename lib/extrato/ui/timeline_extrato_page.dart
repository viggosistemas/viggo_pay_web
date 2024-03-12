import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_builder_main.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_api_dto.dart';
import 'package:viggo_pay_admin/extrato/ui/extrato_timeline/extrato_timeline.dart';
import 'package:viggo_pay_admin/extrato/ui/timeline_extrato_view_model.dart';

class TimelineExtratoPage extends StatelessWidget {
  const TimelineExtratoPage({
    Key? key,
    required this.changeTheme,
  }) : super(key: key);

  final void Function(ThemeMode themeMode) changeTheme;

  @override
  Widget build(BuildContext context) {
    TimelineExtratoViewModel viewModel = locator.get<TimelineExtratoViewModel>();

    return ChangeNotifierProvider(
      create: (_) => locator.get<TimelineExtratoViewModel>(),
      child: AppBuilderMain(
        changeTheme: changeTheme,
        child: StreamBuilder<DomainAccountApiDto?>(
            stream: viewModel.matriz,
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                viewModel.catchEntity();
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    StreamBuilder<List<dynamic>>(
                      stream: viewModel.extrato,
                      builder: (context, extrato) {
                        if (extrato.data == null) {
                          viewModel.loadExtrato(snapshot.data!.materaId!);
                          return const CircularProgressIndicator();
                        } else {
                          return Expanded(
                            child: TimelineExtrato(
                              listExtrato: extrato.data!,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                );
              }
            }),
      ),
    );
  }
}
