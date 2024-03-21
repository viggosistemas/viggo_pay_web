import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DataTableNotPaginated extends StatefulWidget {
  DataTableNotPaginated({
    super.key,
    required this.items,
    required this.viewModel,
  });

  late dynamic viewModel;
  List<dynamic> items;

  @override
  State<DataTableNotPaginated> createState() => _DataTableNotPaginatedState();
}

class _DataTableNotPaginatedState extends State<DataTableNotPaginated> {
  @override
  Widget build(context) {
    return DataTable(
      columns: const <DataColumn>[
        DataColumn(
          label: Text('Name'),
        )
      ],
      rows: List<DataRow>.generate(
        widget.items.length,
        (int index) => DataRow(
          color: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              // All rows will have the same selected color.
              if (states.contains(MaterialState.selected)) {
                return Theme.of(context).colorScheme.primary.withOpacity(0.08);
              }
              // Even rows will have a grey color.
              if (index.isEven) {
                return Colors.grey.withOpacity(0.3);
              }
              return null; // Use default value for other states and odd rows.
            },
          ),
          cells: <DataCell>[
            DataCell(
              Text(widget.items[index].name),
            ),
          ],
          selected: widget.items[index].selected,
          onSelectChanged: (bool? value) {
            setState(() {
              widget.items[index].selected = value!;
              widget.viewModel.checkItem(widget.items[index].id);
            });
          },
        ),
      ),
    );
  }
}
