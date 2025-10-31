import 'package:allybike/widgets/cards/card.widget.dart';
import 'package:flutter/material.dart';

class ServiceCard extends StatelessWidget {

  final String name;
  final Color color;
  final String image;
  final Function()? onTap;
  const ServiceCard({
        super.key,
        required this.name,
        required this.color,
        required this.image,
        this.onTap
        });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
           onTap: onTap,
           child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                   SizedBox(
                   width  : double.infinity,
                   height : 180,
                            child: RoundedCard(
                                   padding: 0,
                                   child: SizedBox(),
                            ),
                   ),
                   Positioned(
                   top: -20,
                   left: 10,
                   child: Image.asset(
                           width: 150,
                           image
                          ), 
                   ),
                   Align(
                   alignment: Alignment.lerp(Alignment.bottomCenter,Alignment.center, 0.3)!,
                   child: Text(name)
                   ),
                   Align(
              alignment: Alignment.lerp(Alignment.bottomCenter,Alignment.center, 0.05)!,
              child: Container(
                     width: 90,
                     height: 5,
                     decoration: BoxDecoration(color: color),
              )
              ),
             ],
      ),
    );
  }
}