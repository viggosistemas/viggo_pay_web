import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/components/hover_button.dart';
import 'package:viggo_pay_admin/matriz/ui/matriz_view_model.dart';
import 'package:viggo_pay_admin/utils/show_msg_snackbar.dart';

class EditInfoDocumentos extends StatelessWidget {
  const EditInfoDocumentos({
    super.key,
    required this.viewModel,
    required this.constraints,
  });

  final MatrizViewModel viewModel;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
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

    return SizedBox(
      height: 300,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Arquivos selecionados:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    StreamBuilder<List<Map<String, dynamic>>>(
                      stream: viewModel.fileList,
                      builder: (context, snapshot) {
                        if (snapshot.data == null) {
                          viewModel.onLoadDomainAccount(showMsgError);
                        }
                        List<Map<String, dynamic>> data = snapshot.data ?? [];
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: ElevatedButton.icon(
                                    onPressed: () async {
                                      FilePickerResult? result = await FilePicker.platform.pickFiles(
                                        allowMultiple: false,
                                        allowedExtensions: ['pdf'],
                                        type: FileType.custom,
                                      );
                                      if (result != null) {
                                        for (var element in result.files) {
                                          viewModel.onSelectedFile(element, showMsgError, 'CONTRATO_SOCIAL');
                                        }
                                      }
                                    },
                                    style: ButtonStyle(
                                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                        const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                      ),
                                      backgroundColor: WidgetStateProperty.all<Color>(Theme.of(context).colorScheme.primary),
                                      minimumSize: WidgetStateProperty.all<Size>(
                                        const Size(50, 50),
                                      ),
                                    ),
                                    icon: const Icon(Icons.upload_outlined),
                                    label: Tooltip(
                                      message: constraints.maxWidth < 960 ? 'Adicionar contrato social' : '',
                                      child: Text(
                                        constraints.maxWidth < 960 ? '...Adicionar contrato' : 'Adicionar contrato social',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Theme.of(context).colorScheme.onPrimary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                data.where((element) => element['tipo'] == 'CONTRATO_SOCIAL').isNotEmpty
                                    ? Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.file_copy_outlined,
                                                color: Theme.of(context).colorScheme.primary,
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              Tooltip(
                                                message: constraints.maxWidth < 960
                                                    ? data.where((element) => element['tipo'] == 'CONTRATO_SOCIAL').toList()[0]['title']
                                                    : '',
                                                child: Text(
                                                  constraints.maxWidth < 960
                                                      ? '${data.where((element) => element['tipo'] == 'CONTRATO_SOCIAL').toList()[0]['title'].substring(0, 10)}...'
                                                      : data.where((element) => element['tipo'] == 'CONTRATO_SOCIAL').toList()[0]['title'],
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          OnHoverButton(
                                            child: IconButton(
                                              onPressed: () {
                                                viewModel.onRemoveItem(
                                                  data.where((element) => element['tipo'] == 'CONTRATO_SOCIAL').toList()[0],
                                                );
                                              },
                                              tooltip: 'Remover documento',
                                              icon: const Icon(
                                                Icons.delete_outline,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : const SizedBox(height: 0),
                                const SizedBox(height: 20),
                                Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: ElevatedButton.icon(
                                    onPressed: () async {
                                      FilePickerResult? result = await FilePicker.platform.pickFiles(
                                        allowMultiple: false,
                                        allowedExtensions: ['pdf'],
                                        type: FileType.custom,
                                      );
                                      if (result != null) {
                                        for (var element in result.files) {
                                          viewModel.onSelectedFile(element, showMsgError, 'PROCURACAO');
                                        }
                                      }
                                    },
                                    style: ButtonStyle(
                                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                        const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                      ),
                                      backgroundColor: WidgetStateProperty.all<Color>(Theme.of(context).colorScheme.primary),
                                      minimumSize: WidgetStateProperty.all<Size>(
                                        const Size(50, 50),
                                      ),
                                    ),
                                    icon: const Icon(Icons.upload_outlined),
                                    label: Tooltip(
                                      message: constraints.maxWidth < 960 ? 'Adicionar procuração' : '',
                                      child: Text(
                                        constraints.maxWidth < 960 ? '...Adicionar procur' : 'Adicionar procuração',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Theme.of(context).colorScheme.onPrimary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                data.where((element) => element['tipo'] == 'PROCURACAO').isNotEmpty
                                    ? Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.file_copy_outlined,
                                                color: Theme.of(context).colorScheme.primary,
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              Tooltip(
                                                message: constraints.maxWidth < 960
                                                    ? data.where((element) => element['tipo'] == 'PROCURACAO').toList()[0]['title']
                                                    : '',
                                                child: Text(
                                                  constraints.maxWidth < 960
                                                      ? '${data.where((element) => element['tipo'] == 'PROCURACAO').toList()[0]['title'].substring(0, 10)}...'
                                                      : data.where((element) => element['tipo'] == 'PROCURACAO').toList()[0]['title'],
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          OnHoverButton(
                                            child: IconButton(
                                              onPressed: () {
                                                viewModel.onRemoveItem(
                                                  data.where((element) => element['tipo'] == 'PROCURACAO').toList()[0],
                                                );
                                              },
                                              tooltip: 'Remover documento',
                                              icon: const Icon(
                                                Icons.delete_outline,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : const SizedBox(height: 0),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
