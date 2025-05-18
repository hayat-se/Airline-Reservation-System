import 'package:airline_reservation_system/Ui/Screens/Login/Bookings/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Data/Providers/auth_provider.dart';
import 'Data/Providers/login_provider.dart';
import 'Data/Providers/services/local_storage_service.dart';
import 'Ui/Screens/Login/Bookings/flight_search_screen.dart';
import 'app_colors.dart';
import 'ui/screens/login/login_with_phone_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final alreadyIn = await LocalStorageService.isLoggedIn();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
      ],
      child: MyApp(showHome: alreadyIn),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.showHome});
  final bool showHome;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.orange),
        scaffoldBackgroundColor: AppColors.lightGrey,
      ),
      home: showHome ? const FlightSearchScreen() : LoginWithPhoneScreen(),
    );
  }
}
