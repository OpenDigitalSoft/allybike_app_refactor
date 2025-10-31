import 'package:flutter/material.dart';

Future<void> snackBar({
  required String text,
  required BuildContext context,
  String action = 'Aceptar',
  Function()? onPressed,
  Function()? onclose,
}) async {
  final snackBar = SnackBar(
    
    content: Text(text),
    action: SnackBarAction(
      label: action,
      onPressed: onPressed ?? () {},
      textColor: Theme.of(context).primaryColor,
    ),
    duration: const Duration(seconds: 2),
    behavior: SnackBarBehavior.fixed,
    
  );
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(snackBar).closed.then((value) => {onclose?.call()});
}
