import 'package:flutter/material.dart';

// ── Design tokens (shared across app) ──────────────────────────────────────
const _kPrimary = Color(0xFF1A6B45);
const _kPrimaryLight = Color(0xFFE8F5EE);
const _kDanger = Color(0xFFDC2626);
const _kDangerLight = Color(0xFFFEF2F2);
const _kSurface = Color(0xFFF7FAF8);
const _kCard = Colors.white;
const _kBorder = Color(0xFFDDEDE5);
const _kTextDark = Color(0xFF0F2419);
const _kTextMid = Color(0xFF4A6358);
const _kTextLight = Color(0xFF8BA899);

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _strengthController = TextEditingController();
  List<String> displayedMedicines = [];

  final List<String> allMedicines = [
    'Paracetamol 500mg', 'Aspirin 100mg', 'Ibuprofen 200mg',
    'Amoxicillin 500mg', 'Metformin 500mg', 'Lisinopril 10mg',
    'Atorvastatin 20mg', 'Omeprazole 20mg', 'Cetirizine 10mg',
    'Loratadine 10mg', 'Metoprolol 50mg', 'Amlodipine 5mg',
    'Vitamin D3 1000IU', 'Vitamin B12 500mcg',
  ];

  @override
  void initState() {
    super.initState();
    displayedMedicines = allMedicines;
  }

  void _performSearch(String medicineName, String strength) {
    if (medicineName.isEmpty && strength.isEmpty) {
      setState(() => displayedMedicines = allMedicines);
    } else {
      setState(() {
        displayedMedicines = allMedicines.where((medicine) {
          bool matchesMedicine = medicineName.isEmpty ||
              medicine.toLowerCase().contains(medicineName.toLowerCase());
          bool matchesStrength = strength.isEmpty ||
              medicine.toLowerCase().contains(strength.toLowerCase());
          return matchesMedicine && matchesStrength;
        }).toList();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _strengthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kSurface,
      body: Row(
        children: [
          _Sidebar(activeRoute: '/search'),
          Expanded(
            child: Column(
              children: [
                _TopBar(title: 'Search Medications'),
                // ── Search bar ─────────────────────────────────────
                Container(
                  color: _kCard,
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Medicine Name',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _kTextMid)),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _searchController,
                              decoration: _inputDec(hint: 'e.g., Paracetamol', icon: Icons.search_rounded),
                              onChanged: (v) => _performSearch(v, _strengthController.text),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Strength',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _kTextMid)),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              value: _strengthController.text.isEmpty ? null : _strengthController.text,
                              hint: const Text('Select', style: TextStyle(fontSize: 13)),
                              items: [
                                '5mg', '10mg', '20mg', '50mg', '100mg', '200mg',
                                '250mg', '500mg', '1000mg', '1g', '2g', '5g',
                                '10g', '500mcg', '1000IU',
                              ].map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 13)))).toList(),
                              onChanged: (v) {
                                setState(() => _strengthController.text = v ?? '');
                                _performSearch(_searchController.text, v ?? '');
                              },
                              decoration: _inputDec(hint: '', icon: Icons.tune_rounded),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: _kBorder),

                // ── Results ────────────────────────────────────────
                Expanded(
                  child: displayedMedicines.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.medication_outlined, size: 52, color: _kTextLight),
                              const SizedBox(height: 12),
                              Text(
                                _searchController.text.isEmpty
                                    ? 'No medicines available'
                                    : 'No results found',
                                style: const TextStyle(color: _kTextLight, fontSize: 15),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: displayedMedicines.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            return Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: _kCard,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: _kBorder),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.03),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: _kPrimaryLight,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(Icons.medication_rounded, color: _kPrimary, size: 22),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      displayedMedicines[index],
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: _kTextDark,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  _ActionBtn(
                                    icon: Icons.compare_arrows_rounded,
                                    label: 'Compare',
                                    onTap: () => Navigator.pushNamed(
                                      context,
                                      '/compare',
                                      arguments: displayedMedicines[index],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  _ActionBtn(
                                    icon: Icons.warning_rounded,
                                    label: 'Shortage',
                                    danger: true,
                                    onTap: () => Navigator.pushNamed(context, '/shortage'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDec({required String hint, required IconData icon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFFB0C4BB), fontSize: 13),
      prefixIcon: Icon(icon, color: _kTextMid, size: 18),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _kBorder)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _kBorder)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _kPrimary, width: 2)),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool danger;

  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.onTap,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = danger ? _kDanger : _kPrimary;
    final bg = danger ? _kDangerLight : _kPrimaryLight;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: [
            Icon(icon, size: 15, color: color),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color)),
          ],
        ),
      ),
    );
  }
}

// ── Shared Sidebar & TopBar ─────────────────────────────────────────────────

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
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(color: _kPrimary, borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.local_pharmacy, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 10),
                const Text('DoseUp',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: _kPrimary, letterSpacing: -0.3)),
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
          _NavItem(icon: Icons.smart_toy_rounded, label: 'AI Assistant', route: '/chatbot', activeRoute: activeRoute),
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

  const _NavItem({required this.icon, required this.label, required this.route, required this.activeRoute});

  @override
  Widget build(BuildContext context) {
    final isActive = route == activeRoute;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: InkWell(
        onTap: () { if (!isActive) Navigator.pushNamed(context, route); },
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
              Icon(icon, size: 19, color: isActive ? _kPrimary : _kTextMid),
              const SizedBox(width: 12),
              Text(label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    color: isActive ? _kPrimary : _kTextMid,
                  )),
              if (isActive) ...[
                const Spacer(),
                Container(width: 4, height: 4, decoration: const BoxDecoration(shape: BoxShape.circle, color: _kPrimary)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final String title;
  const _TopBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(color: _kCard, border: Border(bottom: BorderSide(color: _kBorder))),
      child: Row(
        children: [
          Text(title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _kTextDark)),
          const Spacer(),
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(color: _kPrimaryLight, shape: BoxShape.circle),
            child: const Icon(Icons.person_outline_rounded, size: 20, color: _kPrimary),
          ),
        ],
      ),
    );
  }
}