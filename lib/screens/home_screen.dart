import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/simulation_provider.dart';
import '../widgets/control_panel.dart';
import '../widgets/simulation_canvas.dart';
import '../widgets/statistics_panel.dart';
import '../widgets/chart_panel.dart';
import '../models/simulation_data.dart';
import 'theory_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '🎲 Monte Carlo Simulator',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.library_books),
            tooltip: 'Teoría Monte Carlo',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TheoryScreen(),
                ),
              );
            },
          ),
          Consumer<SimulationProvider>(
            builder: (context, provider, child) {
              return PopupMenuButton<SimulationType>(
                icon: const Icon(Icons.science),
                onSelected: (SimulationType type) {
                  final newParams = provider.parameters.copyWith(type: type);
                  provider.updateParameters(newParams);
                  provider.resetSimulation();
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: SimulationType.randomWalk,
                    child: ListTile(
                      leading: Icon(Icons.timeline),
                      title: Text('Camino Aleatorio'),
                      dense: true,
                    ),
                  ),
                  const PopupMenuItem(
                    value: SimulationType.piEstimation,
                    child: ListTile(
                      leading: Icon(Icons.pie_chart),
                      title: Text('Estimación de π'),
                      dense: true,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWideScreen = constraints.maxWidth > 800;
          
          if (isWideScreen) {
            return _buildWideLayout();
          } else {
            return _buildNarrowLayout();
          }
        },
      ),
    );
  }

  Widget _buildWideLayout() {
    return Row(
      children: [
        // Panel izquierdo - Controles y estadísticas
        Container(
          width: 350,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const ControlPanel(),
              const SizedBox(height: 16),
              const Expanded(child: StatisticsPanel()),
            ],
          ),
        ),
        // Panel central - Simulación
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: const SimulationCanvas(),
          ),
        ),
        // Panel derecho - Gráficas
        Container(
          width: 350,
          padding: const EdgeInsets.all(16),
          child: const ChartPanel(),
        ),
      ],
    );
  }

  Widget _buildNarrowLayout() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: ControlPanel(),
          ),
          Container(
            height: 400,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const SimulationCanvas(),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: StatisticsPanel(),
          ),
          const SizedBox(height: 16),
          Container(
            height: 300,
            padding: const EdgeInsets.all(16.0),
            child: const ChartPanel(),
          ),
        ],
      ),
    );
  }
}