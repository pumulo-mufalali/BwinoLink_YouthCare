import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_state.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/add_screening_screen.dart';
import 'screens/health_access_points_screen.dart';
import 'screens/peer_navigator_screen.dart';
import 'screens/gamification_screen.dart';

void main() {
  runApp(const BwinoLinkApp());
}

class BwinoLinkApp extends StatelessWidget {
  const BwinoLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        title: 'BwinoLink YouthCare',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
        routes: {
          '/home': (context) => const HomeScreen(),
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignupScreen(),
          '/add-screening': (context) => const AddScreeningScreen(),
          '/health-access-points': (context) => const HealthAccessPointsScreen(),
          '/peer-navigator': (context) => const PeerNavigatorScreen(),
          '/gamification': (context) => const GamificationScreen(),
        },
      ),
    );
  }
}
