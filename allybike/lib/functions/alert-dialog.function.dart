import 'package:allybike/widgets/buttons/primary/primary-button.widget.dart';
import 'package:allybike/widgets/buttons/secundary/secundary-button.widget.dart';
import 'package:flutter/material.dart';

Future<bool?> showAlertDialog({
  required BuildContext context,
  required String title,
  required String content,
  required Function()? onAccept
}) {
return  showDialog<bool>(
    context: context,
    barrierDismissible: false, // no se cierra tocando afuera
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(content),
        actions: [
          Row(
           mainAxisAlignment: MainAxisAlignment.end,
           crossAxisAlignment: CrossAxisAlignment.end,
           children: [
              SmallSecundaryButton(
                text: "Cancelar",
                onPressed: () => Navigator.of(context).pop(false),
              ),
              SizedBox(width: 10),
              SmallPrimaryButton(
              text: "Aceptar",
              onPressed: (){
                Navigator.of(context).pop(true);
                onAccept?.call();
              },
              )
           ],
          )
        ],
      );
    },
  );
}
