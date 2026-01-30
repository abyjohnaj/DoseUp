import 'package:flutter/material.dart';

class ComparePage extends StatefulWidget {
  const ComparePage({super.key});

  @override
  State<ComparePage> createState() => _ComparePageState();
}

class _ComparePageState extends State<ComparePage> {
  // Sample pharmacy data
  final List<Map<String, dynamic>> pharmacyData = [
    {
      'name': 'Pharmacy A',
      'price': 250.00,
      'savings': 50.00,
    },
    {
      'name': 'Pharmacy B',
      'price': 280.00,
      'savings': 20.00,
    },
    {
      'name': 'Pharmacy C',
      'price': 300.00,
      'savings': 0.00,
    },
    {
      'name': 'Pharmacy D',
      'price': 265.00,
      'savings': 35.00,
    },
    {
      'name': 'Pharmacy E',
      'price': 290.00,
      'savings': 10.00,
    },
  ];

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
                    // Comparison Table
                    _buildComparisonTable(),
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
                    "Pharmacy",
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
            pharmacyData.length,
            (index) {
              final data = pharmacyData[index];
              final isLowest = index == 0; // Highlight lowest price

              return Container(
                decoration: BoxDecoration(
                  color: isLowest
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
                        data['name'],
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
                        "₹${data['price'].toStringAsFixed(2)}",
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
                                color: const Color(0xFF2D7A4A)
                                    .withOpacity(0.6),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Center(
                                child: Text(
                                  "₹${data['savings'].toStringAsFixed(2)}",
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
