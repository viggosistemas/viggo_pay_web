import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:viggo_core_frontend/base/base_view_model.dart';
import 'package:viggo_core_frontend/domain/data/models/domain_api_dto.dart';
import 'package:viggo_core_frontend/domain/domain/usecases/get_domain_from_settings_use_case.dart';
import 'package:viggo_core_frontend/domain/domain/usecases/set_domain_use_case.dart';
import 'package:viggo_core_frontend/domain/domain/usecases/upload_logo_use_case.dart';
import 'package:viggo_core_frontend/image/domain/usecases/parse_image_url_use_case.dart';
import 'package:viggo_core_frontend/util/list_options.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_api_dto.dart';
import 'package:viggo_pay_admin/domain_account/domain/usecases/get_config_domain_account_by_id_use_case.dart';
import 'package:viggo_pay_admin/domain_account/domain/usecases/get_domain_account_by_id_use_case.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/extrato_api_dto.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/saldo_api_dto.dart';
import 'package:viggo_pay_admin/pay_facs/domain/usecases/get_extrato_domain_account_use_case.dart';
import 'package:viggo_pay_admin/pay_facs/domain/usecases/get_saldo_domain_account_use_case.dart';
import 'package:viggo_pay_admin/pix_to_send/data/models/pix_to_send_api_dto.dart';
import 'package:viggo_pay_admin/pix_to_send/domain/usecases/get_pix_to_send_by_params_use_case.dart';

class DashboardViewModel extends BaseViewModel {
  String materaId = '';
  String domainAccountId = '';
  String domainId = '';
  Map<String, dynamic> taxaMediatorFee = {};

  //USE_CASES
  final GetDomainAccountByIdUseCase getDomainAccount;
  final GetDomainFromSettingsUseCase getDomainFromSettings;
  final GetExtratoDomainAccountUseCase getExtrato;
  final GetSaldoDomainAccountUseCase getSaldo;
  final GetPixToSendsByParamsUseCase listChavePixToSends;
  final UploadLogoDomainUseCase uploadLogo;
  final SetDomainUseCase setDomain;
  final ParseImageUrlUseCase parseImage;
  final GetDomainAccountConfigByIdUseCase getConfigDomainAccount;

  final StreamController<bool> _streamControllerSuccess = StreamController<bool>.broadcast();
  Stream<bool> get isSuccess => _streamControllerSuccess.stream;

  final StreamController<DomainAccountApiDto?> _streamMatrizController = StreamController<DomainAccountApiDto?>.broadcast();
  Stream<DomainAccountApiDto?> get matriz => _streamMatrizController.stream;

  final StreamController<List<ExtratoApiDto>> _streamExtratoController = StreamController<List<ExtratoApiDto>>.broadcast();
  Stream<List<ExtratoApiDto>> get extrato => _streamExtratoController.stream;

  final StreamController<DomainApiDto?> _streamControllerDomain = StreamController<DomainApiDto?>.broadcast();
  Stream<DomainApiDto?> get domain => _streamControllerDomain.stream;

  final StreamController<SaldoApiDto> _streamSaldoController = StreamController<SaldoApiDto>.broadcast();
  Stream<SaldoApiDto> get saldo => _streamSaldoController.stream;

  final StreamController<List<PixToSendApiDto>> _streamChavePixToSendsController = StreamController<List<PixToSendApiDto>>.broadcast();
  Stream<List<PixToSendApiDto>> get chavePixToSends => _streamChavePixToSendsController.stream;

  DashboardViewModel({
    required this.getConfigDomainAccount,
    required this.getDomainAccount,
    required this.getDomainFromSettings,
    required this.getExtrato,
    required this.getSaldo,
    required this.listChavePixToSends,
    required this.uploadLogo,
    required this.setDomain,
    required this.parseImage,
  });

  Future<DomainApiDto?> getDomain() async {
    var domainDto = getDomainFromSettings.invoke();

    if (domainDto != null) {
      domainId = domainDto.id;
      _streamControllerDomain.sink.add(domainDto);
      return domainDto;
    }
    return null;
  }

  Stream<DomainAccountApiDto?> loadDomainAccount() {
    catchEntity();
    return matriz;
  }

  Future<DomainAccountApiDto?> catchEntity() async {
    // if (isLoading) return null;

    // setLoading();

    var result = await getDomainAccount.invoke(id: domainId);

    // setLoading();
    if (result.isRight) {
      _streamMatrizController.sink.add(result.right);
      domainAccountId = result.right.id;
      if (result.right.materaId != null) materaId = result.right.materaId!;
      return result.right;
    } else if (result.isLeft) {
      postError(result.left.message);
      return null;
    }
    return null;
  }

