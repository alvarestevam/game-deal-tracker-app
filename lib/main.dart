import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/game_provider.dart';
import 'views/giveaways_view.dart';
import 'views/deals_view.dart';
import 'views/audit_view.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => GameProvider()
            ..fetchGiveaways()
            ..fetchDeals(),
        ),
      ],
      child: const GameModelTrackerApp(),
    ),
  );
}

class GameModelTrackerApp extends StatelessWidget {
  const GameModelTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GameModel Tracker',
      theme: ThemeData.dark(),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    GiveawaysView(),
    DealsView(),
    AuditView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: 'Gratuitos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sell),
            label: 'Promoções',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Auditoria',
          ),
        ],
      ),
    );
  }
}
