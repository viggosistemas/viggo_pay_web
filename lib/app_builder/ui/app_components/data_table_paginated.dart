import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:viggo_pay_admin/components/dialogs.dart';

class DataSource extends DataTableSource {
  late dynamic viewModel;
  late String labelInclude;

  // static const List<int> _displayIndexToRawIndex = <int>[0, 3, 4, 5, 6];

  late List<dynamic> sortedData;
  late List<String> fieldsData;
  // int _selectedCount = 0;

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

  DataCell cellFor(dynamic data) {
    String value;
    if (data is DateTime) {
      value =
          '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
    } else {
      if (data == null) {
        value = '-';
      } else {
        if(data is String){
          value = data.toString();
        }else{
          var dataString = jsonEncode(data);
          value = jsonDecode(dataString)[labelInclude].toString();
        }
      }
    }
    return DataCell(Text(value));
  }

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= sortedData.length) return null;
    final row = sortedData[index];
    return DataRow(
      cells: <DataCell>[for (var key in fieldsData)cellFor(row[key])],
      selected: row['selected'],
      color: MaterialStateColor.resolveWith(
        (states) =>
            row['active'] == false ? Colors.red.withOpacity(0.7) : Colors.white,
      ),
      onSelectChanged: (value) {
        // if (row['selected'] != value) {
        // _selectedCount += value! ? 1 : -1;
        // assert(_selectedCount >= 0);
        //   row['selected'] = value;
        //   notifyListeners();
        // }
        viewModel.checkItem(row['id']);
        row['selected'] = value;
        notifyListeners();
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
    required this.initialFilters,
    required this.streamList,
    required this.dialogs,
    labelInclude,
    List<Widget>? actions,
  }) {
    if (actions != null) {
      appendActions = true;
      this.actions.addAll(actions);
    }
    if(labelInclude != null){
      this.labelInclude = labelInclude;
    }
  }

  late dynamic viewModel;
  late dynamic dialogs;
  late dynamic labelInclude = '';
  late Stream<dynamic> streamList;
  late Map<String, String> initialFilters;
  late List<dynamic> items;
  late List<DataColumn> columnsDef;
  late List<String> fieldsData;
  late List<Widget> actions = [];
  var appendActions = false;

  @override
  State<DataTablePaginated> createState() => _DataTablePaginatedState();
}

class _DataTablePaginatedState extends State<DataTablePaginated> {
  int _currentPage = 0;
  int _pageSize = 10;
  DataSource dataSource = DataSource();
  bool isLoading = true;
  // int _columnIndex = 0;
  // bool _columnAscending = true;

  // void _sort(int columnIndex, bool ascending) {
  //   setState(() {
  //     _columnIndex = columnIndex;
  //     _columnAscending = ascending;
  //     dataSource.setData(episodes, _columnIndex, _columnAscending);
  //   });
  // }

  initializeTable() {
    if (widget.actions.isEmpty || widget.appendActions) {
      widget.appendActions = false;
      List<Widget> actionsDefault = [
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
      actionsDefault.addAll(widget.actions);
      widget.actions = actionsDefault;
    }
    dataSource.labelInclude = widget.labelInclude;
    dataSource.viewModel = widget.viewModel;
    dataSource.setData(widget.items);
    dataSource.fieldsData = widget.fieldsData;
    isLoading = false;
  }

  void onAddEntity() async {
    var result = await widget.dialogs.addDialog();
    if (result != null && result == true) {
      onReloadData();
    }
  }

  void onEditEntity(){
    var len =
        dataSource.sortedData.where((element) => element['selected']).length;
    if (len == 1) {
      var entity =
          dataSource.sortedData.firstWhere((element) => element['selected']);
      var catchEntity = widget.viewModel.catchEntity(entity['id']) as Future;
      catchEntity.then((value) async {
        var result = await widget.dialogs.editDialog(value);
        if (result != null && result == true) {
          onReloadData();
        }
      });
    }
  }

  void onChangeActive() async {
    List<Map<String, dynamic>> entities = [];
    var selecteds =
        dataSource.sortedData.where((element) => element['selected']);
    var isActiveOnly =
        selecteds.where((element) => element['active'] == true).toList();
    var isInactiveOnly =
        selecteds.where((element) => element['active'] == false).toList();

    if (isActiveOnly.isNotEmpty && isInactiveOnly.isEmpty) {
      for (var e in isActiveOnly) {
        entities.add({
          'id': e['id'],
          'body': {
            'id': e['id'],
            'active': !e['active'],
          }
        });
      }
      var result = await Dialogs(context: context).showConfirmDialog({
        'title_text': 'Inativando itens',
        'title_icon': Icons.person_add_disabled_outlined,
        'message':
            'Você tem certeza que deseja executar essa ação?\n${entities.length.toString() + ' itens'.toUpperCase()} serão inativados.'
      });
      if (result != null && result == true) {
        widget.viewModel.changeActive.invoke(entities: entities);
        onReloadData();
      }
    } else if (isActiveOnly.isEmpty && isInactiveOnly.isNotEmpty) {
      for (var e in isInactiveOnly) {
        entities.add({
          'id': e['id'],
          'body': {
            'id': e['id'],
            'active': !e['active'],
          }
        });
      }
      var result = await Dialogs(context: context).showConfirmDialog({
        'title_text': 'Ativando itens',
        'title_icon': Icons.person_add_outlined,
        'message':
            'Você tem certeza que deseja executar essa ação?\n${entities.length.toString() + ' itens'.toUpperCase()} serão ativados.'
      });
      if (result != null && result == true) {
        widget.viewModel.changeActive.invoke(entities: entities);
        onReloadData();
      }
    }
  }

  void onReloadData() {
    isLoading = true;
    setState(() {
      widget.viewModel.loadData(widget.initialFilters);
      widget.streamList.listen((value) {
        dataSource.setData(value.map((e) {
          return e.toJson();
        }).toList());
      });
      widget.viewModel.clearSelectedItems.invoke();
      isLoading = false;
    });
  }

// FIXME: A PAGINAÇÃO NÃO ESTA SENDO VIA REQUISIÇÃO ATÉ O MOMENTO, ELA ESTA SENDO SOMENTE VIA COMPONENTE
  @override
  Widget build(BuildContext context) {
    initializeTable();

    return //widget.items.isNotEmpty ?
        PaginatedDataTable(
      // sortColumnIndex: _columnIndex,
      // sortAscending: _columnAscending,
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
    // : SizedBox(
    //     height: MediaQuery.of(context).size.height * 0.5,
    //     child: const Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       children: [
    //         Icon(
    //           Icons.info_outline,
    //           color: Colors.black,
    //         ),
    //         SizedBox(
    //           height: 10,
    //         ),
    //         Text('Nenhum resultado encontrado!')
    //       ],
    //     ),
    //   );
  }
}
