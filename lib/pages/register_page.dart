import 'package:flutter/material.dart';
import '../services/auth_service.dart';

const _kPrimary = Color(0xFF1A6B45);
const _kPrimaryLight = Color(0xFFE8F5EE);
const _kSurface = Color(0xFFF7FAF8);
const _kBorder = Color(0xFFDDEDE5);
const _kTextDark = Color(0xFF0F2419);
const _kTextMid = Color(0xFF4A6358);

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String role = 'user';
  bool _isLoading = false;
  bool _obscure = true;

  final auth = AuthService();

  Future<void> _register() async {
    if (nameController.text.trim().isEmpty) { _showSnack('Please enter your name'); return; }
    if (emailController.text.trim().isEmpty) { _showSnack('Please enter your email'); return; }
    if (passwordController.text.length < 6) { _showSnack('Password must be at least 6 characters'); return; }

    setState(() => _isLoading = true);
    try {
      await auth.signUp(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        role: role,
      );
      if (mounted) Navigator.pushReplacementNamed(context, '/dashboard');
    } catch (e) {
      if (mounted) _showSnack(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 4)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kSurface,
      body: Row(
        children: [
          // ── Left panel ────────────────────────────────────────────
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0F2419), Color(0xFF1A6B45)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.local_pharmacy, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'DoseUp',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Text(
                      'Join the Smart\nPharmacy Network',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.2,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Access pricing data, report shortages,\nand connect with the community.',
                      style: TextStyle(fontSize: 15, color: Color(0xFFBBDDCA), height: 1.6),
                    ),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          ),

          // ── Right form ────────────────────────────────────────────
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(48),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 380),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Create account',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: _kTextDark,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Get started with DoseUp today',
                        style: TextStyle(fontSize: 14, color: _kTextMid),
                      ),
                      const SizedBox(height: 32),

                      _FieldLabel(label: 'Full name'),
                      const SizedBox(height: 8),
                      _StyledField(
                        controller: nameController,
                        hint: 'John Doe',
                        prefixIcon: Icons.person_outline_rounded,
                      ),

                      const SizedBox(height: 16),

                      _FieldLabel(label: 'Email address'),
                      const SizedBox(height: 8),
                      _StyledField(
                        controller: emailController,
                        hint: 'you@example.com',
                        prefixIcon: Icons.mail_outline_rounded,
                        keyboardType: TextInputType.emailAddress,
                      ),

                      const SizedBox(height: 16),

                      _FieldLabel(label: 'Password'),
                      const SizedBox(height: 8),
                      _StyledField(
                        controller: passwordController,
                        hint: 'Min. 6 characters',
                        obscure: _obscure,
                        prefixIcon: Icons.lock_outline_rounded,
                        suffix: IconButton(
                          icon: Icon(
                            _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            color: _kTextMid,
                            size: 20,
                          ),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                      ),

                      const SizedBox(height: 16),

                      _FieldLabel(label: 'Account type'),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: _kBorder),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: role,
                            isExpanded: true,
                            icon: const Icon(Icons.keyboard_arrow_down_rounded, color: _kTextMid),
                            items: const [
                              DropdownMenuItem(value: 'user', child: Text('User')),
                              DropdownMenuItem(value: 'pharmacist', child: Text('Pharmacist')),
                              DropdownMenuItem(value: 'pharmacy', child: Text('Pharmacy')),
                            ],
                            onChanged: (value) => setState(() => role = value!),
                            style: const TextStyle(fontSize: 14, color: _kTextDark),
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: _isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(_kPrimary),
                                  strokeWidth: 2.5,
                                ),
                              )
                            : ElevatedButton(
                                onPressed: _register,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _kPrimary,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'Create account',
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                                ),
                              ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Already have an account? ',
                              style: TextStyle(color: _kTextMid, fontSize: 13)),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(context, '/login'),
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                color: _kPrimary,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(label,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _kTextDark));
  }
}

class _StyledField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final IconData prefixIcon;
  final TextInputType? keyboardType;
  final Widget? suffix;

  const _StyledField({
    required this.controller,
    required this.hint,
    this.obscure = false,
    required this.prefixIcon,
    this.keyboardType,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 14, color: _kTextDark),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFB0C4BB), fontSize: 14),
        prefixIcon: Icon(prefixIcon, color: _kTextMid, size: 18),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _kBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _kBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _kPrimary, width: 2),
        ),
      ),
    );
  }
}