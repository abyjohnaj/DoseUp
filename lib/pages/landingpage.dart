import 'package:doseup/pages/dashboard_page.dart';
import 'package:doseup/pages/register_page.dart';
import 'package:flutter/material.dart';

/// ------------------------------------------------------------
/// DoseUp Landing Page
/// Smart Pharmacy Ecosystem Platform
/// Purpose:
/// - Public entry screen
/// - Introduces core platform features
/// - Ideathon demo landing interface
/// ------------------------------------------------------------
class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  /// App branding constants (easy future modification)
  static const String appName = "DoseUp";
  static const String tagline =
      "A Smart Pharmacy Ecosystem for price transparency and collaboration.";

  /// Feature card builder (Reusable component)
  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
  }) {
    return Semantics(
      label: title,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF4CAF73),
                width: 2.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2D7A4A).withOpacity(0.15),
                  blurRadius: 12,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 52,
              color: const Color(0xFF2D7A4A),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF2D7A4A),
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: const Color(0xFF2D7A4A).withOpacity(0.2),

        /// Branding section
        leadingWidth: 220,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Row(
            children: [
              Image.asset(
                "assets/images/doseuplogo.png",
                height: 32,
                fit: BoxFit.contain,
                semanticLabel: "DoseUp Logo",
              ),
              const SizedBox(width: 8),
              const Text(
                appName,
                style: TextStyle(
                  color: Color(0xFF2D7A4A),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        /// Future navigation placeholders
        actions: [
          TextButton(
            onPressed: () {
              // TODO: Scroll to home section
            },
            child: const Text(
              "Home",
              style: TextStyle(
                  color: Color(0xFF2D7A4A),
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
          ),
          TextButton(
            onPressed: () {
              // TODO: About section / Ideathon explanation
            },
            child: const Text(
              "About",
              style: TextStyle(
                  color: Color(0xFF2D7A4A),
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
          ),
          TextButton(
            onPressed: () {
              // TODO: Contact / Support integration
            },
            child: const Text(
              "Contact Us",
              style: TextStyle(
                  color: Color(0xFF2D7A4A),
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),

      // BODY
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// ------------------------------------------------
            /// HERO SECTION — Product Value Proposition
            /// ------------------------------------------------
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1B5E3F),
                    Color(0xFF2D7A4A),
                    Color(0xFF4CAF73),
                    Color(0xFF81C784),
                    Color(0xFFAED581),
                    Colors.white,
                  ],
                  stops: [0.0, 0.15, 0.3, 0.5, 0.75, 1.0],
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    "Compare Medicine Prices Easily",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// Product description (Ideathon clarity)
                  SizedBox(
                    width: 650,
                    child: const Text(
                      "DoseUp helps users find affordable medicines, compare pharmacy prices, and stay informed through a connected healthcare ecosystem.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        height: 1.6,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),

                  /// Primary actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF2D7A4A),
                          elevation: 8,
                          shadowColor: Colors.black26,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 18),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (context) =>
                                  const RegisterPage(),
                            ),
                          );
                        },
                        child: const Text(
                          "Get Started",
                          style: TextStyle(
                            color: Color(0xFF2D7A4A),
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      OutlinedButton(
                        onPressed: () {
                          // TODO: Explain platform vision
                        },
                        child: const Text(
                          "Learn More",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// ------------------------------------------------
            /// FEATURES SECTION — Core Capabilities
            /// ------------------------------------------------
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white,
                    Color(0xFFF0F8F5),
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: _buildFeatureCard(
                      icon: Icons.search,
                      title: "Search Medications",
                    ),
                  ),
                  Container(
                    width: 1.5,
                    height: 140,
                    color: const Color(0xFF2D7A4A).withOpacity(0.25),
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                  ),
                  Expanded(
                    child: _buildFeatureCard(
                      icon: Icons.trending_down,
                      title: "Compare Prices",
                    ),
                  ),
                  Container(
                    width: 1.5,
                    height: 140,
                    color: const Color(0xFF2D7A4A).withOpacity(0.25),
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                  ),
                  Expanded(
                    child: _buildFeatureCard(
                      icon: Icons.warning_amber_rounded,
                      title: "Report Shortages",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}