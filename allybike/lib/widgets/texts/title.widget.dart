import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  final String title;
  final double fontSize;
  const TitleText({super.key, required this.title, this.fontSize = 30});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600),
    );
  }
}
