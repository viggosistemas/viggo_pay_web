import 'dart:async';

import 'package:flutter/material.dart';

const List<Map<String, dynamic>> _contatoList = [
  {'label': 'Telefone', 'icon': Icons.contact_page_outlined, },//Icons.phone_outlined},
  {'label': 'E-Mail', 'icon': Icons.contact_page_outlined, },//Icons.email_outlined},
  {'label': 'Celular', 'icon': Icons.contact_page_outlined, },//Icons.mobile_friendly_outlined},
  {'label': 'WhatsApp', 'icon': Icons.contact_page_outlined, },//Icons.telegram_outlined},
  {'label': 'Instagram', 'icon': Icons.contact_page_outlined, },//Icons.telegram_outlined},
  {'label': 'Facebook', 'icon': Icons.contact_page_outlined, },//Icons.facebook_outlined},
  {'label': 'Telegram', 'icon': Icons.contact_page_outlined, },//Icons.telegram_outlined},
  {'label': 'Linkedin', 'icon': Icons.contact_page_outlined, },//Icons.telegram_outlined},
  {'label': 'Outros', 'icon': Icons.contact_page_outlined, },//Icons.abc},
];

class EditableChipField extends StatefulWidget {
  const EditableChipField({
    super.key,
    required this.onSubmitTags,
  });

  final Function onSubmitTags;

  @override
  EditableChipFieldState createState() {
    return EditableChipFieldState();
  }
}

