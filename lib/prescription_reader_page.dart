import 'dart:io';
import 'package:flutter/material.dart';

class PrescriptionReaderPage extends StatefulWidget {
  const PrescriptionReaderPage({super.key});

  @override
  State<PrescriptionReaderPage> createState() =>
      _PrescriptionReaderPageState();
}

class _PrescriptionReaderPageState extends State<PrescriptionReaderPage> {
  File? _selectedImage;
  bool _isExtracting = false;
  String? _extractedText;

  void _addImage() {
    // Simulate image picker - in real app, use image_picker package
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Prescription Image"),
        content: const Text("Select image from:"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _simulateImageSelection();
            },
            child: const Text("Gallery"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _simulateImageSelection();
            },
            child: const Text("Camera"),
          ),
        ],
      ),
    );
  }

  void _simulateImageSelection() {
    // Simulate selecting an image
    setState(() {
      _selectedImage = File('assets/images/sample_prescription.jpg');
      _extractedText = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Image added successfully'),
        backgroundColor: Color(0xFF2D7A4A),
      ),
    );
  }

  void _extractData() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add an image first'),
          backgroundColor: Color(0xFFE74C3C),
        ),
      );
      return;
    }

    setState(() {
      _isExtracting = true;
    });

    // Simulate extraction process
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isExtracting = false;
      _extractedText = '''
PRESCRIPTION DETAILS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Patient Name: John Doe
Date: 30-01-2026
Doctor: Dr. Sarah Johnson

MEDICINES PRESCRIBED:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. Paracetamol 500mg
   Dosage: 1 tablet
   Frequency: Twice daily
   Duration: 5 days

2. Amoxicillin 500mg
   Dosage: 1 capsule
   Frequency: Three times daily
   Duration: 7 days

3. Vitamin B12 500mcg
   Dosage: 1 tablet
   Frequency: Once daily
   Duration: 30 days

NOTES:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Take medicines with food.
Avoid dairy products with antibiotics.
      ''';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Prescription extracted successfully'),
        backgroundColor: Color(0xFF2D7A4A),
      ),
    );
  }

  void _clearImage() {
    setState(() {
      _selectedImage = null;
      _extractedText = null;
    });
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
              Navigator.pushNamed(context, '/shortage');
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
                  onTap: () {
                    Navigator.pushNamed(context, '/search');
                  },
                ),
                _buildSidebarItem(
                  icon: Icons.warning_amber_rounded,
                  label: "Shortage\nReports",
                  onTap: () {
                    Navigator.pushNamed(context, '/shortage');
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
                  isActive: true,
                  onTap: () {
                    Navigator.pushNamed(context, '/prescription');
                  },
                ),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  const Text(
                    "Prescription Reader",
                    style: TextStyle(
                      color: Color(0xFF2D7A4A),
                      fontSize: 36,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 100,
                    height: 2,
                    color: const Color(0xFF2D7A4A),
                  ),
                  const SizedBox(height: 40),
                  // Image Upload Section
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            constraints: const BoxConstraints(maxWidth: 800),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: const Color(0xFF2D7A4A).withOpacity(0.2),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xFF2D7A4A).withOpacity(0.08),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Image Preview Area
                                Container(
                                  width: double.infinity,
                                  height: 300,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2D7A4A)
                                        .withOpacity(0.05),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8),
                                    ),
                                    border: Border(
                                      bottom: BorderSide(
                                        color: const Color(0xFF2D7A4A)
                                            .withOpacity(0.2),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: _selectedImage == null
                                      ? Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.image_not_supported_outlined,
                                                size: 64,
                                                color: const Color(0xFF2D7A4A)
                                                    .withOpacity(0.4),
                                              ),
                                              const SizedBox(height: 16),
                                              Text(
                                                "No image selected",
                                                style: TextStyle(
                                                  color: const Color(0xFF2D7A4A)
                                                      .withOpacity(0.6),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.check_circle,
                                                size: 64,
                                                color:
                                                    const Color(0xFF2D7A4A),
                                              ),
                                              const SizedBox(height: 16),
                                              Text(
                                                "Image loaded successfully",
                                                style: TextStyle(
                                                  color: const Color(0xFF2D7A4A),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                ),
                                // Buttons Section
                                Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          ElevatedButton.icon(
                                            icon: const Icon(Icons.image_search),
                                            label: const Text("Add Image"),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0xFF2D7A4A),
                                              foregroundColor: Colors.white,
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 32,
                                                vertical: 14,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                            ),
                                            onPressed: _addImage,
                                          ),
                                          const SizedBox(width: 16),
                                          if (_selectedImage != null)
                                            ElevatedButton.icon(
                                              icon: const Icon(Icons.close),
                                              label: const Text("Clear"),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color(0xFFE74C3C),
                                                foregroundColor: Colors.white,
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 32,
                                                  vertical: 14,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                              ),
                                              onPressed: _clearImage,
                                            ),
                                          const Spacer(),
                                          ElevatedButton.icon(
                                            icon: _isExtracting
                                                ? const SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      valueColor:
                                                          AlwaysStoppedAnimation(
                                                        Colors.white,
                                                      ),
                                                    ),
                                                  )
                                                : const Icon(Icons.auto_awesome),
                                            label: Text(
                                              _isExtracting
                                                  ? "Extracting..."
                                                  : "Extract Data",
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0xFF2D7A4A),
                                              foregroundColor: Colors.white,
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 32,
                                                vertical: 14,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                            ),
                                            onPressed: _isExtracting
                                                ? null
                                                : _extractData,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                          // Extracted Data Section
                          if (_extractedText != null)
                            Container(
                              constraints: const BoxConstraints(maxWidth: 800),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: const Color(0xFF2D7A4A)
                                      .withOpacity(0.2),
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF2D7A4A)
                                        .withOpacity(0.08),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: const Color(0xFF2D7A4A)
                                              .withOpacity(0.2),
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    child: const Text(
                                      "Extracted Data",
                                      style: TextStyle(
                                        color: Color(0xFF2D7A4A),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Text(
                                      _extractedText!,
                                      style: const TextStyle(
                                        color: Color(0xFF2D7A4A),
                                        fontSize: 13,
                                        fontFamily: 'monospace',
                                        height: 1.6,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: ElevatedButton.icon(
                                      icon: const Icon(Icons.file_download),
                                      label: const Text("Save Data"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF2D7A4A),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 32,
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                      ),
                                      onPressed: () {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Prescription data saved successfully',
                                            ),
                                            backgroundColor:
                                                Color(0xFF2D7A4A),
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
