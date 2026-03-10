import 'package:flutter/material.dart';
import 'services/price_comparison_service.dart';

class ComparePage extends StatefulWidget {
  const ComparePage({super.key});

  @override
  State<ComparePage> createState() => _ComparePageState();
}

class _ComparePageState extends State<ComparePage> {
  final TextEditingController _medicineController = TextEditingController();
  final PriceComparisonService _priceService = PriceComparisonService();
  
  PriceComparisonResult? _comparisonResult;
  bool _isSearching = false;

  void _searchPrices() async {
    if (_medicineController.text.isEmpty) return;

    setState(() {
      _isSearching = true;
    });

    // Simulate network delay
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: const Color(0xFF2D7A4A).withOpacity(0.2),
        leadingWidth: 220,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Row(
            children: [
              Image.asset(
                "assets/images/doseuplogo.png",
                height: 32,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 8),
              const Text(
                "DoseUp",
                style: TextStyle(
                  color: Color(0xFF2D7A4A),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/landing');
            },
            child: const Text(
              "Dashboard",
              style: TextStyle(
                  color: Color(0xFF2D7A4A),
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
            child: const Text(
              "Search",
              style: TextStyle(
                  color: Color(0xFF2D7A4A),
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/compare');
            },
            child: const Text(
              "Compare",
              style: TextStyle(
                  color: Color(0xFF2D7A4A),
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Row(
        children: [
          // Left Sidebar
          Container(
            width: 250,
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: const Color(0xFF2D7A4A).withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              color: const Color(0xFFF9FFFE),
            ),
            child: Column(
              children: [
                _buildSidebarItem(
                  icon: Icons.dashboard,
                  label: "Dashboard",
                  onTap: () {
                    Navigator.pushNamed(context, '/landing');
                  },
                ),
                _buildSidebarItem(
                  icon: Icons.search,
                  label: "Search",
                  onTap: () {
                    Navigator.pushNamed(context, '/search');
                  },
                ),
                _buildSidebarItem(
                  icon: Icons.warning_amber_rounded,
                  label: "Shortage\nReports",
                  onTap: () {
                    Navigator.pushNamed(context, '/compare');
                  },
                ),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    const Text(
                      "Compare Prices",
                      style: TextStyle(
                        color: Color(0xFF2D7A4A),
                        fontSize: 42,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 500,
                      height: 2,
                      color: const Color(0xFF2D7A4A).withOpacity(0.4),
                    ),
                    const SizedBox(height: 50),
                    // Search Bar
                    Row(
                      children: [
                        SizedBox(
                          width: 400,
                          child: TextField(
                            controller: _medicineController,
                            decoration: InputDecoration(
                              hintText: "Enter medicine name (e.g., Paracetamol, Aspirin, Ibuprofen, Metformin)...",
                              hintStyle: TextStyle(
                                color: const Color(0xFF2D7A4A)
                                    .withOpacity(0.5),
                                fontSize: 14,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: const Color(0xFF2D7A4A)
                                      .withOpacity(0.3),
                                  width: 1.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: const Color(0xFF2D7A4A)
                                      .withOpacity(0.3),
                                  width: 1.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(0xFF2D7A4A),
                                  width: 2,
                                ),
                              ),
                            ),
                            onSubmitted: (_) => _searchPrices(),
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.search),
                          label: const Text("Search"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2D7A4A),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: _searchPrices,
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    // Results
                    if (_isSearching)
                      const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(
                            Color(0xFF2D7A4A),
                          ),
                        ),
                      )
                    else if (_comparisonResult == null)
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFF2D7A4A).withOpacity(0.3),
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          color: const Color(0xFF2D7A4A).withOpacity(0.05),
                        ),
                        child: const Text(
                          "Enter a medicine name and click Search to compare prices",
                          style: TextStyle(
                            color: Color(0xFF2D7A4A),
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      )
                    else if (!_comparisonResult!.found)
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.red.withOpacity(0.3),
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.red.withOpacity(0.05),
                        ),
                        child: Text(
                          _comparisonResult!.message,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Summary Info
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFF2D7A4A).withOpacity(0.4),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              color: const Color(0xFF2D7A4A).withOpacity(0.05),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _comparisonResult!.message,
                                  style: const TextStyle(
                                    color: Color(0xFF2D7A4A),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildSummaryCard(
                                      title: "Cheapest",
                                      shop: _comparisonResult!.cheapest!.shopName,
                                      price: _comparisonResult!.cheapest!.price,
                                    ),
                                    _buildSummaryCard(
                                      title: "Most Expensive",
                                      shop: _comparisonResult!
                                          .costliest!.shopName,
                                      price: _comparisonResult!
                                          .costliest!.price,
                                    ),
                                    _buildSummaryCard(
                                      title: "Average Price",
                                      shop: "All Shops",
                                      price: _comparisonResult!
                                          .averagePrice!,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          // Comparison Table
                          _buildComparisonTable(),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonTable() {
    if (_comparisonResult == null || !_comparisonResult!.found) {
      return const SizedBox.shrink();
    }

    final pricesList = _comparisonResult!.allPrices;
    final cheapestPrice = _comparisonResult!.cheapest!.price;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFF2D7A4A).withOpacity(0.4),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          // Header Row
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: const Color(0xFF2D7A4A).withOpacity(0.4),
                  width: 1.5,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: _buildTableCell(
                    "Shop Name",
                    isHeader: true,
                  ),
                ),
                Container(
                  width: 1.5,
                  height: 60,
                  color: const Color(0xFF2D7A4A).withOpacity(0.3),
                ),
                Expanded(
                  flex: 1,
                  child: _buildTableCell(
                    "Price",
                    isHeader: true,
                  ),
                ),
                Container(
                  width: 1.5,
                  height: 60,
                  color: const Color(0xFF2D7A4A).withOpacity(0.3),
                ),
                Expanded(
                  flex: 1,
                  child: _buildTableCell(
                    "Savings",
                    isHeader: true,
                  ),
                ),
              ],
            ),
          ),
          // Data Rows
          ...List.generate(
            pricesList.length,
            (index) {
              final record = pricesList[index];
              final isCheapest = record.price == cheapestPrice;
              final savings = cheapestPrice > 0
                  ? record.price - cheapestPrice
                  : 0.0;

              return Container(
                decoration: BoxDecoration(
                  color: isCheapest
                      ? const Color(0xFF2D7A4A).withOpacity(0.05)
                      : Colors.transparent,
                  border: Border(
                    bottom: BorderSide(
                      color: const Color(0xFF2D7A4A).withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: _buildTableCell(
                        record.shopName,
                        isHeader: false,
                      ),
                    ),
                    Container(
                      width: 1.5,
                      height: 70,
                      color: const Color(0xFF2D7A4A).withOpacity(0.2),
                    ),
                    Expanded(
                      flex: 1,
                      child: _buildTableCell(
                        "₹${record.price.toStringAsFixed(2)}",
                        isHeader: false,
                      ),
                    ),
                    Container(
                      width: 1.5,
                      height: 70,
                      color: const Color(0xFF2D7A4A).withOpacity(0.2),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 24,
                              decoration: BoxDecoration(
                                color: isCheapest
                                    ? Colors.green.withOpacity(0.7)
                                    : const Color(0xFF2D7A4A)
                                        .withOpacity(0.6),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Center(
                                child: Text(
                                  "₹${savings.abs().toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
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
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String shop,
    required double price,
  }) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFF2D7A4A).withOpacity(0.3),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF2D7A4A),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "₹${price.toStringAsFixed(2)}",
            style: const TextStyle(
              color: Color(0xFF2D7A4A),
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            shop,
            style: const TextStyle(
              color: Color(0xFF2D7A4A),
              fontSize: 12,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableCell(String text, {required bool isHeader}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 18,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: const Color(0xFF2D7A4A),
          fontSize: isHeader ? 18 : 16,
          fontWeight: isHeader ? FontWeight.w700 : FontWeight.w500,
          letterSpacing: isHeader ? 0.3 : 0.2,
        ),
      ),
    );
  }

  Widget _buildSidebarItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFF2D7A4A).withOpacity(0.1)
            : Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFF2D7A4A).withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFF2D7A4A),
                      width: 1.5,
                    ),
                    color: isActive
                        ? const Color(0xFF2D7A4A)
                        : Colors.transparent,
                  ),
                  child: isActive
                      ? const Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.white,
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Color(0xFF2D7A4A),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