class EditableChipFieldState extends State<EditableChipField> {
  final FocusNode _chipFocusNode = FocusNode();
  List<Map<String, dynamic>> _toppings = [_contatoList.first];
  List<Map<String, dynamic>> _suggestions = [];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 100 + (52.0 * _suggestions.length),
      child: Column(
        children: <Widget>[
          ListTile(
              title: ChipsInput<Map<String, dynamic>>(
                values: _toppings,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.contact_page_outlined),
                  border: OutlineInputBorder(),
                  hintText: 'Digite para filtrar',
                ),
                strutStyle: const StrutStyle(fontSize: 15),
                onChanged: _onChanged,
                onSubmitted: _onSubmitted,
                chipBuilder: _chipBuilder,
                onTextChanged: _onSearchChanged,
              ),
              trailing: IconButton(
                onPressed: () {
                  if (_toppings.isNotEmpty) {
                    setState(() {
                      widget.onSubmitTags(_toppings);
                      _toppings = [];
                    });
                  }
                },
                tooltip: 'Adicionar contato',
                icon: Icon(
                  Icons.add_outlined,
                  color: _toppings.isEmpty
                      ? Colors.grey
                      : Theme.of(context).colorScheme.primary,
                ),
              )),
          if (_suggestions.isNotEmpty)
            SizedBox(
              width: double.infinity,
              height: 52.0 * _suggestions.length,
              child: Expanded(
                child: ListView.builder(
                  itemCount: _suggestions.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ToppingSuggestion(
                      _suggestions[index],
                      onTap: _selectSuggestion,
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _onSearchChanged(String value) async {
    final List<Map<String, dynamic>> results = await _suggestionCallback(value);
    setState(() {
      _suggestions = results
          .where((Map<String, dynamic> topping) => !_toppings.contains(topping))
          .toList();
    });
  }

  Widget _chipBuilder(BuildContext context, Map<String, dynamic> topping) {
    return ToppingInputChip(
      topping: topping,
      onDeleted: _onChipDeleted,
      onSelected: _onChipTapped,
    );
  }

  void _selectSuggestion(Map<String, dynamic> topping) {
    setState(() {
      _toppings.add(topping);
      _suggestions = [];
    });
  }

  void _onChipTapped(Map<String, dynamic> topping) {}

  void _onChipDeleted(Map<String, dynamic> topping) {
    setState(() {
      _toppings.remove(topping);
      _suggestions = [];
    });
  }

  void _onSubmitted(String text) {
    if (text.trim().isNotEmpty) {
      setState(() {
        _toppings = [
          ..._toppings,
          {
            'label': text.trim(),
            'icon': Icons.contact_page_outlined,
          }
        ];
      });
    } else {
      _chipFocusNode.unfocus();
      setState(() {
        _toppings = [];
      });
    }
  }

  void _onChanged(List<Map<String, dynamic>> data) {
    setState(() {
      _toppings = data;
    });
  }

  FutureOr<List<Map<String, dynamic>>> _suggestionCallback(String text) {
    if (text.isNotEmpty) {
      return _contatoList.where((topping) {
        return topping['label']
            .toString()
            .toLowerCase()
            .contains(text.toLowerCase());
      }).toList();
    }
    return const <Map<String, dynamic>>[];
  }
}

class ChipsInput<T> extends StatefulWidget {
  const ChipsInput({
    super.key,
    required this.values,
    this.decoration = const InputDecoration(),
    this.style,
    this.strutStyle,
    required this.chipBuilder,
    required this.onChanged,
    this.onChipTapped,
    this.onSubmitted,
    this.onTextChanged,
  });

  final List<T> values;
  final InputDecoration decoration;
  final TextStyle? style;
  final StrutStyle? strutStyle;

  final ValueChanged<List<T>> onChanged;
  final ValueChanged<T>? onChipTapped;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onTextChanged;

  final Widget Function(BuildContext context, T data) chipBuilder;

  @override
  ChipsInputState<T> createState() => ChipsInputState<T>();
}

class ChipsInputState<T> extends State<ChipsInput<T>> {
  @visibleForTesting
  late final ChipsInputEditingController<T> controller;

  String _previousText = '';
  TextSelection? _previousSelection;

  @override
  void initState() {
    super.initState();

    controller = ChipsInputEditingController<T>(
      <T>[...widget.values],
      widget.chipBuilder,
    );
    controller.addListener(_textListener);
  }

  @override
  void dispose() {
    controller.removeListener(_textListener);
    controller.dispose();

    super.dispose();
  }

  void _textListener() {
    final String currentText = controller.text;

    if (_previousSelection != null) {
      final int currentNumber = countReplacements(currentText);
      final int previousNumber = countReplacements(_previousText);

      final int cursorEnd = _previousSelection!.extentOffset;
      final int cursorStart = _previousSelection!.baseOffset;

      final List<T> values = <T>[...widget.values];

      // If the current number and the previous number of replacements are different, then
      // the user has deleted the InputChip using the keyboard. In this case, we trigger
      // the onChanged callback. We need to be sure also that the current number of
      // replacements is different from the input chip to avoid double-deletion.
      if (currentNumber < previousNumber && currentNumber != values.length) {
        if (cursorStart == cursorEnd) {
          values.removeRange(cursorStart - 1, cursorEnd);
        } else {
          if (cursorStart > cursorEnd) {
            values.removeRange(cursorEnd, cursorStart);
          } else {
            values.removeRange(cursorStart, cursorEnd);
          }
        }
        widget.onChanged(values);
      }
    }

    _previousText = currentText;
    _previousSelection = controller.selection;
  }

  static int countReplacements(String text) {
    return text.codeUnits
        .where(
            (int u) => u == ChipsInputEditingController.kObjectReplacementChar)
        .length;
  }

  @override
  Widget build(BuildContext context) {
    controller.updateValues(<T>[...widget.values]);

    return TextField(
      minLines: 1,
      maxLines: 3,
      textInputAction: TextInputAction.done,
      style: widget.style,
      strutStyle: widget.strutStyle,
      controller: controller,
      decoration: const InputDecoration(
          border: OutlineInputBorder(), labelText: 'Tags'),
      onChanged: (String value) =>
          widget.onTextChanged?.call(controller.textWithoutReplacements),
      onSubmitted: (String value) =>
          widget.onSubmitted?.call(controller.textWithoutReplacements),
    );
  }
}

class ChipsInputEditingController<T> extends TextEditingController {
  ChipsInputEditingController(this.values, this.chipBuilder)
      : super(
          text: String.fromCharCode(kObjectReplacementChar) * values.length,
        );

  // This constant character acts as a placeholder in the TextField text value.
  // There will be one character for each of the InputChip displayed.
  static const int kObjectReplacementChar = 0xFFFE;

  List<T> values;

  final Widget Function(BuildContext context, T data) chipBuilder;

  /// Called whenever chip is either added or removed
  /// from the outside the context of the text field.
  void updateValues(List<T> values) {
    if (values.length != this.values.length) {
      final String char = String.fromCharCode(kObjectReplacementChar);
      final int length = values.length;
      value = TextEditingValue(
        text: char * length,
        selection: TextSelection.collapsed(offset: length),
      );
      this.values = values;
    }
  }

  String get textWithoutReplacements {
    final String char = String.fromCharCode(kObjectReplacementChar);
    return text.replaceAll(RegExp(char), '');
  }

  String get textWithReplacements => text;

  @override
  TextSpan buildTextSpan(
      {required BuildContext context,
      TextStyle? style,
      required bool withComposing}) {
    final Iterable<WidgetSpan> chipWidgets =
        values.map((T v) => WidgetSpan(child: chipBuilder(context, v)));

    return TextSpan(
      style: style,
      children: <InlineSpan>[
        ...chipWidgets,
        if (textWithoutReplacements.isNotEmpty)
          TextSpan(text: textWithoutReplacements)
      ],
    );
  }
}

class ToppingSuggestion extends StatelessWidget {
  const ToppingSuggestion(this.topping, {super.key, this.onTap});

  final Map<String, dynamic> topping;
  final ValueChanged<Map<String, dynamic>>? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: ObjectKey(topping),
      leading: CircleAvatar(
        child: Icon(topping['icon']),
      ),
      title: Text(topping['label']),
      onTap: () => onTap?.call(topping),
    );
  }
}

class ToppingInputChip extends StatelessWidget {
  const ToppingInputChip({
    super.key,
    required this.topping,
    required this.onDeleted,
    required this.onSelected,
  });

  final Map<String, dynamic> topping;
  final ValueChanged<Map<String, dynamic>> onDeleted;
  final ValueChanged<Map<String, dynamic>> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 3),
      child: InputChip(
        key: ObjectKey(topping),
        label: Text(topping['label']),
        avatar: CircleAvatar(
          child: Icon(topping['icon']),
        ),
        onDeleted: () => onDeleted(topping),
        onSelected: (bool value) => onSelected(topping),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.all(2),
      ),
    );
  }
}
