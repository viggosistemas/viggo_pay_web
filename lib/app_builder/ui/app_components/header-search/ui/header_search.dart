import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:provider/provider.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:viggo_core_frontend/util/list_options.dart';
import 'package:viggo_pay_admin/app_builder/ui/app_components/header-search/ui/header_search_view_model.dart';
import 'package:viggo_pay_admin/components/hover_button.dart';

// ignore: must_be_immutable
class HeaderSearch extends StatefulWidget {
  HeaderSearch({
    super.key,
    required this.searchFields,
    required this.onSearch,
    required this.onReload,
    notShowAdvancedFilters,
    itemsSelect,
  }) {
    if (notShowAdvancedFilters != null) {
      this.notShowAdvancedFilters = notShowAdvancedFilters;
    }
    if (itemsSelect != null) {
      this.itemsSelect = itemsSelect;
    }
  }

  final List<Map<String, dynamic>> searchFields;
  final Function(List<Map<String, dynamic>> params) onSearch;
  final Function onReload;
  List<Map<String, dynamic>> itemsSelect = [];
  bool notShowAdvancedFilters = false;

  @override
  State<HeaderSearch> createState() => _HeaderSearchState();
}

class _HeaderSearchState extends State<HeaderSearch> {
  // final searchFieldController = TextEditingController();
  static const defaultMask = '########################################';
  final nomeRazaoSocialFieldControll = TextEditingController();
  final searchFieldController = MaskedTextController(
    mask: defaultMask,
    translator: {'#': RegExp(r'[0-9a-zA-Z@\.\-_]')},
  );

  // ignore: prefer_typing_uninitialized_variables
  var _selectedFilter;
  ListOptions selectedStatus = ListOptions.ACTIVE_ONLY;

  final List<Map<String, dynamic>> listFilters = [
    {
      'label': 'Status',
      'icon': Icons.info_outline,
      'search_field': 'list_options',
      'type': 'status',
      'value': ListOptions.ACTIVE_ONLY.name,
      'viewValue': 'Apenas ativos',
    },
  ];

  getViewValue() {
    if (selectedStatus.name == ListOptions.ACTIVE_ONLY.name) {
      return 'Apenas ativos';
    } else if (selectedStatus.name == ListOptions.INACTIVE_ONLY.name) {
      return 'Apenas inativos';
    } else {
      return 'Ativos e Inativos';
    }
  }

