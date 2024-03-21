import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:typed_data';

import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_transferencia_view_model.dart';

class ComprovantePdfViewer extends StatefulWidget {
  ComprovantePdfViewer({super.key});

  final MatrizTransferenciaViewModel viewModel =
      locator.get<MatrizTransferenciaViewModel>();

  @override
  State<ComprovantePdfViewer> createState() => _ComprovantePdfViewerState();
}

class _ComprovantePdfViewerState extends State<ComprovantePdfViewer> {
  @override
  Widget build(BuildContext context) {
    navigateBack() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.viewModel.catchEntity();
        widget.viewModel.loadUltimatransacao(widget.viewModel.materaId);
        widget.viewModel.loadTransacoes(widget.viewModel.materaId);
        widget.viewModel.loadSaldo(widget.viewModel.materaId);
        Navigator.of(context).pop(true);
      });
    }

    void download(
      List<int> bytes, {
      required String downloadName,
    }) {
      final base64 = base64Encode(bytes);
      final anchor =
          AnchorElement(href: 'data:application/octet-stream;base64,$base64')
            ..target = 'blank';
      // ignore: unnecessary_null_comparison
      if (downloadName != null) {
        anchor.download = downloadName;
      }
      document.body!.append(anchor);
      anchor.click();
      anchor.remove();
      return;
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) return;
        navigateBack();
      },
      child: SafeArea(
        child: Scaffold(
          body: StreamBuilder<Either<bool, Uint8List>?>(
            stream: widget.viewModel.extratoPdf,
            builder: (ctx, transfSnapshot) {
              if (transfSnapshot.data == null) {
                widget.viewModel.onCashoutSubmit(context);
                return const Center(child: CircularProgressIndicator());
              } else if (transfSnapshot.data!.isRight) {
                return Stack(
                  alignment: AlignmentDirectional.topCenter,
                  children: <Widget>[
                    PdfViewPinch(
                      controller: PdfControllerPinch(
                        document:
                            PdfDocument.openData(transfSnapshot.data!.right),
                      ),
                      padding: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: ElevatedButton.icon(
                              onPressed: () async => download(
                                transfSnapshot.data!.right,
                                downloadName: 'comprovante_vPay.pdf',
                              ),
                              label: const Text('Baixar'),
                              icon: const Icon(Icons.download_for_offline),
                            ),
                          ),
                          IconButton(
                            onPressed: () => navigateBack(),
                            icon: const Icon(
                              Icons.cancel_outlined,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                navigateBack();
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
