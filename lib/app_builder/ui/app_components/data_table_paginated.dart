import 'package:flutter/material.dart';

class DataSource extends DataTableSource {
  late dynamic viewModel;

  // static const List<int> _displayIndexToRawIndex = <int>[0, 3, 4, 5, 6];

  late List<dynamic> sortedData;
  late List<String> fieldsData;
  int _selectedCount = 0;

  void setData(
    dynamic rawData,
    // int sortColumn,
    // bool sortAscending,
  ) {
    sortedData = rawData.toList();
    // ..sort((List<Comparable<Object>> a, List<Comparable<Object>> b) {
    //   final Comparable<Object> cellA = a[_displayIndexToRawIndex[sortColumn]];
    //   final Comparable<Object> cellB = b[_displayIndexToRawIndex[sortColumn]];
    //   return cellA.compareTo(cellB) * (sortAscending ? 1 : -1);
    // });
    notifyListeners();
  }

  static DataCell cellFor(Object data) {
    String value;
    if (data is DateTime) {
      value =
          '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
    } else {
      value = data.toString();
    }
    return DataCell(Text(value));
  }

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= sortedData.length) return null;
    final row = sortedData[index];
    return DataRow(
      cells: <DataCell>[
        for (var key in fieldsData) cellFor(row[key])
      ],
      selected: row['selected'],
      onSelectChanged: (value) {
        if (row['selected'] != value) {
          _selectedCount += value! ? 1 : -1;
          assert(_selectedCount >= 0);
          row['selected'] = value;
          notifyListeners();
        }
        // row['selected'] = value!;
        // viewModel.checkItem(row.id);
        // notifyListeners();
      },
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
class DataTablePaginated extends StatefulWidget {
  DataTablePaginated({
    super.key,
    required this.items,
    required this.columnsDef,
    required this.fieldsData,
    required this.viewModel,
  });

  late dynamic viewModel;
  List<dynamic> items;
  List<DataColumn> columnsDef;
  List<String> fieldsData;

  @override
  State<DataTablePaginated> createState() => _DataTablePaginatedState();
}

class _DataTablePaginatedState extends State<DataTablePaginated> {
  DataSource dataSource = DataSource();
  // int _columnIndex = 0;
  // bool _columnAscending = true;

  // void _sort(int columnIndex, bool ascending) {
  //   setState(() {
  //     _columnIndex = columnIndex;
  //     _columnAscending = ascending;
  //     dataSource.setData(episodes, _columnIndex, _columnAscending);
  //   });
  // }

  @override
  void initState() {
    dataSource.viewModel = widget.viewModel;
    dataSource.setData(widget.items);
    dataSource.fieldsData = widget.fieldsData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable(
      // sortColumnIndex: _columnIndex,
      // sortAscending: _columnAscending,
      actions: [
        IconButton.outlined(
          onPressed: () {},
          icon: const Icon(
            Icons.search,
          ),
        ),
      ],
      availableRowsPerPage: const [5, 10, 25, 50],
      header: const Text('Header'),
      rowsPerPage: widget.items.length > 10 ? 10 : widget.items.length,
      initialFirstRowIndex: 0,
      showFirstLastButtons: true,
      showCheckboxColumn: true,
      columns: widget.columnsDef,
      source: dataSource,
    );
  }
}