  @override
  Widget build(context) {
    final viewModel = Provider.of<HeaderSearchViewModel>(context);
    final brightnessMode = Theme.of(context).brightness;
    final colorSchemeMode = Theme.of(context).colorScheme;

    void changeStatus(ListOptions status) {
      setState(() {
        selectedStatus = status;
        var auxFilter = {
          'label': 'Status',
          'icon': Icons.info_outline,
          'search_field': 'list_options',
          'type': 'status',
          'value': selectedStatus.name,
          'viewValue': getViewValue()
        };
        var index = listFilters.indexWhere(
            (element) => element['search_field'] == auxFilter['search_field']);
        if (index != -1) {
          listFilters.removeAt(index);
          listFilters.add(auxFilter);
        } else {
          listFilters.add(auxFilter);
        }
        // viewModel.onSearch(context, listFilters);
        widget.onSearch(listFilters);
        viewModel.form.searchField.onValueChange('');
        _selectedFilter = null;
      });
    }

    void applyFilter() {
      setState(() {
        var auxFilter = {
          'label': _selectedFilter['label'],
          'icon': _selectedFilter['icon'],
          'type': _selectedFilter['type'],
          'search_field': _selectedFilter['search_field'],
          'value': searchFieldController.value.text,
        };
        var index = listFilters.indexWhere(
            (element) => element['search_field'] == auxFilter['search_field']);
        if (index != -1) {
          listFilters.removeAt(index);
          listFilters.add(auxFilter);
        } else {
          listFilters.add(auxFilter);
        }
        // viewModel.onSearch(context, listFilters);
        widget.onSearch(listFilters);
        viewModel.form.searchField.onValueChange('');
        _selectedFilter = null;
      });
    }

    void clearAllFilters() {
      setState(() {
        viewModel.form.searchField.onValueChange('');
        _selectedFilter = null;
        listFilters.removeRange(0, listFilters.length);
        listFilters.add(
          {
            'label': 'Status',
            'icon': Icons.info_outline,
            'search_field': 'list_options',
            'type': 'status',
            'value': ListOptions.ACTIVE_ONLY.name,
            'viewValue': 'Apenas ativos',
          },
        );
        widget.onSearch(listFilters);
      });
    }

    void removeFilter(int index) {
      setState(() {
        listFilters.removeAt(index);
        widget.onSearch(listFilters);
      });
    }

    void updateMask() {
      var type = searchFieldController.value.text
          .replaceAll('.', '')
          .replaceAll('-', '')
          .replaceAll('/', '');
      if (_selectedFilter['type'] == 'cnpj') {
        searchFieldController.updateMask('##.###.###/####-##');
      } else if (type.length <= 11) {
        searchFieldController.updateMask('###.###.###-###');
      } else if (type.length > 11) {
        searchFieldController.updateMask('##.###.###/####-##');
      } else {
        searchFieldController.updateMask(defaultMask);
      }
    }

    List<Widget> contentActions() {
      return [
        StreamBuilder<Object>(
            stream: viewModel.form.searchField.field,
            builder: (context, snapshot) {
              return OnHoverButton(
                child: IconButton.outlined(
                  onPressed: () {
                    if (snapshot.data != null &&
                        snapshot.data.toString().isNotEmpty &&
                        _selectedFilter != null) {
                      applyFilter();
                    }
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: snapshot.data != null &&
                            snapshot.data.toString().isNotEmpty &&
                            _selectedFilter != null
                        ? Colors.white.withOpacity(0)
                        : Colors.grey.withOpacity(0.7),
                  ),
                  icon: Icon(
                    Icons.search,
                    color: snapshot.data != null &&
                            snapshot.data.toString().isNotEmpty &&
                            _selectedFilter != null
                        ? Theme.of(context).colorScheme.primary
                        : Colors.black38,
                  ),
                ),
              );
            }),
        const SizedBox(
          width: 10,
        ),
        StreamBuilder<Object>(
            stream: viewModel.form.searchField.field,
            builder: (context, snapshot) {
              return (snapshot.data.toString().isNotEmpty &&
                          snapshot.data != null) ||
                      (listFilters.isNotEmpty && listFilters.length != 1)
                  ? OnHoverButton(
                      child: IconButton.outlined(
                        onPressed: () => clearAllFilters(),
                        color: Theme.of(context).colorScheme.primary,
                        icon: const Icon(
                          Icons.clear_outlined,
                          color: Colors.red,
                        ),
                      ),
                    )
                  : const Text('');
            }),
        const SizedBox(
          width: 10,
        ),
        OnHoverButton(
          child: IconButton.outlined(
            onPressed: () => widget.onReload,
            color: Theme.of(context).colorScheme.primary,
            icon: Icon(
              Icons.replay_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ];
    }

    List<Widget> contentSearch(BoxConstraints constraints) {
      return [
        if (!widget.notShowAdvancedFilters)
          Theme(
            data: ThemeData().copyWith(
              hoverColor: Colors.grey.withOpacity(0.3),
              brightness: brightnessMode,
              colorScheme: colorSchemeMode,
              popupMenuTheme: const PopupMenuThemeData().copyWith(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onPrimary,
                iconColor: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.primary,
                surfaceTintColor:
                    Theme.of(context).brightness == Brightness.dark
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.primary,
              ),
            ),
            child: PopupMenuButton<ListOptions>(
              initialValue: selectedStatus,
              onSelected: (ListOptions status) {
                changeStatus(status);
              },
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15.0),
                ),
              ),
              tooltip: 'Filtros avançados',
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    width: 1,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                child: const Icon(Icons.filter_alt_outlined),
              ),
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<ListOptions>>[
                PopupMenuItem<ListOptions>(
                  value: ListOptions.ACTIVE_ONLY,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Apenas ativos",
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      Icon(
                        Icons.person_add_outlined,
                        size: 18,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<ListOptions>(
                  value: ListOptions.INACTIVE_ONLY,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Apenas inativos",
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      Icon(
                        Icons.person_add_disabled_outlined,
                        size: 18,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<ListOptions>(
                  value: ListOptions.ACTIVE_AND_INACTIVE,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Ativos e Inativos",
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      Icon(
                        Icons.people_outline,
                        size: 18,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        SizedBox(
          width: constraints.maxWidth >= 600 ? 20 : 0,
          height: constraints.maxWidth >= 600 ? 0 : 20,
        ),
        OnHoverButton(
          child: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.white,
              hoverColor:
                  Theme.of(context).colorScheme.primary.withOpacity(0.5),
              focusColor: Colors.transparent,
            ),
            child: SizedBox(
              width: 300,
              child: DropdownButtonFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                dropdownColor: Colors.white,
                value: _selectedFilter,
                hint: const Text(
                  'Selecionar filtro',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                items: widget.searchFields.map<DropdownMenuItem>((vl) {
                  return DropdownMenuItem(
                    alignment: Alignment.center,
                    value: vl,
                    child: Container(
                      alignment: Alignment.center,
                      constraints: const BoxConstraints(
                        minHeight: 48.0,
                      ),
                      color: Colors.transparent,
                      child: Row(
                        children: [
                          Icon(
                            vl['icon'],
                            color: Colors.black,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            vl['label'],
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedFilter = value!;
                    viewModel.form.searchField.onValueChange('');
                  });
                },
              ),
            ),
          ),
        ),
        SizedBox(
          width: constraints.maxWidth >= 600 ? 20 : 0,
          height: constraints.maxWidth >= 600 ? 0 : 20,
        ),
        SizedBox(
          width: constraints.maxWidth >= 600
              ? constraints.maxWidth * 0.5
              : constraints.maxWidth,
          child: StreamBuilder<String>(
            stream: viewModel.form.searchField.field,
            builder: (context, snapshot) {
              searchFieldController.value =
                  searchFieldController.value.copyWith(text: snapshot.data);
              if (_selectedFilter != null &&
                  (_selectedFilter['type'] == 'cpf_cnpj' ||
                      _selectedFilter['type'] == 'cnpj')) {
                updateMask();
              } else {
                searchFieldController.updateMask(defaultMask);
              }
              return _selectedFilter != null &&
                      (_selectedFilter['type'] == 'enum' ||
                          _selectedFilter['type'] == 'bool') &&
                      widget.itemsSelect.isNotEmpty
                  ? SelectFormField(
                      type: SelectFormFieldType.dropdown,
                      items: widget.itemsSelect
                          .where((element) =>
                              element['type'] == _selectedFilter['type'])
                          .toList(),
                      decoration: InputDecoration(
                        labelText: 'Filtro',
                        border: const OutlineInputBorder(),
                        errorText: snapshot.error?.toString(),
                        suffixIcon: searchFieldController.value.text.isEmpty
                            ? const Text('')
                            : OnHoverButton(
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.clear_outlined,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => viewModel.form.searchField
                                      .onValueChange(''),
                                ),
                              ),
                      ),
                      enabled: _selectedFilter != null,
                      controller: searchFieldController,
                      onChanged: (value) {
                        viewModel.form.searchField.onValueChange(value);
                      },
                      onSaved: (value) => applyFilter(),
                      onFieldSubmitted: (value) => applyFilter(),
                    )
                  : TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Filtro',
                        border: const OutlineInputBorder(),
                        errorText: snapshot.error?.toString(),
                        suffixIcon: searchFieldController.value.text.isEmpty
                            ? const Text('')
                            : OnHoverButton(
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.clear_outlined,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => viewModel.form.searchField
                                      .onValueChange(''),
                                ),
                              ),
                      ),
                      enabled: _selectedFilter != null,
                      controller: searchFieldController,
                      inputFormatters: [
                        if (_selectedFilter != null &&
                            (_selectedFilter['type'] == 'cpf_cnpj' ||
                                _selectedFilter['type'] == 'number'))
                          FilteringTextInputFormatter.digitsOnly
                      ],
                      onChanged: (value) {
                        viewModel.form.searchField.onValueChange(value);
                      },
                      onFieldSubmitted: (value) => applyFilter(),
                    );
            },
          ),
        ),
        SizedBox(
          width: constraints.maxWidth >= 600 ? 20 : 0,
          height: constraints.maxWidth >= 600 ? 0 : 20,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: contentActions(),
        ),
      ];
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                constraints.maxWidth >= 600
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: contentSearch(constraints),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: contentSearch(constraints),
                      ),
                const SizedBox(
                  height: 10,
                ),
                Wrap(
                  children: List<Widget>.generate(
                    listFilters.length,
                    (int idx) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          right: 10.0,
                        ),
                        child: Chip(
                          deleteIconColor: listFilters[idx]['viewValue'] == null
                              ? Colors.red
                              : Colors.red.withOpacity(
                                  0,
                                ),
                          deleteButtonTooltipMessage:
                              listFilters[idx]['viewValue'] == null
                                  ? 'Remover filtro'
                                  : '',
                          onDeleted: () {
                            if (listFilters[idx]['viewValue'] == null) {
                              removeFilter(idx);
                            }
                          },
                          padding: const EdgeInsets.all(8.0),
                          avatar: Icon(
                            listFilters[idx]['icon'],
                            color: Colors.black,
                          ),
                          label: Text(
                              '${listFilters[idx]['label']}: ${listFilters[idx]['viewValue'] ?? listFilters[idx]['value']}'),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
