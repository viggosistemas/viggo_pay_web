import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/pop_menu/ui/pop_menu_items/alterar_senha/alterar_senha_form_fields.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/pop_menu/ui/pop_menu_items/info_user/info_user_form_fields.dart';
import 'package:viggo_pay_core_frontend/base/base_view_model.dart';
import 'package:viggo_pay_core_frontend/image/domain/usecases/parse_image_url_use_case.dart';
import 'package:viggo_pay_core_frontend/user/data/models/user_api_dto.dart';
import 'package:viggo_pay_core_frontend/user/domain/usecases/delete_photo_use_case%20.dart';
import 'package:viggo_pay_core_frontend/user/domain/usecases/get_user_by_id_use_case.dart';
import 'package:viggo_pay_core_frontend/user/domain/usecases/get_user_use_case.dart';
import 'package:viggo_pay_core_frontend/user/domain/usecases/set_user_use_case.dart';
import 'package:viggo_pay_core_frontend/user/domain/usecases/update_password_use_case.dart';
import 'package:viggo_pay_core_frontend/user/domain/usecases/update_user_use_case.dart';
import 'package:viggo_pay_core_frontend/user/domain/usecases/upload_photo_use_case.dart';

class PopMenuViewModel extends BaseViewModel {
  final UpdateUserUseCase updateUserUseCase;
  final UpdatePasswordUserUseCase updatePasswordUserUseCase;
  final GetUserUseCase getUserFromSettings;
  final SetUserUseCase setUser;
  final GetUserByIdUseCase getUserById;
  final ParseImageUrlUseCase parseImage;
  final UploadPhotoUserUseCase uploadPhotoUserUseCase;
  final DeletePhotoUserUseCase deletePhotoUserUseCase;

  final InfoUserFormFields form = InfoUserFormFields();
  final AlterarSenhaFormFields formSenha = AlterarSenhaFormFields();

  final StreamController<bool> _streamController =
      StreamController<bool>.broadcast();
  Stream<bool> get isSuccess => _streamController.stream;

  final StreamController<UserApiDto> _streamUserController =
      StreamController<UserApiDto>.broadcast();
  Stream<UserApiDto> get userController => _streamUserController.stream;

  PopMenuViewModel({
    required this.parseImage,
    required this.updateUserUseCase,
    required this.uploadPhotoUserUseCase,
    required this.deletePhotoUserUseCase,
    required this.updatePasswordUserUseCase,
    required this.getUserFromSettings,
    required this.setUser,
    required this.getUserById,
  });

  Future<void> funGetUserById(String userId) async {
    var result = await getUserById.invoke(id: userId);
    if (result.isLeft) {
      postError(result.left.message);
    } else {
      setUser.invoke(result.right);
    }
  }

  UserApiDto? get user {
    var userDto = getUserFromSettings.invoke();
    if (userDto == null) {
      return null;
    } else {
      return userDto;
    }
  }

  void onSubmit(
    Function showMsg,
    BuildContext context,
  ) async {
    if (isLoading) return;
    setLoading();

    Map<String, dynamic> params = {
      'id': user!.id,
      'nickname': '',
    };
    var formFields = form.getFields();
    params['nickname'] = formFields?['nickname'] ?? '';

    var result = await updateUserUseCase.invoke(id: user!.id, body: params);
    setLoading();

    if (result.isLeft) {
      postError(result.left.message);
    } else {
      if (!_streamController.isClosed) {
        _streamController.sink.add(true);
        await funGetUserById(user!.id);
      }
    }
  }

  void onSubmitSenha(
    Function showMsg,
    BuildContext context,
  ) async {
    if (isLoading) return;
    setLoading();

    Map<String, dynamic> params = {
      'old_password': '',
      'password': '',
    };
    var formFields = formSenha.getFields();
    params['old_password'] = formFields?['senhaAntiga'] ?? '';
    params['password'] = formFields?['novaSenha'] ?? '';

    var result =
        await updatePasswordUserUseCase.invoke(id: user!.id, body: params);
    setLoading();
    if (result.isLeft) {
      postError(result.left.message);
    } else {
      if (!_streamController.isClosed) {
        _streamController.sink.add(true);
      }
    }
  }

  void uploadPhoto(PlatformFile file, Function onError) async {
    if (isLoading) return;
    setLoading();

    var kb = (file.bytes!.lengthInBytes * 0.001 * 100).round() /
        100; // TAMANHO EM KBYTES
    var mb = (kb * 0.001 * 100).round() / 100; // TAMANHO EM MEGABYTES
    // var gb = (mb * 0.001 * 100).round() / 100; // TAMANHO EM GYGABYTES
    if (file.extension != 'png' &&
        file.extension != 'jpg' &&
        file.extension != 'wbp' &&
        file.extension != 'jpeg') {
      onError('Somente é permitidos arquivos de imagem!');
      return;
    }
    if (mb > 10) {
      onError('Só é permitido arquivos com até 10Mb de tamanho!');
      return;
    }

    var result = await uploadPhotoUserUseCase.invoke(
      id: user!.id,
      fileName: file.name,
      bytes: file.bytes!,
    );
    setLoading();
    if (result.isLeft) {
      postError(result.left.message);
    } else {
      if (!_streamController.isClosed) {
        UserApiDto saveUser = getUserFromSettings.invoke()!;
        saveUser.photoId = result.right.id;
        setUser.invoke(saveUser);
        _streamUserController.sink.add(saveUser);
        _streamController.sink.add(true);
      }
    }
  }

  void removePhoto() async {
    if (isLoading) return;
    setLoading();

    var result = await deletePhotoUserUseCase.invoke(id: user!.id);
    setLoading();
    if (result.isLeft) {
      postError(result.left.message);
    } else {
      if (!_streamController.isClosed) {
        UserApiDto saveUser = getUserFromSettings.invoke()!;
        saveUser.photoId = null;
        setUser.invoke(saveUser);
        _streamUserController.sink.add(saveUser);
        _streamController.sink.add(true);
      }
    }
  }
}
