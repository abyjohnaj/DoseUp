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
  Uint8List? _imageBytes;
  Map<String, dynamic>? _result;
  bool _isLoading = false;
  String _loadingStep = "";
  String? _errorMessage;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );
    if (file == null) return;
    final bytes = await file.readAsBytes();
    setState(() {
      _imageBytes = bytes;
      _result = null;
      _errorMessage = null;
    });
    await _processImage(bytes);
  }

  Future<void> _processImage(Uint8List bytes) async {
    setState(() {
      _isLoading = true;
      _loadingStep = "Uploading image...";
      _errorMessage = null;
    });
    try {
      setState(() => _loadingStep = "Reading text with Tesseract OCR...");
      await Future.delayed(const Duration(milliseconds: 300));
      setState(() => _loadingStep = "Analysing with Ollama AI...");
      final result = await PrescriptionService.extractPrescription(bytes);
      if (mounted) {
        setState(() {
          _result = result;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceFirst("Exception: ", "");
          _isLoading = false;
        });
      }
    }
  }

  void _reset() {
    setState(() {
      _imageBytes = null;
      _result = null;
      _errorMessage = null;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("Prescription Reader"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
        actions: [
          if (_result != null || _imageBytes != null)
            TextButton.icon(
              onPressed: _reset,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text("New Scan"),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF2D7A4A),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingView()
          : _result != null
              ? _buildResultView()
              : _buildUploadView(),
    );
  }

  // ── Upload View ──────────────────────────────────────────────────────────────

  Widget _buildUploadView() {
    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF7F2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF2D7A4A).withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.document_scanner_outlined,
                    size: 56,
                    color: Color(0xFF2D7A4A),
                  ),
                ),

                const SizedBox(height: 28),

                const Text(
                  "Read Your Prescription",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Upload a photo of your prescription.\nTesseract reads the text, then AI structures it for you.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black45,
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 32),

                // Upload area
                GestureDetector(
                  onTap: pickImage,
                  child: Container(
                    width: double.infinity,
                    height: 130,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF7F2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF2D7A4A).withOpacity(0.4),
                        width: 1.5,
                      ),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud_upload_outlined,
                          size: 36,
                          color: Color(0xFF2D7A4A),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Click to upload image",
                          style: TextStyle(
                            color: Color(0xFF2D7A4A),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "JPG, PNG supported",
                          style: TextStyle(
                            color: Colors.black38,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // Upload button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: pickImage,
                    icon: const Icon(Icons.upload_file, size: 20),
                    label: const Text(
                      "Upload Prescription",
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2D7A4A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                if (_errorMessage != null) ...[
                  const SizedBox(height: 16),
                  _ErrorBanner(message: _errorMessage!),
                ],

                const SizedBox(height: 20),
                const _Disclaimer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Loading View ─────────────────────────────────────────────────────────────

  Widget _buildLoadingView() {
    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_imageBytes != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.memory(
                      _imageBytes!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                const SizedBox(height: 32),

                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2D7A4A)),
                  strokeWidth: 3,
                ),

                const SizedBox(height: 20),

                Text(
                  _loadingStep,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "This may take 20–40 seconds",
                  style: TextStyle(fontSize: 12, color: Colors.black38),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Result View ──────────────────────────────────────────────────────────────

  Widget _buildResultView() {
    final medicine = _result!['medicine'] as String;
    final strength = _result!['strength'] as String;
    final form = _result!['form'] as String;
    final frequency = _result!['frequency'] as String;
    final ocrText = _result!['ocr_text'] as String;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image thumbnail
              if (_imageBytes != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    _imageBytes!,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

              const SizedBox(height: 16),

              // Prescription card
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF2D7A4A).withOpacity(0.25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      decoration: const BoxDecoration(
                        color: Color(0xFF2D7A4A),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.medication, color: Colors.white, size: 22),
                          SizedBox(width: 10),
                          Text(
                            "Prescription Details",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Fields
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _TypedField(
                            label: "Medicine",
                            value: medicine,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1A1A1A),
                          ),
                          const _DottedDivider(),
                          Row(
                            children: [
                              Expanded(
                                child: _TypedField(
                                  label: "Strength",
                                  value: strength,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF2D7A4A),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _TypedField(
                                  label: "Form",
                                  value: form,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const _DottedDivider(),
                          _TypedField(
                            label: "Frequency / Dosage",
                            value: frequency,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                            icon: Icons.schedule,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              if (ocrText.isNotEmpty) _OcrTextSection(ocrText: ocrText),

              const SizedBox(height: 16),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: pickImage,
                      icon: const Icon(Icons.upload_file, size: 18),
                      label: const Text("Upload New"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF2D7A4A),
                        side: const BorderSide(color: Color(0xFF2D7A4A)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _reset,
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text("Reset"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2D7A4A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              const _Disclaimer(),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Helper Widgets ─────────────────────────────────────────────────────────────

class _TypedField extends StatelessWidget {
  final String label;
  final String value;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final IconData? icon;

  const _TypedField({
    required this.label,
    required this.value,
    required this.fontSize,
    required this.fontWeight,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.black38,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: fontSize * 0.8, color: color),
                const SizedBox(width: 6),
              ],
              Expanded(
                child: Text(
                  value.isNotEmpty ? value : "—",
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: fontWeight,
                    color: value.isNotEmpty ? color : Colors.black26,
                    letterSpacing: 0.3,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DottedDivider extends StatelessWidget {
  const _DottedDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: List.generate(
          50,
          (i) => Expanded(
            child: Container(
              height: 1,
              color: i.isEven ? Colors.black12 : Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }
}

class _OcrTextSection extends StatefulWidget {
  final String ocrText;
  const _OcrTextSection({required this.ocrText});

  @override
  State<_OcrTextSection> createState() => _OcrTextSectionState();
}

class _OcrTextSectionState extends State<_OcrTextSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(
                    Icons.text_snippet_outlined,
                    size: 18,
                    color: Colors.black45,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      "Raw OCR Text",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.black38,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Text(
                widget.ocrText,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black45,
                  height: 1.6,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.red, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _Disclaimer extends StatelessWidget {
  const _Disclaimer();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 16),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              "This is a readable representation of the prescription. "
              "It does not replace professional medical or pharmacy advice.",
              style: TextStyle(fontSize: 11, color: Colors.orange),
            ),
          ),
        ],
      ),
    );
  }
}