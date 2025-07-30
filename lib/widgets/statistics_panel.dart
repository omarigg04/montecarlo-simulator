import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;
import '../providers/simulation_provider.dart';
import '../models/simulation_data.dart';
import '../services/export_service.dart';

class StatisticsPanel extends StatelessWidget {
  const StatisticsPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SimulationProvider>(
      builder: (context, provider, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.analytics,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Estadísticas en Tiempo Real',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                if (provider.parameters.type == SimulationType.randomWalk)
                  _buildRandomWalkStats(context, provider)
                else
                  _buildPiEstimationStats(context, provider),
                
                const SizedBox(height: 16),
                _buildExportButton(context, provider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRandomWalkStats(BuildContext context, SimulationProvider provider) {
    final stats = provider.statistics;
    
    return Column(
      children: [
        _buildStatRow(
          context,
          'Pasos Actuales',
          stats.currentStep.toString(),
          Icons.timeline,
          ui.Color(0xFF2196F3),
        ),
        _buildStatRow(
          context,
          'Partículas Activas',
          stats.activeParticles.toString(),
          Icons.scatter_plot,
          ui.Color(0xFF4CAF50),
        ),
        _buildStatRow(
          context,
          'Distancia Promedio',
          stats.averageDistance.toStringAsFixed(2),
          Icons.straighten,
          ui.Color(0xFFFF9800),
        ),
        _buildStatRow(
          context,
          'Distancia Máxima',
          stats.maxDistance.toStringAsFixed(2),
          Icons.trending_up,
          ui.Color(0xFFF44336),
        ),
        _buildStatRow(
          context,
          'RMS Teórico (√n)',
          stats.theoreticalRMS.toStringAsFixed(2),
          Icons.functions,
          ui.Color(0xFF9C27B0),
        ),
        _buildStatRow(
          context,
          'Eficiencia (%)',
          _calculateEfficiency(stats).toStringAsFixed(1),
          Icons.speed,
          ui.Color(0xFF00BCD4),
        ),
      ],
    );
  }

  Widget _buildPiEstimationStats(BuildContext context, SimulationProvider provider) {
    final stats = provider.statistics;
    final particles = provider.particles;
    final insideCount = particles.where((p) => p.currentPosition.distanceFromOrigin() <= 1.0).length;
    final totalCount = particles.length;
    final accuracy = totalCount > 0 ? (1 - (stats.piEstimate - math.pi).abs() / math.pi) * 100 : 0.0;
    
    return Column(
      children: [
        _buildStatRow(
          context,
          'Puntos Totales',
          totalCount.toString(),
          Icons.scatter_plot,
          ui.Color(0xFF2196F3),
        ),
        _buildStatRow(
          context,
          'Puntos Dentro del Círculo',
          insideCount.toString(),
          Icons.circle,
          ui.Color(0xFF4CAF50),
        ),
        _buildStatRow(
          context,
          'Estimación de π',
          stats.piEstimate.toStringAsFixed(6),
          Icons.pie_chart,
          ui.Color(0xFFFF9800),
        ),
        _buildStatRow(
          context,
          'π Real',
          math.pi.toStringAsFixed(6),
          Icons.functions,
          ui.Color(0xFF9C27B0),
        ),
        _buildStatRow(
          context,
          'Error Absoluto',
          (stats.piEstimate - math.pi).abs().toStringAsFixed(6),
          Icons.error_outline,
          ui.Color(0xFFF44336),
        ),
        _buildStatRow(
          context,
          'Precisión (%)',
          accuracy.toStringAsFixed(2),
          Icons.verified,
          ui.Color(0xFF00BCD4),
        ),
      ],
    );
  }

  Widget _buildStatRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    ui.Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(color.value).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Color(color.value), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[400],
                  ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Color(color.value),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExportButton(BuildContext context, SimulationProvider provider) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: provider.particles.isNotEmpty ? () => _exportData(context, provider) : null,
        icon: const Icon(Icons.download),
        label: const Text('Exportar Datos'),
      ),
    );
  }

  double _calculateEfficiency(SimulationStatistics stats) {
    if (stats.theoreticalRMS == 0) return 0.0;
    return (stats.theoreticalRMS / stats.averageDistance) * 100;
  }

  void _exportData(BuildContext context, SimulationProvider provider) {
    final data = provider.exportData();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exportar Datos'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total de registros: ${data.length}'),
            Text('Partículas: ${provider.particles.length}'),
            Text('Pasos: ${provider.statistics.currentStep}'),
            const SizedBox(height: 16),
            const Text('Los datos incluyen:'),
            const Text('• ID de partícula'),
            const Text('• Número de paso'),
            const Text('• Coordenadas X, Y'),
            const Text('• Distancia desde el origen'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
          OutlinedButton(
            onPressed: () => _handleExport(context, provider, 'json'),
            child: const Text('JSON'),
          ),
          FilledButton(
            onPressed: () => _handleExport(context, provider, 'csv'),
            child: const Text('CSV'),
          ),
        ],
      ),
    );
  }

  void _handleExport(BuildContext context, SimulationProvider provider, String format) async {
    Navigator.of(context).pop();
    
    try {
      final data = provider.exportData();
      final filename = '${ExportService.generateFilename(provider.parameters.type)}.$format';
      
      if (format == 'csv') {
        await ExportService.exportToCSV(
          data: data,
          filename: filename,
          simulationType: provider.parameters.type,
        );
      } else if (format == 'json') {
        final metadata = ExportService.generateMetadata(
          parameters: provider.parameters,
          statistics: provider.statistics,
          totalParticles: provider.particles.length,
        );
        
        await ExportService.exportToJSON(
          data: data,
          metadata: metadata,
          filename: filename,
        );
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Datos exportados como $format'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al exportar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}