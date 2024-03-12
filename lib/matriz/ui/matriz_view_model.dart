import 'dart:async';
import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_api_dto.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_config_api_dto.dart';
import 'package:viggo_pay_admin/domain_account/domain/usecases/add_config_domain_account_use_case.dart';
import 'package:viggo_pay_admin/domain_account/domain/usecases/add_domain_account_documents_use_case.dart';
import 'package:viggo_pay_admin/domain_account/domain/usecases/get_config_domain_account_by_id_use_case.dart';
import 'package:viggo_pay_admin/domain_account/domain/usecases/get_domain_account_by_id_use_case.dart';
import 'package:viggo_pay_admin/domain_account/domain/usecases/update_config_domain_account_use_case.dart';
import 'package:viggo_pay_admin/domain_account/domain/usecases/update_domain_account_use_case.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_info/edit-info-empresa/edit-info-form/edit_info_form_fields.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_info/edit-info-endereco/edit-endereco-form/edit_endereco_form_fields.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_info/edit-taxa-empresa/edit-taxa-form/edit_taxa_form_fields.dart';
import 'package:viggo_pay_core_frontend/domain/data/models/domain_api_dto.dart';
import 'package:viggo_pay_core_frontend/domain/domain/usecases/get_domain_from_settings_use_case.dart';
import 'package:viggo_pay_core_frontend/localidades/data/models/address_via_cep_dto.dart';
import 'package:viggo_pay_core_frontend/localidades/domain/usecases/get_municipio_by_params_use_case.dart';
import 'package:viggo_pay_core_frontend/localidades/domain/usecases/search_cep_use_case.dart';
import 'package:viggo_pay_core_frontend/network/network_exceptions.dart';

