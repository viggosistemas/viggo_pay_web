import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viggo_core_frontend/base/base_view_model.dart';
import 'package:viggo_core_frontend/domain/data/models/domain_api_dto.dart';
import 'package:viggo_core_frontend/localidades/data/models/address_via_cep_dto.dart';
import 'package:viggo_core_frontend/localidades/domain/usecases/get_municipio_by_params_use_case.dart';
import 'package:viggo_core_frontend/localidades/domain/usecases/search_cep_use_case.dart';
import 'package:viggo_core_frontend/user/domain/usecases/get_users_disponiveis_use_case.dart';
import 'package:viggo_core_frontend/util/constants.dart';
import 'package:viggo_core_frontend/util/list_options.dart';
import 'package:viggo_pay_admin/funcionario/domain/usecases/create_funcionario_use_case.dart';
import 'package:viggo_pay_admin/funcionario/domain/usecases/get_funcionario_by_id_use_case.dart';
import 'package:viggo_pay_admin/funcionario/domain/usecases/update_funcionario_use_case.dart';
import 'package:viggo_pay_admin/funcionario/ui/edit_funcionario/edit_funcionario_stepper/edit_contato_form/edit_contato_form_fields.dart';
import 'package:viggo_pay_admin/funcionario/ui/edit_funcionario/edit_funcionario_stepper/edit_endereco_form/edit_endereco_form_fields.dart';
import 'package:viggo_pay_admin/funcionario/ui/edit_funcionario/edit_funcionario_stepper/edit_funcionario_form/edit_funcionario_form_fields.dart';
import 'package:viggo_pay_admin/parceiro/domain/usecases/create_parceiro_use_case.dart';
import 'package:viggo_pay_admin/parceiro/domain/usecases/get_parceiro_by_params_use_case.dart';
import 'package:viggo_pay_admin/parceiro/domain/usecases/update_parceiro_use_case.dart';

class EditFuncionarioViewModel extends BaseViewModel {
  final SharedPreferences sharedPrefs;
  final UpdateFuncionarioUseCase updateFuncionario;
  final CreateFuncionarioUseCase createFuncionario;
  final UpdateParceiroUseCase updateParceiro;
  final CreateParceiroUseCase createParceiro;
  final GetUsersDisponiveisUseCase getUsers;
  final SearchCepUseCase searchCep;
  final GetMunicipioByParamsUseCase getMunicipio;
  final GetParceiroByParamsUseCase getParceiro;
  final GetFuncionarioByIdUseCase getFuncionario;

  final EditFuncionarioFormFields formDados = EditFuncionarioFormFields();
  final EditEnderecoFormFields formEndereco = EditEnderecoFormFields();
  final EditContatoFormFields formContato = EditContatoFormFields();

  final StreamController<bool> _streamControllerSuccess =
      StreamController<bool>.broadcast();
  Stream<bool> get isSuccess => _streamControllerSuccess.stream;

  EditFuncionarioViewModel({
    required this.sharedPrefs,
    required this.updateFuncionario,
    required this.createFuncionario,
    required this.updateParceiro,
    required this.createParceiro,
    required this.getParceiro,
    required this.getUsers,
    required this.searchCep,
    required this.getMunicipio,
    required this.getFuncionario,
  });

  Future loadUsers(Map<String, String> filters) async {
    if (isLoading) return;
    setLoading();

    String? domainJson = sharedPrefs.getString(CoreUserPreferences.DOMAIN);
    DomainApiDto domain = DomainApiDto.fromJson(jsonDecode(domainJson!));

    filters.addEntries(
      <String, String>{'domain_id': domain.id}.entries,
    );

    var result = await getUsers.invoke(filters: filters);
    setLoading();

    if (result.isRight) {
      return result.right;
    } else if (result.isLeft) {
      postError(result.left.message);
    }
  }

