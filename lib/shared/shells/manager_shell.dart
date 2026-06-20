import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Manager shell with navigation rail (left sidebar)
class ManagerShell extends StatefulWidget {
  final Widget child;

  const ManagerShell({required this.child, Key? key}) : super(key: key);

  @override
  State<ManagerShell> createState() => _ManagerShellState();
}

class _ManagerShellState extends State<ManagerShell> {
  int _selectedIndex = 0;

  void _onNavTapped(int index) {
    setState(() => _selectedIndex = index);

    switch (index) {
      case 0:
        context.goNamed('manager_dashboard');
        break;
      case 1:
        context.goNamed('manager_incidents');
        break;
      case 2:
        context.goNamed('manager_escalations');
        break;
      case 3:
        context.goNamed('manager_supervisors');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Update selected index based on current route
    final location = GoRouterState.of(context).uri.path;
    if (location.contains('supervisors')) {
      _selectedIndex = 3;
    } else if (location.contains('escalations')) {
      _selectedIndex = 2;
    } else if (location.contains('incidents')) {
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
                icon: Icon(Icons.dashboard),
                label: Text('Dashboard'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.error_outline),
                label: Text('Incidents'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.warning),
                label: Text('Escalations'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.supervisor_account),
                label: Text('Supervisors'),
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
