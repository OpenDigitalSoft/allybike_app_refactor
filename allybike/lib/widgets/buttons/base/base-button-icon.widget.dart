import 'package:flutter/material.dart';

abstract class BaseIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final bool loading;
  final bool disabled;
  final bool fullWidth;
  final double? width;
  final double? height;
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;
  final double fontSize;
  final double borderRadius;

  const BaseIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.backgroundColor,
    this.loading = false,
    this.disabled = false,
    this.fullWidth = true,
    this.width,
    this.height,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    this.fontSize = 18,
    this.borderRadius = 10,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
           onTap: onPressed,
           child: Container(
                  width: height,
                  height: height,
                  decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: backgroundColor,
            
                  ),
                  child: Center(child: Icon(icon, color: Colors.white, size: 20)),
      ),
    );
  }
}


