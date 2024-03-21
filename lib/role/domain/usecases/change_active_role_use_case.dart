import 'package:viggo_core_frontend/role/domain/role_repository.dart';

class ChangeActiveRoleUseCase {
  final RoleRepository repository;

  ChangeActiveRoleUseCase({required this.repository});

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