  Future getConfigInfo(String id) async {
    if (isLoading) return;
    setLoading();

    Map<String, String> filters = {'domain_account_id': id};
    var result = await getConfigDomainAccount.invoke(filters: filters);
    setLoading();

    if (result.isRight && result.right.domainAccountTaxas.isNotEmpty) {
      var taxa = result.right.domainAccountTaxas[0].taxa;
      var isPorcentagem = result.right.domainAccountTaxas[0].porcentagem;
      taxaMediatorFee = {
        'taxa': taxa ?? 0.0,
        'porcentagem': isPorcentagem ?? false,
      };
      if (taxaMediatorFee['porcentagem']) {
        taxaMediatorFee['taxa'] = taxaMediatorFee['taxa'] / 100;
      }
    } else if (result.isLeft) {
      postError(result.left.message);
    }
  }

  Future<List<ExtratoApiDto>> loadExtrato(String materaId) async {
    // if (isLoading) return [];

    // setLoading();

    Map<String, dynamic> data = {
      'id': materaId,
      'account_id': materaId,
      'parametros': {
        'start': DateFormat('yyyy-MM-dd').format(DateTime(DateTime.now().year, DateTime.now().month, 1)),
        'ending': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      }
    };

    var result = await getExtrato.invoke(body: data);

    // setLoading();

    if (result.isLeft) {
      postError(result.left.message);
      _streamExtratoController.sink.add([]);
      return [];
    } else {
      if (!_streamExtratoController.isClosed) {
        _streamExtratoController.sink.add(result.right);
        return result.right;
      }
    }
    return [];
  }

  Future<SaldoApiDto?> loadSaldo(String materaId) async {
    if (materaId.isNotEmpty) {
      Map<String, dynamic> data = {
        'id': materaId,
        'account_id': materaId,
      };

      var result = await getSaldo.invoke(body: data);

      if (result.isLeft) {
        postError(result.left.message);
        return null;
      } else {
        if (!_streamSaldoController.isClosed) {
          _streamSaldoController.sink.add(result.right);
          return result.right;
        }
      }
    }
    return null;
  }

  Future<List<PixToSendApiDto>> loadChavePixToSends(String domainAccountId) async {
    Map<String, String> filters = {
      'order_by': 'alias',
      'list_options': ListOptions.ACTIVE_ONLY.name,
      'domain_account_id': domainAccountId,
    };
    var result = await listChavePixToSends.invoke(filters: filters);
    if (result.isRight) {
      await getConfigInfo(domainAccountId);
      _streamChavePixToSendsController.sink.add(result.right.pixToSends);
      return result.right.pixToSends;
    } else if (result.isLeft) {
      postError(result.left.message);
      return [];
    }
    return [];
  }

  void uploadPhoto(
    PlatformFile file,
    Function onError,
    Function onSuccess,
  ) async {
    if (isLoading) return;
    setLoading();

    var kb = (file.bytes!.lengthInBytes * 0.001 * 100).round() / 100; // TAMANHO EM KBYTES
    var mb = (kb * 0.001 * 100).round() / 100; // TAMANHO EM MEGABYTES
    // var gb = (mb * 0.001 * 100).round() / 100; // TAMANHO EM GYGABYTES
    if (file.extension != 'png' && file.extension != 'jpg' && file.extension != 'wbp' && file.extension != 'jpeg') {
      onError('Somente é permitidos arquivos de imagem!');
      return;
    }
    if (mb > 10) {
      onError('Só é permitido arquivos com até 10Mb de tamanho!');
      return;
    }

    var result = await uploadLogo.invoke(
      id: domainId,
      fileName: file.name,
      bytes: file.bytes!,
    );
    setLoading();
    if (result.isLeft) {
      postError(result.left.message);
    } else {
      if (!_streamControllerSuccess.isClosed) {
        DomainApiDto domainSave = getDomainFromSettings.invoke()!;
        domainSave.logoId = result.right.logoId;
        domainSave.settings = '';
        setDomain.invoke(domainSave);
        _streamControllerDomain.sink.add(domainSave);
        _streamControllerSuccess.sink.add(true);
        onSuccess('Imagem alterada com sucesso!');
      }
    }
  }

  DomainApiDto? get domainDto {
    var domainDto = getDomainFromSettings.invoke();
    if (domainDto == null) {
      return null;
    } else {
      return domainDto;
    }
  }

  Future<String?> getImageUrl(String? photoId) async {
    if (photoId != null) return await parseImage.invoke(photoId);
    return null;
  }
}
