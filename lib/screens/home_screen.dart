import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import 'home_tab.dart';
import 'results_tab.dart';
import 'youth_assigned.dart';
import 'rewards_tab.dart';
import 'settings_tab.dart';
import 'add_screening_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        // Define tabs based on user role
        final tabs = _getTabsForRole(appState);
        final tabTitles = _getTabTitlesForRole(appState);
        final tabIcons = _getTabIconsForRole(appState);

        return Scaffold(
          backgroundColor: AppTheme.lightGrey,
          appBar: AppBar(
            title: Text(tabTitles[appState.currentScreenIndex]),
            actions: [
              // Notifications button
              IconButton(
                icon: Badge(
                  label: Text('${appState.currentUser?.notifications ?? 0}'),
                  child: const Icon(Icons.notifications),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/notifications');
                },
                tooltip: 'Notifications',
              ),
              // User role indicator
              Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getRoleColor(appState.currentUser?.role),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  appState.userRoleDisplayName,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppTheme.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          body: IndexedStack(
            index: appState.currentScreenIndex,
            children: tabs,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: appState.currentScreenIndex,
            onTap: (index) => appState.setCurrentScreen(index),
            type: BottomNavigationBarType.fixed,
            items: List.generate(
              tabIcons.length,
              (index) => BottomNavigationBarItem(
                icon: Icon(tabIcons[index]),
                label: tabTitles[index],
              ),
            ),
          ),
          // Floating action button based on user role
          floatingActionButton: _getFloatingActionButton(appState),
        );
      },
    );
  }

  // Get tabs based on user role
  List<Widget> _getTabsForRole(AppState appState) {
    if (appState.isYouth) {
      return [
        const HomeTab(),
        const ResultsTab(),
        const RewardsTab(),
        const SettingsTab(),
      ];
    } else if (appState.isStaff) {
      return [
        const HomeTab(),
        const ResultsTab(),
        const RewardsTab(),
        const SettingsTab(),
      ];
    } else if (appState.isPeerNavigator) {
      return [
        const HomeTab(),
        const YouthAssignedScreen(),
        const RewardsTab(),
        const SettingsTab(),
      ];
    }
    return [
      const HomeTab(),
      const ResultsTab(),
      const RewardsTab(),
      const SettingsTab(),
    ];
  }

  // Get tab titles based on user role
  List<String> _getTabTitlesForRole(AppState appState) {
    if (appState.isYouth) {
      return [
        'My Health',
        'Results',
        'Rewards',
        'Profile',
      ];
    } else if (appState.isStaff) {
      return [
        'Dashboard',
        'Screenings',
        'Rewards',
        'Settings',
      ];
    } else if (appState.isPeerNavigator) {
      return [
        'Dashboard',
        'My Youth',
        'Rewards',
        'Profile',
      ];
    }
    return [
      'Home',
      'Results',
      'Rewards',
      'Settings',
    ];
  }

  // Get tab icons based on user role
  List<IconData> _getTabIconsForRole(AppState appState) {
    if (appState.isYouth) {
      return [
        Icons.favorite,
        Icons.medical_services,
        Icons.card_giftcard,
        Icons.person,
      ];
    } else if (appState.isStaff) {
      return [
        Icons.dashboard,
        Icons.medical_services,
        Icons.card_giftcard,
        Icons.settings,
      ];
    } else if (appState.isPeerNavigator) {
      return [
        Icons.dashboard,
        Icons.people,
        Icons.card_giftcard,
        Icons.person,
      ];
    }
    return [
      Icons.home,
      Icons.medical_services,
      Icons.card_giftcard,
      Icons.settings,
    ];
  }

  // Get role color
  Color _getRoleColor(String? role) {
    switch (role) {
      case 'youth':
        return AppTheme.accentPink;
      case 'staff':
        return AppTheme.secondaryBlue;
      case 'peer_navigator':
        return AppTheme.successGreen;
      default:
        return AppTheme.primaryPurple;
    }
  }

  // Get floating action button based on user role
  Widget? _getFloatingActionButton(AppState appState) {
    if (appState.isStaff) {
      return FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddScreeningScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: Text(appState.isStaff ? 'Add Screening' : 'Record Health'),
      );
    } else if (appState.isVendor) {
      return FloatingActionButton.extended(
        onPressed: () {
          // Navigate to market health services
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Market health services coming soon!'),
            ),
          );
        },
        icon: const Icon(Icons.health_and_safety),
        label: const Text('Health Services'),
      );
    }
    return null;
  }
}