class MatrizViewModel extends ChangeNotifier
    with RegisterDomainAccountDocumentsTransformer {
  bool isLoading = false;

  late DomainAccountApiDto matrizAccount;
  late DomainAccountConfigApiDto matrizAccountTaxa;
  late String estadoAddress = '';

  final UpdateDomainAccountUseCase updateDomainAccount;
  final UpdateConfigDomainAccountUseCase updateConfigAccount;
  final AddConfigDomainAccountUseCase createConfigAccount;
  final GetDomainAccountByIdUseCase getDomainAccount;
  final GetDomainFromSettingsUseCase getDomainFromSettings;
  final GetDomainAccountConfigByIdUseCase getDomainAccountTaxa;
  final SearchCepUseCase searchCep;
  final GetMunicipioByParamsUseCase getMunicipio;
  final AddDomainAccountDocumentsUseCase addDomainAccountDocuments;

  final EditInfoFormFields form = EditInfoFormFields();
  final EditInfoEnderecoFormFields formAddress = EditInfoEnderecoFormFields();
  final ConfigMatrizTaxaFormFields formConfig = ConfigMatrizTaxaFormFields();

  final StreamController<String> _streamControllerError =
      StreamController<String>.broadcast();
  Stream<String> get isError => _streamControllerError.stream;

  final StreamController<bool> _streamControllerSuccess =
      StreamController<bool>.broadcast();
  Stream<bool> get isSuccess => _streamControllerSuccess.stream;

  final StreamController<DomainAccountApiDto> _streamMatrizController =
      StreamController<DomainAccountApiDto>.broadcast();
  Stream<DomainAccountApiDto> get matriz => _streamMatrizController.stream;

  final StreamController<DomainAccountConfigApiDto>
      _streamMatrizTaxaController =
      StreamController<DomainAccountConfigApiDto>.broadcast();
  Stream<DomainAccountConfigApiDto> get matrizTaxa =>
      _streamMatrizTaxaController.stream;

  MatrizViewModel({
    required this.updateDomainAccount,
    required this.createConfigAccount,
    required this.updateConfigAccount,
    required this.getDomainAccount,
    required this.getDomainAccountTaxa,
    required this.getDomainFromSettings,
    required this.searchCep,
    required this.getMunicipio,
    required this.addDomainAccountDocuments,
  }) {
    getEntities();
  }

  getEntities() {
    catchEntity().then((value) {
      matrizAccount = value!;
      getConfigInfo(value.id).then((config) {
        matrizAccountTaxa = config!;
        initialFormValues();
      });
    });
  }

  initialFormValues() {
    form.onClientTaxIdChange(matrizAccount.clientTaxIdentifierTaxId);
    form.onClientTaxCountryChange(
        matrizAccount.clientTaxIdentifierCountry ?? '');
    form.onClientNameChange(matrizAccount.clientName);
    form.onClientMobilePhoneChange(matrizAccount.clientMobilePhone);
    form.onClientMobilePhoneCountryChange(
        matrizAccount.clientMobilePhoneCountry);
    form.onClientEmailChange(matrizAccount.clientEmail);

    formAddress.onLogradouroChange(matrizAccount.billingAddressLogradouro);
    formAddress.onNumeroChange(matrizAccount.billingAddressNumero);
    formAddress.onComplementoChange(matrizAccount.billingAddressComplemento);
    formAddress.onBairroChange(matrizAccount.billingAddressBairro);
    formAddress.onCidadeChange(matrizAccount.billingAddressCidade);
    formAddress.onEstadoChange(matrizAccount.billingAddressEstado);
    formAddress.onCepChange(matrizAccount.billingAddressCep);
    formAddress.onPaisChange(matrizAccount.billingAddressPais);

    formConfig.onTaxaChange(matrizAccountTaxa.taxa.toString());
    formConfig.onPorcentagemChange(
      matrizAccountTaxa.porcentagem.toString().parseBool(),
    );
  }

  void notifyLoading() {
    isLoading = !isLoading;
    // notifyListeners();
  }

  Future<DomainAccountApiDto?> catchEntity() async {
    var result =
        await getDomainAccount.invoke(id: getDomainFromSettings.invoke()!.id);

    if (result.isRight) {
      _streamMatrizController.sink.add(result.right);
      estadoAddress = result.right.billingAddressEstado;
      return result.right;
    } else if (result.isLeft && !_streamControllerError.isClosed) {
      _streamControllerError.sink.add(result.left.message);
    }
    return null;
  }

  Future<DomainAccountConfigApiDto?> getConfigInfo(String id) async {
    Map<String, String> filters = {'domain_account_id': id};
    var result = await getDomainAccountTaxa.invoke(filters: filters);
    if (result.isRight && result.right.domainAccountTaxas.isNotEmpty) {
      _streamMatrizTaxaController.sink.add(result.right.domainAccountTaxas[0]);
      return result.right.domainAccountTaxas[0];
    } else if (result.isLeft && !_streamControllerError.isClosed) {
      _streamControllerError.sink.add(result.left.message);
    }
    return null;
  }

  void submit(
    Function showMsg,
    BuildContext context,
  ) async {
    notifyLoading();
    var formFields = form.getFields();
    var formAddressFields = formAddress.getFields();

    Map<String, dynamic> data = {
      'id': matrizAccount.id,
      'client_name': formFields!['client_name'],
      'client_mobile_phone_phone_number': formFields['client_mobile_phone'],
      'client_mobile_phone_country': formFields['client_mobile_phone_country'],
      'client_email': formFields['client_email'],
      'billing_address_logradouro':
          formAddressFields!['billing_address_logradouro'],
      'billing_address_numero': formAddressFields['billing_address_numero'],
      'billing_address_complemento':
          formAddressFields['billing_address_complemento'],
      'billing_address_bairro': formAddressFields['billing_address_bairro'],
      'billing_address_cidade': formAddressFields['billing_address_cidade'],
      'billing_address_estado': formAddressFields['billing_address_estado'],
      'billing_address_cep': formAddressFields['billing_address_cep'],
      'billing_address_pais':
          formAddressFields['billing_address_pais'] ?? 'BRA',
    };

    var result =
        await updateDomainAccount.invoke(id: matrizAccount.id, body: data);
    if (result.isLeft) {
      if (!_streamControllerError.isClosed) {
        _streamControllerError.sink.add(result.left.message);
        notifyLoading();
      }
    } else {
      if (!_streamControllerSuccess.isClosed) {
        _streamControllerSuccess.sink.add(true);
        notifyLoading();
      }
    }
  }

  void submitConfig(
    Function showMsg,
    BuildContext context,
  ) async {
    notifyLoading();
    dynamic result;
    var form = formConfig.getFields();
    var taxa = form!['taxa'] ?? matrizAccountTaxa.taxa;

    Map<String, dynamic> data = matrizAccountTaxa.id.isNotEmpty
        ? {
            'id': matrizAccountTaxa.id,
            "domain_account_id": matrizAccountTaxa.domainAccountId,
            "taxa": double.parse(taxa.toString()),
            "porcentagem": false, //form['porcentagem'].toString().parseBool(),
          }
        : {
            "domain_account_id": matrizAccountTaxa.domainAccountId,
            "taxa": double.parse(taxa.toString()),
            "porcentagem": false, //form['porcentagem'].toString().parseBool(),
          };

    if (matrizAccountTaxa.id.isNotEmpty) {
      result = await updateConfigAccount.invoke(
        id: matrizAccountTaxa.id,
        body: data,
      );
    } else {
      result = await createConfigAccount.invoke(body: data);
    }

    if (result.isLeft) {
      if (!_streamControllerError.isClosed) {
        _streamControllerError.sink.add(result.left.message);
        notifyLoading();
      }
    } else {
      if (!_streamControllerSuccess.isClosed) {
        // _streamControllerSuccess.sink.add(true);
        notifyLoading();
      }
    }
  }

  void searchViaCep(String cep) async {
    var result = await searchCep.invoke(cep: cep);

    if (result.isRight) {
      getMunicipioViaCep(result.right);
    } else if (result.isLeft && !_streamControllerError.isClosed) {
      _streamControllerError.sink.add(result.left.message);
    }
  }

  getMunicipioViaCep(AddressApiDto addressViaCep) async {
    var result = await getMunicipio.invoke(
      filters: {
        'codigo_ibge': addressViaCep.ibge,
      },
    );

    if (result.isRight) {
      formAddress.onEstadoChange(result.right.municipios[0].siglaUf);
      estadoAddress = result.right.municipios[0].siglaUf;
      formAddress.onCidadeChange(result.right.municipios[0].nome);
    } else if (result.isLeft && !_streamControllerError.isClosed) {
      _streamControllerError.sink.add(result.left.message);
    }
  }

  // DOCUMENTOS

  final _fileList = BehaviorSubject<List<Map<String, dynamic>>>();
  Stream<List<Map<String, dynamic>>> get fileList => _fileList.stream;
  Stream<int> get fileListSize => _fileList.stream.transform(fileListMaxFiles);

  Future<void> onLoadDomainAccount(Function onError) async {
    var domain = getDomainFromSettings.invoke();

    if (domain == null) {
      onError('Domínio não encontrado');
      return;
    }

    var result = await getDomainAccount.invoke(id: domain.id);
    if (result.isLeft) {
      if (result.left is! NotFound) onError(result.left.message);
      return;
    }

    _fileList.sink.add(result.right.documents.map((e) => e.toJson()).toList());
  }

  Future<void> onSelectedFile(PlatformFile file, Function onError) async {
    var kb = (file.bytes!.lengthInBytes * 0.001 * 100).round() / 100; // TAMANHO EM KBYTES
    var mb = (kb * 0.001 * 100).round() / 100; // TAMANHO EM MEGABYTES
    // var gb = (mb * 0.001 * 100).round() / 100; // TAMANHO EM GYGABYTES
    if (file.extension != 'pdf') {
      onError('Somente é permitidos arquivos em PDF!');
      return;
    }
    if (mb > 10) {
      onError('Só é permitido arquivos com até 10Mb de tamanho!');
      return;
    }
    List<Map<String, dynamic>> currentList = _fileList.valueOrNull ?? [];
    // if (file.path != null) {
    //   Uint8List? bytes = await _readFileByte(file.path!);
    if (file.bytes != null) {
      currentList.add({
        'content': base64.encode(file.bytes!),
        'tipo': 'UNKNOWN',
        'title': file.name,
      });
    }
    // }
    _fileList.sink.add(currentList);
  }

  void onRemoveItem(Map<String, dynamic> file) {
    List<Map<String, dynamic>> currentList = _fileList.valueOrNull ?? [];
    if (currentList.contains(file)) {
      currentList.remove(file);
      _fileList.sink.add(currentList);
    }
  }

  Future<List<Map<String, dynamic>>?> _getFileList() async {
    return _fileList.valueOrNull;
  }

  Future<void> onSendFiles(
    Function showMsg,
    BuildContext context,
  ) async {
    List<Map<String, dynamic>> itens = await _getFileList() ?? [];
    DomainApiDto? domain = getDomainFromSettings.invoke();
    if (itens.isEmpty) {
      _streamControllerError.sink.add('Erro ao enviar documentos');
      return;
    }
    if (domain == null) {
      _streamControllerError.sink.add('Erro ao enviar documentos');
      return;
    }

    var result =
        await addDomainAccountDocuments.invoke(domain.id, {'documents': itens});
    if (result.isLeft) {
      _streamControllerError.sink.add(result.left.message);
      return;
    }
  }
}

extension BoolParsing on String {
  bool parseBool() {
    return toLowerCase() == 'true';
  }
}

mixin RegisterDomainAccountDocumentsTransformer {
  final fileListMaxFiles =
      StreamTransformer<List<Map<String, dynamic>>, int>.fromHandlers(
    handleData: (value, sink) {
      sink.add(value.length);
    },
  );
}

// Future<Uint8List?> _readFileByte(String filePath) async {
//   Uri myUri = Uri.parse(filePath);
//   File audioFile = File.fromUri(myUri);
//   Uint8List? bytes;
//   await audioFile.readAsBytes().then((value) {
//     bytes = Uint8List.fromList(value);
//   });
//   return bytes;
// }
