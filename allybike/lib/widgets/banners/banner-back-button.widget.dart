import 'package:allybike/widgets/banners/background-image.widget.dart';
import 'package:flutter/material.dart';

class BannerWithBackButton extends StatelessWidget {
  final double height;
  const BannerWithBackButton({super.key,this.height = 0.35});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgroundImage(height: height),
        Positioned(top: 45, child: BackButton(color: Colors.red)),
      ],
    );
  }
}
