import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;
import '../providers/simulation_provider.dart';
import '../models/simulation_data.dart';

class SimulationCanvas extends StatelessWidget {
  const SimulationCanvas({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SimulationProvider>(
      builder: (context, provider, child) {
        return Card(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: CustomPaint(
              painter: provider.parameters.type == SimulationType.randomWalk
                  ? RandomWalkPainter(provider.particles, provider.statistics)
                  : PiEstimationPainter(provider.particles, provider.statistics),
            ),
          ),
        );
      },
    );
  }
}

class RandomWalkPainter extends CustomPainter {
  final List<Particle> particles;
  final SimulationStatistics statistics;

  RandomWalkPainter(this.particles, this.statistics);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final scale = math.min(size.width, size.height) / 400;

    // Dibujar fondo
    final backgroundPaint = Paint()..color = Colors.black;
    canvas.drawRect(Offset.zero & size, backgroundPaint);

    // Dibujar centro
    final centerPaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(centerX, centerY), 4, centerPaint);

    // Dibujar partículas y sus caminos
    for (final particle in particles) {
      if (particle.path.length < 2) continue;

      // Convertir color personalizado a Color de Flutter
      final flutterColor = ui.Color(particle.color.value);
      
      // Dibujar camino
      paint.color = flutterColor.withOpacity(0.3);
      final path = Path();
      
      final startPoint = particle.path.first;
      path.moveTo(
        centerX + startPoint.x * scale,
        centerY + startPoint.y * scale,
      );

      for (int i = 1; i < particle.path.length; i++) {
        final point = particle.path[i];
        path.lineTo(
          centerX + point.x * scale,
          centerY + point.y * scale,
        );
      }
      
      canvas.drawPath(path, paint);

      // Dibujar partícula actual
      final currentPoint = particle.currentPosition;
      final particlePaint = Paint()
        ..color = flutterColor
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(
        Offset(
          centerX + currentPoint.x * scale,
          centerY + currentPoint.y * scale,
        ),
        particle.isActive ? 3 : 2,
        particlePaint,
      );
    }

    // Dibujar información
    _drawInfo(canvas, size);
  }

  void _drawInfo(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    );

    final infoText = 'Paso: ${statistics.currentStep}\n'
        'Partículas activas: ${statistics.activeParticles}\n'
        'Distancia promedio: ${statistics.averageDistance.toStringAsFixed(1)}\n'
        'Distancia máxima: ${statistics.maxDistance.toStringAsFixed(1)}';

    textPainter.text = TextSpan(
      text: infoText,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontFamily: 'monospace',
      ),
    );

    textPainter.layout();
    textPainter.paint(canvas, const Offset(10, 10));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class PiEstimationPainter extends CustomPainter {
  final List<Particle> particles;
  final SimulationStatistics statistics;

  PiEstimationPainter(this.particles, this.statistics);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = math.min(size.width, size.height) / 2 * 0.8;

    // Dibujar fondo
    final backgroundPaint = Paint()..color = Colors.black;
    canvas.drawRect(Offset.zero & size, backgroundPaint);

    // Dibujar cuadrado
    paint
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(centerX, centerY),
        width: radius * 2,
        height: radius * 2,
      ),
      paint,
    );

    // Dibujar círculo
    paint.color = Colors.blue.withOpacity(0.3);
    canvas.drawCircle(Offset(centerX, centerY), radius, paint);

    // Dibujar puntos
    for (final particle in particles) {
      final point = particle.currentPosition;
      final x = centerX + point.x * radius;
      final y = centerY + point.y * radius;
      
      final distance = point.distanceFromOrigin();
      final isInside = distance <= 1.0;
      
      final pointPaint = Paint()
        ..color = isInside ? Colors.green : Colors.red
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(Offset(x, y), 2, pointPaint);
    }

    // Dibujar información
    _drawInfo(canvas, size);
  }

  void _drawInfo(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    );

    final insideCount = particles.where((p) => p.currentPosition.distanceFromOrigin() <= 1.0).length;
    final totalCount = particles.length;
    final piEstimate = statistics.piEstimate;

    final infoText = 'Puntos totales: $totalCount\n'
        'Puntos dentro: $insideCount\n'
        'Estimación π: ${piEstimate.toStringAsFixed(4)}\n'
        'Error: ${(piEstimate - math.pi).abs().toStringAsFixed(4)}';

    textPainter.text = TextSpan(
      text: infoText,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontFamily: 'monospace',
      ),
    );

    textPainter.layout();
    textPainter.paint(canvas, const Offset(10, 10));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}