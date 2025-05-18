import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Data/Providers/services/local_storage_service.dart';
import '../../data/providers/auth_provider.dart';
import '../../app_colors.dart';
import '../screens/login/login_with_phone_screen.dart';

/// Side drawer used across the app.
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key, this.selected});

  /// Pass a string key to highlight the active menu row (e.g. 'home').
  final String? selected;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String?>>(
      future: LocalStorageService.getUser(),
      builder: (context, snapshot) {
        final name = snapshot.data?['name'] ?? 'Guest';
        final email = snapshot.data?['email'] ?? '';

        return Drawer(
          child: SafeArea(
            child: Column(
              children: [
                _header(name, email),
                const Divider(height: 0),
                Expanded(child: _menuList(context)),
                const Divider(height: 0),
                _logoutTile(context),
              ],
            ),
          ),
        );
      },
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Header with avatar replaced by initial to avoid asset error
  Widget _header(String name, String email) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.orange,
            child: Text(
              (name.isNotEmpty ? name[0] : 'G').toUpperCase(),
              style: const TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(email, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Menu list
  Widget _menuList(BuildContext context) {
    Widget item({
      required String id,
      required IconData icon,
      required String label,
      VoidCallback? onTap,
    }) {
      final bool active = selected == id;
      return ListTile(
        leading: Icon(icon,
            color: active ? AppColors.orange : Colors.grey.shade700),
        title: Text(
          label,
          style: TextStyle(
            fontWeight: active ? FontWeight.w600 : FontWeight.w400,
            color: active ? AppColors.orange : Colors.black87,
          ),
        ),
        onTap: () {
          Navigator.pop(context); // close drawer first
          onTap?.call();
        },
      );
    }

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        item(
          id: 'home',
          icon: Icons.flight_takeoff_rounded,
          label: 'Book Flight',
          onTap: () {
            // TODO: Navigator.pushNamed(context, '/home');
          },
        ),
        item(
          id: 'myBookings',
          icon: Icons.assignment_outlined,
          label: 'My Bookings',
          onTap: () {
            // TODO: Navigator.pushNamed(context, '/bookings');
          },
        ),
        item(
          id: 'offers',
          icon: Icons.local_offer_outlined,
          label: 'Offers',
          onTap: () {},
        ),
        item(
          id: 'notifications',
          icon: Icons.notifications_none_rounded,
          label: 'Notifications',
          onTap: () {},
        ),
        item(
          id: 'help',
          icon: Icons.help_outline,
          label: 'Help Center',
          onTap: () {},
        ),
        item(
          id: 'settings',
          icon: Icons.settings_outlined,
          label: 'Settings',
          onTap: () {},
        ),
      ],
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Logout tile with proper logout and navigation
  Widget _logoutTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.redAccent),
      title: const Text('Log Out', style: TextStyle(color: Colors.redAccent)),
      onTap: () async {
        final auth = Provider.of<AuthProvider>(context, listen: false);
        await auth.logout();
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
