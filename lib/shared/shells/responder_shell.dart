import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Responder shell with navigation rail (left sidebar)
class ResponderShell extends StatefulWidget {
  final Widget child;

  const ResponderShell({required this.child, Key? key}) : super(key: key);

  @override
  State<ResponderShell> createState() => _ResponderShellState();
}

class _ResponderShellState extends State<ResponderShell> {
  int _selectedIndex = 0;

  void _onNavTapped(int index) {
    setState(() => _selectedIndex = index);

    switch (index) {
      case 0:
        context.goNamed('responder_feed');
        break;
      case 1:
        context.goNamed('responder_map');
        break;
      case 2:
        context.goNamed('responder_maintenance');
        break;
      case 3:
        context.goNamed('responder_profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Update selected index based on current route
    final location = GoRouterState.of(context).uri.path;
    if (location.contains('profile')) {
      _selectedIndex = 3;
    } else if (location.contains('maintenance')) {
      _selectedIndex = 2;
    } else if (location.contains('map')) {
      _selectedIndex = 1;
    } else {
      _selectedIndex = 0;
    }

    return Scaffold(
      body: Row(
        children: [
          // Left navigation rail
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onNavTapped,
            extended: false,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.notifications),
                label: Text('Feed'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.map),
                label: Text('Map'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.build),
                label: Text('Maintenance'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person),
                label: Text('Profile'),
              ),
            ],
          ),
          // Main content
          Expanded(child: widget.child),
        ],
      ),
    );
  }
}
