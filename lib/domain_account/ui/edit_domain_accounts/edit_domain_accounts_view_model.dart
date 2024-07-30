import 'dart:async';
import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:viggo_core_frontend/base/base_view_model.dart';
import 'package:viggo_core_frontend/localidades/data/models/address_via_cep_dto.dart';
import 'package:viggo_core_frontend/localidades/domain/usecases/get_municipio_by_params_use_case.dart';
import 'package:viggo_core_frontend/localidades/domain/usecases/search_cep_use_case.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_api_dto.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_config_api_dto.dart';
import 'package:viggo_pay_admin/domain_account/domain/usecases/add_config_domain_account_use_case.dart';
import 'package:viggo_pay_admin/domain_account/domain/usecases/add_domain_account_documents_use_case.dart';
import 'package:viggo_pay_admin/domain_account/domain/usecases/update_config_domain_account_use_case.dart';
import 'package:viggo_pay_admin/domain_account/domain/usecases/update_domain_account_use_case.dart';
import 'package:viggo_pay_admin/domain_account/ui/edit_domain_accounts/config_domain_accounts/config_domain_accounts_form_fields.dart';
import 'package:viggo_pay_admin/domain_account/ui/edit_domain_accounts/domain_accounts_stepper/edit_domain_account_address/edit_form_fields.dart';
import 'package:viggo_pay_admin/domain_account/ui/edit_domain_accounts/domain_accounts_stepper/edit_domain_account_info/edit_form_fields.dart';

class EditDomainAccountViewModel extends BaseViewModel with RegisterDomainAccountDocumentsTransformer {
  late String estadoAddress = '';

  final UpdateDomainAccountUseCase updateDomainAccount;
  final UpdateConfigDomainAccountUseCase updateConfigAccount;
  final AddConfigDomainAccountUseCase createConfigAccount;
  final SearchCepUseCase searchCep;
  final GetMunicipioByParamsUseCase getMunicipio;
  final AddDomainAccountDocumentsUseCase addDomainAccountDocuments;

  final EditInfoFormFields form = EditInfoFormFields();
  final EditAddressFormFields formAddress = EditAddressFormFields();

  final ConfigDomainAccountFormFields formConfig = ConfigDomainAccountFormFields();

  final StreamController<bool> _streamControllerSuccess = StreamController<bool>.broadcast();
  Stream<bool> get isSuccess => _streamControllerSuccess.stream;

  EditDomainAccountViewModel({
    required this.updateDomainAccount,
    required this.createConfigAccount,
    required this.updateConfigAccount,
    required this.searchCep,
    required this.getMunicipio,
    required this.addDomainAccountDocuments,
  });

  void submit(
    String? id,
    Function showMsg,
    BuildContext context,
  ) async {
    if (isLoading) return;

    setLoading();
    var formFields = form.getValues();

    Map<String, dynamic> data = {'id': id, 'client_name': formFields!['client_name']};

    var result = await updateDomainAccount.invoke(id: id!, body: data);
    setLoading();

    if (result.isLeft) {
      postError(result.left.message);
    } else {
      if (!_streamControllerSuccess.isClosed) {
        _streamControllerSuccess.sink.add(true);
      }
    }
  }

  void submitConfig(
    DomainAccountConfigApiDto entity,
    Function showMsg,
    BuildContext context,
  ) async {
    if (isLoading) return;

    setLoading();
    dynamic result;
    var form = formConfig.getValues();
    //TODO: ATE O MOMENTO DIA 25/04/2024 A PARTE DE PORCENTAGEM NAO ESTA HABILITADA
    var taxa = form!['taxa'] ?? entity.taxa;

    Map<String, dynamic> data = entity.id.isNotEmpty
        ? {
            'id': entity.id,
            "domain_account_id": entity.domainAccountId,
            "taxa": double.parse(taxa.toString()),
            "porcentagem": false //form['porcentagem'].toString().parseBool(),
          }
        : {
            "domain_account_id": entity.domainAccountId,
            "taxa": double.parse(taxa.toString()),
            "porcentagem": false //form['porcentagem'].toString().parseBool(),
          };

    if (entity.id.isNotEmpty) {
      result = await updateConfigAccount.invoke(
        id: entity.id,
        body: data,
      );
    } else {
      result = await createConfigAccount.invoke(body: data);
    }

    setLoading();
    if (result.isLeft) {
      postError(result.left.message);
    } else {
      if (!_streamControllerSuccess.isClosed) {
        _streamControllerSuccess.sink.add(true);
      }
    }
  }

  void searchViaCep(String cep) async {
    var result = await searchCep.invoke(cep: cep);

    if (result.isRight) {
      getMunicipioViaCep(result.right);
    } else if (result.isLeft) {
      postError(result.left.message);
    }
  }

  getMunicipioViaCep(AddressApiDto addressViaCep) async {
    var result = await getMunicipio.invoke(
      filters: {
        'codigo_ibge': addressViaCep.ibge,
      },
    );

    if (result.isRight) {
      formAddress.estado.onValueChange(result.right.municipios[0].siglaUf);
      estadoAddress = result.right.municipios[0].siglaUf;
      formAddress.cidade.onValueChange(result.right.municipios[0].nome);
    } else if (result.isLeft) {
      postError(result.left.message);
    }
  }

  // DOCUMENTOS

  final _fileList = BehaviorSubject<List<Map<String, dynamic>>>();
  Stream<List<Map<String, dynamic>>> get fileList => _fileList.stream;
  Stream<int> get fileListSize => _fileList.stream.transform(fileListMaxFiles);

  Future<void> onLoadDomainAccount(Function onError, DomainAccountApiDto? domainAccount) async {
    _fileList.sink.add(domainAccount?.documents.map((e) => e.toJson()).toList() ?? []);
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
    String domainAccountId,
  ) async {
    List<Map<String, dynamic>> itens = await _getFileList() ?? [];
    if (itens.isEmpty) {
      postError('Erro ao enviar documentos');
      return;
    }

    var result = await addDomainAccountDocuments.invoke(domainAccountId, {'documents': itens});
    if (result.isLeft) {
      postError(result.left.message);
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
  final fileListMaxFiles = StreamTransformer<List<Map<String, dynamic>>, int>.fromHandlers(
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
