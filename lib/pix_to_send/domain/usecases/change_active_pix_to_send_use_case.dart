import 'package:viggo_pay_admin/pix_to_send/domain/pix_to_send_repository.dart';

class ChangeActivePixToSendUseCase {
  final PixToSendRepository repository;

  ChangeActivePixToSendUseCase({required this.repository});

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
