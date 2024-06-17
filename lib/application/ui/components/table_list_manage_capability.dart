import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:viggo_core_frontend/route/data/models/route_api_dto.dart';
import 'package:viggo_pay_admin/application/ui/components/table_routes.dart';
import 'package:viggo_pay_admin/application/ui/edit_capability/edit_capability_view_model.dart';
import 'package:viggo_pay_admin/components/hover_button.dart';

// ignore: must_be_immutable
class TableListCapability extends StatefulWidget {
  TableListCapability({
    super.key,
    required this.viewModel,
    required this.disponiveis,
    required this.bckDisponiveis,
    required this.width,
  });

  final EditCapabilityViewModel viewModel;
  late List<RouteApiDto> disponiveis = [];
  late List<RouteApiDto> bckDisponiveis = disponiveis;
  final double width;

  final routesRowValues = ['name', 'url', 'method', 'bypass', 'sysadmin'];

  @override
  State<TableListCapability> createState() => _TableListCapabilityState();
}

class _TableListCapabilityState extends State<TableListCapability> {
  final searchFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Filtro',
            border: const OutlineInputBorder(),
            suffixIcon: searchFieldController.value.text.isEmpty
                ? const Text('')
                : OnHoverButton(
                    child: IconButton(
                      icon: const Icon(
                        Icons.clear_outlined,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        setState(() {
                          searchFieldController.setText('');
                          widget.disponiveis = widget.bckDisponiveis;
                        });
                      },
                    ),
                  ),
          ),
          controller: searchFieldController,
          onFieldSubmitted: (value) {
            setState(() {
              if (widget.disponiveis.isEmpty) {
                widget.disponiveis = widget.bckDisponiveis;
              }
              var filteredEntities = widget.disponiveis.where((element) => element.url.contains(value)).toList();
              widget.disponiveis = filteredEntities;
            });
          },
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: widget.width,
          child: DataTableRoutes(
            title: Row(
              children: [
                Text(
                  'Adicionando capacidades',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(
                  width: 4,
                ),
                const Icon(Icons.polyline_outlined),
              ],
            ),
            viewModel: widget.viewModel,
            fieldsData: widget.routesRowValues,
            items: widget.disponiveis.map((e) {
              return e.toJson();
            }).toList(),
          ),
        ),
      ],
    );
  }
}
