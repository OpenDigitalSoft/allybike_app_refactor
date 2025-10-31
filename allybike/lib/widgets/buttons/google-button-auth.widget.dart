import 'package:allybike/const/colors.conts.dart';
import 'package:flutter/material.dart';

class GoogleButtonLogin extends StatelessWidget {
  final Function()? onPressed;
  final String text;
  const GoogleButtonLogin({super.key,required this.onPressed,required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
             width: double.infinity,
             height: 44,
             padding: EdgeInsets.symmetric(horizontal: 24),
             decoration: BoxDecoration(
               color: Colors.white,
               border: Border.all(color: PaleteColors.gray),
               borderRadius: BorderRadius.circular(10),
             ),
             child: Row(
               crossAxisAlignment: CrossAxisAlignment.center,
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Image.asset("assets/images/google-logo.png", width: 25, height: 25),
                 SizedBox(width: 10),
                 Text(text, style: TextStyle(fontSize: 19)),
               ],
        ),
      ),
    );
  }
}
