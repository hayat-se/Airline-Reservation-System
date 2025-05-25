import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:airline_reservation_system/ui/screens/login/profile/profile_screen.dart';
import '../../data/providers/services/local_storage_service.dart';
import '../../data/providers/auth_provider.dart';
import '../../app_colors.dart';
import '../screens/login/bookings/my_bookings_screen.dart';
import '../screens/login/login_with_phone_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key, this.selected});
  final String? selected;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String?>>(
      future: LocalStorageService.getUser(),
      builder: (context, snapshot) {
        final name = snapshot.data?['name'] ?? 'Guest';
        final email = snapshot.data?['email'] ?? '';
        final imagePath = snapshot.data?['imagePath'];
        final imageExists = imagePath != null && File(imagePath).existsSync();

        return Drawer(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.close, size: 24),
                      ),
                      const SizedBox(width: 24),
                      InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ProfileScreen()),
                          );
                        },
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.grey.shade200,
                              backgroundImage: imageExists
                                  ? FileImage(File(imagePath!))
                                  : const AssetImage('assets/images/avatar_placeholder.png')
                              as ImageProvider,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Hello', style: TextStyle(fontSize: 12)),
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const _Divider(),
                Expanded(child: _MenuList(selected: selected)),
                const _Divider(),
                const _AppVersion(),
                const SizedBox(height: 8),
                const _LogoutTile(),
              ],
            ),
          ),
        );
      },
    );
  }
}

//───────────────────────────────────────────────────────────────────────────

class _MenuList extends StatelessWidget {
  const _MenuList({required this.selected});
  final String? selected;

  @override
  Widget build(BuildContext context) {
    Widget item({
      required String id,
      required IconData icon,
      required String label,
      VoidCallback? onTap,
    }) {
      final bool active = selected == id;
      return Material(
        color: active ? Colors.orange.withOpacity(0.08) : Colors.transparent,
        child: ListTile(
          leading: Icon(
            icon,
            size: 22,
            color: active ? AppColors.orange : Colors.black87,
          ),
          title: Text(
            label,
            style: TextStyle(
              fontWeight: active ? FontWeight.bold : FontWeight.w500,
              color: active ? AppColors.orange : Colors.black87,
            ),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          onTap: () {
            Navigator.pop(context);
            onTap?.call();
          },
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      children: [
        item(
          id: 'myBookings',
          icon: Icons.assignment_outlined,
          label: 'My Bookings',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MyBookingsScreen()),
            );
          },
        ),
        item(id: 'boardingPass', icon: Icons.confirmation_number_outlined, label: 'Boarding Pass'),
        item(id: 'support', icon: Icons.headset_mic_outlined, label: 'Support'),
        item(id: 'rate', icon: Icons.star_border, label: 'Rate us'),
        const _Divider(),
        item(id: 'flight', icon: Icons.flight_takeoff_rounded, label: 'Flight'),
      ],
    );
  }
}

//───────────────────────────────────────────────────────────────────────────

class _LogoutTile extends StatelessWidget {
  const _LogoutTile();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.redAccent),
      title: const Text('Log Out', style: TextStyle(color: Colors.redAccent)),
      onTap: () async {
        await Provider.of<AuthProvider>(context, listen: false).logout();
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginWithPhoneScreen()),
                (_) => false,
          );
        }
      },
    );
  }
}

//───────────────────────────────────────────────────────────────────────────

class _AppVersion extends StatelessWidget {
  const _AppVersion();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        'App version 1.0.1',
        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
      ),
    );
  }
}

//───────────────────────────────────────────────────────────────────────────

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Divider(height: 0, color: Colors.grey.shade300, thickness: 1);
  }
}
