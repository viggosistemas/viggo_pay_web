import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:viggo_core_frontend/capability/data/models/capability_api_dto.dart';
import 'package:viggo_pay_admin/application/ui/components/table_routes.dart';
import 'package:viggo_pay_admin/application/ui/edit_policy/edit_policy_view_model.dart';
import 'package:viggo_pay_admin/components/hover_button.dart';

// ignore: must_be_immutable
class TableListPolicy extends StatefulWidget {
  TableListPolicy({
    super.key,
    required this.viewModel,
    required this.disponiveis,
    required this.bckDisponiveis,
    required this.mockSelectedList,
    required this.width,
  });

  final EditPolicyViewModel viewModel;
  late List<CapabilityApiDto> disponiveis = [];
  late List<CapabilityApiDto> bckDisponiveis = disponiveis;
  late List<CapabilityApiDto> mockSelectedList = [];
  final double width;

  final routesRowValues = ['route', 'route', 'route', 'route', 'route'];

  final routesListLabelInclude = ['name', 'url', 'method', 'bypass', 'sysadmin'];

  @override
  State<TableListPolicy> createState() => _TableListPolicyState();
}

class _TableListPolicyState extends State<TableListPolicy> {
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
              if (value.isEmpty) {
                widget.disponiveis = widget.bckDisponiveis;
              } else {
                if (widget.disponiveis.isEmpty) {
                  widget.disponiveis = widget.bckDisponiveis;
                }
                var filteredEntities = widget.bckDisponiveis.where((element) => element.route!.url.contains(value)).toList();
                widget.disponiveis = filteredEntities;
              }
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
                  'Adicionando políticas',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(
                  width: 4,
                ),
                const Icon(Icons.policy_outlined),
              ],
            ),
            mockSelectedList: widget.mockSelectedList,
            viewModel: widget.viewModel,
            fieldsData: widget.routesRowValues,
            labelInclude: widget.routesListLabelInclude,
            items: widget.disponiveis.map((e) {
              return e.toJson();
            }).toList(),
          ),
        ),
      ],
    );
  }
}
