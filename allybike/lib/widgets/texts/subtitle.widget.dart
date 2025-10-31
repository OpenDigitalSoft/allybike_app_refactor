import 'package:flutter/material.dart';

class SubTitle extends StatelessWidget {
  
  final String text;
  const SubTitle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return  Text(text,
            style: TextStyle(
                   fontSize   : 20,
                   fontWeight : FontWeight.w400,
            ),
    );
  }
}