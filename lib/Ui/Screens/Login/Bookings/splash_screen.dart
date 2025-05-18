import 'package:airline_reservation_system/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:airline_reservation_system/Data/Providers/services/local_storage_service.dart';
import '../login_with_phone_screen.dart';
import 'flight_search_screen.dart';

class InitialSplashScreen extends StatefulWidget {
  const InitialSplashScreen({super.key});

  @override
  State<InitialSplashScreen> createState() => _InitialSplashScreenState();
}

class _InitialSplashScreenState extends State<InitialSplashScreen> {

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    // Show the splash for at least a short moment
    await Future.delayed(const Duration(seconds:3));

    final loggedIn = await LocalStorageService.isLoggedIn();

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => loggedIn
            ? const FlightSearchScreen()
            : const LoginWithPhoneScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Your splash UI (logo, animation, etc.)
    return Scaffold(
      backgroundColor: AppColors.orange,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/app_logo.png',
              width: 300,
            ),
            Text("Flight Booking App", style: TextStyle(color: Colors.white,fontSize: 30 ,fontWeight: FontWeight.bold),)
          ],
        )
      ),
    );
  }
}
