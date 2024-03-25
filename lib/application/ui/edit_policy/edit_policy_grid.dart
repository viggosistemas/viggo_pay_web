import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viggo_core_frontend/application/data/models/application_api_dto.dart';
import 'package:viggo_core_frontend/policies/data/models/policy_api_dto.dart';
import 'package:viggo_core_frontend/role/data/models/role_api_dto.dart';
import 'package:viggo_core_frontend/util/list_options.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/data_table_paginated.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/header-search/ui/header_search_main.dart';
import 'package:viggo_pay_admin/application/ui/components/dialog_manage_policy.dart';
import 'package:viggo_pay_admin/application/ui/edit_policy/edit_policy_view_model.dart';
import 'package:viggo_pay_admin/components/dialogs.dart';
import 'package:viggo_pay_admin/components/hover_button.dart';
import 'package:viggo_pay_admin/components/progress_loading.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/utils/show_msg_snackbar.dart';

// ignore: must_be_immutable
class EditPolicyGrid extends StatefulWidget {
  EditPolicyGrid({super.key});

  EditPolicyViewModel viewModel = locator.get<EditPolicyViewModel>();
  SharedPreferences sharedPrefs = locator.get<SharedPreferences>();

  @override
  State<EditPolicyGrid> createState() => _EditPolicyGridState();
}

class _EditPolicyGridState extends State<EditPolicyGrid> {
  late bool jaPreencheu;
  late RoleApiDto? roleSelected;
  late Map<String, String> initialFilters;
  late List<PolicyApiDto> selectedPolicies;

  @override
  void initState() {
    jaPreencheu = false;
    roleSelected = null;
    initialFilters = {};
    selectedPolicies = [];
    super.initState();
  }

  static const routesRowValues = [
    'capability.route',
    'capability.route',
    'capability.route',
    'capability.route',
    'capability.route'
  ];

  static const routesListLabelInclude = [
    'name',
    'url',
    'method',
    'bypass',
    'sysadmin'
  ];

  loadCapabilities(
    ApplicationApiDto selected,
    Map<String, String> searchFilters,
    RoleApiDto? role,
  ) {
    widget.viewModel.avaliableCapabilities = [];
    Map<String, String> filters = {
      'application_id': selected.id,
      'list_options': ListOptions.ACTIVE_ONLY.name,
    };

    if (selected.name != 'default') {
      filters.addEntries(
        <String, String>{'route.sysadmin': 'false'}.entries,
      );
    }

    initialFilters = filters;

    if (searchFields.isNotEmpty) {
      initialFilters.addEntries(searchFilters.entries);
    }

    widget.viewModel.loadData(filters, role);
    widget.viewModel.listRoles();
  }

  checkApplication(ApplicationApiDto? selected) {
    String? key = widget.sharedPrefs.getString('APPLICATION_SELECTED');
    if (key != null) {
      if (selected != null) {
        widget.sharedPrefs
            .setString('APPLICATION_SELECTED', jsonEncode(selected));
        loadCapabilities(selected, {}, roleSelected);
      } else {
        ApplicationApiDto application =
            ApplicationApiDto.fromJson(jsonDecode(key));
        loadCapabilities(application, {}, roleSelected);
      }
    } else {
      widget.sharedPrefs
          .setString('APPLICATION_SELECTED', jsonEncode(selected));
      loadCapabilities(selected!, {}, roleSelected);
    }
  }

  ApplicationApiDto get application {
    String? key = widget.sharedPrefs.getString('APPLICATION_SELECTED');
    return ApplicationApiDto.fromJson(jsonDecode(key!));
  }

  List<Map<String, dynamic>> searchFields = [
    {
      'label': 'Nome',
      'search_field': 'route.name',
      'type': 'text',
      'icon': Icons.abc,
    },
  ];

  void onSearch(List<Map<String, dynamic>> params) {
    Map<String, String> filters = {};
    var newParams = params
        .map((e) => {
              'search_field': e['search_field'],
              'value': e['value'],
              'type': e['type'],
            })
        .toList();

    for (var element in newParams) {
      var fieldValue = '';

      if (element['type'] == 'text') {
        fieldValue = '%${element['value']}%';
      } else {
        fieldValue = element['value'];
      }
      filters.addEntries(
        <String, String>{element['search_field']: fieldValue}.entries,
      );
    }

    loadCapabilities(application, filters, roleSelected);
  }

