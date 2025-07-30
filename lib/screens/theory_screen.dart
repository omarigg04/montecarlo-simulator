import 'package:flutter/material.dart';
import 'dart:math' as math;

class TheoryScreen extends StatelessWidget {
  const TheoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📚 Teoría del Método Monte Carlo'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIntroductionCard(),
            const SizedBox(height: 16),
            _buildHistoryCard(),
            const SizedBox(height: 16),
            _buildPrinciplesCard(),
            const SizedBox(height: 16),
            _buildRandomWalkCard(),
            const SizedBox(height: 16),
            _buildPiEstimationCard(),
            const SizedBox(height: 16),
            _buildApplicationsCard(),
            const SizedBox(height: 16),
            _buildAdvantagesCard(),
            const SizedBox(height: 16),
            _buildMathematicalFoundationCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildIntroductionCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb, color: Colors.amber, size: 24),
                const SizedBox(width: 8),
                Text(
                  '¿Qué es el Método Monte Carlo?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'El método Monte Carlo es una técnica computacional que utiliza números aleatorios para resolver problemas matemáticos y físicos complejos. Su nombre proviene del famoso casino de Monte Carlo en Mónaco, haciendo referencia al elemento aleatorio central del método.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Text(
                '💡 Idea Central: Usar la aleatoriedad para aproximar soluciones a problemas determinísticos que son difíciles de resolver analíticamente.',
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.blue[700],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.history, color: Colors.brown, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Historia y Desarrollo',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTimelineItem(
              '1940s',
              'Stanisław Ulam y John von Neumann',
              'Desarrollo durante el Proyecto Manhattan para simular la difusión de neutrones en materiales fisibles.',
            ),
            _buildTimelineItem(
              '1946',
              'Publicación del Método',
              'Primera descripción formal del método en problemas de física nuclear.',
            ),
            _buildTimelineItem(
              '1950s-60s',
              'Expansión a otras áreas',
              'Aplicación en finanzas, ingeniería, ciencias sociales y más.',
            ),
            _buildTimelineItem(
              'Actualidad',
              'Era de la Computación',
              'Amplio uso en machine learning, simulaciones complejas y análisis de riesgo.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(String year, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.brown.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              year,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.brown[700],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrinciplesCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.psychology, color: Colors.purple, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Principios Fundamentales',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildPrincipleItem(
              '🎲 Muestreo Aleatorio',
              'Se generan números aleatorios que representan posibles estados o configuraciones del sistema.',
            ),
            _buildPrincipleItem(
              '📊 Simulación Estadística',
              'Se ejecutan múltiples simulaciones independientes para obtener una muestra representativa.',
            ),
            _buildPrincipleItem(
              '🔢 Convergencia Numérica',
              'A medida que aumenta el número de muestras, la estimación converge al valor verdadero.',
            ),
            _buildPrincipleItem(
              '📈 Ley de los Grandes Números',
              'El promedio de una gran cantidad de observaciones se aproxima al valor esperado.',
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Error de Estimación:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'El error típicamente decrece como 1/√N, donde N es el número de muestras.',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrincipleItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              description,
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRandomWalkCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.timeline, color: Colors.green, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Camino Aleatorio (Random Walk)',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Un camino aleatorio es una secuencia de movimientos donde cada paso se toma en una dirección aleatoria. Es uno de los procesos estocásticos más fundamentales.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 12),
            _buildSubsection('📐 Matemática del Random Walk:', [
              '• Posición inicial: (0, 0)',
              '• Cada paso: dirección θ aleatoria ∈ [0, 2π]',
              '• Nueva posición: x_{n+1} = x_n + r·cos(θ), y_{n+1} = y_n + r·sin(θ)',
              '• Distancia RMS teórica: √(N) × tamaño_paso',
            ]),
            const SizedBox(height: 12),
            _buildSubsection('🔬 Aplicaciones Reales:', [
              '• Movimiento Browniano de partículas',
              '• Difusión molecular en gases y líquidos',
              '• Fluctuaciones en mercados financieros',
              '• Migración de especies en ecosistemas',
              '• Propagación de rumores en redes sociales',
            ]),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '🧮 Teorema Central del Límite: La distribución de la posición final se aproxima a una distribución gaussiana para N grande.',
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.green[700],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPiEstimationCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.pie_chart, color: Colors.orange, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Estimación de π por Monte Carlo',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Este método estima π lanzando puntos aleatorios en un cuadrado que contiene un círculo, y contando cuántos caen dentro del círculo.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 12),
            _buildSubsection('📊 Procedimiento:', [
              '1. Generar puntos aleatorios (x,y) en el cuadrado [-1,1] × [-1,1]',
              '2. Verificar si x² + y² ≤ 1 (punto dentro del círculo)',
              '3. Contar puntos dentro vs. puntos totales',
              '4. Estimar π = 4 × (puntos_dentro / puntos_totales)',
            ]),
            const SizedBox(height: 12),
            _buildSubsection('🧮 Fundamento Matemático:', [
              '• Área del círculo unitario = π × r² = π × 1² = π',
              '• Área del cuadrado = 2 × 2 = 4',
              '• Relación de áreas = π/4',
              '• Por tanto: π = 4 × (área_círculo / área_cuadrado)',
            ]),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '⚡ Convergencia:',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange[700]),
                  ),
                  Text(
                    'Error ≈ √(π(4-π)/(4N)) ≈ 1.64/√N',
                    style: TextStyle(fontSize: 14, color: Colors.orange[700]),
                  ),
                  Text(
                    'Para 3 decimales correctos se necesitan ~1,000,000 puntos',
                    style: TextStyle(fontSize: 12, color: Colors.orange[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplicationsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.apps, color: Colors.teal, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Aplicaciones del Método Monte Carlo',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildApplicationCategory('🏦 Finanzas', [
              'Valoración de opciones y derivados',
              'Análisis de riesgo de carteras',
              'Simulación de precios de activos',
              'Cálculo de Value at Risk (VaR)',
            ]),
            _buildApplicationCategory('🧬 Ciencias', [
              'Simulación molecular',
              'Física de partículas',
              'Epidemiología y propagación de enfermedades',
              'Análisis de sistemas complejos',
            ]),
            _buildApplicationCategory('🤖 Inteligencia Artificial', [
              'Reinforcement Learning',
              'Redes neuronales bayesianas',
              'Optimización estocástica',
              'Algoritmos genéticos',
            ]),
            _buildApplicationCategory('🏭 Ingeniería', [
              'Análisis de confiabilidad',
              'Control de calidad',
              'Optimización de procesos',
              'Simulación de sistemas complejos',
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildApplicationCategory(String title, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 2),
            child: Text('• $item', style: TextStyle(fontSize: 14)),
          )),
        ],
      ),
    );
  }

  Widget _buildAdvantagesCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.thumb_up, color: Colors.indigo, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Ventajas y Limitaciones',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '✅ Ventajas',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...[
                        'Aplicable a problemas complejos',
                        'Fácil de paralelizar',
                        'No requiere derivadas',
                        'Maneja alta dimensionalidad',
                        'Conceptualmente simple',
                        'Proporciona intervalos de confianza',
                      ].map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text('• $item', style: TextStyle(fontSize: 13)),
                      )),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '❌ Limitaciones',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...[
                        'Convergencia lenta (1/√N)',
                        'Requiere muchas muestras',
                        'Dependiente de calidad del RNG',
                        'Puede ser computacionalmente caro',
                        'Resultados con incertidumbre',
                        'Sensible a dimensión del problema',
                      ].map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text('• $item', style: TextStyle(fontSize: 13)),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMathematicalFoundationCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.functions, color: Colors.deepPurple, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Fundamentos Matemáticos',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildMathSection('📊 Estimación de Integrales', [
              'Para estimar ∫f(x)dx en [a,b]:',
              '1. Generar n puntos aleatorios x₁, x₂, ..., xₙ',
              '2. Calcular I ≈ (b-a)/n × Σf(xᵢ)',
              '3. Error estándar ≈ σ/√n donde σ² = Var[f(X)]',
            ]),
            _buildMathSection('🎯 Teorema del Límite Central', [
              'Para n grande, la distribución de la media muestral',
              'se aproxima a N(μ, σ²/n)',
              'Esto permite construir intervalos de confianza',
            ]),
            _buildMathSection('🔀 Generadores de Números Aleatorios', [
              'Linear Congruential Generator (LCG)',
              'Mersenne Twister',
              'Crypto-secure PRNGs',
              'Calidad crucial para resultados válidos',
            ]),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📈 Técnicas de Reducción de Varianza:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '• Variables antitéticas\n• Muestreo estratificado\n• Variables de control\n• Muestreo por importancia',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubsection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 4),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 2),
          child: Text(item, style: TextStyle(fontSize: 13)),
        )),
      ],
    );
  }

  Widget _buildMathSection(String title, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 4),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 2),
            child: Text(item, style: TextStyle(fontSize: 13)),
          )),
        ],
      ),
    );
  }
}