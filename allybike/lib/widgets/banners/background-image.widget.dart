
import 'package:flutter/material.dart';

class BackgroundImage extends StatelessWidget {
  
  final double height;
  const BackgroundImage({super.key,this.height = 0.35});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Padding(
           padding : EdgeInsets.only(top: 30.0),
           child  : SizedBox(
                    height     : screenSize.height * height,
                    width      : double.infinity,
                    child      : Center(
                                 child: Image.asset(
                                        "assets/images/logo.png",
                                        width: 200,
                                        ),
                    )
      ),
    );
  }
}