  onReload() {
    loadCapabilities(application, {}, roleSelected);
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as ApplicationApiDto?;

    widget.viewModel.isSuccess.listen((value) {
      showInfoMessage(
        context,
        2,
        Colors.green,
        'Políticas removidas com sucesso!',
        'X',
        () {},
        Colors.white,
      );
      onReload();
    });

    widget.viewModel.errorMessage.listen(
      (value) {
        if (value.isNotEmpty && context.mounted) {
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
      },
    );

    return StreamBuilder<List<PolicyApiDto>>(
      stream: widget.viewModel.policies,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          if (!jaPreencheu) {
            jaPreencheu = true;
            checkApplication(args);
          }
          return const ProgressLoading();
        } else {
          selectedPolicies = (snapshot.data as List<PolicyApiDto>);
          return SizedBox(
            height: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      StreamBuilder<List<RoleApiDto>>(
                        stream: widget.viewModel.papeisSistema,
                        builder: (context, papeis) {
                          if (papeis.data == null) {
                            widget.viewModel.listRoles();
                            return const CircularProgressIndicator();
                          } else {
                            return PopupMenuButton<RoleApiDto>(
                                onSelected: (RoleApiDto selected) {
                                  setState(() {
                                    roleSelected = selected;
                                    onReload();
                                  });
                                },
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15.0),
                                  ),
                                ),
                                tooltip: 'Selecione um papel',
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      width: 1,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  child: const Icon(Icons.filter_alt_outlined),
                                ),
                                itemBuilder: (BuildContext context) {
                                  return papeis.data!
                                      .map(
                                        (e) => PopupMenuItem<RoleApiDto>(
                                          value: e,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(e.name),
                                              const Icon(
                                                Icons.people_alt_outlined,
                                                size: 18,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                      .toList();
                                });
                          }
                        },
                      ),
                      const SizedBox(width: 10),
                      HeaderSearchMain(
                        searchFields: searchFields,
                        onSearch: onSearch,
                        onReload: onReload,
                        notShowAdvancedFilters: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  selectedPolicies.isEmpty
                      ? Center(
                          child: Text(
                            roleSelected == null
                                ? 'Selecione um papel'
                                : 'Nenhum resultado encontrado pro papel - ${roleSelected!.name}',
                            style: Theme.of(context).textTheme.titleLarge!,
                          ),
                        )
                      : SizedBox(
                          width: double.infinity,
                          child: DataTablePaginated(
                            titleTable:
                                'Editando políticas de ${args?.name ?? application.name} ${roleSelected != null ? '- Papel: ${roleSelected?.name}' : ''}',
                            viewModel: widget.viewModel,
                            streamList: widget.viewModel.policies,
                            dialogs: null,
                            initialFilters: initialFilters,
                            columnsDef: const [
                              DataColumn(
                                label: Text(
                                  'Nome',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'URL',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Método',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Bypass',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Sysadmin',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                            fieldsData: routesRowValues,
                            labelInclude: routesListLabelInclude,
                            validActionsList: const [],
                            actions: [
                              OnHoverButton(
                                child: IconButton.outlined(
                                  onPressed: () async {
                                    var result = await EditPolicyDialog(
                                      context: context,
                                      disponiveis: widget
                                          .viewModel.avaliableCapabilities,
                                      roleId: roleSelected!.id,
                                    ).addDialog();
                                    if (result != null && result == true) {
                                      onReload();
                                    }
                                  },
                                  tooltip: 'Adicionar políticas de acesso',
                                  icon: Icon(
                                    Icons.add_outlined,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              OnHoverButton(
                                child: IconButton.outlined(
                                  onPressed: () async {
                                    var selecteds = selectedPolicies
                                        .where((element) => element.selected)
                                        .toList();
                                    if (selecteds.isNotEmpty) {
                                      var result =
                                          await Dialogs(context: context)
                                              .showConfirmDialog({
                                        'title_text':
                                            'Removendo políticas de acesso',
                                        'title_icon': Icons.delete_outline,
                                        'message':
                                            'Você tem certeza que deseja executar essa ação?\n${selecteds.length.toString() + ' itens'.toUpperCase()} serão removidos.'
                                      });
                                      if (result != null &&
                                          result == true &&
                                          context.mounted) {
                                        widget.viewModel.onRemovePolicies(
                                          showInfoMessage,
                                          context,
                                          selecteds,
                                        );
                                      }
                                    }
                                  },
                                  tooltip: 'Remover políticas de acesso',
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                            ],
                            items: selectedPolicies.map((e) {
                              return e.toJson();
                            }).toList(),
                          ),
                        ),
                  // DataTableNotPaginated(
                  //   viewModel: viewModel,
                  //   items: items,
                  // ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
