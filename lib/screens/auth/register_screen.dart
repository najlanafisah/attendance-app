import 'package:attendence_app/screens/auth/widgets/auth_text_field.dart';
import 'package:attendence_app/screens/auth/widgets/gradient_scaffold.dart';
import 'package:attendence_app/services/auth_services.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback onLoginTap;

  const RegisterScreen({super.key, required this.onLoginTap});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>(); //
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthServices();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return; // kalo misal proses validasinya udh selesai

    setState(() => _isLoading = true);

    try {
      await _authService.registerWithEmailAndPassword(
        _emailController.text.trim(), // fungsinya untuk menghapus spasi diawal dan diakhir biar ga error
        _passwordController.text.trim()
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red)
        );
      }
    }
    finally { // ini mau error atau ga dia bakal ttp jalan
      if (mounted) {setState(() => _isLoading = false);}
    }
  }

  @override
  void dispose() { // untuk menghilangkan cache bial aplikasinya lebih ringan
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();

  }


  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      logoIcon: Icons.person_add_rounded,
      title: 'Create Account',
      subtitle: 'Register to get started',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AuthTextField(
                      controller: _emailController,
                      label: 'Email',
                      icon: Icons.email_outlined,
                      obscureText: false,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Please enter your email' : null,
                    ),
                    SizedBox(height: 16),
                    AuthTextField(
                      controller: _passwordController,
                      label: 'Password',
                      icon: Icons.lock_clock_outlined,
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: Colors.blue[600],
                        ),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword)
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'Please enter your password';
                        if (value!.length < 6) return 'Password must be at least 6 characters';
                      },
                    ),
                    SizedBox(height: 16),
                    AuthTextField(
                      controller: _confirmPasswordController,
                      label: 'Confirm Password',
                      icon: Icons.lock_clock_outlined,
                      obscureText: _obscureConfirmPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: Colors.blue[600],
                        ),
                        onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword)
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'Please confirm your password';
                        if (value != _passwordController.text) return 'Password do not match!';
                      },
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        foregroundColor: Colors.white, //buat textnya
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 4
                      ),
                      child: _isLoading
                          ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                          : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.person_add_rounded, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Register',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                                ),
                              )
                            ],
                          )
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 24),
          TextButton(
            onPressed: widget.onLoginTap,
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            child: Text(
              'Already have an account? Login',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500
              ),
            ),
          )
        ],
      ),
    );
  }
}