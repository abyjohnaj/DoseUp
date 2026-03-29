import 'package:flutter/material.dart';

// ── DoseUp Design Tokens ────────────────────────────────────────────────────
const _kPrimary = Color(0xFF1A6B45);
const _kPrimaryLight = Color(0xFFE8F5EE);
const _kPrimaryMid = Color(0xFF2D8A57);
const _kSurface = Color(0xFFF7FAF8);
const _kCard = Colors.white;
const _kBorder = Color(0xFFDDEDE5);
const _kTextDark = Color(0xFF0F2419);
const _kTextMid = Color(0xFF4A6358);
const _kTextLight = Color(0xFF8BA899);

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kSurface,
      body: Row(
        children: [
          // ── Sidebar ──────────────────────────────────────────────────
          _Sidebar(activeRoute: '/dashboard'),
          // ── Main content ─────────────────────────────────────────────
          Expanded(
            child: Column(
              children: [
                _TopBar(title: 'Dashboard'),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Welcome banner
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [_kPrimary, _kPrimaryMid],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'Welcome to DoseUp 👋',
                                      style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        letterSpacing: -0.3,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Compare medicine prices, find generic alternatives,\nand check availability across pharmacies.',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFFBBDDCA),
                                        height: 1.6,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.local_pharmacy_outlined,
                                size: 64,
                                color: Color(0x44FFFFFF),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        const Text(
                          'Quick Access',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: _kTextDark,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 16),

                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 2.2,
                          children: [
                            _DashCard(
                              context: context,
                              icon: Icons.search_rounded,
                              title: 'Search Medicine',
                              subtitle: 'Find medicines quickly',
                              route: '/search',
                              accent: const Color(0xFF1A6B45),
                            ),
                            _DashCard(
                              context: context,
                              icon: Icons.receipt_long_rounded,
                              title: 'Prescription Reader',
                              subtitle: 'Read prescriptions easily',
                              route: '/prescription',
                              accent: const Color(0xFF2563EB),
                            ),
                            _DashCard(
                              context: context,
                              icon: Icons.forum_rounded,
                              title: 'Community Forum',
                              subtitle: 'Discuss medicines & shortages',
                              route: '/forum',
                              accent: const Color(0xFF7C3AED),
                            ),
                            _DashCard(
                              context: context,
                              icon: Icons.smart_toy_rounded,
                              title: 'AI Assistant',
                              subtitle: 'Get help using DoseUp',
                              route: '/assistant',
                              accent: const Color(0xFFD97706),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Dashboard Card ──────────────────────────────────────────────────────────

class _DashCard extends StatelessWidget {
  final BuildContext context;
  final IconData icon;
  final String title;
  final String subtitle;
  final String route;
  final Color accent;

  const _DashCard({
    required this.context,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
    required this.accent,
  });

  @override
  Widget build(BuildContext _) {
    const builtRoutes = {'/search', '/prescription', '/forum', '/dashboard'};

    return InkWell(
      onTap: () {
        if (builtRoutes.contains(route)) {
          Navigator.pushNamed(context, route);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$title — coming soon!')),
          );
        }
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _kCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _kBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 26, color: accent),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: _kTextDark,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: _kTextLight,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 14, color: _kTextLight),
          ],
        ),
      ),
    );
  }
}

// ── Shared Sidebar ──────────────────────────────────────────────────────────

class _Sidebar extends StatelessWidget {
  final String activeRoute;
  const _Sidebar({required this.activeRoute});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      color: _kCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
            child: Row(
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
                  'DoseUp',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: _kPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: _kBorder),
          const SizedBox(height: 8),
          _NavItem(icon: Icons.dashboard_rounded, label: 'Dashboard', route: '/dashboard', activeRoute: activeRoute),
          _NavItem(icon: Icons.search_rounded, label: 'Search', route: '/search', activeRoute: activeRoute),
          _NavItem(icon: Icons.compare_arrows_rounded, label: 'Compare Prices', route: '/compare', activeRoute: activeRoute),
          _NavItem(icon: Icons.receipt_long_rounded, label: 'Prescription', route: '/prescription', activeRoute: activeRoute),
          _NavItem(icon: Icons.forum_rounded, label: 'Community', route: '/forum', activeRoute: activeRoute),
          _NavItem(icon: Icons.warning_amber_rounded, label: 'Shortage Reports', route: '/shortage', activeRoute: activeRoute),
          _NavItem(icon: Icons.smart_toy_rounded, label: 'AI Assistant', route: '/assistant', activeRoute: activeRoute),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;
  final String activeRoute;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.route,
    required this.activeRoute,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = route == activeRoute;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: InkWell(
        onTap: () {
          if (!isActive) Navigator.pushNamed(context, route);
        },
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: BoxDecoration(
            color: isActive ? _kPrimaryLight : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 19,
                color: isActive ? _kPrimary : _kTextMid,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive ? _kPrimary : _kTextMid,
                ),
              ),
              if (isActive) ...[
                const Spacer(),
                Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: _kPrimary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ── Shared Top Bar ──────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final String title;
  const _TopBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: _kCard,
        border: Border(bottom: BorderSide(color: _kBorder)),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: _kTextDark,
            ),
          ),
          const Spacer(),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _kPrimaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person_outline_rounded, size: 20, color: _kPrimary),
          ),
        ],
      ),
    );
  }
}