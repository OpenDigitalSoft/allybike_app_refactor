import 'package:allybike/functions/validator-input.fuction.dart';
import 'package:flutter/material.dart';

class Input extends StatelessWidget {

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final Function()? onEditingComplete;
  final List<Validator>? validators;
  final String hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Function(String)? onChanged;
  final bool isTextArea;
  final bool readOnly;
  const Input({
    super.key,
    required this.hintText,
    this.focusNode,
    this.controller,
    this.keyboardType,
    this.onEditingComplete,
    this.validators,
    this.prefixIcon,
    this.onChanged,
    this.suffixIcon,
    this.isTextArea = false,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
           controller        : controller,
           focusNode         : focusNode,
           autovalidateMode  : AutovalidateMode.onUserInteraction,
           keyboardType      : keyboardType,
           textInputAction   : TextInputAction.next,
           onEditingComplete : onEditingComplete,
           onChanged         : onChanged,
           minLines          : isTextArea ? 4 : 1,
           maxLines          : isTextArea ? 6 : 1,
           readOnly          : readOnly,
           validator         : validators != null && validators!.isEmpty
                                ? null
                                : (text) => validate(text, validators ?? List.empty()),
           decoration        : InputDecoration(
                               hintText  : hintText,
                               contentPadding: EdgeInsets.symmetric(horizontal: 10),
                               prefixIcon : prefixIcon == null 
                                           ? null 
                                           : Icon(prefixIcon),
                               suffixIcon : suffixIcon == null 
                                           ? null 
                                           : Icon(suffixIcon),
           ),
    );
  }
}
