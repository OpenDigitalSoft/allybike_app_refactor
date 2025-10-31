import 'package:allybike/widgets/skeletors/route-card-skeletor.widget.dart';
import 'package:flutter/material.dart';

class SkeletorRouteList extends StatelessWidget {
  const SkeletorRouteList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        return SkeletorRouteCard();
      },
    );
  }
}


