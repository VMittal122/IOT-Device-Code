import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'login.dart';
import 'package:iot_device/app/bottom_navigation/bottom_navigation.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _formKey = GlobalKey<FormState>();
  bool isChecked = false;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _createAccount() async {
    if (_formKey.currentState!.validate() && isChecked) {
      final provider = context.read<AuthProvider>();
      final res = await provider.signup(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _fullNameController.text.trim(),
        _phoneController.text.trim(),
      );
      if (mounted) {
        if (res) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const BottomNavigationPage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(provider.error ?? 'Account creation failed'),
            ),
          );
        }
      }
    } else if (!isChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to the terms.')),
      );
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required String? Function(String?) validator,
    bool obscureText = false,
    VoidCallback? toggleVisibility,
    TextInputType keyboardType = TextInputType.text, // ✅ Added this
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType, // ✅ Added this
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon),
        suffixIcon:
            toggleVisibility != null
                ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: toggleVisibility,
                )
                : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 18.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Center(
                child: SizedBox(
                  width: 200,
                  height: 80,
                  child: Image.asset('assets/logo.png', fit: BoxFit.contain),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Create Account',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Let's get started!",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 30),

              _buildTextField(
                controller: _fullNameController,
                hintText: 'Full Name',
                icon: Icons.person_outline,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Enter full name'
                            : null,
              ),
              const SizedBox(height: 15),

              _buildTextField(
                controller: _emailController,
                hintText: 'Email Address',
                icon: Icons.email_outlined,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter email';
                  final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!regex.hasMatch(value)) return 'Enter valid email';
                  return null;
                },
              ),
              const SizedBox(height: 15),

              _buildTextField(
                controller: _phoneController,
                hintText: 'Phone Number',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone, // ✅ Shows number pad
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Enter phone number'
                            : null,
              ),
              const SizedBox(height: 15),

              _buildTextField(
                controller: _passwordController,
                hintText: 'Password',
                icon: Icons.lock_outline,
                obscureText: _obscurePassword,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter password';
                  if (value.length < 6)
                    return 'Password must be at least 6 characters';
                  return null;
                },
                toggleVisibility: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),
              const SizedBox(height: 15),

              _buildTextField(
                controller: _confirmPasswordController,
                hintText: 'Confirm Password',
                icon: Icons.lock_reset_outlined,
                obscureText: _obscureConfirmPassword,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Confirm your password';
                  if (value != _passwordController.text)
                    return 'Passwords do not match';
                  return null;
                },
                toggleVisibility: () {
                  setState(
                    () => _obscureConfirmPassword = !_obscureConfirmPassword,
                  );
                },
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Checkbox(
                    value: isChecked,
                    activeColor: Colors.blue,
                    onChanged:
                        (value) => setState(() => isChecked = value ?? false),
                  ),
                  Expanded(
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(color: Colors.black, fontSize: 13),
                        children: [
                          TextSpan(text: 'I agree to the '),
                          TextSpan(
                            text: 'Terms and Conditions',
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Consumer<AuthProvider>(
                builder: (context, provider, _) {
                  return provider.isLoading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _createAccount,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4D9BE6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'Create Account',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                },
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      'Log in',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4D9BE6),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
