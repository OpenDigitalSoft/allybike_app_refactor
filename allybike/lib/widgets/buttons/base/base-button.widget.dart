import 'package:flutter/material.dart';

abstract class BaseButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool loading;
  final bool disabled;
  final bool fullWidth;
  final double? width;
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;
  final double fontSize;
  final double borderRadius;
  const BaseButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.backgroundColor,
    this.loading = false,
    this.disabled = false,
    this.fullWidth = true,
    this.width,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    this.fontSize = 18,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : width,
      child: ElevatedButton(
        onPressed: loading || disabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (loading)
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),
            if (loading) SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

abstract class SmallBaseButton extends BaseButton {

 const SmallBaseButton(
   {super.key, 
    required super.text,
    required super.onPressed,
    required super.backgroundColor,
  }): super(
         fullWidth: false,
         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
         fontSize: 13,
         borderRadius: 10
  );
}
