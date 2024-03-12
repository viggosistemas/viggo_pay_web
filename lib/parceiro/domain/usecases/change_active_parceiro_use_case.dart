
import 'package:viggo_pay_admin/parceiro/domain/parceiro_repository.dart';

class ChangeActiveParceiroUseCase {
  final ParceiroRepository repository;

  ChangeActiveParceiroUseCase({required this.repository});

  bool invoke({
    required List<Map<String, dynamic>> entities,
  }) {
    var count = 0;
    for (var element in entities) {
      repository.updateEntity(id: element['id'], body: element['body']);
      count++;
    }
    return count == entities.length;
  }
}
