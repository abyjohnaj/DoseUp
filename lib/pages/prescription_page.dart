import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/prescription_service.dart';

class PrescriptionPage extends StatefulWidget {
  const PrescriptionPage({super.key});

  @override
  State<PrescriptionPage> createState() => _PrescriptionPageState();
}

class _PrescriptionPageState extends State<PrescriptionPage> {
  Uint8List? imageBytes;
  Map<String, dynamic>? result;
  bool isLoading = false;
  String? errorMessage;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      final bytes = await file.readAsBytes();
      setState(() {
        imageBytes = bytes;
        result = null;     // clear previous result on new image
        errorMessage = null;
      });
    }
  }

  Future<void> extractPrescription() async {
    if (imageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please upload an image first")),
      );
      return;
    }

    setState(() {
      isLoading = true;
      result = null;
      errorMessage = null;
    });

    try {
      final data = await PrescriptionService.extractPrescription(imageBytes!);
      setState(() {
        result = data;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString().replaceFirst("Exception: ", "");
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Prescription Reader"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Upload section ───────────────────────────────────────────────
            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Upload Prescription",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),

                  // Image preview or placeholder
                  GestureDetector(
                    onTap: pickImage,
                    child: Container(
                      width: double.infinity,
                      height: 180,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF7F2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF2D7A4A).withOpacity(0.4),
                          width: 1.5,
                        ),
                      ),
                      child: imageBytes != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(11),
                              child: Image.memory(imageBytes!, fit: BoxFit.cover),
                            )
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_photo_alternate_outlined,
                                    size: 48, color: Color(0xFF2D7A4A)),
                                SizedBox(height: 8),
                                Text("Tap to select image",
                                    style: TextStyle(
                                        color: Color(0xFF2D7A4A), fontSize: 14)),
                              ],
                            ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: pickImage,
                        icon: const Icon(Icons.photo_library_outlined, size: 18),
                        label: const Text("Choose Image"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF2D7A4A),
                          side: const BorderSide(color: Color(0xFF2D7A4A)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: isLoading ? null : extractPrescription,
                        icon: isLoading
                            ? const SizedBox(
                                width: 16, height: 16,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white))
                            : const Icon(Icons.document_scanner_outlined, size: 18),
                        label: Text(isLoading ? "Reading..." : "Extract"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2D7A4A),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ]),
                ],
              ),
            ),

            // ── Error ────────────────────────────────────────────────────────
            if (errorMessage != null) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(errorMessage!,
                          style: const TextStyle(color: Colors.red, fontSize: 13)),
                    ),
                  ],
                ),
              ),
            ],

            // ── Results ──────────────────────────────────────────────────────
            if (result != null) ...[
              const SizedBox(height: 16),
              _SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(children: [
                      Icon(Icons.check_circle, color: Color(0xFF2D7A4A), size: 20),
                      SizedBox(width: 8),
                      Text("Prescription Summary",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                    ]),
                    const SizedBox(height: 16),

                    // Extracted fields as cards
                    _ResultRow(
                        icon: Icons.medication,
                        label: "Medicine",
                        value: result!['medicine']),
                    _ResultRow(
                        icon: Icons.monitor_weight_outlined,
                        label: "Strength",
                        value: result!['strength']),
                    _ResultRow(
                        icon: Icons.category_outlined,
                        label: "Form",
                        value: result!['form']),
                    _ResultRow(
                        icon: Icons.schedule,
                        label: "Frequency",
                        value: result!['frequency']),

                    // Raw OCR text (collapsible)
                    if ((result!['ocr_text'] as String).isNotEmpty) ...[
                      const SizedBox(height: 12),
                      const Divider(),
                      const SizedBox(height: 8),
                      const Text("Raw OCR Text",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54)),
                      const SizedBox(height: 6),
                      Text(
                        result!['ocr_text'],
                        style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black45,
                            height: 1.5),
                      ),
                    ],
                  ],
                ),
              ),
            ],

            const SizedBox(height: 20),

            // ── Disclaimer ───────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.warning_amber_rounded,
                      color: Colors.orange, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "This is a readable representation of the prescription text. "
                      "It does not replace professional medical or pharmacy advice.",
                      style: TextStyle(fontSize: 12, color: Colors.orange),
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

// ── Helper widgets ─────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final Widget child;
  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: child,
    );
  }
}

class _ResultRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ResultRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF7F2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: const Color(0xFF2D7A4A)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black45,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(
                  value.isNotEmpty ? value : "—",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: value.isNotEmpty ? Colors.black87 : Colors.black26,
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