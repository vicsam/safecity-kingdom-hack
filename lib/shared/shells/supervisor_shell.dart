import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Supervisor shell with navigation rail (left sidebar)
class SupervisorShell extends StatefulWidget {
  final Widget child;

  const SupervisorShell({required this.child, Key? key}) : super(key: key);

  @override
  State<SupervisorShell> createState() => _SupervisorShellState();
}

class _SupervisorShellState extends State<SupervisorShell> {
  int _selectedIndex = 0;

  void _onNavTapped(int index) {
    setState(() => _selectedIndex = index);

    switch (index) {
      case 0:
        context.goNamed('supervisor_feed');
        break;
      case 1:
        context.goNamed('supervisor_escalations');
        break;
      case 2:
        context.goNamed('supervisor_team');
        break;
      case 3:
        context.goNamed('supervisor_map');
        break;
      case 4:
        context.goNamed('supervisor_maintenance');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Update selected index based on current route
    final location = GoRouterState.of(context).uri.path;
    if (location.contains('maintenance')) {
      _selectedIndex = 4;
    } else if (location.contains('map')) {
      _selectedIndex = 3;
    } else if (location.contains('team')) {
      _selectedIndex = 2;
    } else if (location.contains('escalations')) {
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
                icon: Icon(Icons.warning),
                label: Text('Escalations'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.people),
                label: Text('Team'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.map),
                label: Text('Map'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.build),
                label: Text('Maintenance'),
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
