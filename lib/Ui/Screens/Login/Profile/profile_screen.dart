import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../../../../Data/Providers/services/local_storage_service.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = 'Not set';
  String email = 'Not set';
  String address = 'Not set';
  String passport = 'Not set';
  String dob = 'Not set';
  String country = 'Not set';
  String? imagePath;

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    final user = await LocalStorageService.getUser();

    // 🚨 Clear Flutter's image cache to force reload of the new image
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();

    setState(() {
      name = user['name'] ?? 'Not set';
      email = user['email'] ?? 'Not set';
      address = user['address'] ?? 'Not set';
      passport = user['passport'] ?? 'Not set';
      dob = user['dob'] ?? 'Not set';
      country = user['country'] ?? 'Not set';
      imagePath = user['imagePath'];
    });
  }

  void _navigateToEditProfile() async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EditProfileScreen()),
    );

    if (updated == true) {
      _loadUserDetails(); // ✅ Refresh updated values + image
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageExists = imagePath != null && File(imagePath!).existsSync();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Profile'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey.shade300,
              backgroundImage: imageExists ? FileImage(File(imagePath!)) : null,
              child: !imageExists
                  ? const Icon(Icons.person, size: 60, color: Colors.orange)
                  : null,
            ),
            const SizedBox(height: 16),
            const Text(
              "Traveler Profile",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _buildProfileCard(Icons.person, "Name", name),
            _buildProfileCard(Icons.email, "Email", email),
            _buildProfileCard(Icons.location_on, "Address", address),
            _buildProfileCard(Icons.credit_card, "Passport", passport),
            _buildProfileCard(Icons.calendar_today, "Date of Birth", dob),
            _buildProfileCard(Icons.flag, "Country", country),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.edit, color: Colors.white),
                label: const Text("Edit Profile"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _navigateToEditProfile,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(IconData icon, String label, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepOrange),
        title: Text(label,
            style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.grey)),
        subtitle: Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
