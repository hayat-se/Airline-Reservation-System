import 'package:flutter/material.dart';
import '../../../../Data/Providers/services/local_storage_service.dart'; // ✅ correct path

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final passCtrl     = TextEditingController();
  final confirmCtrl  = TextEditingController();
  final _formKey     = GlobalKey<FormState>();

  /* ── Save new password into Shared‑Preferences ── */
  Future<void> _saveNewPassword() async {
    final user = await LocalStorageService.getUser();            // ✅ correct call
    final email = user['email'];

    if (email == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No registered account found')),
      );
      return;
    }

    await LocalStorageService.saveUserCredentials(
      email,
      passCtrl.text.trim(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password reset successfully!')),
    );

    // Pop back to login screen
    if (mounted) Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: passCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                (v == null || v.length < 6) ? 'Min 6 characters' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: confirmCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                (v != passCtrl.text) ? 'Passwords do not match' : null,
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) _saveNewPassword();
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: Colors.red,
                ),
                child: const Text('Save Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
