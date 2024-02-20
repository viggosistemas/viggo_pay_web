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
      cells: <DataCell>[for (var key in fieldsData) cellFor(row[key])],
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
    List<Widget>? actions,
  }) {
    if (actions != null) {
      this.actions.addAll(actions);
    }
  }

  late dynamic viewModel;
  List<dynamic> items;
  List<DataColumn> columnsDef;
  List<String> fieldsData;
  List<Widget> actions = [];

  @override
  State<DataTablePaginated> createState() => _DataTablePaginatedState();
}

class _DataTablePaginatedState extends State<DataTablePaginated> {
  int _currentPage = 0;
  int _pageSize = 10;
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
    widget.actions = [
      IconButton.outlined(
        onPressed: () => onAddEntity(),
        tooltip: 'Adicionar',
        icon: const Icon(
          Icons.add,
        ),
      ),
      const SizedBox(
        width: 10,
      ),
      IconButton.outlined(
        onPressed: () => onEditEntity(),
        tooltip: 'Editar',
        icon: const Icon(
          Icons.edit,
        ),
      ),
      const SizedBox(
        width: 10,
      ),
      IconButton.outlined(
        onPressed: () => onChangeActive(),
        tooltip: 'Alterar status',
        icon: const Icon(
          Icons.change_circle,
        ),
      ),
      const SizedBox(
        width: 10,
      ),
      IconButton.outlined(
        onPressed: () => onReloadData(),
        tooltip: 'Recarregar',
        icon: const Icon(
          Icons.replay,
        ),
      ),
    ];
    super.initState();
  }

  void onAddEntity() {}

  void onEditEntity() {
    var len =
        dataSource.sortedData.where((element) => element['selected']).length;
    if (len == 1) {
      var entity =
          dataSource.sortedData.firstWhere((element) => element['selected']);
      print(entity);
    }
  }

  void onChangeActive() {
    var selecteds =
        dataSource.sortedData.where((element) => element['selected']);
    var isActiveOnly = selecteds.where((element) => element['active'] == true);
    var isInactiveOnly =
        selecteds.where((element) => element['active'] == false);

    if (isActiveOnly.isNotEmpty && isInactiveOnly.isEmpty) {
      print(isActiveOnly);
    } else if (isActiveOnly.isEmpty && isInactiveOnly.isNotEmpty) {
      print(isInactiveOnly);
    }
  }

  void onReloadData() {
  //   setState(() {
  //     widget.viewModel.loadData(0, 10, true);
  //     widget.viewModel.domains.listen((value) {
  //       dataSource.setData(value.map((e) {
  //         return e.toJson();
  //       }).toList());
  //     });
  //   });
  }

// FIXME: A PAGINAÇÃO NÃO ESTA SENDO VIA REQUISIÇÃO ATÉ O MOMENTO, ELA ESTA SENDO SOMENTE VIA COMPONENTE
  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable(
      // sortColumnIndex: _columnIndex,
      // sortAscending: _columnAscending,
      // actions: [
      //   IconButton.outlined(
      //     onPressed: () {},
      //     icon: const Icon(
      //       Icons.search,
      //     ),
      //   ),
      // ],
      availableRowsPerPage: const [5, 10, 25, 50],
      onRowsPerPageChanged: (value) {
        setState(() {
          _pageSize = value!;
          // widget.viewModel.loadData(_currentPage, _pageSize, true);
          // widget.viewModel.domains.listen((value) {
          //   dataSource.setData(value.map((e) {
          //     return e.toJson();
          //   }).toList());
          // });
        });
      },
      headingRowColor: MaterialStateColor.resolveWith(
        (states) => Colors.grey.withOpacity(0.7),
      ),
      header: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ...widget.actions.toList(),
        ],
      ),
      rowsPerPage: _pageSize,
      arrowHeadColor: Theme.of(context).colorScheme.primary,
      onPageChanged: (value) {
        setState(() {
          //COMPARA OS INDEX DA PRIMEIRA LINHA SE FOREM IGUAIS SOMO UMA PAGINA
          var last = dataSource.sortedData.last;
          var lastIndex = dataSource.sortedData.lastIndexOf(last);
          if (value == lastIndex) {
            _currentPage++;
          } else {
            _currentPage--;
          }
          // widget.viewModel.loadData(_currentPage, _pageSize, true);
          // widget.viewModel.domains.listen((value) {
          //   dataSource.setData(value.map((e) {
          //     return e.toJson();
          //   }).toList());
          // });
        });
      },
      initialFirstRowIndex: _currentPage,
      showFirstLastButtons: true,
      showCheckboxColumn: true,
      columns: widget.columnsDef,
      source: dataSource,
    );
  }
}
