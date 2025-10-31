import 'package:flutter/material.dart';

class FloatButton extends StatelessWidget {

  final void Function()? onPressed;
  final Color color;
  final String label;
  const FloatButton({
        super.key,
        required this.onPressed,
        required this.color,
        this.label = "Crear",
        });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
           heroTag: UniqueKey().toString(),
           backgroundColor: color,
           onPressed: onPressed, 
           label: Text(label,
                  style: TextStyle(color: Colors.white),
           ),
           icon: Icon(Icons.add_circle_outline,color: Colors.white),
           );
  }
}