import 'package:allybike/const/colors.conts.dart';
import 'package:flutter/material.dart';

class AppleButtonLogin extends StatelessWidget {
  final Function()? onPressed;

  const AppleButtonLogin({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 44,
        padding: EdgeInsets.symmetric(horizontal: 35),
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(color: PaleteColors.gray),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/apple-logo.png",width: 25,height: 25),
            SizedBox(width:15),
            Text("Sing in with Apple", style: TextStyle(fontSize: 19,color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
