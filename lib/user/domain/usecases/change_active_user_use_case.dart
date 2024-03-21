import 'package:viggo_core_frontend/user/domain/user_repository.dart';

class ChangeActiveUserUseCase {
  final UserRepository repository;

  ChangeActiveUserUseCase({required this.repository});

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
