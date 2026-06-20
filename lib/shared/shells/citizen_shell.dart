import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CitizenShell extends StatefulWidget {
  final Widget child;

  const CitizenShell({required this.child, Key? key}) : super(key: key);

  @override
  State<CitizenShell> createState() => _CitizenShellState();
}

class _CitizenShellState extends State<CitizenShell> {
  int _selectedIndex = 0;

  void _onNavTapped(int index) {
    setState(() => _selectedIndex = index);

    switch (index) {
      case 0:
        context.goNamed('citizen_home');
        break;
      case 1:
        context.goNamed('citizen_report');
        break;
      case 2:
        context.goNamed('citizen_track');
        break;
      case 3:
        context.goNamed('citizen_profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.contains('profile')) {
      _selectedIndex = 3;
    } else if (location.contains('track')) {
      _selectedIndex = 2;
    } else if (location.contains('report')) {
      _selectedIndex = 1;
    } else {
      _selectedIndex = 0;
    }

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'Report'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), label: 'Track'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}
