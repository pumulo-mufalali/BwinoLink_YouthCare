import 'package:bwino_link_youthcare/screens/results_tab.dart';
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
import 'screens/booking_screen.dart';
import 'screens/health_tips_screen.dart';
import 'screens/peer_chat_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/health_worker_chat_screen.dart';

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
          '/results-tab': (context) => const ResultsTab(),
          '/peer-navigator': (context) => const PeerNavigatorScreen(),
          '/gamification': (context) => const GamificationScreen(),
          '/booking': (context) => const BookingScreen(),
          '/health-tips': (context) => const HealthTipsScreen(),
          '/peer-chat': (context) => const PeerChatScreen(),
          '/notifications': (context) => const NotificationsScreen(),
          '/health-worker-chat': (context) => const HealthWorkerChatScreen(),
        },
      ),
    );
  }
}
