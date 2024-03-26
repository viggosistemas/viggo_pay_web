import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viggo_core_frontend/domain/data/models/domain_api_dto.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_builder.dart';
import 'package:viggo_pay_admin/components/hover_button.dart';
import 'package:viggo_pay_admin/dashboard/ui/dashboard_view_model.dart';
import 'package:viggo_pay_admin/dashboard/ui/extrato_timeline/extrato_timeline.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_api_dto.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_transferencia/matriz_transferencia_dialog/matriz_transferencia_dialog.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/extrato_api_dto.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/saldo_api_dto.dart';
import 'package:viggo_pay_admin/pix_to_send/data/models/pix_to_send_api_dto.dart';
import 'package:viggo_pay_admin/utils/constants.dart';
import 'package:viggo_pay_admin/utils/format_mask.dart';
import 'package:viggo_pay_admin/utils/show_msg_snackbar.dart';

// ignore: must_be_immutable
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  DashboardViewModel viewModel = locator.get<DashboardViewModel>();

  SharedPreferences sharedPrefs = locator.get<SharedPreferences>();

  bool isObscureSaldo = true;

  int lengthExtrato = 5;

  Widget? getImagem(String? logoId) {
    if (logoId != null && logoId.isNotEmpty) {
      return CircleAvatar(
        backgroundImage: NetworkImage(
          viewModel.parseImage.invoke(logoId),
        ),
      );
    } else if (viewModel.domainDto!.logoId != null &&
        viewModel.domainDto!.logoId!.isNotEmpty) {
      return CircleAvatar(
        backgroundImage: NetworkImage(
          viewModel.parseImage.invoke(viewModel.domainDto!.logoId!),
        ),
      );
    } else {
      return const CircleAvatar(
        backgroundImage: AssetImage(
          'assets/images/avatar.png',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dialogs = MatrizTransferenciaDialog(context: context);
    viewModel.errorMessage.listen((value) {
      if (value.isNotEmpty && context.mounted) {
        viewModel.clearError();
        showInfoMessage(
          context,
          2,
          Colors.red,
          value,
          'X',
          () {},
          Colors.white,
        );
      }
    });

    showMsgError(String value) {
      showInfoMessage(
        context,
        2,
        Colors.red,
        value,
        'X',
        () {},
        Colors.white,
      );
    }

    onUploadLogo() async {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        allowedExtensions: ['png', 'jpg', 'wbp', 'jpeg'],
        type: FileType.custom,
      );

      if (result != null) {
        for (var element in result.files) {
          viewModel.uploadPhoto(
            element,
            showMsgError,
          );
        }
      }
    }

    return AppBuilder(
      child: StreamBuilder<DomainApiDto?>(
        stream: viewModel.domain,
        builder: (context, domain) {
          viewModel.getDomain();
          if (domain.data == null) {
            return Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            );
          } else {
            if (domain.data!.name == 'default') {
              return const Text('');
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // const Expanded(child: DashboardCards()),
                  StreamBuilder<DomainAccountApiDto?>(
                    stream: viewModel.matriz,
                    builder: (context, matriz) {
                      if (matriz.data == null) {
                        viewModel.catchEntity();
                        return Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          padding: const EdgeInsets.all(16),
                          width: 500,
                          child: Card(
                            elevation: 8,
                            margin: const EdgeInsets.all(18),
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context)
                                        .colorScheme
                                        .secondary
                                        .withOpacity(0.8),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Tooltip(
                                        message:
                                            'Editar informações da empresa',
                                        child: OnHoverButton(
                                          child: IconButton(
                                            onPressed: () {
                                              sharedPrefs.setString(
                                                  'SELECTED_INDEX',
                                                  jsonEncode(2));
                                              WidgetsBinding.instance
                                                  .addPostFrameCallback((_) {
                                                Navigator.of(context)
                                                    .pushReplacementNamed(
                                                        Routes.MATRIZ);
                                              });
                                            },
                                            icon: Icon(
                                              Icons.edit_outlined,
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? Colors.black
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Tooltip(
                                    message: 'Alterar foto',
                                    child: GestureDetector(
                                      onTap: () => onUploadLogo(),
                                      child: OnHoverButton(
                                        child: SizedBox(
                                          width: 150,
                                          height: 150,
                                          child: getImagem(domain.data?.logoId),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    matriz.data!.clientName,
                                    style: GoogleFonts.comicNeue(
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.black
                                          : Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'CNPJ: ${FormatMask().formated(matriz.data!.clientTaxIdentifierTaxId)}',
                                    style: GoogleFonts.lato(
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.black.withOpacity(0.7)
                                          : Theme.of(context)
                                              .colorScheme
                                              .onPrimary
                                              .withOpacity(0.7),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  StreamBuilder<SaldoApiDto>(
                                    stream: viewModel.saldo,
                                    builder: (context, saldoData) {
                                      if (saldoData.data == null) {
                                        viewModel
                                            .loadSaldo(matriz.data!.materaId!);
                                        return CircularProgressIndicator(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        );
                                      } else {
                                        return Card(
                                          elevation: 8,
                                          margin: const EdgeInsets.all(18),
                                          child: Container(
                                            padding: const EdgeInsets.all(10.0),
                                            height: 150,
                                            width: 250,
                                            alignment: Alignment.center,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Text(
                                                          'Saldo disponível',
                                                          style:
                                                              GoogleFonts.lato(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .primary,
                                                          ),
                                                        ),
                                                        OnHoverButton(
                                                          child: IconButton(
                                                            icon: Icon(
                                                              isObscureSaldo
                                                                  ? Icons
                                                                      .visibility
                                                                  : Icons
                                                                      .visibility_off,
                                                              size: 20,
                                                            ),
                                                            onPressed: () {
                                                              setState(() {
                                                                isObscureSaldo =
                                                                    !isObscureSaldo;
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      isObscureSaldo
                                                          ? 'R\$ ${saldoData.data!.real.toString().replaceAll(RegExp(r"."), "*")}'
                                                          : 'R\$ ${saldoData.data!.real.toString()}',
                                                      style: GoogleFonts.lato(
                                                        fontSize: 24,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                StreamBuilder<
                                                    List<PixToSendApiDto>>(
                                                  stream:
                                                      viewModel.chavePixToSends,
                                                  builder:
                                                      (context, pixToSendData) {
                                                    if (pixToSendData.data ==
                                                        null) {
                                                      viewModel
                                                          .loadChavePixToSends(
                                                        matriz.data!.id,
                                                      );
                                                      return CircularProgressIndicator(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .secondary,
                                                      );
                                                    }
                                                    return Tooltip(
                                                      message: saldoData
                                                                  .data!.real ==
                                                              0
                                                          ? 'Não há saldo disponível!'
                                                          : '',
                                                      child: Directionality(
                                                        textDirection:
                                                            TextDirection.rtl,
                                                        child: OnHoverButton(
                                                          child: ElevatedButton
                                                              .icon(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor: saldoData
                                                                          .data!
                                                                          .real >
                                                                      0
                                                                  ? Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .primary
                                                                  : Colors.grey,
                                                            ),
                                                            icon: const Icon(
                                                              Icons
                                                                  .attach_money_outlined,
                                                              size: 20,
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              if (saldoData
                                                                      .data!
                                                                      .real >
                                                                  0) {
                                                                var result =
                                                                    await dialogs
                                                                        .transferenciaDialog(
                                                                  materaId: matriz
                                                                      .data!
                                                                      .materaId!,
                                                                  saldo:
                                                                      saldoData
                                                                          .data!,
                                                                  pixToSendList:
                                                                      pixToSendData
                                                                          .data!,
                                                                );
                                                                if (result != null &&
                                                                    result ==
                                                                        true &&
                                                                    context
                                                                        .mounted) {
                                                                  showInfoMessage(
                                                                    context,
                                                                    2,
                                                                    Colors
                                                                        .green,
                                                                    'Transferência realizada com sucesso!',
                                                                    'X',
                                                                    () {},
                                                                    Colors
                                                                        .white,
                                                                  );
                                                                  viewModel.loadSaldo(
                                                                      matriz
                                                                          .data!
                                                                          .materaId!);
                                                                  viewModel.loadExtrato(
                                                                      matriz
                                                                          .data!
                                                                          .materaId!);
                                                                }
                                                              }
                                                            },
                                                            label: const Text(
                                                              'Transferir',
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Últimas movimentações',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Theme.of(context)
                                            .colorScheme
                                            .secondary
                                            .withOpacity(0.8)
                                        : Theme.of(context).colorScheme.primary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Tooltip(
                              message: 'Carregar mais 5 itens',
                              child: OnHoverButton(
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: TextButton.icon(
                                    icon: Icon(
                                      Icons
                                          .keyboard_double_arrow_right_outlined,
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Theme.of(context)
                                              .colorScheme
                                              .secondary
                                              .withOpacity(0.8)
                                          : Theme.of(context)
                                              .colorScheme
                                              .primary,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        lengthExtrato += 5;
                                      });
                                    },
                                    label: Text(
                                      'Carregar mais',
                                      style: GoogleFonts.lato(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Theme.of(context)
                                                .colorScheme
                                                .secondary
                                                .withOpacity(0.8)
                                            : Theme.of(context)
                                                .colorScheme
                                                .primary,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  StreamBuilder<List<ExtratoApiDto>>(
                    stream: viewModel.extrato,
                    builder: (context, extrato) {
                      if (extrato.data == null) {
                        viewModel.loadExtrato(viewModel.materaId);
                        return CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.secondary,
                        );
                      } else {
                        return Expanded(
                          child: ExtratoTimeline(
                            listExtrato: extrato.data!,
                            lengthExtrato: lengthExtrato,
                          ),
                        );
                      }
                    },
                  ),
                ],
              );
            }
          }
        },
      ),
    );
  }
}
