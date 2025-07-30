import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/simulation_data.dart';

class ExportService {
  static Future<void> exportToCSV({
    required List<Map<String, dynamic>> data,
    required String filename,
    required SimulationType simulationType,
  }) async {
    try {
      // Preparar datos para CSV
      List<List<dynamic>> csvData = [];
      
      if (simulationType == SimulationType.randomWalk) {
        csvData.add(['particle_id', 'step', 'x', 'y', 'distance_from_origin']);
        for (final row in data) {
          csvData.add([
            row['particle_id'],
            row['step'],
            row['x'],
            row['y'],
            row['distance_from_origin'],
          ]);
        }
      } else if (simulationType == SimulationType.piEstimation) {
        csvData.add(['point_id', 'x', 'y', 'inside_circle', 'distance_from_origin']);
        for (final row in data) {
          final distance = row['distance_from_origin'] as double;
          csvData.add([
            row['particle_id'],
            row['x'],
            row['y'],
            distance <= 1.0,
            distance,
          ]);
        }
      }

      // Convertir a CSV
      String csvString = const ListToCsvConverter().convert(csvData);

      // Obtener directorio de documentos
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$filename');

      // Escribir archivo
      await file.writeAsString(csvString);

      // Compartir archivo
      await Share.shareXFiles([XFile(file.path)], text: 'Datos de simulación Monte Carlo');
    } catch (e) {
      throw Exception('Error al exportar CSV: $e');
    }
  }

  static Future<void> exportToJSON({
    required List<Map<String, dynamic>> data,
    required Map<String, dynamic> metadata,
    required String filename,
  }) async {
    try {
      final exportData = {
        'metadata': metadata,
        'data': data,
        'exported_at': DateTime.now().toIso8601String(),
      };

      final jsonString = const JsonEncoder.withIndent('  ').convert(exportData);

      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$filename');

      await file.writeAsString(jsonString);
      await Share.shareXFiles([XFile(file.path)], text: 'Datos de simulación Monte Carlo (JSON)');
    } catch (e) {
      throw Exception('Error al exportar JSON: $e');
    }
  }

  static Map<String, dynamic> generateMetadata({
    required SimulationParameters parameters,
    required SimulationStatistics statistics,
    required int totalParticles,
  }) {
    return {
      'simulation_type': parameters.type.toString(),
      'parameters': {
        'particle_count': parameters.particleCount,
        'step_size': parameters.stepSize,
        'max_steps': parameters.maxSteps,
        'speed': parameters.speed,
      },
      'statistics': {
        'current_step': statistics.currentStep,
        'active_particles': statistics.activeParticles,
        'average_distance': statistics.averageDistance,
        'max_distance': statistics.maxDistance,
        'theoretical_rms': statistics.theoreticalRMS,
        'pi_estimate': statistics.piEstimate,
      },
      'total_particles': totalParticles,
      'total_data_points': totalParticles * statistics.currentStep,
    };
  }

  static String generateFilename(SimulationType type) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final typeStr = type == SimulationType.randomWalk ? 'random_walk' : 'pi_estimation';
    return 'monte_carlo_${typeStr}_$timestamp';
  }
}