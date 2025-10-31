import 'package:flutter/material.dart';

class SelectDropdown<T> extends StatelessWidget {
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?> onChanged;
  final String hint;
  final String? Function(T?)? validator;
  final FocusNode? focusNode;

  const SelectDropdown({
    super.key,
    required this.items,
    required this.onChanged,
    required this.hint,
    this.validator,
    this.value,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
           value: value,
           items: items,
           onChanged: onChanged,
           validator: validator,
           focusNode: focusNode,
           decoration: InputDecoration(
                       hintText: hint,
                       contentPadding: EdgeInsets.symmetric(horizontal: 10),
                       hintStyle: TextStyle(color: Colors.grey)
           ),
    );
  }
}