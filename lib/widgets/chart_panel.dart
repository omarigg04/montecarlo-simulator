import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;
import '../providers/simulation_provider.dart';
import '../models/simulation_data.dart';

class ChartPanel extends StatefulWidget {
  const ChartPanel({Key? key}) : super(key: key);

  @override
  State<ChartPanel> createState() => _ChartPanelState();
}

class _ChartPanelState extends State<ChartPanel> {
  int _selectedChartIndex = 0;

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
                      Icons.show_chart,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Gráficas en Tiempo Real',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Selector de gráfica
                _buildChartSelector(context, provider),
                const SizedBox(height: 16),
                
                // Gráfica
                Expanded(
                  child: _buildSelectedChart(context, provider),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildChartSelector(BuildContext context, SimulationProvider provider) {
    final charts = provider.parameters.type == SimulationType.randomWalk
        ? ['Distancia vs Tiempo', 'Distribución de Distancias', 'Comparación Teórica']
        : ['Estimación π vs Tiempo', 'Distribución de Puntos', 'Convergencia'];

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: charts.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(charts[index]),
              selected: _selectedChartIndex == index,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedChartIndex = index;
                  });
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildSelectedChart(BuildContext context, SimulationProvider provider) {
    if (provider.parameters.type == SimulationType.randomWalk) {
      switch (_selectedChartIndex) {
        case 0:
          return _buildDistanceTimeChart(provider);
        case 1:
          return _buildDistanceDistributionChart(provider);
        case 2:
          return _buildTheoreticalComparisonChart(provider);
        default:
          return _buildDistanceTimeChart(provider);
      }
    } else {
      switch (_selectedChartIndex) {
        case 0:
          return _buildPiEstimationChart(provider);
        case 1:
          return _buildPointDistributionChart(provider);
        case 2:
          return _buildConvergenceChart(provider);
        default:
          return _buildPiEstimationChart(provider);
      }
    }
  }

  Widget _buildDistanceTimeChart(SimulationProvider provider) {
    final history = provider.statistics.distanceHistory;
    if (history.isEmpty) {
      return const Center(child: Text('No hay datos para mostrar'));
    }

    final spots = history.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value);
    }).toList();

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 5,
          verticalInterval: 50,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.3),
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.3),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: math.max(1, history.length / 5),
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 5,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toStringAsFixed(0),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: const ui.Color(0xff37434d)),
        ),
        minX: 0,
        maxX: history.length.toDouble(),
        minY: 0,
        maxY: history.isNotEmpty ? history.reduce(math.max) * 1.1 : 10,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            gradient: LinearGradient(
              colors: [
                Colors.blue.withOpacity(0.8),
                Colors.blue.withOpacity(0.3),
              ],
            ),
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Colors.blue.withOpacity(0.3),
                  Colors.blue.withOpacity(0.1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDistanceDistributionChart(SimulationProvider provider) {
    final particles = provider.particles;
    if (particles.isEmpty) {
      return const Center(child: Text('No hay datos para mostrar'));
    }

    // Crear histograma de distancias
    final distances = particles.map((p) => p.distanceFromOrigin).toList();
    final maxDistance = distances.reduce(math.max);
    final binCount = 20;
    final binSize = maxDistance / binCount;
    
    final bins = List.generate(binCount, (index) => 0);
    for (final distance in distances) {
      final binIndex = math.min((distance / binSize).floor(), binCount - 1);
      bins[binIndex]++;
    }

    final barGroups = bins.asMap().entries.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: entry.value.toDouble(),
            color: Colors.green.withOpacity(0.8),
            width: 12,
            borderRadius: BorderRadius.circular(2),
          ),
        ],
      );
    }).toList();

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: bins.reduce(math.max).toDouble() * 1.1,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                final binValue = (value * binSize).toStringAsFixed(1);
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    binValue,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 8,
                    ),
                  ),
                );
              },
              reservedSize: 30,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        barGroups: barGroups,
        gridData: FlGridData(show: false),
      ),
    );
  }

  Widget _buildTheoreticalComparisonChart(SimulationProvider provider) {
    final history = provider.statistics.distanceHistory;
    if (history.isEmpty) {
      return const Center(child: Text('No hay datos para mostrar'));
    }

    final actualSpots = history.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value);
    }).toList();

    final theoreticalSpots = List.generate(history.length, (index) {
      final step = index + 1;
      final theoretical = math.sqrt(step) * provider.parameters.stepSize;
      return FlSpot(index.toDouble(), theoretical);
    });

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          // Datos reales
          LineChartBarData(
            spots: actualSpots,
            isCurved: true,
            color: Colors.blue,
            barWidth: 2,
            dotData: FlDotData(show: false),
          ),
          // Datos teóricos
          LineChartBarData(
            spots: theoreticalSpots,
            isCurved: false,
            color: Colors.red,
            barWidth: 2,
            dashArray: [5, 5],
            dotData: FlDotData(show: false),
          ),
        ],
      ),
    );
  }

  Widget _buildPiEstimationChart(SimulationProvider provider) {
    final history = provider.statistics.piHistory;
    if (history.isEmpty) {
      return const Center(child: Text('No hay datos para mostrar'));
    }

    final spots = history.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value);
    }).toList();

    final piLineSpots = [
      FlSpot(0, math.pi),
      FlSpot(history.length.toDouble(), math.pi),
    ];

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: true),
        minY: 2.5,
        maxY: 3.5,
        lineBarsData: [
          // Estimación de π
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.orange,
            barWidth: 2,
            dotData: FlDotData(show: false),
          ),
          // Valor real de π
          LineChartBarData(
            spots: piLineSpots,
            isCurved: false,
            color: Colors.red,
            barWidth: 2,
            dashArray: [5, 5],
            dotData: FlDotData(show: false),
          ),
        ],
      ),
    );
  }

  Widget _buildPointDistributionChart(SimulationProvider provider) {
    return const Center(
      child: Text('Gráfica de distribución de puntos\n(Ver canvas principal)'),
    );
  }

  Widget _buildConvergenceChart(SimulationProvider provider) {
    final history = provider.statistics.piHistory;
    if (history.isEmpty) {
      return const Center(child: Text('No hay datos para mostrar'));
    }

    // Calcular error absoluto en cada punto
    final errorSpots = history.asMap().entries.map((entry) {
      final error = (entry.value - math.pi).abs();
      return FlSpot(entry.key.toDouble(), error);
    }).toList();

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: errorSpots,
            isCurved: true,
            color: Colors.purple,
            barWidth: 2,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.purple.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
}