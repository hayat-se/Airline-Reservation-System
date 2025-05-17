import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Data/Providers/auth_provider.dart';
import 'Data/Providers/login_provider.dart';
import 'ui/screens/login/login_with_phone_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required for shared_preferences
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Airline Reservation App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.red,
          fontFamily: 'Roboto',
          scaffoldBackgroundColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: LoginWithPhoneScreen(),
      ),
    );
  }
}
