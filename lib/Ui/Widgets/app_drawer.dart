import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/providers/services/local_storage_service.dart';
import '../../data/providers/auth_provider.dart';
import '../../app_colors.dart';
import '../Screens/Login/Bookings/my_bookings_screen.dart';
import '../Screens/Login/Profile/profile_screen.dart';
import '../screens/login/login_with_phone_screen.dart';

/// Sliding navigation drawer shown across the app.
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key, this.selected});

  /// Menu id for the currently‑active screen (e.g. 'flight').
  final String? selected;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String?>>(
      future: LocalStorageService.getUser(),
      builder: (context, snapshot) {
        final name = snapshot.data?['name'] ?? 'Guest';
        final email = snapshot.data?['email'] ?? '';

        return Drawer(
          backgroundColor: Colors.white,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Header(name: name, email: email),
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
// Header – avatar, greeting and user name
class _Header extends StatelessWidget {
  const _Header({required this.name, required this.email});

  final String name;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Row(
        children: [
          const Icon(Icons.close, size: 22),
          const SizedBox(width: 24),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundImage: const AssetImage(
                    'assets/images/avatar_placeholder.png',
                  ),
                  backgroundColor: Colors.grey.shade200,
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
    );
  }
}

//───────────────────────────────────────────────────────────────────────────
// Menu list – primary and secondary sections
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
      return ListTile(
        leading: Icon(
          icon,
          size: 20,
          color: active ? AppColors.orange : Colors.grey.shade800,
        ),
        title: Text(
          label,
          style: TextStyle(
            fontWeight: active ? FontWeight.w600 : FontWeight.w400,
            color: active ? AppColors.orange : Colors.black87,
          ),
        ),
        onTap: () {
          Navigator.pop(context); // Close drawer
          onTap?.call(); // Execute navigation callback if any
        },
      );
    }

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        item(
          id: 'myBookings',
          icon: Icons.assignment_outlined,
          label: 'My Bookings',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyBookingsScreen()),
            );
          },
        ),
        item(
          id: 'boardingPass',
          icon: Icons.confirmation_number_outlined,
          label: 'Boarding Pass',
          onTap: () {
            // Add boarding pass screen navigation if needed
          },
        ),
        item(
          id: 'support',
          icon: Icons.headset_mic_outlined,
          label: 'Support',
          onTap: () {
            // Add support screen navigation if needed
          },
        ),
        item(
          id: 'rate',
          icon: Icons.star_border,
          label: 'Rate us',
          onTap: () {
            // Add rate us navigation if needed
          },
        ),
        const _Divider(),
        item(
          id: 'flight',
          icon: Icons.flight_takeoff_rounded,
          label: 'Flight',
          onTap: () {
            // Add flight screen navigation if needed
          },
        ),
        item(
          id: 'hotel',
          icon: Icons.hotel_outlined,
          label: 'Hotel',
          onTap: () {
            // Add hotel screen navigation if needed
          },
        ),
        item(
          id: 'bus',
          icon: Icons.directions_bus_outlined,
          label: 'Bus',
          onTap: () {
            // Add bus screen navigation if needed
          },
        ),
        item(
          id: 'tour',
          icon: Icons.lock_outline,
          label: 'Tour',
          onTap: () {
            // Add tour screen navigation if needed
          },
        ),
        item(
          id: 'loan',
          icon: Icons.account_balance_wallet_outlined,
          label: 'Travel loan',
          onTap: () {
            // Add travel loan screen navigation if needed
          },
        ),
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
