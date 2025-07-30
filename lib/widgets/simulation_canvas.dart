import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;
import '../providers/simulation_provider.dart';
import '../models/simulation_data.dart';

class SimulationCanvas extends StatefulWidget {
  const SimulationCanvas({Key? key}) : super(key: key);

  @override
  State<SimulationCanvas> createState() => _SimulationCanvasState();
}

class _SimulationCanvasState extends State<SimulationCanvas> {
  final TransformationController _transformationController = TransformationController();
  
  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SimulationProvider>(
      builder: (context, provider, child) {
        return Card(
          child: Stack(
            children: [
              InteractiveViewer(
                transformationController: _transformationController,
                minScale: 0.1,
                maxScale: 5.0,
                constrained: false,
                child: Container(
                  width: 1200, // Canvas más grande para mejor zoom
                  height: 900,
                  child: CustomPaint(
                    painter: provider.parameters.type == SimulationType.randomWalk
                        ? RandomWalkPainter(provider.particles, provider.statistics)
                        : PiEstimationPainter(provider.particles, provider.statistics),
                  ),
                ),
              ),
              // Controles de zoom
              Positioned(
                top: 8,
                right: 8,
                child: _buildZoomControls(),
              ),
              // Información de zoom
              Positioned(
                bottom: 8,
                left: 8,
                child: _buildZoomInfo(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildZoomControls() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              IconButton(
                icon: const Icon(Icons.zoom_in, color: Colors.white),
                onPressed: _zoomIn,
                tooltip: 'Acercar',
              ),
              IconButton(
                icon: const Icon(Icons.zoom_out, color: Colors.white),
                onPressed: _zoomOut,
                tooltip: 'Alejar',
              ),
              IconButton(
                icon: const Icon(Icons.center_focus_strong, color: Colors.white),
                onPressed: _resetZoom,
                tooltip: 'Centrar',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildZoomInfo() {
    return ValueListenableBuilder<Matrix4>(
      valueListenable: _transformationController,
      builder: (context, matrix, child) {
        final scale = matrix.getMaxScaleOnAxis();
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            'Zoom: ${scale.toStringAsFixed(1)}x',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }

  void _zoomIn() {
    final currentScale = _transformationController.value.getMaxScaleOnAxis();
    if (currentScale < 5.0) {
      _transformationController.value = Matrix4.identity()..scale(currentScale * 1.2);
    }
  }

  void _zoomOut() {
    final currentScale = _transformationController.value.getMaxScaleOnAxis();
    if (currentScale > 0.1) {
      _transformationController.value = Matrix4.identity()..scale(currentScale / 1.2);
    }
  }

  void _resetZoom() {
    _transformationController.value = Matrix4.identity();
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
    final scale = math.min(size.width, size.height) / 600; // Mejor escala para canvas más grande

    // Dibujar fondo
    final backgroundPaint = Paint()..color = Colors.black;
    canvas.drawRect(Offset.zero & size, backgroundPaint);

    // Dibujar centro
    final centerPaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(centerX, centerY), 6, centerPaint);
    
    // Dibujar grid de referencia
    _drawGrid(canvas, size, centerX, centerY, scale);

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
        particle.isActive ? 4 : 3, // Partículas un poco más grandes
        particlePaint,
      );
    }

    // Dibujar información
    _drawInfo(canvas, size);
  }

  void _drawGrid(Canvas canvas, Size size, double centerX, double centerY, double scale) {
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 0.5;

    // Líneas verticales y horizontales principales
    canvas.drawLine(
      Offset(0, centerY),
      Offset(size.width, centerY),
      gridPaint,
    );
    canvas.drawLine(
      Offset(centerX, 0),
      Offset(centerX, size.height),
      gridPaint,
    );

    // Grid secundario
    final gridSpacing = 50 * scale;
    if (gridSpacing > 20) { // Solo mostrar si el grid no está muy denso
      gridPaint.color = Colors.white.withOpacity(0.05);
      
      // Líneas verticales
      for (double x = centerX + gridSpacing; x < size.width; x += gridSpacing) {
        canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
      }
      for (double x = centerX - gridSpacing; x > 0; x -= gridSpacing) {
        canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
      }
      
      // Líneas horizontales
      for (double y = centerY + gridSpacing; y < size.height; y += gridSpacing) {
        canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
      }
      for (double y = centerY - gridSpacing; y > 0; y -= gridSpacing) {
        canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
      }
    }
  }

  void _drawInfo(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    );

    final infoText = 'Paso: ${statistics.currentStep}\n'
        'Partículas activas: ${statistics.activeParticles}\n'
        'Distancia promedio: ${statistics.averageDistance.toStringAsFixed(1)}\n'
        'Distancia máxima: ${statistics.maxDistance.toStringAsFixed(1)}\n'
        'RMS teórico: ${statistics.theoreticalRMS.toStringAsFixed(1)}';

    textPainter.text = TextSpan(
      text: infoText,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontFamily: 'monospace',
        shadows: [
          Shadow(
            offset: Offset(1, 1),
            blurRadius: 2,
            color: Colors.black,
          ),
        ],
      ),
    );

    textPainter.layout();
    
    // Fondo semi-transparente para mejor legibilidad
    final backgroundRect = Rect.fromLTWH(
      10,
      10,
      textPainter.width + 10,
      textPainter.height + 10,
    );
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(backgroundRect, const Radius.circular(4)),
      Paint()..color = Colors.black.withOpacity(0.7),
    );
    
    textPainter.paint(canvas, const Offset(15, 15));
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
    final radius = math.min(size.width, size.height) / 2 * 0.7; // Mejor proporción para canvas más grande

    // Dibujar fondo
    final backgroundPaint = Paint()..color = Colors.black;
    canvas.drawRect(Offset.zero & size, backgroundPaint);

    // Dibujar grid de referencia
    _drawPiGrid(canvas, size, centerX, centerY, radius);

    // Dibujar cuadrado
    paint
      ..color = Colors.white.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(centerX, centerY),
        width: radius * 2,
        height: radius * 2,
      ),
      paint,
    );

    // Dibujar círculo
    paint
      ..color = Colors.blue.withOpacity(0.4)
      ..strokeWidth = 3;
    canvas.drawCircle(Offset(centerX, centerY), radius, paint);

    // Dibujar puntos
    for (final particle in particles) {
      final point = particle.currentPosition;
      final x = centerX + point.x * radius;
      final y = centerY + point.y * radius;
      
      final distance = point.distanceFromOrigin();
      final isInside = distance <= 1.0;
      
      final pointPaint = Paint()
        ..color = isInside ? Colors.green.withOpacity(0.8) : Colors.red.withOpacity(0.8)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(Offset(x, y), 3, pointPaint); // Puntos más grandes para mejor visibilidad
    }

    // Dibujar información
    _drawInfo(canvas, size);
  }

  void _drawPiGrid(Canvas canvas, Size size, double centerX, double centerY, double radius) {
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 0.5;

    // Líneas del cuadrado principales
    final left = centerX - radius;
    final right = centerX + radius;
    final top = centerY - radius;
    final bottom = centerY + radius;

    // Divisiones del cuadrado para referencia
    final divisions = 4;
    final stepX = (radius * 2) / divisions;
    final stepY = (radius * 2) / divisions;

    // Líneas verticales
    for (int i = 1; i < divisions; i++) {
      final x = left + i * stepX;
      canvas.drawLine(
        Offset(x, top),
        Offset(x, bottom),
        gridPaint,
      );
    }

    // Líneas horizontales
    for (int i = 1; i < divisions; i++) {
      final y = top + i * stepY;
      canvas.drawLine(
        Offset(left, y),
        Offset(right, y),
        gridPaint,
      );
    }

    // Ejes principales
    gridPaint.color = Colors.white.withOpacity(0.2);
    canvas.drawLine(
      Offset(left, centerY),
      Offset(right, centerY),
      gridPaint,
    );
    canvas.drawLine(
      Offset(centerX, top),
      Offset(centerX, bottom),
      gridPaint,
    );
  }

  void _drawInfo(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    );

    final insideCount = particles.where((p) => p.currentPosition.distanceFromOrigin() <= 1.0).length;
    final totalCount = particles.length;
    final piEstimate = statistics.piEstimate;
    final accuracy = totalCount > 0 ? (1 - (piEstimate - math.pi).abs() / math.pi) * 100 : 0.0;

    final infoText = 'Puntos totales: $totalCount\n'
        'Puntos dentro: $insideCount\n'
        'Estimación π: ${piEstimate.toStringAsFixed(6)}\n'
        'π real: ${math.pi.toStringAsFixed(6)}\n'
        'Error: ${(piEstimate - math.pi).abs().toStringAsFixed(6)}\n'
        'Precisión: ${accuracy.toStringAsFixed(2)}%';

    textPainter.text = TextSpan(
      text: infoText,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontFamily: 'monospace',
        shadows: [
          Shadow(
            offset: Offset(1, 1),
            blurRadius: 2,
            color: Colors.black,
          ),
        ],
      ),
    );

    textPainter.layout();
    
    // Fondo semi-transparente para mejor legibilidad
    final backgroundRect = Rect.fromLTWH(
      10,
      10,
      textPainter.width + 10,
      textPainter.height + 10,
    );
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(backgroundRect, const Radius.circular(4)),
      Paint()..color = Colors.black.withOpacity(0.7),
    );
    
    textPainter.paint(canvas, const Offset(15, 15));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}