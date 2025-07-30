import 'dart:math';

class Point {
  final double x;
  final double y;
  
  const Point(this.x, this.y);
  
  double distanceFromOrigin() => sqrt(x * x + y * y);
  
  @override
  String toString() => 'Point($x, $y)';
}

class Particle {
  final String id;
  final List<Point> path;
  final ParticleColor color;
  bool isActive;
  
  Particle({
    required this.id,
    required Point startPoint,
    required this.color,
    this.isActive = true,
  }) : path = [startPoint];
  
  Point get currentPosition => path.last;
  Point get startPosition => path.first;
  
  double get distanceFromOrigin => currentPosition.distanceFromOrigin();
  
  void move(double stepSize) {
    if (!isActive) return;
    
    final angle = Random().nextDouble() * 2 * pi;
    final newX = currentPosition.x + cos(angle) * stepSize;
    final newY = currentPosition.y + sin(angle) * stepSize;
    
    path.add(Point(newX, newY));
  }
}

class SimulationParameters {
  final int particleCount;
  final double stepSize;
  final int maxSteps;
  final double speed;
  final SimulationType type;
  
  const SimulationParameters({
    this.particleCount = 100,
    this.stepSize = 2.0,
    this.maxSteps = 1000,
    this.speed = 50.0,
    this.type = SimulationType.randomWalk,
  });
  
  SimulationParameters copyWith({
    int? particleCount,
    double? stepSize,
    int? maxSteps,
    double? speed,
    SimulationType? type,
  }) {
    return SimulationParameters(
      particleCount: particleCount ?? this.particleCount,
      stepSize: stepSize ?? this.stepSize,
      maxSteps: maxSteps ?? this.maxSteps,
      speed: speed ?? this.speed,
      type: type ?? this.type,
    );
  }
}

class SimulationStatistics {
  final int currentStep;
  final int activeParticles;
  final double averageDistance;
  final double maxDistance;
  final double theoreticalRMS;
  final double piEstimate;
  final List<double> distanceHistory;
  final List<double> piHistory;
  
  const SimulationStatistics({
    this.currentStep = 0,
    this.activeParticles = 0,
    this.averageDistance = 0.0,
    this.maxDistance = 0.0,
    this.theoreticalRMS = 0.0,
    this.piEstimate = 0.0,
    this.distanceHistory = const [],
    this.piHistory = const [],
  });
}

enum SimulationType {
  randomWalk,
  piEstimation,
}

class ParticleColor {
  final int value;
  
  const ParticleColor(this.value);
  
  static ParticleColor random() {
    final hue = Random().nextDouble() * 360;
    return ParticleColor(_hslToRgb(hue, 0.7, 0.6));
  }
  
  static int _hslToRgb(double h, double s, double l) {
    h /= 360;
    final c = (1 - (2 * l - 1).abs()) * s;
    final x = c * (1 - ((h * 6) % 2 - 1).abs());
    final m = l - c / 2;
    
    double r, g, b;
    if (h < 1/6) {
      r = c; g = x; b = 0;
    } else if (h < 2/6) {
      r = x; g = c; b = 0;
    } else if (h < 3/6) {
      r = 0; g = c; b = x;
    } else if (h < 4/6) {
      r = 0; g = x; b = c;
    } else if (h < 5/6) {
      r = x; g = 0; b = c;
    } else {
      r = c; g = 0; b = x;
    }
    
    final red = ((r + m) * 255).round();
    final green = ((g + m) * 255).round();
    final blue = ((b + m) * 255).round();
    
    return (0xFF << 24) | (red << 16) | (green << 8) | blue;
  }
}