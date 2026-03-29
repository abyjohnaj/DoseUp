import 'package:doseup/pages/login_page.dart';
import 'package:flutter/material.dart';

const _kPrimary = Color(0xFF1A6B45);
const _kPrimaryMid = Color(0xFF2D8A57);
const _kPrimaryLight = Color(0xFFE8F5EE);
const _kSurface = Color(0xFFF7FAF8);
const _kBorder = Color(0xFFDDEDE5);
const _kTextDark = Color(0xFF0F2419);
const _kTextMid = Color(0xFF4A6358);
const _kTextLight = Color(0xFF8BA899);

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  static const String appName = 'DoseUp';
  static const String tagline =
      'A Smart Pharmacy Ecosystem for price transparency and collaboration.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ── Nav bar ────────────────────────────────────────────────
          Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 40),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: _kBorder)),
            ),
            child: Row(
              children: [
                // Logo
                Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: _kPrimary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.local_pharmacy, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      appName,
                      style: TextStyle(
                        color: _kPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                _NavLink(label: 'Home', onTap: () {}),
                _NavLink(label: 'About', onTap: () {}),
                _NavLink(label: 'Contact Us', onTap: () {}),
                const SizedBox(width: 16),
                OutlinedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _kPrimary,
                    side: const BorderSide(color: _kPrimary),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Login', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _kPrimary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Get Started', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),

          // ── Body ───────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // ── Hero ─────────────────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 96, horizontal: 80),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF0F2419), Color(0xFF1A6B45), Color(0xFF2D8A57)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [0.0, 0.5, 1.0],
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: Colors.white.withOpacity(0.2)),
                          ),
                          child: const Text(
                            '🚀 Smart Pharmacy Ecosystem',
                            style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(height: 28),
                        const Text(
                          'Compare Medicine Prices\nEasily',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 52,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'DoseUp helps users find affordable medicines, compare pharmacy prices,\nand stay informed through a connected healthcare ecosystem.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFFBBDDCA),
                            fontSize: 17,
                            height: 1.6,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: _kPrimary,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const LoginPage()),
                              ),
                              child: const Text(
                                'Get Started',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                              ),
                            ),
                            const SizedBox(width: 16),
                            OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Colors.white54),
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              child: const Text(
                                'Learn More',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // ── Features ───────────────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 80),
                    color: Colors.white,
                    child: Column(
                      children: [
                        const Text(
                          'Everything you need',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: _kTextDark,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Powerful tools to navigate the pharmacy ecosystem',
                          style: TextStyle(fontSize: 16, color: _kTextMid),
                        ),
                        const SizedBox(height: 56),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            _FeatureCard(
                              icon: Icons.search_rounded,
                              title: 'Search Medications',
                              description: 'Find any medicine instantly from our comprehensive database.',
                            ),
                            SizedBox(width: 24),
                            _FeatureCard(
                              icon: Icons.trending_down_rounded,
                              title: 'Compare Prices',
                              description: 'See prices across pharmacies and save money on every purchase.',
                            ),
                            SizedBox(width: 24),
                            _FeatureCard(
                              icon: Icons.warning_amber_rounded,
                              title: 'Report Shortages',
                              description: 'Stay informed and help the community by reporting availability.',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // ── Footer ─────────────────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 80),
                    decoration: const BoxDecoration(
                      color: _kSurface,
                      border: Border(top: BorderSide(color: _kBorder)),
                    ),
                    child: const Center(
                      child: Text(
                        '© 2025 DoseUp. Smart Pharmacy Ecosystem.',
                        style: TextStyle(color: _kTextLight, fontSize: 13),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _NavLink({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        label,
        style: const TextStyle(color: _kTextMid, fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  const _FeatureCard({required this.icon, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: _kSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _kBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: _kPrimaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 28, color: _kPrimary),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: _kTextDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: _kTextMid,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}