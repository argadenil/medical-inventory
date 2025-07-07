import 'package:flutter/material.dart';
import 'package:medical_ims/pages/dashboard.dart';
import 'package:medical_ims/pages/inventory.dart';
import 'package:medical_ims/pages/reports.dart';
import 'package:medical_ims/pages/settings.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  late List<AnimationController> _animationControllers;

  final List<Widget> _pages = const [
    Dashboard(),
    Inventory(),
    Reports(),
    SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
    _animationControllers = List.generate(
      4,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
        lowerBound: 1.0,
        upperBound: 1.2,
      ),
    );
    _animationControllers[_selectedIndex].forward(); // Animate initial tab
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;

    _animationControllers[_selectedIndex].reverse(); // Reset previous icon
    _animationControllers[index].forward(); // Animate new icon

    setState(() {
      _selectedIndex = index;
    });

    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (final controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final iconList = [
      Icons.home,
      Icons.inventory,
      Icons.bar_chart,
      Icons.settings,
    ];

    final labels = ['Home', 'Inventory', 'Reports', 'Settings'];

    return Scaffold(
      appBar: AppBar(title: const Text('Welcome to Medical IMS')),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFF7F9FC),
        selectedItemColor: const Color(0xFF3B5BDB),
        unselectedItemColor: const Color(0xFFA0A4A8),
        onTap: _onItemTapped,

        items: List.generate(iconList.length, (index) {
          return BottomNavigationBarItem(
            icon: ScaleTransition(
              scale: _animationControllers[index],
              child: Icon(iconList[index]),
            ),
            label: labels[index],
          );
        }),
      ),
    );
  }
}
