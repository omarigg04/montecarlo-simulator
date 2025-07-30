import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/simulation_data.dart';

class SimulationProvider extends ChangeNotifier {
  SimulationParameters _parameters = const SimulationParameters();
  SimulationStatistics _statistics = const SimulationStatistics();
  List<Particle> _particles = [];
  Timer? _simulationTimer;
  bool _isRunning = false;
  bool _isPaused = false;
  
  // Getters
  SimulationParameters get parameters => _parameters;
  SimulationStatistics get statistics => _statistics;
  List<Particle> get particles => _particles;
  bool get isRunning => _isRunning;
  bool get isPaused => _isPaused;
  
  void updateParameters(SimulationParameters newParameters) {
    _parameters = newParameters;
    notifyListeners();
  }
  
  void startSimulation() {
    if (_particles.isEmpty) {
      _initializeParticles();
    }
    
    _isRunning = true;
    _isPaused = false;
    
    final speedMs = (101 - _parameters.speed).round();
    _simulationTimer = Timer.periodic(
      Duration(milliseconds: speedMs),
      (_) => _updateSimulation(),
    );
    
    notifyListeners();
  }
  
  void pauseSimulation() {
    _isPaused = true;
    _simulationTimer?.cancel();
    notifyListeners();
    
    if (_isRunning) {
      _isRunning = false;
    }
  }
  
  void resumeSimulation() {
    if (_isPaused) {
      startSimulation();
    }
  }
  
  void resetSimulation() {
    _simulationTimer?.cancel();
    _isRunning = false;
    _isPaused = false;
    _particles.clear();
    _statistics = const SimulationStatistics();
    notifyListeners();
  }
  
  void _initializeParticles() {
    _particles.clear();
    
    if (_parameters.type == SimulationType.randomWalk) {
      _initializeRandomWalkParticles();
    } else if (_parameters.type == SimulationType.piEstimation) {
      _initializePiEstimationParticles();
    }
  }
  
  void _initializeRandomWalkParticles() {
    for (int i = 0; i < _parameters.particleCount; i++) {
      _particles.add(Particle(
        id: 'particle_$i',
        startPoint: const Point(0, 0),
        color: ParticleColor.random(),
      ));
    }
  }
  
  void _initializePiEstimationParticles() {
    final random = Random();
    for (int i = 0; i < _parameters.particleCount; i++) {
      final x = random.nextDouble() * 2 - 1; // [-1, 1]
      final y = random.nextDouble() * 2 - 1; // [-1, 1]
      
      _particles.add(Particle(
        id: 'point_$i',
        startPoint: Point(x, y),
        color: ParticleColor.random(),
      ));
    }
  }
  
  void _updateSimulation() {
    if (_statistics.currentStep >= _parameters.maxSteps) {
      pauseSimulation();
      return;
    }
    
    if (_parameters.type == SimulationType.randomWalk) {
      _updateRandomWalk();
    } else if (_parameters.type == SimulationType.piEstimation) {
      _updatePiEstimation();
    }
    
    _updateStatistics();
    notifyListeners();
  }
  
  void _updateRandomWalk() {
    for (final particle in _particles) {
      particle.move(_parameters.stepSize);
    }
  }
  
  void _updatePiEstimation() {
    // Para π, no necesitamos mover partículas, solo contar las que están dentro del círculo
  }
  
  void _updateStatistics() {
    final activeParticles = _particles.where((p) => p.isActive).toList();
    final distances = activeParticles.map((p) => p.distanceFromOrigin).toList();
    
    double averageDistance = 0.0;
    double maxDistance = 0.0;
    double piEstimate = 0.0;
    
    if (distances.isNotEmpty) {
      averageDistance = distances.reduce((a, b) => a + b) / distances.length;
      maxDistance = distances.reduce(max);
    }
    
    if (_parameters.type == SimulationType.piEstimation) {
      final insideCircle = _particles.where((p) => 
        p.currentPosition.distanceFromOrigin() <= 1.0).length;
      piEstimate = (4.0 * insideCircle) / _particles.length;
    }
    
    final theoreticalRMS = _parameters.type == SimulationType.randomWalk
        ? sqrt(_statistics.currentStep) * _parameters.stepSize
        : 0.0;
    
    // Actualizar historial para gráficas
    final newDistanceHistory = List<double>.from(_statistics.distanceHistory);
    final newPiHistory = List<double>.from(_statistics.piHistory);
    
    newDistanceHistory.add(averageDistance);
    if (_parameters.type == SimulationType.piEstimation) {
      newPiHistory.add(piEstimate);
    }
    
    // Limitar el historial a 500 puntos para rendimiento
    if (newDistanceHistory.length > 500) {
      newDistanceHistory.removeAt(0);
    }
    if (newPiHistory.length > 500) {
      newPiHistory.removeAt(0);
    }
    
    _statistics = SimulationStatistics(
      currentStep: _statistics.currentStep + 1,
      activeParticles: activeParticles.length,
      averageDistance: averageDistance,
      maxDistance: maxDistance,
      theoreticalRMS: theoreticalRMS,
      piEstimate: piEstimate,
      distanceHistory: newDistanceHistory,
      piHistory: newPiHistory,
    );
  }
  
  List<Map<String, dynamic>> exportData() {
    final data = <Map<String, dynamic>>[];
    
    for (int i = 0; i < _particles.length; i++) {
      final particle = _particles[i];
      for (int j = 0; j < particle.path.length; j++) {
        final point = particle.path[j];
        data.add({
          'particle_id': particle.id,
          'step': j,
          'x': point.x,
          'y': point.y,
          'distance_from_origin': point.distanceFromOrigin(),
        });
      }
    }
    
    return data;
  }
  
  @override
  void dispose() {
    _simulationTimer?.cancel();
    super.dispose();
  }
}