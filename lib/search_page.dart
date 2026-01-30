import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _strengthController = TextEditingController();
  List<String> displayedMedicines = [];
  bool _showResults = false;

  // Sample medicine data
  final List<String> allMedicines = [
    'Paracetamol 500mg',
    'Aspirin 100mg',
    'Ibuprofen 200mg',
    'Amoxicillin 500mg',
    'Metformin 500mg',
    'Lisinopril 10mg',
    'Atorvastatin 20mg',
    'Omeprazole 20mg',
    'Cetirizine 10mg',
    'Loratadine 10mg',
    'Metoprolol 50mg',
    'Amlodipine 5mg',
    'Vitamin D3 1000IU',
    'Vitamin B12 500mcg',
  ];

  @override
  void initState() {
    super.initState();
    // Show all medicines by default
    displayedMedicines = allMedicines;
  }

  void _performSearch(String medicineName, String strength) {
    if (medicineName.isEmpty && strength.isEmpty) {
      setState(() {
        displayedMedicines = allMedicines;
        _showResults = true;
      });
    } else {
      setState(() {
        displayedMedicines = allMedicines
            .where((medicine) {
              bool matchesMedicine = medicineName.isEmpty ||
                  medicine.toLowerCase().contains(medicineName.toLowerCase());
              bool matchesStrength = strength.isEmpty ||
                  medicine.toLowerCase().contains(strength.toLowerCase());
              return matchesMedicine && matchesStrength;
            })
            .toList();
        _showResults = true;
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
              "Reports",
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
                  isActive: true,
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
                _buildSidebarItem(
                  icon: Icons.chat_rounded,
                  label: "AI Assistant",
                  onTap: () {
                    Navigator.pushNamed(context, '/chatbot');
                  },
                ),
                _buildSidebarItem(
                  icon: Icons.document_scanner,
                  label: "Prescription\nReader",
                  onTap: () {
                    Navigator.pushNamed(context, '/prescription');
                  },
                ),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: Column(
              children: [
                // Search Bar Section - Fixed at Top
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Search Medications",
                        style: TextStyle(
                          color: Color(0xFF2D7A4A),
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          // Medicine Name Search Box
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Medicine Name",
                                  style: TextStyle(
                                    color: Color(0xFF2D7A4A),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _searchController,
                                  decoration: InputDecoration(
                                    hintText: "e.g., Paracetamol",
                                    prefixIcon: const Icon(
                                      Icons.search,
                                      color: Color(0xFF2D7A4A),
                                    ),
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
                                  onChanged: (value) {
                                    _performSearch(
                                      _searchController.text,
                                      _strengthController.text,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Strength Search Box
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Strength",
                                  style: TextStyle(
                                    color: Color(0xFF2D7A4A),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _strengthController,
                                  decoration: InputDecoration(
                                    hintText: "e.g., 500mg",
                                    prefixIcon: const Icon(
                                      Icons.tune,
                                      color: Color(0xFF2D7A4A),
                                    ),
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
                                  onChanged: (value) {
                                    _performSearch(
                                      _searchController.text,
                                      _strengthController.text,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(height: 0, thickness: 1),
                // Scrollable Medicines List
                Expanded(
                  child: displayedMedicines.isEmpty
                      ? Center(
                          child: Text(
                            _searchController.text.isEmpty
                                ? "No medicines available"
                                : "No medicines found",
                            style: TextStyle(
                              color: const Color(0xFF2D7A4A).withOpacity(0.6),
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: displayedMedicines.length,
                          separatorBuilder: (context, index) => Divider(
                            height: 1,
                            color: const Color(0xFF2D7A4A).withOpacity(0.2),
                          ),
                          itemBuilder: (context, index) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    displayedMedicines[index],
                                    style: const TextStyle(
                                      color: Color(0xFF2D7A4A),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          icon: const Icon(Icons.compare_arrows),
                                          label: const Text("Compare Price"),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFF2D7A4A),
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.pushNamed(
                                              context,
                                              '/compare',
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          icon: const Icon(Icons.warning_rounded),
                                          label: const Text("Report Shortage"),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFFE74C3C),
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.pushNamed(
                                              context,
                                              '/shortage',
                                            );
                                          },
                                        ),
                                      ),
                                    ],
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
