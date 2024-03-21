import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/domain_account/data/models/domain_account_api_dto.dart';
import 'package:viggo_pay_admin/domain_account/ui/edit_domain_accounts/edit_domain_accounts_view_model.dart';
import 'package:viggo_pay_admin/utils/show_msg_snackbar.dart';

// ignore: must_be_immutable
class EditDomainAccountDocuments extends StatelessWidget {
  EditDomainAccountDocuments({
    super.key,
    required this.viewModel,
    required this.readOnly,
    entity,
  }) {
    if (entity != null) {
      this.entity = entity;
    }
  }

  final EditDomainAccountViewModel viewModel;
  late bool readOnly = false;
  // ignore: avoid_init_to_null
  late DomainAccountApiDto? entity = null;

  @override
  Widget build(context) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          StreamBuilder<int>(
            stream: viewModel.fileListSize,
            builder: (context, snapshot) {
              return SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if ((snapshot.data ?? 0) < 2 && !readOnly)
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles(
                              allowMultiple: false,
                              allowedExtensions: ['pdf'],
                              type: FileType.custom,
                            );
                            if (result != null) {
                              for (var element in result.files) {
                                viewModel.onSelectedFile(
                                  element,
                                  showMsgError,
                                );
                              }
                            }
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Adicionar documento'),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(
            height: 20,
          ),
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
                          viewModel.onLoadDomainAccount(showMsgError, entity);
                        }
                        return SizedBox(
                          height: 100,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data?.length ?? 0,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Row(
                                  children: [
                                    const Icon(Icons.file_copy_outlined),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Flexible(
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                          right: 13,
                                        ),
                                        child: Tooltip(
                                          message: snapshot.data?[index]['title'] ?? '',
                                          child: Text(
                                            snapshot.data?[index]['title'] ?? '',
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: !readOnly
                                    ? IconButton(
                                        onPressed: () {
                                          viewModel.onRemoveItem(
                                              snapshot.data![index]);
                                        },
                                        tooltip: 'Remover documento',
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          color: Colors.red,
                                        ),
                                      )
                                    : const Text(''),
                              );
                            },
                          ),
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
