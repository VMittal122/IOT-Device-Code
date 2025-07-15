import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  File? _image;
  bool _loading = true;

  String _nameHint = '';
  String _phoneHint = '';
  String _emailHint = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

    if (userDoc.exists) {
      final data = userDoc.data()!;
      _nameHint = data['name'] ?? '';
      _phoneHint = data['phone'] ?? '';
      _emailHint = user.email ?? '';
    }

    setState(() => _loading = false);
  }

  Future<void> _saveChanges() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final updates = <String, dynamic>{};

    if (_nameController.text.trim().isNotEmpty) {
      updates['name'] = _nameController.text.trim();
    }
    if (_phoneController.text.trim().isNotEmpty) {
      updates['phone'] = _phoneController.text.trim();
    }
    if (_emailController.text.trim().isNotEmpty &&
        _emailController.text.trim() != user.email) {
      try {
        await user.verifyBeforeUpdateEmail(_emailController.text.trim());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Verification email sent for email update"),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error updating email: $e")));
        return;
      }
    }

    if (updates.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update(updates);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully")),
      );
    }
  }

  Future<void> _changePassword() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    String current = _currentPasswordController.text.trim();
    String newPass = _newPasswordController.text.trim();
    String confirm = _confirmPasswordController.text.trim();

    if (newPass != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("New passwords do not match")),
      );
      return;
    }

    final cred = EmailAuthProvider.credential(
      email: user.email!,
      password: current,
    );

    try {
      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(newPass);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password changed successfully")),
      );

      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to change password: $e")));
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _image = File(picked.path));
    }
  }

  Widget _buildEditableField(
    TextEditingController controller,
    String label,
    IconData icon, {
    String? hint,
    bool obscure = false,
    bool showPassword = false,
    VoidCallback? toggleVisibility,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure && !showPassword,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint ?? '',
        prefixIcon: Icon(icon, color: const Color(0xFF4D9BE6)),
        suffixIcon:
            obscure
                ? IconButton(
                  icon: Icon(
                    showPassword ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: toggleVisibility,
                )
                : null,
        filled: true,
        fillColor: Colors.white,
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4D9BE6),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'AutoStock',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF3F8FF),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Profile Image
                    Center(
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 48,
                          backgroundImage:
                              _image != null ? FileImage(_image!) : null,
                          child:
                              _image == null
                                  ? const Icon(
                                    Icons.person,
                                    size: 48,
                                    color: Colors.white,
                                  )
                                  : null,
                          backgroundColor: const Color(0xFF4D9BE6),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Form Fields
                    _buildEditableField(
                      _nameController,
                      "Full Name",
                      Icons.person,
                      hint: _nameHint,
                    ),
                    const SizedBox(height: 12),
                    _buildEditableField(
                      _phoneController,
                      "Phone",
                      Icons.phone,
                      hint: _phoneHint,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 12),
                    _buildEditableField(
                      _emailController,
                      "Email",
                      Icons.email,
                      hint: _emailHint,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),

                    ElevatedButton.icon(
                      onPressed: _saveChanges,
                      icon: const Icon(Icons.save),
                      label: const Text("Save Changes"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4D9BE6),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Password Section
                    const Divider(),
                    const SizedBox(height: 16),
                    const Text(
                      "Change Password",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildEditableField(
                      _currentPasswordController,
                      "Current Password",
                      Icons.lock_outline,
                      obscure: true,
                      showPassword: _showCurrentPassword,
                      toggleVisibility: () {
                        setState(
                          () => _showCurrentPassword = !_showCurrentPassword,
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildEditableField(
                      _newPasswordController,
                      "New Password",
                      Icons.lock,
                      obscure: true,
                      showPassword: _showNewPassword,
                      toggleVisibility: () {
                        setState(() => _showNewPassword = !_showNewPassword);
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildEditableField(
                      _confirmPasswordController,
                      "Confirm New Password",
                      Icons.lock,
                      obscure: true,
                      showPassword: _showConfirmPassword,
                      toggleVisibility: () {
                        setState(
                          () => _showConfirmPassword = !_showConfirmPassword,
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    ElevatedButton.icon(
                      onPressed: _changePassword,
                      icon: const Icon(Icons.lock_reset),
                      label: const Text("Change Password"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4D9BE6),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
