import 'dart:typed_data';

import 'package:either_dart/either.dart';
import 'package:viggo_core_frontend/network/network_exceptions.dart';
import 'package:viggo_pay_admin/domain_account/domain/domain_account_repository.dart';

class GetExtratoPdfDomainAccountUseCase {
  final DomainAccountRepository repository;

  GetExtratoPdfDomainAccountUseCase({required this.repository});

  Future<Either<NetworkException, Uint8List>> invoke({
    required String id,
    required String de,
    required String ate,
  }) =>
      repository.extratoPDF(id: id, de: de, ate: ate);
}
