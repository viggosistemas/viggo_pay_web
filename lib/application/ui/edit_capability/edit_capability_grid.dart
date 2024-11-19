import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viggo_core_frontend/application/data/models/application_api_dto.dart';
import 'package:viggo_core_frontend/capability/data/models/capability_api_dto.dart';
import 'package:viggo_core_frontend/route/data/models/route_api_dto.dart';
import 'package:viggo_core_frontend/util/list_options.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/header-search/ui/header_search_main.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/list-view-data/table/data_table_paginated.dart';
import 'package:viggo_pay_admin/application/ui/components/dialog_manage_capability.dart';
import 'package:viggo_pay_admin/application/ui/edit_capability/edit_capability_view_model.dart';
import 'package:viggo_pay_admin/components/dialogs.dart';
import 'package:viggo_pay_admin/components/hover_button.dart';
import 'package:viggo_pay_admin/components/progress_loading.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/utils/show_msg_snackbar.dart';

// ignore: must_be_immutable
class EditCapabilityGrid extends StatefulWidget {
  EditCapabilityGrid({super.key});

  EditCapabilityViewModel viewModel = locator.get<EditCapabilityViewModel>();
  SharedPreferences sharedPrefs = locator.get<SharedPreferences>();

  @override
  State<EditCapabilityGrid> createState() => _EditCapabilityGridState();
}

class _EditCapabilityGridState extends State<EditCapabilityGrid> {
  Map<String, String> initialFilters = {};
  List<CapabilityApiDto> selectedCapabilitites = [];

  static const routesRowValues = ['route', 'route', 'route', 'route', 'route'];

  static const routesListLabelInclude = ['name', 'url', 'method', 'bypass', 'sysadmin'];

  loadCapabilities(
    ApplicationApiDto selected,
    Map<String, String> searchFilters,
  ) {
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

    widget.viewModel.loadData(filters);
    widget.viewModel.listRoutes();
  }

