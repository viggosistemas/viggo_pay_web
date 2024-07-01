import 'dart:typed_data';

import 'package:either_dart/either.dart';
import 'package:viggo_core_frontend/network/network_exceptions.dart';
import 'package:viggo_core_frontend/network/no_content_response.dart';
import 'package:viggo_core_frontend/util/list_options.dart';
import 'package:viggo_pay_admin/domain_account/data/domain_account_data_source.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_api_dto.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_dto_pagination.dart';
import 'package:viggo_pay_admin/domain_account/domain/domain_account_repository.dart';

class DomainAccountRepositoryImpl implements DomainAccountRepository {
  final DomainAccountRemoteDataSource remoteDataSource;

  DomainAccountRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<NetworkException, DomainAccountDtoPagination>> getEntitiesByParams({
    Map<String, String> filters = const {},
    ListOptions? listOptions,
    String? include,
  }) =>
      remoteDataSource.getEntitiesByParams(
        filters: filters,
        listOptions: listOptions,
        include: include,
      );

  @override
  Future<Either<NetworkException, DomainAccountApiDto>> getEntityById({
    required String id,
    String? include,
  }) =>
      remoteDataSource.getEntityById(id: id, include: include);

  @override
  Future<Either<NetworkException, DomainAccountApiDto>> updateEntity({
    required String id,
    required Map<String, dynamic> body,
  }) =>
      remoteDataSource.updateEntity(id: id, body: body);

  @override
  Future<Either<NetworkException, NoContentApiDto>> updatePasswordPix({
    required String id,
    required Map<String, dynamic> body,
  }) =>
      remoteDataSource.updatePasswordPix(id: id, body: body);

  @override
  Future<Either<NetworkException, DomainAccountApiDto>> addDocuments(
    String id,
    Map<String, dynamic> body,
  ) =>
      remoteDataSource.addDocuments(id: id, body: body);

  @override
  Future<Either<NetworkException, Uint8List>> extratoPDF({
    required String id,
    required String de,
    required String ate,
  }) =>
      remoteDataSource.extratoPDF(id: id, de: de, ate: ate);

  @override
  Future<Either<NetworkException, NoContentApiDto>> resetarNumTentativas({
    required String id,
    required Map<String, dynamic> body,
  }) =>
      remoteDataSource.resetarNumTentativas(id: id, body: body);
}
