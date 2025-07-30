import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'providers/simulation_provider.dart';

void main() {
  runApp(const MonteCarloApp());
}

class MonteCarloApp extends StatelessWidget {
  const MonteCarloApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SimulationProvider()),
      ],
      child: MaterialApp(
        title: 'Monte Carlo Simulator',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF1E1E1E),
          cardColor: const Color(0xFF2D2D2D),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF4CAF50),
            secondary: Color(0xFF2196F3),
            surface: Color(0xFF2D2D2D),
            background: Color(0xFF1E1E1E),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF2D2D2D),
            elevation: 0,
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}