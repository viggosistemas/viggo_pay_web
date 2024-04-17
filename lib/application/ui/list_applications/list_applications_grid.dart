import 'package:flutter/material.dart';
import 'package:viggo_core_frontend/application/data/models/application_api_dto.dart';
import 'package:viggo_core_frontend/util/list_options.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/header-search/ui/header_search_main.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/list-view-data/card/list_view_mode_card.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/list-view-data/table/data_table_paginated.dart';
import 'package:viggo_pay_admin/application/ui/edit_applications/edit_applications.dart';
import 'package:viggo_pay_admin/application/ui/list_applications/list_application_web_view_model.dart';
import 'package:viggo_pay_admin/components/hover_button.dart';
import 'package:viggo_pay_admin/components/progress_loading.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/utils/constants.dart';
import 'package:viggo_pay_admin/utils/show_msg_snackbar.dart';

class ListApplicationsGrid extends StatefulWidget {
  const ListApplicationsGrid({super.key});

  @override
  State<ListApplicationsGrid> createState() => _ListApplicationsGridState();
}

class _ListApplicationsGridState extends State<ListApplicationsGrid> {
  ListApplicationWebViewModel viewModel = locator.get<ListApplicationWebViewModel>();

  static const applicationValidActions = [
    {
      'backendUrl': '/applications',
      'method': 'POST',
    },
    {
      'backendUrl': '/applications/<id>',
      'method': 'PUT',
    },
    {
      'backendUrl': '/applications/<id>',
      'method': 'DELETE',
    },
  ];

  static const applicationsRowValues = ['name'];

  List<Map<String, dynamic>> searchFields = [
    {
      'label': 'Nome',
      'search_field': 'name',
      'type': 'text',
      'icon': Icons.abc,
    },
  ];

  Map<String, String> filters = {
    'order_by': 'name',
    'list_options': ListOptions.ACTIVE_ONLY.name,
  };

  void onSearch(List<Map<String, dynamic>> params) {
    filters = {};
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
        filters.addEntries(
          <String, String>{element['search_field']: fieldValue}.entries,
        );
      }
    }

    filters.addEntries(
      <String, String>{'order_by': 'name'}.entries,
    );

    viewModel.loadData(filters);
  }

  onReload() {
    viewModel.loadData(filters);
  }

  @override
  Widget build(BuildContext context) {
    final dialogs = EditApplications(context: context);
    onReload();

    viewModel.errorMessage.listen(
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

    onEditCapability(entity) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          Navigator.of(context).pushReplacementNamed(
            Routes.EDIT_CAPABILITY,
            arguments: ApplicationApiDto.fromJson(entity),
          );
        },
      );
    }

    onEditPolicy(entity) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          Navigator.of(context).pushReplacementNamed(
            Routes.EDIT_POLICY,
            arguments: ApplicationApiDto.fromJson(entity),
          );
        },
      );
    }

    return StreamBuilder<List<ApplicationApiDto>>(
      stream: viewModel.applications,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          onReload();
          return ProgressLoading(
            color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.primary,
          );
        } else {
          List<ApplicationApiDto> items = (snapshot.data as List<ApplicationApiDto>);
          return LayoutBuilder(builder: (context, constraints) {
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
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: constraints.maxWidth <= 960
                          ? Padding(
                              padding: const EdgeInsets.all(50.0),
                              child: ListViewCard(
                                onReloadData: onReload,
                                viewModel: viewModel,
                                dialogs: dialogs,
                                fieldsData: 'name',
                                validActionsList: applicationValidActions,
                                actions: [
                                  PopupMenuItem<dynamic>(
                                    value: {'action': onEditCapability, 'type': 'DETAIL'},
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Editar capacidades",
                                          style: TextStyle(
                                            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                                          ),
                                        ),
                                        Icon(
                                          Icons.polyline_outlined,
                                          size: 18,
                                          color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem<dynamic>(
                                    value: {'action': onEditPolicy, 'type': 'DETAIL'},
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Editar políticas",
                                          style: TextStyle(
                                            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                                          ),
                                        ),
                                        Icon(
                                          Icons.policy_outlined,
                                          size: 18,
                                          color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                items: items.map((e) {
                                  return e.toJson();
                                }).toList(),
                              ),
                            )
                          : DataTablePaginated(
                              viewModel: viewModel,
                              streamList: viewModel.applications,
                              dialogs: dialogs,
                              initialFilters: filters,
                              actions: [
                                StreamBuilder<List<ApplicationApiDto>>(
                                    stream: viewModel.applications,
                                    builder: (context, snapshot) {
                                      if (snapshot.data == null) {
                                        return OnHoverButton(
                                          child: IconButton.outlined(
                                            onPressed: () => {},
                                            tooltip: 'Editar capacidades',
                                            icon: const Icon(
                                              Icons.polyline_outlined,
                                            ),
                                          ),
                                        );
                                      } else {
                                        var lengthSelected = snapshot.data!.where((element) => element.selected).length;
                                        // ignore: avoid_init_to_null
                                        ApplicationApiDto? selected = null;
                                        if (lengthSelected == 1) {
                                          selected = snapshot.data!.where((element) => element.selected).first;
                                        }
                                        return OnHoverButton(
                                          child: IconButton.outlined(
                                            onPressed: () => lengthSelected == 1
                                                ? WidgetsBinding.instance.addPostFrameCallback(
                                                    (_) {
                                                      Navigator.of(context).pushReplacementNamed(
                                                        Routes.EDIT_CAPABILITY,
                                                        arguments: selected,
                                                      );
                                                    },
                                                  )
                                                : {},
                                            tooltip: 'Editar capacidades',
                                            icon: const Icon(
                                              Icons.polyline_outlined,
                                            ),
                                          ),
                                        );
                                      }
                                    }),
                                const SizedBox(width: 10),
                                StreamBuilder<List<ApplicationApiDto>>(
                                    stream: viewModel.applications,
                                    builder: (context, snapshot) {
                                      if (snapshot.data == null) {
                                        return OnHoverButton(
                                          child: IconButton.outlined(
                                            onPressed: () => {},
                                            tooltip: 'Editar políticas',
                                            icon: const Icon(
                                              Icons.policy_outlined,
                                            ),
                                          ),
                                        );
                                      } else {
                                        var lengthSelected = snapshot.data!.where((element) => element.selected).length;
                                        // ignore: avoid_init_to_null
                                        ApplicationApiDto? selected = null;
                                        if (lengthSelected == 1) {
                                          selected = snapshot.data!.where((element) => element.selected).first;
                                        }
                                        return OnHoverButton(
                                          child: IconButton.outlined(
                                            onPressed: () => lengthSelected == 1
                                                ? WidgetsBinding.instance.addPostFrameCallback(
                                                    (_) {
                                                      Navigator.of(context).pushReplacementNamed(
                                                        Routes.EDIT_POLICY,
                                                        arguments: selected,
                                                      );
                                                    },
                                                  )
                                                : {},
                                            tooltip: 'Editar políticas',
                                            icon: const Icon(
                                              Icons.policy_outlined,
                                            ),
                                          ),
                                        );
                                      }
                                    }),
                                const SizedBox(width: 10),
                              ],
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
                              ],
                              fieldsData: applicationsRowValues,
                              validActionsList: applicationValidActions,
                              items: items.map((e) {
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
          });
        }
      },
    );
  }
}