  checkApplication(ApplicationApiDto? selected) {
    String? key = widget.sharedPrefs.getString('APPLICATION_SELECTED');
    if (key != null) {
      if (selected != null) {
        widget.sharedPrefs.setString('APPLICATION_SELECTED', jsonEncode(selected));
        loadCapabilities(selected, {});
      } else {
        ApplicationApiDto application = ApplicationApiDto.fromJson(jsonDecode(key));
        loadCapabilities(application, {});
      }
    } else {
      widget.sharedPrefs.setString('APPLICATION_SELECTED', jsonEncode(selected));
      loadCapabilities(selected!, {});
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
    {
      'label': 'URL',
      'search_field': 'route.url',
      'type': 'text',
      'icon': Icons.route_outlined,
    },
    {
      'label': 'Método',
      'search_field': 'route.method',
      'type': 'enum',
      'icon': Icons.http_outlined,
    },
    {
      'label': 'Tipo',
      'search_field': 'route.bypass',
      'type': 'bool',
      'icon': Icons.shape_line_outlined,
    },
  ];

  final List<Map<String, dynamic>> itemSelect = [
    {
      'value': 'bypass',
      'label': 'BYPASS',
      'type': 'bool',
    },
    {
      'value': 'sysadmin',
      'label': 'SYSADMIN',
      'type': 'bool',
    },
    {
      'value': METHOD.PUT.name,
      'label': METHOD.PUT.name,
      'type': 'enum',
    },
    {
      'value': METHOD.POST.name,
      'label': METHOD.POST.name,
      'type': 'enum',
    },
    {
      'value': METHOD.DELETE.name,
      'label': METHOD.DELETE.name,
      'type': 'enum',
    },
    {
      'value': METHOD.GET.name,
      'label': METHOD.GET.name,
      'type': 'enum',
    },
    {
      'value': METHOD.LIST.name,
      'label': METHOD.LIST.name,
      'type': 'enum',
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
      if (element['value'].toString().isNotEmpty) {
        var fieldValue = '';

        if (element['type'] == 'text') {
          fieldValue = '%${element['value']}%';
        } else {
          fieldValue = element['value'];
        }

        if (element['search_field'] == 'route.bypass') {
          filters.addEntries(
            <String, String>{'route.$fieldValue': 'true'}.entries,
          );
        } else {
          filters.addEntries(
            <String, String>{element['search_field']: fieldValue}.entries,
          );
        }
      }
    }

    loadCapabilities(application, filters);
  }

  onReload() {
    loadCapabilities(application, {});
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as ApplicationApiDto?;

    widget.viewModel.isSuccess.listen((value) {
      showInfoMessage(
        context,
        2,
        Colors.green,
        'Capacidades removidas com sucesso!',
        'X',
        () {},
        Colors.white,
      );
      onReload();
    });

    widget.viewModel.errorMessage.listen(
      (value) {
        if (value.isNotEmpty && context.mounted) {
          widget.viewModel.clearError();
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

    return StreamBuilder<List<CapabilityApiDto>>(
      stream: widget.viewModel.capabilities,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          checkApplication(args);
          return ProgressLoading(
            color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.primary,
          );
        } else {
          selectedCapabilitites = (snapshot.data as List<CapabilityApiDto>);
          return SizedBox(
            height: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  HeaderSearchMain(
                    onReload: onReload,
                    onSearch: onSearch,
                    searchFields: searchFields,
                    notShowAdvancedFilters: true,
                    itemsSelect: itemSelect,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: DataTablePaginated(
                      titleTable: 'Editando capacidades de ${args?.name ?? application.name}',
                      viewModel: widget.viewModel,
                      streamList: widget.viewModel.capabilities,
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
                        StreamBuilder<List<RouteApiDto>>(
                            stream: widget.viewModel.routesSistema,
                            builder: (context, rotas) {
                              if (rotas.data == null) {
                                widget.viewModel.listRoutes();
                                return OnHoverButton(
                                  child: IconButton.outlined(
                                    onPressed: () {},
                                    tooltip: 'Adicionar capacidades',
                                    icon: Icon(
                                      Icons.add_outlined,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                );
                              } else {
                                return OnHoverButton(
                                  child: IconButton.outlined(
                                    onPressed: () async {
                                      for (var c in selectedCapabilitites) {
                                        var rotaSelecionada = rotas.data!.firstWhere((rota) => c.routeId == rota.id);
                                        rotas.data!.remove(rotaSelecionada);
                                      }
                                      if (rotas.data!.isNotEmpty) {
                                        widget.viewModel.listRoutes();
                                        var result = await EditCapabilityDialog(
                                          context: context,
                                          disponiveis: rotas.data!,
                                          mockSelectedList: widget.viewModel.mockSelectedList,
                                          applicationId: application.id,
                                        ).addDialog();
                                        if (result != null && result == true) {
                                          onReload();
                                        }else{
                                          widget.viewModel.clearRouteSelected();
                                        }
                                      }else{
                                        widget.viewModel.listRoutes();
                                      }
                                    },
                                    tooltip: selectedCapabilitites.length != rotas.data!.length
                                        ? 'Adicionar capacidades'
                                        : 'Todas as capacidades foram adicionadas',
                                    icon: Icon(
                                      Icons.add_outlined,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                );
                              }
                            }),
                        const SizedBox(width: 10),
                        IconButton.outlined(
                          onPressed: () async {
                            var selecteds = selectedCapabilitites.where((element) => element.selected).toList();
                            if (selecteds.isNotEmpty) {
                              var result = await Dialogs(context: context).showConfirmDialog({
                                'title_text': 'Removendo capacidades',
                                'title_icon': Icons.delete_outline,
                                'message':
                                    'Você tem certeza que deseja executar essa ação?\n${selecteds.length.toString() + ' itens'.toUpperCase()} serão removidos.'
                              });
                              if (result != null && result == true && context.mounted) {
                                widget.viewModel.onRemoveCapabilitites(
                                  showInfoMessage,
                                  context,
                                  selecteds,
                                );
                              }
                            }
                          },
                          tooltip: 'Remover capacidades',
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                      items: selectedCapabilitites.map((e) {
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
