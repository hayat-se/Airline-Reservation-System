import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Data/Providers/services/local_storage_service.dart';
import '../../../../data/providers/auth_provider.dart';
import '../../../widgets/custom_text_field.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final nameController           = TextEditingController();
  final emailController          = TextEditingController();
  final passwordController       = TextEditingController();
  final confirmPasswordController= TextEditingController();

  final _formKey = GlobalKey<FormState>();

  /* ─────────────────────────── SIGN‑UP ─────────────────────────── */

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    if (passwordController.text != confirmPasswordController.text) {
      return _showSnack('Passwords do not match');
    }

    // 1️⃣  Save locally
    await LocalStorageService.saveUserCredentials(
      emailController.text.trim(),
      passwordController.text.trim(),
      name: nameController.text.trim(),   // ✅ named
    );


    // 2️⃣  Call provider (mock / real API)
    final auth = context.read<AuthProvider>();
    await auth.signUp(
      name:     nameController.text.trim(),
      email:    emailController.text.trim(),
      password: passwordController.text,
    );

    _showSnack('Account created successfully!');
    Future.delayed(const Duration(seconds: 1), () => Navigator.pop(context));
  }

  void _showSnack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  /* ─────────────────────────── UI ─────────────────────────── */

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Create an Account',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),

                CustomTextField(
                  label: 'Full Name',
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  validator: (v) =>
                  (v == null || v.isEmpty) ? 'Name is required' : null,
                ),
                const SizedBox(height: 15),

                CustomTextField(
                  label: 'Email Address',
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) =>
                  (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
                ),
                const SizedBox(height: 15),

                CustomTextField(
                  label: 'Password',
                  controller: passwordController,
                  obscureText: true,
                  validator: (v) =>
                  (v == null || v.length < 6) ? 'Min 6 characters' : null,
                ),
                const SizedBox(height: 15),

                CustomTextField(
                  label: 'Confirm Password',
                  controller: confirmPasswordController,
                  obscureText: true,
                  validator: (v) =>
                  (v != passwordController.text) ? 'Passwords do not match' : null,
                ),
                const SizedBox(height: 30),

                ElevatedButton(
                  onPressed: _handleSignUp,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: Colors.red,
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Sign Up', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 20),

                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Already have an account? Login',
                        style: TextStyle(color: Colors.red)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
