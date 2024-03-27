import 'package:flutter/material.dart';
import 'package:viggo_core_frontend/route/data/models/route_api_dto.dart';
import 'package:viggo_core_frontend/util/list_options.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/data_table_paginated.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/header-search/ui/header_search_main.dart';
import 'package:viggo_pay_admin/components/progress_loading.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/route/ui/edit_routes/edit_routes.dart';
import 'package:viggo_pay_admin/route/ui/list_routes/list_route_web_view_model.dart';
import 'package:viggo_pay_admin/utils/show_msg_snackbar.dart';

class ListRoutesGrid extends StatefulWidget {
  const ListRoutesGrid({super.key});

  @override
  State<ListRoutesGrid> createState() => _ListRoutesGridState();
}

class _ListRoutesGridState extends State<ListRoutesGrid> {
  ListRouteWebViewModel viewModel = locator.get<ListRouteWebViewModel>();

  static const routesValidActions = [
    {
      'backendUrl': '/routes',
      'method': 'POST',
    },
    {
      'backendUrl': '/routes/<id>',
      'method': 'PUT',
    },
    {
      'backendUrl': '/routes/<id>',
      'method': 'DELETE',
    },
  ];

  static const routesRowValues = [
    'name',
    'url',
    'method',
    'bypass',
    'sysadmin'
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

  List<Map<String, dynamic>> searchFields = [
    {
      'label': 'Nome',
      'search_field': 'name',
      'type': 'text',
      'icon': Icons.abc,
    },
    {
      'label': 'URL',
      'search_field': 'url',
      'type': 'text',
      'icon': Icons.route_outlined,
    },
    {
      'label': 'Método',
      'search_field': 'method',
      'type': 'enum',
      'icon': Icons.http_outlined,
    },
    {
      'label': 'Tipo',
      'search_field': 'bypass',
      'type': 'bool',
      'icon': Icons.shape_line_outlined,
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
        if(element['search_field'] == 'bypass') {
          filters.addEntries(
            <String, String>{element['value']: 'true'}.entries,
          );
        }else{
          filters.addEntries(
            <String, String>{element['search_field']: fieldValue}.entries,
          );
        }
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
    final dialogs = EditRoutes(context: context);
    onReload();

    viewModel.errorMessage.listen(
      (value) {
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
      },
    );
    return StreamBuilder<List<RouteApiDto>>(
      stream: viewModel.routes,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          onReload();
          return ProgressLoading(
            color: Theme.of(context).brightness == Brightness.dark
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).colorScheme.primary,
          );
        } else {
          List<RouteApiDto> items = (snapshot.data as List<RouteApiDto>);
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
                    itemsSelect: itemSelect,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: DataTablePaginated(
                      viewModel: viewModel,
                      streamList: viewModel.routes,
                      dialogs: dialogs,
                      initialFilters: filters,
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
                      validActionsList: routesValidActions,
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
        }
      },
    );
  }
}
