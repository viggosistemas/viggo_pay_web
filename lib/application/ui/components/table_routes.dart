import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/utils/format_mask.dart';

/// Flutter code sample for [PaginatedDataTable].

class DataSourceRoutes extends DataTableSource {
  late List<dynamic> mockSelectedList = [];
  late List<String> labelInclude = [];
  late int counter = 0;
  late List<dynamic> sortedData;
  late List<String> fieldsData;
  late dynamic viewModel;

  void setData(dynamic rawData) {
    sortedData = rawData.toList();
    notifyListeners();
  }

  String seeRowDatas(dynamic data, String value, String? key) {
    if (data == null) {
      value = '-';
      counter++;
      if (labelInclude.length == counter) {
        counter = 0;
      }
    } else {
      if (data is String) {
        value = data.toString();
        if (key == 'client_tax_identifier_tax_id') {
          value = FormatMask().formated(value);
        }
      } else if (data is bool) {
        value = data == true ? 'Sim' : 'Não';
      } else if (data is Enum) {
        value = data.name.replaceAll('_', ' ');
      } else {
        var dataString = jsonEncode(data);
        value = jsonDecode(dataString)[labelInclude[counter]].toString();
        if (labelInclude[counter] == 'cpf_cnpj') {
          value = FormatMask().formated(jsonDecode(dataString)[labelInclude[counter]].toString());
        } else {
          value = seeRowDatas(jsonDecode(dataString)[labelInclude[counter]], value, key);
        }
        counter++;
        if (labelInclude.length == counter) {
          counter = 0;
        }
      }
    }
    return value;
  }

  DataCell cellFor(dynamic data, String? key) {
    String value = '';
    if (data is DateTime) {
      value = '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
    } else {
      value = seeRowDatas(data, value, key);
    }
    return DataCell(Text(value));
  }

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= sortedData.length) return null;
    final row = sortedData[index];
    return DataRow(
      onSelectChanged: (value) {
        row['selected'] = value;
        viewModel.mockSelectedList = mockSelectedList;
        viewModel.addOrRemove(row);
        viewModel.checkRouteSelected(row['id']);
        row['selected'] = value;
        notifyListeners();
      },
      selected: row['selected'],
      cells: <DataCell>[
        for (var key in fieldsData)
          key.split('.').length == 1 ? cellFor(row[key], key) : cellFor(row[key.split('.')[0]].toJson()[key.split('.')[1]], null)
      ],
    );
  }

  @override
  int get rowCount => sortedData.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}

// ignore: must_be_immutable
class DataTableRoutes extends StatefulWidget {
  DataTableRoutes({
    super.key,
    required this.viewModel,
    required this.items,
    required this.fieldsData,
    required this.title,
    labelInclude,
    mockSelectedList,
  }) {
    if (labelInclude != null) {
      this.labelInclude = labelInclude;
    }
    if (mockSelectedList != null) {
      this.mockSelectedList = mockSelectedList;
    }
  }

  late Widget title;
  late dynamic viewModel;
  late dynamic labelInclude = [''];
  late List<dynamic> items;
  late List<dynamic> mockSelectedList = [];
  late List<String> fieldsData;

  @override
  State<DataTableRoutes> createState() => _DataTableRoutesState();
}

class _DataTableRoutesState extends State<DataTableRoutes> {
  DataSourceRoutes dataSource = DataSourceRoutes();

  @override
  Widget build(BuildContext context) {
    dataSource.setData(widget.items);
    dataSource.fieldsData = widget.fieldsData;
    dataSource.labelInclude = widget.labelInclude;
    dataSource.mockSelectedList = widget.mockSelectedList;
    dataSource.viewModel = widget.viewModel;

    return PaginatedDataTable(
      showEmptyRows: false,
      showCheckboxColumn: true,
      arrowHeadColor: Theme.of(context).colorScheme.primary,
      showFirstLastButtons: true,
      header: widget.title,
      columns: const <DataColumn>[
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
      source: dataSource,
    );
  }
}
