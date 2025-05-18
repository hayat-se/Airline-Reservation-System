import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../data/providers/login_provider.dart';
import '../../widgets/custom_text_field.dart';
import 'Bookings/flight_search_screen.dart';
import 'auth/create_account_screen.dart';

class LoginWithPhoneScreen extends StatefulWidget {
  const LoginWithPhoneScreen({super.key});

  @override
  State<LoginWithPhoneScreen> createState() => _LoginWithPhoneScreenState();
}

class _LoginWithPhoneScreenState extends State<LoginWithPhoneScreen> {
  final _formKey           = GlobalKey<FormState>();
  final _emailController   = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    await auth.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (context.mounted) {
      // 🚀  go straight to home & clear back‑stack
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const FlightSearchScreen()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = context.watch<LoginProvider>();
    final isLoading     = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  const Text('Login',
                      style: TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Welcome back to the app'),
                  const SizedBox(height: 30),

                  // ── Email ───────────────────────────────────────────────
                  CustomTextField(
                    label: 'Email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) =>
                    v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 15),

                  // ── Password + "Forgot" ────────────────────────────────
                  Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      CustomTextField(
                        label: 'Password',
                        controller: _passwordController,
                        obscureText: true,
                        validator: (v) =>
                        v == null || v.isEmpty ? 'Required' : null,
                      ),
                      TextButton(
                        onPressed: () {
                          // TODO: Forgot‑password flow
                        },
                        child: const Text('Forgot Password?',
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // ── Keep me signed in ──────────────────────────────────
                  Row(
                    children: [
                      Checkbox(
                        value: loginProvider.keepSignedIn,
                        onChanged: (_) => loginProvider.toggleKeepSignedIn(),
                      ),
                      const Text('Keep me signed in'),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── Login Button ───────────────────────────────────────
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: isLoading ? null : _handleLogin,
                    child: isLoading
                        ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : const Text('Login',
                        style:
                        TextStyle(color: Colors.white, fontSize: 18)),
                  ),

                  const SizedBox(height: 30),

                  // ── Sign‑up Link ───────────────────────────────────────
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const CreateAccountScreen()),
                        );
                      },
                      child: const Text(
                        'Create an account',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),

                  // ── force‑logout for testing (OPTIONAL) ───────────────
                  // FutureBuilder(
                  //   future: LocalStorageService.isLoggedIn(),
                  //   builder: (_, snap) =>
                  //       Text('Logged in prefs: ${snap.data}'),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
