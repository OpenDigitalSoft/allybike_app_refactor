import 'package:flutter/material.dart';

class SkeletonCard extends StatefulWidget {
  final double height;
  final double marginHorizontal;
  const SkeletonCard({required this.height, this.marginHorizontal = 16, super.key});

  @override
  State<SkeletonCard> createState() => _SkeletonCard();
}

class _SkeletonCard extends State<SkeletonCard> {
  bool _visible = true;

  @override
  void initState() {
    super.initState();
    Future.doWhile(() async {
      await Future.delayed(Duration(milliseconds: 400));
      if (mounted) {
        setState(() => _visible = !_visible);
        return true;
      }
      return false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.3, // 👈 efecto de flash
      duration: Duration(milliseconds: 400),
      child: Container(
        height: widget.height,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: widget.marginHorizontal),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
