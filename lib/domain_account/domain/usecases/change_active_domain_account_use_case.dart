import 'package:viggo_pay_admin/domain_account/domain/domain_account_repository.dart';

class ChangeActiveDomainAccountUseCase {
  final DomainAccountRepository repository;

  ChangeActiveDomainAccountUseCase({required this.repository});

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
