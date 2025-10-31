import 'package:allybike/functions/validator-input.fuction.dart';
import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {

  final TextEditingController passwordController;
  final FocusNode passwordFocus;
  final Function()? onEditingComplete;
  final String hintText;

  const PasswordField({
        super.key,
        required this.passwordController,
        required this.passwordFocus,
        this.onEditingComplete,
        this.hintText = "Contraseña"
        });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {

  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return  TextFormField(
            controller       : widget.passwordController,
            focusNode        : widget.passwordFocus,
            obscureText      : isObscure,
            autovalidateMode : AutovalidateMode.onUserInteraction,
            onEditingComplete: widget.onEditingComplete,
            validator        : (text) => validate(text, [
                               RequiredValidator(),
                               MinLengthValidator(8),
            ]),     
            decoration       : InputDecoration(
                               hintText  : widget.hintText,
                               prefixIcon : Icon(Icons.lock_outline),
                               contentPadding: EdgeInsets.symmetric(horizontal: 10),
                               suffixIcon : IconButton(
                                           icon      : isObscure 
                                                       ? Icon(Icons.visibility_off_outlined) 
                                                       : Icon(Icons.remove_red_eye_outlined),
                                           onPressed : () => setState(() {
                                              isObscure = !isObscure;
                                           }),
                                           )
            ),
            );
  }
}