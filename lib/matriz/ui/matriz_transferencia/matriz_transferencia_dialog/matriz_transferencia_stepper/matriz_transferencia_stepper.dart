import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/components/hover_button.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_api_dto.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_transferencia/matriz_transferencia_dialog/matriz_transferencia_stepper/step_conferir_transferencia/detalhes_transferencia.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_transferencia/matriz_transferencia_dialog/matriz_transferencia_stepper/step_escolher_pix/list_chave_pix.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_transferencia/matriz_transferencia_dialog/matriz_transferencia_stepper/step_informar_senha/confirmar_transferencia.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_transferencia/matriz_transferencia_dialog/matriz_transferencia_stepper/step_inicial_informar_valor/informar_valor.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_transferencia_view_model.dart';
import 'package:viggo_pay_admin/pay_facs/data/models/saldo_api_dto.dart';
import 'package:viggo_pay_admin/pix_to_send/data/models/pix_to_send_api_dto.dart';

class MatrizTransferenciaStepper extends StatefulWidget {
  const MatrizTransferenciaStepper({
    super.key,
    required this.materaId,
    required this.saldo,
    required this.pixToSendList,
    required this.taxa,
  });

  final String? materaId;
  final SaldoApiDto saldo;
  final List<PixToSendApiDto> pixToSendList;
  final Map<String, dynamic>? taxa;

  @override
  State<MatrizTransferenciaStepper> createState() => _MatrizTransferenciaStepperState();
}

class _MatrizTransferenciaStepperState extends State<MatrizTransferenciaStepper> with TickerProviderStateMixin {
  late PageController pageViewController;
  late TabController tabController;
  int currentPageIndex = 0;
  final viewModel = locator.get<MatrizTransferenciaViewModel>();

  @override
  void initState() {
    super.initState();
    pageViewController = PageController();
    tabController = TabController(length: 4, vsync: this);
    viewModel.initValues();
  }

  @override
  void dispose() {
    super.dispose();
    pageViewController.dispose();
    tabController.dispose();
  }

  void handlePageViewChanged(int currentPageIndex) {
    if (!_isOnDesktopAndWeb) {
      return;
    }
    tabController.index = currentPageIndex;
    setState(() {
      currentPageIndex = currentPageIndex;
    });
  }

  bool get _isOnDesktopAndWeb {
    if (kIsWeb) {
      return true;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return true;
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.fuchsia:
        return false;
    }
  }

  void updateCurrentPageIndex(int index) {
    if (pageViewController.positions.isNotEmpty) {
      currentPageIndex = index;
      tabController.index = index;
      pageViewController.animateToPage(
        index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void handlePage(DomainAccountApiDto? domain) {
    if (currentPageIndex == 0) {
      updateCurrentPageIndex(0);
    } else if (currentPageIndex == 1) {
      updateCurrentPageIndex(1);
    } else if (currentPageIndex == 2) {
      updateCurrentPageIndex(2);
    } else {
      updateCurrentPageIndex(3);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageViewController,
          onPageChanged: handlePageViewChanged,
          children: [
            StepInformarValor(
              saldo: widget.saldo,
              changePage: updateCurrentPageIndex,
              currentPage: currentPageIndex,
            ),
            StepEscolherPix(
              pixToSendList: widget.pixToSendList,
              changePage: updateCurrentPageIndex,
              currentPage: currentPageIndex,
            ),
            StepTransferenciaDetalhe(
              changePage: updateCurrentPageIndex,
              currentPage: currentPageIndex,
              saldo: widget.saldo,
              materaId: widget.materaId,
              taxa: widget.taxa,
            ),
            StepInformarSenha(
              changePage: updateCurrentPageIndex,
              currentPage: currentPageIndex,
              materaId: widget.materaId,
              taxa: widget.taxa,
            ),
          ],
        ),
        // PageIndicator(
        //   tabController: tabController,
        //   currentPageIndex: currentPageIndex,
        //   onUpdateCurrentPageIndex: updateCurrentPageIndex,
        //   isOnDesktopAndWeb: _isOnDesktopAndWeb,
        // ),
      ],
    );
  }
}

class PageIndicator extends StatelessWidget {
  const PageIndicator({
    super.key,
    required this.tabController,
    required this.currentPageIndex,
    required this.onUpdateCurrentPageIndex,
    required this.isOnDesktopAndWeb,
  });

  final int currentPageIndex;
  final TabController tabController;
  final void Function(int) onUpdateCurrentPageIndex;
  final bool isOnDesktopAndWeb;

  @override
  Widget build(BuildContext context) {
    if (!isOnDesktopAndWeb) {
      return const SizedBox.shrink();
    }
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          OnHoverButton(
            child: IconButton(
              splashRadius: 16.0,
              padding: EdgeInsets.zero,
              onPressed: () {
                if (currentPageIndex == 0) {
                  return;
                }
                onUpdateCurrentPageIndex(currentPageIndex - 1);
              },
              icon: const Icon(
                Icons.arrow_left_rounded,
                size: 32.0,
              ),
            ),
          ),
          TabPageSelector(
            controller: tabController,
            color: colorScheme.onPrimary,
            selectedColor: colorScheme.primary,
          ),
          OnHoverButton(
            child: IconButton(
              splashRadius: 16.0,
              padding: EdgeInsets.zero,
              onPressed: () {
                if (currentPageIndex == 2) {
                  return;
                }
                onUpdateCurrentPageIndex(currentPageIndex + 1);
              },
              icon: const Icon(
                Icons.arrow_right_rounded,
                size: 32.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
