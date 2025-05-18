import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Data/Providers/services/local_storage_service.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../data/providers/login_provider.dart';
import '../../widgets/custom_text_field.dart';
import 'Bookings/flight_search_screen.dart';
import 'auth/create_account_screen.dart';
import 'auth/forgot_password_screen.dart';

class LoginWithPhoneScreen extends StatefulWidget {
  const LoginWithPhoneScreen({super.key});

  @override
  State<LoginWithPhoneScreen> createState() => _LoginWithPhoneScreenState();
}

class _LoginWithPhoneScreenState extends State<LoginWithPhoneScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final ok = await LocalStorageService.verify(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!ok) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email or password')),
      );
      return;
    }

    // credentials are correct → continue to home
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const FlightSearchScreen()),
          (_) => false,
    );
  }


  @override
  Widget build(BuildContext context) {
    final loginProvider = context.watch<LoginProvider>();
    final isLoading = context.watch<AuthProvider>().isLoading;

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
                  const Text(
                    'Login',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('Welcome back to the app'),
                  const SizedBox(height: 30),

                  // ── Email ───────────────────────────────────────────────
                  CustomTextField(
                    label: 'Email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator:
                        (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 15),

                  // ── Password ─────────────────────────────────────────────
                  CustomTextField(
                    label: 'Password',
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    validator:
                        (v) => v == null || v.isEmpty ? 'Required' : null,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
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

                  // ── Forgot Password Button BELOW checkbox ───────────────
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Login Button ───────────────────────────────────────
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: isLoading ? null : _handleLogin,
                    child:
                        isLoading
                            ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                            : const Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                  ),

                  const SizedBox(height: 30),

                  // ── Sign‑up Link ───────────────────────────────────────
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CreateAccountScreen(),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'New to the app? ',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const Text(
                            'Create an account',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
