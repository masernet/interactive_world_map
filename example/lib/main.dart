import 'package:flutter/material.dart';
import 'interactive_map_demo_page.dart';
import 'icon_examples_page.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF355E79);
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.light,
    );
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: scheme,
        scaffoldBackgroundColor: const Color(0xFFF4F2ED),
        fontFamily: 'serif',
        textTheme: ThemeData.light()
            .textTheme
            .apply(bodyColor: scheme.onSurface, displayColor: scheme.onSurface)
            .copyWith(
              headlineMedium: const TextStyle(
                fontFamily: 'serif',
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
              titleLarge: const TextStyle(
                fontFamily: 'serif',
                fontWeight: FontWeight.w600,
                letterSpacing: -0.2,
              ),
            ),
      ),
      home: const ExampleHome(),
    );
  }
}

class ExampleHome extends StatefulWidget {
  const ExampleHome({super.key});

  @override
  State<ExampleHome> createState() => _ExampleHomeState();
}

class _ExampleHomeState extends State<ExampleHome> {
  int _index = 0;
  final _pages = const [
    InteractiveMapDemoPage(),
    IconExamplesPage(),
  ];

  String get _title => _index == 0 ? 'Interactive Map' : 'World Icons';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        centerTitle: false,
      ),
      body: IndexedStack(
        index: _index,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.public),
            label: 'Map',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view),
            label: 'Icons',
          ),
        ],
      ),
    );
  }
}
