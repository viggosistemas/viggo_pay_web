import 'package:either_dart/either.dart';
import 'package:viggo_pay_admin/pay_facs/domain/pay_facs_repository.dart';
import 'package:viggo_pay_core_frontend/network/network_exceptions.dart';

class CashoutViaPixDomainAccountUseCase {
  final PayFacsRepository repository;

  CashoutViaPixDomainAccountUseCase({required this.repository});

  Future<Either<NetworkException, dynamic>> invoke({
    required Map<String, dynamic> body,
  }) =>
      repository.cashoutViaPix(body: body);
}