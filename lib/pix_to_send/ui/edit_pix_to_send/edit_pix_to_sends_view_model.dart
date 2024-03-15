import 'dart:async';

import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/domain_account/domain/usecases/get_domain_account_by_id_use_case.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/destinatario_api_dto.dart';
import 'package:viggo_pay_admin/pay_facs/domain/usecases/consultar_alias_destinatario_use_case.dart';
import 'package:viggo_pay_admin/pix_to_send/data/models/pix_to_send_api_dto.dart';
import 'package:viggo_pay_admin/pix_to_send/domain/usecases/create_pix_to_send_use_case.dart';
import 'package:viggo_pay_admin/pix_to_send/domain/usecases/update_pix_to_send_use_case.dart';
import 'package:viggo_pay_admin/pix_to_send/ui/edit_pix_to_send/edit_pix_to_sends_form/edit_form_fields.dart';
import 'package:viggo_pay_core_frontend/base/base_view_model.dart';
import 'package:viggo_pay_core_frontend/domain/domain/usecases/get_domain_from_settings_use_case.dart';

class EditPixToSendViewModel extends BaseViewModel {
  String materaId = '';
  // ignore: avoid_init_to_null
  late Map<String, dynamic> entity = {};

  final UpdatePixToSendUseCase updatePixToSend;
  final CreatePixToSendUseCase createPixToSend;
  final GetDomainFromSettingsUseCase getDomainFromSettings;
  final ConsultarAliasDestinatarioUseCase consultarDestinatario;
  final GetDomainAccountByIdUseCase getDomainAccount;

  final EditPixToSendFormFields form = EditPixToSendFormFields();

  final StreamController<bool> _streamControllerSuccess =
      StreamController<bool>.broadcast();
  Stream<bool> get isSuccess => _streamControllerSuccess.stream;

  final StreamController<PixToSendApiDto> _streamSuccessPixToSend =
      StreamController<PixToSendApiDto>.broadcast();
  Stream<PixToSendApiDto> get pixToSendSuccess =>
      _streamSuccessPixToSend.stream;

  Function(DestinatarioApiDto?) get onDestinatarioChange =>
      _streamDestinatarioController.sink.add;
  final StreamController<DestinatarioApiDto?> _streamDestinatarioController =
      StreamController<DestinatarioApiDto?>.broadcast();
  Stream<DestinatarioApiDto?> get destinatarioInfo =>
      _streamDestinatarioController.stream;

  EditPixToSendViewModel({
    required this.consultarDestinatario,
    required this.updatePixToSend,
    required this.createPixToSend,
    required this.getDomainFromSettings,
    required this.getDomainAccount,
  });

  get domainAccountID {
    var domainDto = getDomainFromSettings.invoke();

    if (domainDto != null) {
      return domainDto.id;
    }
  }

  void catchDomainAccount() async {
    var result = await getDomainAccount.invoke(id: domainAccountID);

    if (result.isRight) {
      if (result.right.materaId != null) materaId = result.right.materaId!;
    } else if (result.isLeft) {
      postError(result.left.message);
    }
    return null;
  }

  void submit(
    String? id,
    Function showMsg,
    BuildContext context,
  ) async {
    if (isLoading) return;
    setLoading();

    dynamic result;

    if (id != null) {
      entity.addEntries(
        <String, dynamic>{'id': id}.entries,
      );
    }
    if (id != null) {
      result = await updatePixToSend.invoke(
        id: id,
        body: entity,
      );
    } else {
      result = await createPixToSend.invoke(body: entity);
    }

    setLoading();
    if (result.isLeft) {
      postError(result.left.message);
    } else {
      if (!_streamControllerSuccess.isClosed) {
        _streamControllerSuccess.sink.add(true);
        _streamSuccessPixToSend.sink.add(result.right);
      }
    }
  }

  void loadInfoDestinatario(
    String aliasCountry,
    String aliasValue,
  ) async {
    
    if(isLoading) return;
    setLoading();

    Map<String, String> body = {
      'account_id': materaId,
      'country': aliasCountry,
      'alias_destinatario': aliasValue,
    };
    var result = await consultarDestinatario.invoke(body: body);

    setLoading();
    if (result.isRight) {
      _streamDestinatarioController.sink.add(result.right);
    } else if (result.isLeft) {
      postError(result.left.message);
    }
  }

  preencherEntity(DestinatarioApiDto destinatario) {
    var formFields = form.getFields()!;

    entity['alias'] = formFields['alias'];
    entity['alias_type'] = formFields['aliasType'];

    entity['domain_account_id'] = domainAccountID;
    entity['destination_account'] = destinatario.accountDestination;
    entity['destination_account_type'] = destinatario.accountTypeDestination;
    entity['destination_branch'] = destinatario.accountBranchDestination;
    entity['psp_id'] = destinatario.pspId;
    entity['psp_country'] = destinatario.pspCountry;
    entity['psp_name'] = destinatario.pspName;
    entity['holder_name'] = destinatario.aliasHolderName;
    entity['holder_tax_identifier_country'] = destinatario.aliasHolderCountry;
    entity['holder_tax_identifier_tax_id'] = destinatario.aliasHolderTaxId;
    entity['holder_tax_identifier_tax_id_masked'] =
        destinatario.aliasHolderTaxIdMasked;
  }
}
