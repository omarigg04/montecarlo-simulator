import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/simulation_provider.dart';
import '../models/simulation_data.dart';

class ControlPanel extends StatelessWidget {
  const ControlPanel({Key? key}) : super(key: key);

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
                      Icons.tune,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Controles',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Tipo de simulación
                _buildSimulationTypeSelector(context, provider),
                const SizedBox(height: 16),
                
                // Parámetros
                _buildParameterSlider(
                  context,
                  'Partículas',
                  provider.parameters.particleCount.toDouble(),
                  1,
                  1000,
                  (value) => _updateParameters(
                    provider,
                    provider.parameters.copyWith(particleCount: value.round()),
                  ),
                  divisions: 999,
                ),
                
                _buildParameterSlider(
                  context,
                  'Tamaño del Paso',
                  provider.parameters.stepSize,
                  0.1,
                  10.0,
                  (value) => _updateParameters(
                    provider,
                    provider.parameters.copyWith(stepSize: value),
                  ),
                  divisions: 99,
                ),
                
                _buildParameterSlider(
                  context,
                  'Velocidad',
                  provider.parameters.speed,
                  1,
                  100,
                  (value) => _updateParameters(
                    provider,
                    provider.parameters.copyWith(speed: value),
                  ),
                  divisions: 99,
                ),
                
                _buildParameterSlider(
                  context,
                  'Pasos Máximos',
                  provider.parameters.maxSteps.toDouble(),
                  100,
                  5000,
                  (value) => _updateParameters(
                    provider,
                    provider.parameters.copyWith(maxSteps: value.round()),
                  ),
                  divisions: 49,
                ),
                
                const SizedBox(height: 24),
                
                // Botones de control
                _buildControlButtons(context, provider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSimulationTypeSelector(BuildContext context, SimulationProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tipo de Simulación',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        SegmentedButton<SimulationType>(
          segments: const [
            ButtonSegment(
              value: SimulationType.randomWalk,
              label: Text('Random Walk'),
              icon: Icon(Icons.timeline),
            ),
            ButtonSegment(
              value: SimulationType.piEstimation,
              label: Text('Estimación π'),
              icon: Icon(Icons.pie_chart),
            ),
          ],
          selected: {provider.parameters.type},
          onSelectionChanged: (Set<SimulationType> selection) {
            final newParams = provider.parameters.copyWith(type: selection.first);
            provider.updateParameters(newParams);
            provider.resetSimulation();
          },
        ),
      ],
    );
  }

  Widget _buildParameterSlider(
    BuildContext context,
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged, {
    int? divisions,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.titleMedium),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                value % 1 == 0 ? value.toInt().toString() : value.toStringAsFixed(1),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildControlButtons(BuildContext context, SimulationProvider provider) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: provider.isRunning ? null : provider.startSimulation,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Iniciar'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: FilledButton.icon(
                onPressed: provider.isRunning ? provider.pauseSimulation : null,
                icon: const Icon(Icons.pause),
                label: const Text('Pausar'),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: provider.resetSimulation,
            icon: const Icon(Icons.refresh),
            label: const Text('Reiniciar'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }

  void _updateParameters(SimulationProvider provider, SimulationParameters newParameters) {
    provider.updateParameters(newParameters);
  }
}