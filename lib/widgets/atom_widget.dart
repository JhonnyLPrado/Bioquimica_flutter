import 'package:flutter/material.dart';
import 'dart:math';
import '../utils/bohr_shells.dart';

class AtomWidget extends StatefulWidget {
  final String simbolo;
  final int numeroAtomico;
  final double size;
  final Color color;

  const AtomWidget({
    super.key,
    required this.simbolo,
    required this.numeroAtomico,
    required this.size,
    required this.color,
  });

  @override
  State<AtomWidget> createState() => _AtomWidgetState();
}

class _AtomWidgetState extends State<AtomWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late List<int> shells;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    shells = computeBohrShells(widget.numeroAtomico);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Fondo circular
              Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  color: widget.color.withOpacity(0.22),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: widget.color.withOpacity(0.45),
                      blurRadius: 40,
                      spreadRadius: 5,
                    ),
                  ],
                ),
              ),

              // Órbitas y electrones
              ...List.generate(shells.length, (i) {
                final electrons = shells[i];
                if (electrons == 0) return const SizedBox();

                final radius = (widget.size * 0.22) + (i * 22.0);

                return CustomPaint(
                  painter: OrbitPainter(
                    color: Colors.white.withOpacity(0.9),
                    radius: radius,
                  ),
                  child: Stack(
                    children: List.generate(electrons, (e) {
                      final angle =
                          controller.value * 2 * pi +
                          (2 * pi / electrons) * e +
                          i * 0.4;

                      return Positioned(
                        left: radius * cos(angle) + widget.size / 2 - 6,
                        top: radius * sin(angle) + widget.size / 2 - 6,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.9),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                );
              }),

              // Núcleo 3D
              Container(
                width: widget.size * 0.30,
                height: widget.size * 0.30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white,
                      Colors.grey.shade400,
                      Colors.grey.shade800,
                    ],
                    center: Alignment.topLeft,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 12,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  widget.simbolo,
                  style: TextStyle(
                    fontSize: widget.size * 0.14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Órbita
class OrbitPainter extends CustomPainter {
  final Color color;
  final double radius;

  OrbitPainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
