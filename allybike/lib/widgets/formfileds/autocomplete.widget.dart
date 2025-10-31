import 'package:allybike/widgets/formfileds/input.widget.dart';
import 'package:flutter/material.dart';

class SimpleAutocomplete<T extends Object> extends StatelessWidget {
  final List<T> options;
  final String label;
  final void Function(T)? onSelected;
  final String Function(T) displayStringForOption;
  const SimpleAutocomplete({
    super.key,
    required this.options,
    this.label = 'Buscar',
    this.onSelected,
    required this.displayStringForOption,
  });

  @override
  Widget build(BuildContext context) {
    return Autocomplete<T>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return  Iterable<T>.empty();
        }
        final filterOptions = options.where((option) {
          return displayStringForOption(option).toLowerCase().contains(textEditingValue.text.toLowerCase());
        });
        return filterOptions;
      },
      onSelected: onSelected,
      displayStringForOption: displayStringForOption,
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return Input(
               hintText   : label,
               controller : controller,
               suffixIcon  :  Icons.search,
               focusNode  : focusNode,
               );
      },
    );
  }
}