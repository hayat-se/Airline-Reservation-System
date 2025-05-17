import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/providers/login_provider.dart';
import '../../widgets/custom_text_field.dart';
import 'auth/create_account_screen.dart';

class LoginWithPhoneScreen extends StatelessWidget {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginWithPhoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                const Text('Login',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                const Text('Welcome back to the app'),
                const SizedBox(height: 30),

                CustomTextField(
                  label: 'Phone Number',
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 15),

                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    CustomTextField(
                      label: 'Password',
                      controller: passwordController,
                      obscureText: true,
                    ),
                    TextButton(
                      onPressed: () {
                        // TODO: Implement Forgot Password Navigation
                      },
                      child: const Text('Forgot Password?',
                          style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                Consumer<LoginProvider>(
                  builder: (context, loginProvider, _) => Row(
                    children: [
                      Checkbox(
                        value: loginProvider.keepSignedIn,
                        onChanged: (_) => loginProvider.toggleKeepSignedIn(),
                      ),
                      const Text('Keep me signed in'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: () {
                    // TODO: Implement login logic
                  },
                  child: const Text('Login',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ),

                const SizedBox(height: 30),

                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateAccountScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Create an account',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
