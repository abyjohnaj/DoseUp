import 'package:flutter/material.dart';
import '../services/price_comparison_service.dart';

const _kPrimary = Color(0xFF1A6B45);
const _kPrimaryLight = Color(0xFFE8F5EE);
const _kSurface = Color(0xFFF7FAF8);
const _kCard = Colors.white;
const _kBorder = Color(0xFFDDEDE5);
const _kTextDark = Color(0xFF0F2419);
const _kTextMid = Color(0xFF4A6358);
const _kTextLight = Color(0xFF8BA899);

class ComparePage extends StatefulWidget {
  final String? medicineName;
  const ComparePage({super.key, this.medicineName});

  @override
  State<ComparePage> createState() => _ComparePageState();
}

class _ComparePageState extends State<ComparePage> {
  final TextEditingController _medicineController = TextEditingController();
  final PriceComparisonService _priceService = PriceComparisonService();
  PriceComparisonResult? _comparisonResult;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    if (widget.medicineName != null) {
      _medicineController.text = widget.medicineName!;
      _searchPrices();
    }
  }

  void _searchPrices() async {
    if (_medicineController.text.isEmpty) return;
    setState(() => _isSearching = true);
    await Future.delayed(const Duration(milliseconds: 800));
    final result = _priceService.comparePrices(_medicineController.text);
    setState(() {
      _comparisonResult = result;
      _isSearching = false;
    });
  }

  @override
  void dispose() {
    _medicineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kSurface,
      body: Row(
        children: [
          _Sidebar(activeRoute: '/compare'),
          Expanded(
            child: Column(
              children: [
                _TopBar(title: 'Compare Prices'),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Search bar card
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: _kCard,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: _kBorder),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _medicineController,
                                  style: const TextStyle(fontSize: 14, color: _kTextDark),
                                  decoration: InputDecoration(
                                    hintText: 'Enter medicine name (e.g., Paracetamol, Metformin)...',
                                    hintStyle: const TextStyle(color: Color(0xFFB0C4BB), fontSize: 13),
                                    prefixIcon: const Icon(Icons.search_rounded, color: _kTextMid, size: 18),
                                    filled: true,
                                    fillColor: _kSurface,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(color: _kBorder)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(color: _kBorder)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(color: _kPrimary, width: 2)),
                                  ),
                                  onSubmitted: (_) => _searchPrices(),
                                ),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.search_rounded, size: 18),
                                label: const Text('Search'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _kPrimary,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                onPressed: _searchPrices,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Results area
                        if (_isSearching)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(40),
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(_kPrimary),
                                strokeWidth: 2.5,
                              ),
                            ),
                          )
                        else if (_comparisonResult == null)
                          _EmptyState()
                        else if (!_comparisonResult!.found)
                          _NotFound(message: _comparisonResult!.message)
                        else ...[
                          // Summary cards
                          Row(
                            children: [
                              _SummaryCard(
                                icon: Icons.trending_down_rounded,
                                label: 'Cheapest',
                                shop: _comparisonResult!.cheapest!.shopName,
                                price: _comparisonResult!.cheapest!.price,
                                accent: const Color(0xFF16A34A),
                              ),
                              const SizedBox(width: 16),
                              _SummaryCard(
                                icon: Icons.trending_up_rounded,
                                label: 'Most Expensive',
                                shop: _comparisonResult!.costliest!.shopName,
                                price: _comparisonResult!.costliest!.price,
                                accent: const Color(0xFFDC2626),
                              ),
                              const SizedBox(width: 16),
                              _SummaryCard(
                                icon: Icons.bar_chart_rounded,
                                label: 'Average Price',
                                shop: 'All Shops',
                                price: _comparisonResult!.averagePrice!,
                                accent: const Color(0xFF2563EB),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Header
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: _kCard,
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                              border: Border.all(color: _kBorder),
                            ),
                            child: Text(
                              _comparisonResult!.message,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _kTextDark),
                            ),
                          ),

                          // Table
                          _buildComparisonTable(),
                        ],
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

  Widget _buildComparisonTable() {
    if (_comparisonResult == null || !_comparisonResult!.found) return const SizedBox.shrink();

    final pricesList = _comparisonResult!.allPrices;
    final cheapestPrice = _comparisonResult!.cheapest!.price;

    return Container(
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
        border: Border.all(color: _kBorder),
      ),
      child: Column(
        children: [
          // Header row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: const BoxDecoration(
              color: _kSurface,
              border: Border(bottom: BorderSide(color: _kBorder)),
            ),
            child: Row(
              children: const [
                Expanded(flex: 3, child: Text('PHARMACY', style: _headerStyle)),
                Expanded(flex: 2, child: Text('PRICE', style: _headerStyle)),
                Expanded(flex: 2, child: Text('SAVINGS vs CHEAPEST', style: _headerStyle)),
              ],
            ),
          ),
          // Data rows
          ...List.generate(pricesList.length, (index) {
            final record = pricesList[index];
            final isCheapest = record.price == cheapestPrice;
            final savings = record.price - cheapestPrice;

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: isCheapest ? const Color(0xFFF0FDF4) : Colors.transparent,
                border: const Border(bottom: BorderSide(color: _kBorder)),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        if (isCheapest) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFF16A34A),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text('BEST', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800)),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(record.shopName,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isCheapest ? FontWeight.w700 : FontWeight.w500,
                              color: _kTextDark,
                            )),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      '₹${record.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isCheapest ? const Color(0xFF16A34A) : _kTextDark,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: savings == 0
                        ? const Text('—', style: TextStyle(color: _kTextLight))
                        : Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF2F2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '+₹${savings.toStringAsFixed(2)}',
                              style: const TextStyle(color: Color(0xFFDC2626), fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                          ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

const _headerStyle = TextStyle(
  fontSize: 11,
  fontWeight: FontWeight.w700,
  color: _kTextLight,
  letterSpacing: 0.5,
);

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String shop;
  final double price;
  final Color accent;

  const _SummaryCard({
    required this.icon,
    required this.label,
    required this.shop,
    required this.price,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _kCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _kBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: accent, size: 22),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: _kTextLight, fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text('₹${price.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: accent)),
                Text(shop, style: const TextStyle(fontSize: 11, color: _kTextMid)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _kBorder),
      ),
      child: Column(
        children: const [
          Icon(Icons.compare_arrows_rounded, size: 48, color: _kTextLight),
          SizedBox(height: 12),
          Text('Enter a medicine name and click Search to compare prices',
              textAlign: TextAlign.center,
              style: TextStyle(color: _kTextMid, fontSize: 14)),
        ],
      ),
    );
  }
}

class _NotFound extends StatelessWidget {
  final String message;
  const _NotFound({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFECACA)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: Color(0xFFDC2626), size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(message,
              style: const TextStyle(color: Color(0xFFDC2626), fontSize: 14, fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }
}

// ── Sidebar & TopBar ────────────────────────────────────────────────────────

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
                  width: 34, height: 34,
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
              Text(label, style: TextStyle(
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
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _kTextDark)),
          const Spacer(),
          Container(
            width: 36, height: 36,
            decoration: const BoxDecoration(color: _kPrimaryLight, shape: BoxShape.circle),
            child: const Icon(Icons.person_outline_rounded, size: 20, color: _kPrimary),
          ),
        ],
      ),
    );
  }
}