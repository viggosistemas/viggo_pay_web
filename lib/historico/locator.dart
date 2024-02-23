import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/historico/ui/timeline_historico_transacao_view_model.dart';

class HistoricoTransacaoLocator {
  void setup() {
    // viewModel
    locator.registerFactory(
      () => HistoricoTransacaoViewModel(),
    );
  }
}