  void submit(
    String? id,
    Function showMsg,
    BuildContext context,
  ) async {
    if (isLoading) return;
    setLoading();

    dynamic result;
    var dadosFormFields = formDados.getValues()!;
    var enderecosFormFields = formEndereco.getValues()!;
    var contatosFormFields = formContato.getValues()!;
    String? domainJson = sharedPrefs.getString(CoreUserPreferences.DOMAIN);
    DomainApiDto domain = DomainApiDto.fromJson(jsonDecode(domainJson!));

    Map<String, dynamic> data = {
      'domain_id': domain.id,
      'cpf_cnpj': dadosFormFields['cpf_cnpj'],
      'nome_razao_social': dadosFormFields['nome_razao_social'],
      'rg_insc_est': dadosFormFields['rg_insc_est'],
      'apelido_nome_fantasia': dadosFormFields['apelido_nome_fantasia'],
      'enderecos': [
        {
          'logradouro': enderecosFormFields['logradouro'],
          'numero': enderecosFormFields['numero'],
          'complemento': enderecosFormFields['complemento'],
          'bairro': enderecosFormFields['bairro'],
          'cep': enderecosFormFields['cep']!
              .replaceAll('.', '')
              .replaceAll('-', ''),
          'ponto_referencia': enderecosFormFields['ponto_referencia'],
          'municipio_id': enderecosFormFields['municipio'],
        }
      ],
      'contatos': contatosFormFields['contatos'].toString().isEmpty
          ? []
          : jsonDecode(contatosFormFields['contatos'].toString()),
    };

    if (id != null) {
      data.addEntries(
        <String, dynamic>{'id': id}.entries,
      );
      result = await updateParceiro.invoke(
        id: id,
        body: data,
      );
    } else {
      result = await createParceiro.invoke(body: data);
    }

    setLoading();
    if (result.isLeft) {
      postError(result.left.message);
    } else {
      submitFuncionario(id, result.right.id, showMsg);
    }
  }

  void submitFuncionario(
    String? novo,
    String parceiroId,
    Function showMsg,
  ) async {
    if (isLoading) return;
    setLoading();

    var dadosFormFields = formDados.getValues()!;
    dynamic result;
    String? domainJson = sharedPrefs.getString(CoreUserPreferences.DOMAIN);
    DomainApiDto domain = DomainApiDto.fromJson(jsonDecode(domainJson!));

    Map<String, dynamic> data = {
      'domain_account_id': domain.id,
      'user_id': dadosFormFields['user_id'].toString().isEmpty
          ? null
          : dadosFormFields['user_id'],
      'id': parceiroId,
    };

    if (novo != null) {
      data.addEntries(
        <String, dynamic>{'id': parceiroId}.entries,
      );
      result = await updateFuncionario.invoke(
        id: parceiroId,
        body: data,
      );
    } else {
      result = await createFuncionario.invoke(body: data);
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
      formEndereco.municipio.onValueChange(result.right.municipios[0].id);
      formEndereco.municipioName.onValueChange(
          '${result.right.municipios[0].nome}/${result.right.municipios[0].siglaUf}');
    } else if (result.isLeft) {
      postError(result.left.message);
    }
  }

  Future checkParceiro(String cpfCnpj) async {
    Map<String, String> filters = {};

    if (isLoading) return null;
    setLoading();

    String? domainJson = sharedPrefs.getString(CoreUserPreferences.DOMAIN);
    DomainApiDto domain = DomainApiDto.fromJson(jsonDecode(domainJson!));

    filters.addEntries(
      <String, String>{'domain_id': domain.id}.entries,
    );
    filters.addEntries(
      <String, String>{'cpf_cnpj': cpfCnpj}.entries,
    );
    filters.addEntries(
      <String, String>{'page': '0'}.entries,
    );
    filters.addEntries(
      <String, String>{'page_size': '1'}.entries,
    );
    filters.addEntries(
      <String, String>{'require_pagination': 'true'}.entries,
    );

    var result = await getParceiro.invoke(
      filters: filters,
      listOptions: ListOptions.ACTIVE_ONLY,
    );
    setLoading();
    if (result.isRight) {
      if (result.right.parceiros.isNotEmpty) {
        var resultFuncionario = await getFuncionario.invoke(id: result.right.parceiros[0].id);
        if(resultFuncionario.isRight){
          postError('Já existe um funcionário registrado com esse CPF/CNPJ!');
          clearError();
          formDados.cpfCnpj.onValueChange('');
          formDados.nomeRazaoSocial.onValueChange('');
          formDados.apelidoNomeFantasia.onValueChange('');
          formDados.rgInscEst.onValueChange('');
          formDados.userId.onValueChange('');
          return true;
        }else{
          return false;
        }
      }else{
        return false;
      }
    } else if (result.isLeft) {
      postError(result.left.message);
      return false;
    }
  }
}
