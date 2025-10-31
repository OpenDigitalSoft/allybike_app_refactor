import 'package:flutter/material.dart';

class RoundedCard extends StatelessWidget {
  final Widget child;
  final double padding;
  final Function()? onTap;
  const RoundedCard({
        super.key,
        required this.child,
        this.onTap,
        this.padding = 12
        });

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
            onTap: onTap,
            child: Card(
                    shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(12),
                    ),
                    color: Colors.white,
                    elevation: 0,
                    child: Padding(
                           padding: EdgeInsetsGeometry.all(padding),
                           child: child,
                           ),
            ),
    );
  }
}