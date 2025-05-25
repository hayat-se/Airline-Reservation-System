import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../Data/Providers/services/local_storage_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final passportController = TextEditingController();
  final dobController = TextEditingController();
  String selectedCountry = 'Country';
  String? imagePath;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await LocalStorageService.getUser();
    setState(() {
      nameController.text = user['name'] ?? '';
      emailController.text = user['email'] ?? '';
      addressController.text = user['address'] ?? '';
      passportController.text = user['passport'] ?? '';
      dobController.text = user['dob'] ?? '';
      selectedCountry = user['country'] ?? 'Country';
      imagePath = user['imagePath'];
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final newPath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png';
      final newFile = await File(pickedFile.path).copy(newPath);

      setState(() {
        imagePath = newFile.path;
      });

      await LocalStorageService.saveProfileImagePath(newFile.path);
    }
  }

  Future<void> _selectDOB() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      dobController.text = "${picked.day}/${picked.month}/${picked.year}";
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      if (dobController.text.trim().isEmpty) {
        _showError('Please select your Date of Birth.');
        return;
      }
      if (selectedCountry == 'Country') {
        _showError('Please select your country.');
        return;
      }

      final user = {
        'name': nameController.text,
        'email': emailController.text,
        'address': addressController.text,
        'passport': passportController.text,
        'dob': dobController.text,
        'country': selectedCountry,
        'imagePath': imagePath,
      };
      await LocalStorageService.saveUser(user);
      Navigator.pop(context, true);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageExists = imagePath != null && File(imagePath!).existsSync();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Edit Profile', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: imageExists ? FileImage(File(imagePath!)) : null,
                  child: !imageExists
                      ? const Icon(Icons.camera_alt, size: 40, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              _buildInput("Name", "Enter your name", Icons.person, nameController,
                  validator: (value) => value!.isEmpty ? "Name is required" : null),
              _buildInput("Email", "Enter your email", Icons.email, emailController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return "Email is required";
                    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                    return !regex.hasMatch(value) ? "Enter a valid email" : null;
                  }),
              _buildInput("Address", "Enter your address", Icons.location_on, addressController,
                  validator: (value) => value!.isEmpty ? "Address is required" : null),
              _buildInput("Passport", "Enter passport number", Icons.credit_card, passportController,
                  validator: (value) => value!.isEmpty ? "Passport is required" : null),
              _buildDatePicker("DOB", Icons.calendar_today, dobController),
              _buildCountryDropdown("Country", Icons.flag),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text("Save Changes", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(String label, String hint, IconData icon, TextEditingController controller,
      {String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey),
          labelText: label,
          hintText: hint,
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _buildDatePicker(String label, IconData icon, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        onTap: _selectDOB,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey),
          labelText: label,
          hintText: 'Select your birth date',
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _buildCountryDropdown(String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: selectedCountry,
        validator: (value) =>
        (value == null || value == 'Country') ? 'Please select a country' : null,
        items: ['Country', 'USA', 'UK', 'Pakistan', 'India']
            .map((country) => DropdownMenuItem(
          value: country,
          child: Text(country),
        ))
            .toList(),
        onChanged: (value) {
          setState(() {
            selectedCountry = value!;
          });
        },
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey),
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
