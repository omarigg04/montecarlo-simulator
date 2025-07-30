# Monte Carlo Simulator App

Una aplicación Flutter interactiva para simulaciones Monte Carlo con visualizaciones en tiempo real y análisis estadístico avanzado.

## 🎯 Características Principales

### 🔬 Tipos de Simulación
- **Random Walk (Camino Aleatorio)**: Simulación de partículas que se mueven aleatoriamente en un plano 2D
- **Estimación de π**: Método Monte Carlo para aproximar el valor de π usando puntos aleatorios

### 📊 Visualizaciones Interactivas
- **Canvas en tiempo real**: Visualización de partículas y sus trayectorias
- **Gráficas dinámicas**: Múltiples tipos de gráficas usando fl_chart
  - Distancia vs Tiempo
  - Distribución de distancias
  - Comparación con valores teóricos
  - Convergencia de estimaciones

### ⚙️ Controles Configurables
- Número de partículas (1-1000)
- Tamaño del paso (0.1-10.0)
- Velocidad de simulación (1-100)
- Pasos máximos (100-5000)
- Tipo de simulación seleccionable

### 📈 Estadísticas en Tiempo Real
- Pasos actuales
- Partículas activas
- Distancia promedio y máxima
- RMS teórico
- Estimación de π (cuando aplique)
- Precisión y error absoluto

### 💾 Exportación de Datos
- Exportar a CSV
- Exportar a JSON con metadatos
- Compartir archivos
- Estadísticas completas incluidas

## 🏗️ Arquitectura

### Estructura del Proyecto
```
lib/
├── main.dart                    # Punto de entrada de la aplicación
├── models/
│   └── simulation_data.dart     # Modelos de datos y enums
├── providers/
│   └── simulation_provider.dart # Gestión de estado con Provider
├── screens/
│   └── home_screen.dart         # Pantalla principal
├── widgets/
│   ├── control_panel.dart       # Panel de controles
│   ├── simulation_canvas.dart   # Canvas de visualización
│   ├── statistics_panel.dart    # Panel de estadísticas
│   └── chart_panel.dart         # Panel de gráficas
└── services/
    └── export_service.dart      # Servicio de exportación
```

### Patrones de Diseño
- **Provider Pattern**: Para gestión de estado reactivo
- **Observer Pattern**: Para actualizaciones en tiempo real
- **Service Pattern**: Para operaciones de exportación
- **Widget Composition**: Para UI modular y reutilizable

## 🚀 Tecnologías Utilizadas

### Framework y Lenguaje
- **Flutter**: Framework multiplataforma
- **Dart**: Lenguaje de programación

### Dependencias Principales
- `fl_chart: ^0.68.0` - Gráficas interactivas
- `provider: ^6.1.1` - Gestión de estado
- `vector_math: ^2.1.4` - Operaciones matemáticas
- `csv: ^5.1.1` - Exportación CSV
- `share_plus: ^7.2.1` - Compartir archivos
- `path_provider: ^2.1.1` - Acceso al sistema de archivos

## 📱 Responsive Design

### Diseño Adaptativo
- **Pantallas anchas (>800px)**: Layout de 3 columnas
  - Panel izquierdo: Controles y estadísticas
  - Panel central: Canvas de simulación
  - Panel derecho: Gráficas
- **Pantallas estrechas (≤800px)**: Layout vertical apilado
  - Scroll vertical para acceso a todos los componentes

### Compatibilidad
- ✅ **Mobile**: iOS y Android
- ✅ **Web**: Navegadores modernos
- ✅ **Desktop**: Windows, macOS, Linux

## 🎨 UI/UX Features

### Tema Dark
- Esquema de colores oscuro optimizado
- Contraste mejorado para legibilidad
- Efectos de transparencia y blur

### Interactividad
- Controles deslizantes en tiempo real
- Botones de estado (Play/Pause/Reset)
- Selector de tipo de simulación
- Gráficas seleccionables por pestañas

### Feedback Visual
- Indicadores de estado
- Animaciones fluidas
- Mensajes de confirmación
- Colores semánticos para diferentes estados

## 🔬 Algoritmos Implementados

### Random Walk
```dart
// Movimiento aleatorio en 2D
final angle = Random().nextDouble() * 2 * pi;
final newX = currentPosition.x + cos(angle) * stepSize;
final newY = currentPosition.y + sin(angle) * stepSize;
```

### Estimación de π
```dart
// Método Monte Carlo para π
final insideCircle = points.where((p) => p.distanceFromOrigin() <= 1.0).length;
final piEstimate = (4.0 * insideCircle) / totalPoints;
```

### Estadísticas
- **RMS Teórico**: `√n * stepSize`
- **Distancia Promedio**: Suma de distancias / número de partículas
- **Error Absoluto**: `|estimación - valorReal|`
- **Precisión**: `(1 - error/valorReal) * 100%`

## 🎯 Casos de Uso

### Educativo
- Demostración de conceptos de probabilidad
- Visualización de teoremas de límite central
- Enseñanza de métodos Monte Carlo

### Investigación
- Prototipado rápido de simulaciones
- Análisis de convergencia
- Validación de modelos teóricos

### Análisis
- Exportación de datos para análisis posterior
- Comparación de diferentes parámetros
- Visualización de patrones emergentes

## 🚀 Instalación y Uso

### Requisitos
- Flutter SDK (>=3.10.0)
- Dart SDK (>=3.0.0)

### Pasos de Instalación
1. Clonar el repositorio
2. Ejecutar `flutter pub get`
3. Ejecutar `flutter run`

### Uso Básico
1. Seleccionar tipo de simulación
2. Ajustar parámetros según necesidades
3. Iniciar simulación
4. Observar visualizaciones en tiempo real
5. Exportar datos si es necesario

## 🔮 Extensiones Futuras

### Nuevos Tipos de Simulación
- Diffusion-Limited Aggregation (DLA)
- Ising Model
- Percolation Theory
- Stock Price Simulation

### Mejoras de UI
- Temas personalizables
- Modo claro/oscuro
- Configuraciones guardadas
- Historial de simulaciones

### Características Avanzadas
- Simulaciones 3D
- Análisis estadístico avanzado
- Machine Learning integration
- Simulaciones paralelas

---

## 📄 Licencia

Este proyecto está bajo la licencia MIT. Ver el archivo `LICENSE` para más detalles.

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Por favor, lee las guías de contribución antes de enviar un pull request.

## 📞 Soporte

Para reportar bugs o solicitar nuevas características, por favor crea un issue en el repositorio.