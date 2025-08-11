// Main home screen with bottom navigation for AfyaLink Market app
// Contains tabs: Home, Results, Rewards, Settings

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import 'home_tab.dart';
import 'results_tab.dart';
import 'rewards_tab.dart';
import 'settings_tab.dart';
import 'add_screening_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> _tabs = [
    const HomeTab(),
    const ResultsTab(),
    const RewardsTab(),
    const SettingsTab(),
  ];

  final List<String> _tabTitles = [
    'Home',
    'Results',
    'Rewards',
    'Settings',
  ];

  final List<IconData> _tabIcons = [
    Icons.home,
    Icons.medical_services,
    Icons.card_giftcard,
    Icons.settings,
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return Scaffold(
          backgroundColor: AppTheme.lightGrey,
          appBar: AppBar(
            title: Text(_tabTitles[appState.currentScreenIndex]),
            actions: [
              // User role indicator
              Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: appState.currentUser?.role == 'staff' 
                      ? AppTheme.secondaryBlue 
                      : AppTheme.accentGreen,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  appState.currentUser?.role == 'staff' ? 'Staff' : 'Visitor',
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
            children: _tabs,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: appState.currentScreenIndex,
            onTap: (index) => appState.setCurrentScreen(index),
            type: BottomNavigationBarType.fixed,
            items: List.generate(
              _tabIcons.length,
              (index) => BottomNavigationBarItem(
                icon: Icon(_tabIcons[index]),
                label: _tabTitles[index],
              ),
            ),
          ),
          // Floating action button for adding screenings (only for staff)
          floatingActionButton: appState.currentUser?.role == 'staff'
              ? FloatingActionButton.extended(
                  onPressed: () {
                    // Navigate to add screening screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddScreeningScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Screening'),
                )
              : null,
        );
      },
    );
  }
}
