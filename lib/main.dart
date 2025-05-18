import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/providers/auth_provider.dart';
import 'data/providers/login_provider.dart';
import 'ui/screens/login/bookings/splash_screen.dart';
import 'app_colors.dart';

/// A global root‑navigator so any part of the app (including AuthProvider)
/// can reset the whole route‑stack, e.g. on logout or token‑expiry.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,            // ★ root navigator
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.orange),
        scaffoldBackgroundColor: AppColors.lightGrey,
      ),
      // Always start with the splash/initial‑routing widget
      home: const InitialSplashScreen(),
    );
  }
}
