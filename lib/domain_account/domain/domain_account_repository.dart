import 'dart:typed_data';

import 'package:either_dart/either.dart';
import 'package:viggo_core_frontend/network/network_exceptions.dart';
import 'package:viggo_core_frontend/network/no_content_response.dart';
import 'package:viggo_core_frontend/util/list_options.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_api_dto.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_dto_pagination.dart';

abstract class DomainAccountRepository {

  Future<Either<NetworkException, DomainAccountApiDto>> getEntityById({
    required String id,
    String? include,
  });

  Future<Either<NetworkException, DomainAccountDtoPagination>> getEntitiesByParams({
    Map<String, String> filters = const {},
    ListOptions? listOptions,
    String? include,
  });

  Future<Either<NetworkException, DomainAccountApiDto>> updateEntity({
    required String id,
    required Map<String, dynamic> body,
  });

  Future<Either<NetworkException, NoContentApiDto>> updatePasswordPix({
    required String id,
    required Map<String, dynamic> body,
  });
  
  Future<Either<NetworkException, DomainAccountApiDto>> addDocuments(
    String id,
    Map<String, dynamic> body,
  );

  Future<Either<NetworkException, Uint8List>> extratoPDF({
    required String id,
    required String de,
    required String ate,
  });

  Future<Either<NetworkException, NoContentApiDto>> resetarNumTentativas({
    required String id,
    required Map<String, dynamic> body,
  });
}
