import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> searchResults = [];
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
  ];

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
        _showResults = false;
      });
    } else {
      setState(() {
        searchResults = allMedicines
            .where((medicine) =>
                medicine.toLowerCase().contains(query.toLowerCase()))
            .toList();
        _showResults = true;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
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
            onPressed: () {},
            child: const Text(
              "Dashboard",
              style: TextStyle(
                  color: Color(0xFF2D7A4A),
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              "Search",
              style: TextStyle(
                  color: Color(0xFF2D7A4A),
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
          ),
          TextButton(
            onPressed: () {},
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
                  onTap: () {},
                ),
                _buildSidebarItem(
                  icon: Icons.search,
                  label: "Search",
                  isActive: true,
                  onTap: () {},
                ),
                _buildSidebarItem(
                  icon: Icons.warning_amber_rounded,
                  label: "Shortage\nReports",
                  onTap: () {},
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
                      "Search Medications",
                      style: TextStyle(
                        color: Color(0xFF2D7A4A),
                        fontSize: 36,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Search Bar
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: "Enter medicine name...",
                              hintStyle: TextStyle(
                                color: const Color(0xFF2D7A4A).withOpacity(0.5),
                                fontSize: 16,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide(
                                  color: const Color(0xFF2D7A4A).withOpacity(0.3),
                                  width: 1.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide(
                                  color: const Color(0xFF2D7A4A).withOpacity(0.3),
                                  width: 1.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(
                                  color: Color(0xFF2D7A4A),
                                  width: 2,
                                ),
                              ),
                            ),
                            onChanged: _performSearch,
                          ),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2D7A4A),
                            foregroundColor: Colors.white,
                            elevation: 4,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          onPressed: () => _performSearch(_searchController.text),
                          child: const Text(
                            "Search",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 60),
                    // Search Results Section
                    if (_showResults)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: const Color(0xFF2D7A4A).withOpacity(0.4),
                                  width: 1.5,
                                ),
                              ),
                            ),
                            child: const Text(
                              "Search Results",
                              style: TextStyle(
                                color: Color(0xFF2D7A4A),
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                          if (searchResults.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 30,
                              ),
                              child: Text(
                                "No medicines found matching '${_searchController.text}'",
                                style: TextStyle(
                                  color: const Color(0xFF2D7A4A).withOpacity(0.6),
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            )
                          else
                            Column(
                              children: List.generate(
                                searchResults.length,
                                (index) => Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: const Color(0xFF2D7A4A)
                                            .withOpacity(0.2),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    searchResults[index],
                                    style: const TextStyle(
                                      color: Color(0xFF2D7A4A),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      )
                    else if (_searchController.text.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 40,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFF2D7A4A).withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "No results for '${_searchController.text}'",
                            style: TextStyle(
                              color: const Color(0xFF2D7A4A).withOpacity(0.6),
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
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