import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_state.dart';
import 'theme/app_theme.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/add_screening_screen.dart';

void main() {
  runApp(const AfyaLinkApp());
}

class AfyaLinkApp extends StatelessWidget {
  const AfyaLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        title: 'AfyaLink Market',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: Consumer<AppState>(
          builder: (context, appState, child) {
            return appState.isLoggedIn ? const HomeScreen() : const LoginScreen();
          },
        ),
        routes: {
          '/home': (context) => const HomeScreen(),
          '/login': (context) => const LoginScreen(),
          '/add-screening': (context) => const AddScreeningScreen(),
        },
      ),
    );
  }
}
