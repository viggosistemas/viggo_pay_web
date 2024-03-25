import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:typed_data';

import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:viggo_pay_admin/components/hover_button.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/extrato/ui/timeline_extrato_view_model.dart';

class ExtratoPdfViewer extends StatefulWidget {
  ExtratoPdfViewer({
    super.key,
    required this.domainAccountId,
    required this.params,
  });

  final String domainAccountId;
  final Map<String, String> params;
  final TimelineExtratoViewModel viewModel =
      locator.get<TimelineExtratoViewModel>();

  @override
  State<ExtratoPdfViewer> createState() => _ExtratoPdfViewerState();
}

class _ExtratoPdfViewerState extends State<ExtratoPdfViewer> {
  @override
  Widget build(BuildContext context) {
    navigateBack() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop();
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
      onPopInvoked: (_) {
        navigateBack();
      },
      child: SafeArea(
        child: Scaffold(
          body: StreamBuilder<Either<bool, Uint8List>?>(
            stream: widget.viewModel.extratoPdf,
            builder: (ctx, transfSnapshot) {
              if (transfSnapshot.data == null) {
                widget.viewModel
                    .gerarPdf(widget.domainAccountId, widget.params);
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
                          OnHoverButton(
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: ElevatedButton.icon(
                                onPressed: () async => download(
                                  transfSnapshot.data!.right,
                                  downloadName: 'extrato_vPay.pdf',
                                ),
                                label: const Text('Baixar'),
                                icon: const Icon(Icons.download_for_offline),
                              ),
                            ),
                          ),
                          OnHoverButton(
                            child: IconButton(
                              onPressed: () => navigateBack(),
                              icon: const Icon(
                                Icons.cancel_outlined,
                                color: Colors.red,
                              ),
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
