import 'package:flutter/material.dart';

/// --- CARD PRINCIPAL ---
class SkeletorRouteCard extends StatelessWidget {


  const SkeletorRouteCard({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardHeader(screenWidth: screenWidth),
          _CardContent(screenWidth: screenWidth),
        ],
      ),
    );
  }
}

/// --- HEADER CON IMAGEN + CÍRCULO ---
class _CardHeader extends StatelessWidget {
  final double screenWidth;

  const _CardHeader({required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          const Positioned.fill(
            child:  ClipRRect(
              borderRadius:  BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child:  _BlinkingBox(),
            ), // Fondo gris animado
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.02),
              child: const _BlinkingCircle(), // Círculo animado
            ),
          ),
        ],
      ),
    );
  }
}

/// --- CONTENIDO TEXTO + FILA ---
class _CardContent extends StatelessWidget {
  final double screenWidth;

  const _CardContent({required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.03),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SkeletonLine(width: screenWidth * 0.4, height: 20),
          const SizedBox(height: 4),
          _SkeletonLine(width: screenWidth * 0.5, height: 16),
          const SizedBox(height: 8),
          _CardFooter(screenWidth: screenWidth),
        ],
      ),
    );
  }
}

/// --- FILA DE ICONOS + TEXTOS ---
class _CardFooter extends StatelessWidget {
  final double screenWidth;

  const _CardFooter({required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        4,
        (index) => Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index < 3 ? screenWidth * 0.02 : 0),
            child: Row(
              children: [
                const _BlinkingCircle(sizeFactor: 0.04),
                SizedBox(width: screenWidth * 0.02),
                Flexible(child: _SkeletonLine(height: 16)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// --- LÍNEA RECTÁNGULO ---
class _SkeletonLine extends StatelessWidget {
  final double? width;
  final double height;

  const _SkeletonLine({this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return _BlinkingBox(width: width, height: height);
  }
}

/// --- WIDGET ANIMADO GENÉRICO (RECTÁNGULOS) ---
class _BlinkingBox extends StatefulWidget {
  final double? width;
  final double? height;

  const _BlinkingBox({this.width, this.height});

  @override
  State<_BlinkingBox> createState() => _BlinkingBoxState();
}

class _BlinkingBoxState extends State<_BlinkingBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true); // va y viene
    _opacity = Tween(begin: 0.4, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacity,
      builder: (_, __) => Opacity(
        opacity: _opacity.value,
        child: Container(
          width: widget.width,
          height: widget.height,
          
          decoration: BoxDecoration(
                     
                      color: Colors.grey[300],
          ),
        ),
      ),
    );
  }
}

/// --- WIDGET ANIMADO PARA CÍRCULOS ---
class _BlinkingCircle extends StatefulWidget {
  final double? sizeFactor; // relativo al ancho de pantalla
  const _BlinkingCircle({this.sizeFactor});

  @override
  State<_BlinkingCircle> createState() => _BlinkingCircleState();
}

class _BlinkingCircleState extends State<_BlinkingCircle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _opacity = Tween(begin: 0.4, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final size = (widget.sizeFactor ?? 0.08) * screenWidth;

    return AnimatedBuilder(
      animation: _opacity,
      builder: (_, __) => Opacity(
        opacity: _opacity.value,
        child: Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
