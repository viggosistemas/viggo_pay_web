import 'package:viggo_pay_core_frontend/application/domain/application_repository.dart';

class ChangeActiveApplicationUseCase {
  final ApplicationRepository repository;

  ChangeActiveApplicationUseCase({required this.repository});

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
