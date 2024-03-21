import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:viggo_core_frontend/domain/data/models/domain_api_dto.dart';
import 'package:viggo_core_frontend/util/list_options.dart';
import 'package:viggo_pay_admin/di/locator.dart';
import 'package:viggo_pay_admin/user/ui/list_users/list_users_grid.dart';
import 'package:viggo_pay_admin/usuarios_por_dominio/ui/list_users_domain_view_model.dart';

// ignore: must_be_immutable
class ListUsersDomainGrid extends StatefulWidget {
  ListUsersDomainGrid({super.key});

  ListUsersDomainViewModel viewModel = locator.get<ListUsersDomainViewModel>();

  @override
  State<ListUsersDomainGrid> createState() => _ListUsersDomainGridState();
}

class _ListUsersDomainGridState extends State<ListUsersDomainGrid> {
  bool selected = false;
  final domainFieldControll = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 500,
              child: StreamBuilder<String>(
                stream: widget.viewModel.form.domainId.field,
                builder: (context, snapshot) {
                  domainFieldControll.value =
                      domainFieldControll.value.copyWith(text: snapshot.data);
                  return Autocomplete<DomainApiDto>(
                    optionsBuilder: (TextEditingValue textEditingValue) async {
                      if (textEditingValue.text.isEmpty) {
                        var options = await widget.viewModel.loadDomains({
                          'list_options': ListOptions.ACTIVE_ONLY.name,
                          'order_by': 'name'
                        });
                        return options!.where((element) => true);
                      } else {
                        var options = await widget.viewModel.loadDomains({
                          'list_options': ListOptions.ACTIVE_ONLY.name,
                          'order_by': 'name',
                          'name': '%${textEditingValue.text}%'
                        });
                        return options!.where((element) => true);
                      }
                    },
                    displayStringForOption: (option) => option.name,
                    optionsViewBuilder: (context, onSelected, options) => Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(4.0)),
                        ),
                        child: SizedBox(
                          height: 52.0 * options.length,
                          width: 500, //define the same width of dialog
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: options.length,
                            shrinkWrap: false,
                            itemBuilder: (BuildContext context, int index) {
                              final DomainApiDto option =
                                  options.elementAt(index);
                              return InkWell(
                                onTap: () => onSelected(option),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(option.name),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    fieldViewBuilder: (
                      BuildContext context,
                      TextEditingController controller,
                      FocusNode focusNode,
                      VoidCallback onFieldSubmitted,
                    ) {
                      return TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Domínio',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          floatingLabelAlignment: FloatingLabelAlignment.start,
                          border: const OutlineInputBorder(),
                          errorText: snapshot.error?.toString(),
                          suffix:
                              snapshot.data != null && snapshot.data!.isNotEmpty
                                  ? IconButton(
                                      onPressed: () {
                                        widget.viewModel.form.domainId
                                            .onValueChange('');
                                        controller.setText('');
                                      },
                                      icon: const Icon(
                                        Icons.cancel_outlined,
                                        size: 18,
                                        color: Colors.red,
                                      ),
                                    )
                                  : const Text(''),
                        ),
                        controller: controller,
                        focusNode: focusNode,
                        onChanged: (value) {
                          widget.viewModel.form.domainId.onValueChange(value);
                          setState(
                            () {
                              selected = false;
                            },
                          );
                        },
                      );
                    },
                    onSelected: (DomainApiDto selection) {
                      widget.viewModel.form.domainId
                          .onValueChange(selection.id);
                      setState(
                        () {
                          selected = true;
                        },
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: StreamBuilder<String>(
                stream: widget.viewModel.form.domainId.field,
                builder: (context, snapshot) {
                  if (snapshot.data == null ||
                      snapshot.data!.isEmpty ||
                      !selected) {
                    return Center(
                      child: Text(
                        'Selecione um domínio!',
                        style: Theme.of(context).textTheme.titleMedium!,
                      ),
                    );
                  } else {
                    return ListUsersGrid(
                      domainId: snapshot.data!,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
