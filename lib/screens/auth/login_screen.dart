import 'package:flutter/material.dart';
import 'package:medical_patient_app/services/supabase_service.dart';
import 'package:medical_patient_app/widgets/glass_container.dart';
import 'dart:ui';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _signIn() async {
    setState(() => _isLoading = true);
    try {
      await supabase.auth.signInWithPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red.withOpacity(0.8),
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF0D9488),
              const Color(0xFF06B6D4),
              const Color(0xFF3B82F6),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Floating medical icons background
            Positioned(top: 100, left: 30, child: _buildFloatingIcon(Icons.favorite, 60)),
            Positioned(top: 200, right: 50, child: _buildFloatingIcon(Icons.local_hospital, 80)),
            Positioned(bottom: 150, left: 60, child: _buildFloatingIcon(Icons.medical_services, 70)),
            Positioned(bottom: 250, right: 40, child: _buildFloatingIcon(Icons.healing, 65)),
            // Login Card
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: GlassContainer(
                  padding: const EdgeInsets.all(40),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Colors.white.withOpacity(0.3), Colors.white.withOpacity(0.1)],
                            ),
                          ),
                          child: const Icon(Icons.local_hospital, size: 60, color: Colors.white),
                        ),
                        const SizedBox(height: 24),
                        const Text('Medical Portal', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 8),
                        Text('Patient Management System', style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.8))),
                        const SizedBox(height: 40),
                        _buildGlassTextField(controller: _emailController, label: 'Email Address', icon: Icons.email_outlined),
                        const SizedBox(height: 20),
                        _buildGlassTextField(controller: _passwordController, label: 'Password', icon: Icons.lock_outline, isPassword: true),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _signIn,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF0D9488),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              elevation: 0,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0D9488))),
                            )
                                : const Text('Sign In', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingIcon(IconData icon, double size) {
    return Container(
      padding: EdgeInsets.all(size * 0.3),
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.1)),
      child: Icon(icon, size: size, color: Colors.white.withOpacity(0.2)),
    );
  }

  Widget _buildGlassTextField({required TextEditingController controller, required String label, required IconData icon, bool isPassword = false}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            color: Colors.white.withOpacity(0.1),
            child: TextField(
              controller: controller,
              obscureText: isPassword,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.8)),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(20),
              ),
            ),
          ),
        ),
      ),
    );
  }
}