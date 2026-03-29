import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/prescription_service.dart';

const _kPrimary = Color(0xFF1A6B45);
const _kPrimaryLight = Color(0xFFE8F5EE);
const _kSurface = Color(0xFFF7FAF8);
const _kCard = Colors.white;
const _kBorder = Color(0xFFDDEDE5);
const _kTextDark = Color(0xFF0F2419);
const _kTextMid = Color(0xFF4A6358);
const _kTextLight = Color(0xFF8BA899);

class PrescriptionPage extends StatefulWidget {
  const PrescriptionPage({super.key});

  @override
  State<PrescriptionPage> createState() => _PrescriptionPageState();
}

class _PrescriptionPageState extends State<PrescriptionPage> {
  Uint8List? _imageBytes;
  Map<String, dynamic>? _result;
  bool _isLoading = false;
  String _loadingStep = '';
  String? _errorMessage;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery, imageQuality: 90);
    if (file == null) return;
    final bytes = await file.readAsBytes();
    setState(() { _imageBytes = bytes; _result = null; _errorMessage = null; });
    await _processImage(bytes);
  }

  Future<void> _processImage(Uint8List bytes) async {
    setState(() { _isLoading = true; _loadingStep = 'Uploading image...'; _errorMessage = null; });
    try {
      setState(() => _loadingStep = 'Reading text with Tesseract OCR...');
      await Future.delayed(const Duration(milliseconds: 300));
      setState(() => _loadingStep = 'Analysing with Ollama AI...');
      final result = await PrescriptionService.extractPrescription(bytes);
      if (mounted) setState(() { _result = result; _isLoading = false; });
    } catch (e) {
      if (mounted) setState(() { _errorMessage = e.toString().replaceFirst('Exception: ', ''); _isLoading = false; });
    }
  }

  void _reset() {
    setState(() { _imageBytes = null; _result = null; _errorMessage = null; _isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kSurface,
      body: Row(
        children: [
          _Sidebar(activeRoute: '/prescription'),
          Expanded(
            child: Column(
              children: [
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: const BoxDecoration(
                    color: _kCard,
                    border: Border(bottom: BorderSide(color: _kBorder)),
                  ),
                  child: Row(
                    children: [
                      const Text('Prescription Reader',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _kTextDark)),
                      const Spacer(),
                      if (_result != null || _imageBytes != null)
                        TextButton.icon(
                          onPressed: _reset,
                          icon: const Icon(Icons.refresh_rounded, size: 16),
                          label: const Text('New Scan'),
                          style: TextButton.styleFrom(foregroundColor: _kPrimary),
                        ),
                      Container(
                        width: 36, height: 36,
                        decoration: const BoxDecoration(color: _kPrimaryLight, shape: BoxShape.circle),
                        child: const Icon(Icons.person_outline_rounded, size: 20, color: _kPrimary),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _isLoading
                      ? _buildLoadingView()
                      : _result != null
                          ? _buildResultView()
                          : _buildUploadView(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadView() {
    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
            child: Column(
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: _kPrimaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.document_scanner_outlined, size: 48, color: _kPrimary),
                ),
                const SizedBox(height: 24),
                const Text('Read Your Prescription',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: _kTextDark, letterSpacing: -0.3)),
                const SizedBox(height: 8),
                const Text(
                  'Upload a photo of your prescription.\nTesseract reads the text, then AI structures it for you.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: _kTextMid, height: 1.6),
                ),
                const SizedBox(height: 32),
                GestureDetector(
                  onTap: pickImage,
                  child: Container(
                    width: double.infinity,
                    height: 140,
                    decoration: BoxDecoration(
                      color: _kPrimaryLight,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFF86BFAB), width: 1.5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.cloud_upload_outlined, size: 32, color: _kPrimary),
                        SizedBox(height: 8),
                        Text('Click to upload image',
                            style: TextStyle(color: _kPrimary, fontWeight: FontWeight.w600, fontSize: 14)),
                        SizedBox(height: 4),
                        Text('JPG, PNG supported',
                            style: TextStyle(color: _kTextLight, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: pickImage,
                    icon: const Icon(Icons.upload_file_rounded, size: 18),
                    label: const Text('Upload Prescription', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _kPrimary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

  Widget _buildLoadingView() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_imageBytes != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.memory(_imageBytes!, height: 200, width: double.infinity, fit: BoxFit.cover),
                ),
              const SizedBox(height: 32),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(_kPrimary), strokeWidth: 3),
              const SizedBox(height: 20),
              Text(_loadingStep,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: _kTextMid)),
              const SizedBox(height: 6),
              const Text('This may take 20–40 seconds',
                  style: TextStyle(fontSize: 12, color: _kTextLight)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultView() {
    final medicine = _result!['medicine'] as String;
    final strength = _result!['strength'] as String;
    final form = _result!['form'] as String;
    final frequency = _result!['frequency'] as String;
    final ocrText = _result!['ocr_text'] as String;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_imageBytes != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.memory(_imageBytes!, height: 180, width: double.infinity, fit: BoxFit.cover),
                ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: _kCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _kBorder),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 3))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      decoration: const BoxDecoration(
                        color: _kPrimary,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.medication_rounded, color: Colors.white, size: 20),
                          SizedBox(width: 10),
                          Text('Prescription Details',
                              style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _TypedField(label: 'Medicine', value: medicine, fontSize: 22, fontWeight: FontWeight.w800, color: _kTextDark),
                          const _DottedDivider(),
                          Row(children: [
                            Expanded(child: _TypedField(label: 'Strength', value: strength, fontSize: 18, fontWeight: FontWeight.w700, color: _kPrimary)),
                            const SizedBox(width: 16),
                            Expanded(child: _TypedField(label: 'Form', value: form, fontSize: 18, fontWeight: FontWeight.w700, color: _kTextDark)),
                          ]),
                          const _DottedDivider(),
                          _TypedField(label: 'Frequency / Dosage', value: frequency, fontSize: 18, fontWeight: FontWeight.w700, color: _kTextDark, icon: Icons.schedule_rounded),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (ocrText.isNotEmpty) _OcrTextSection(ocrText: ocrText),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: pickImage,
                      icon: const Icon(Icons.upload_file_rounded, size: 16),
                      label: const Text('Upload New'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _kPrimary,
                        side: const BorderSide(color: _kPrimary),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _reset,
                      icon: const Icon(Icons.refresh_rounded, size: 16),
                      label: const Text('Reset'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _kPrimary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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

// ── Helpers ──────────────────────────────────────────────────────────────────

class _TypedField extends StatelessWidget {
  final String label, value;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final IconData? icon;

  const _TypedField({required this.label, required this.value, required this.fontSize, required this.fontWeight, required this.color, this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label.toUpperCase(),
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: _kTextLight, letterSpacing: 1.2)),
        const SizedBox(height: 4),
        Row(children: [
          if (icon != null) ...[Icon(icon, size: fontSize * 0.8, color: color), const SizedBox(width: 6)],
          Expanded(child: Text(value.isNotEmpty ? value : '—',
              style: TextStyle(fontSize: fontSize, fontWeight: fontWeight,
                  color: value.isNotEmpty ? color : _kTextLight, height: 1.2))),
        ]),
      ]),
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
        children: List.generate(50, (i) => Expanded(
          child: Container(height: 1, color: i.isEven ? _kBorder : Colors.transparent),
        )),
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
        color: _kCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _kBorder),
      ),
      child: Column(children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(children: [
              const Icon(Icons.text_snippet_outlined, size: 16, color: _kTextLight),
              const SizedBox(width: 8),
              const Expanded(child: Text('Raw OCR Text',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: _kTextMid))),
              Icon(_expanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded, color: _kTextLight),
            ]),
          ),
        ),
        if (_expanded)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: Text(widget.ocrText,
                style: const TextStyle(fontSize: 12, color: _kTextMid, height: 1.6)),
          ),
      ]),
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
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFECACA)),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Icon(Icons.error_outline_rounded, color: Color(0xFFDC2626), size: 16),
        const SizedBox(width: 8),
        Expanded(child: Text(message, style: const TextStyle(color: Color(0xFFDC2626), fontSize: 13))),
      ]),
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
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(Icons.warning_amber_rounded, color: Color(0xFFD97706), size: 15),
        SizedBox(width: 8),
        Expanded(child: Text(
          'This is a readable representation of the prescription. '
          'It does not replace professional medical or pharmacy advice.',
          style: TextStyle(fontSize: 11, color: Color(0xFFD97706)),
        )),
      ]),
    );
  }
}

// ── Sidebar & NavItem ───────────────────────────────────────────────────────

class _Sidebar extends StatelessWidget {
  final String activeRoute;
  const _Sidebar({required this.activeRoute});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220, color: _kCard,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          child: Row(children: [
            Container(width: 34, height: 34,
                decoration: BoxDecoration(color: _kPrimary, borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.local_pharmacy, color: Colors.white, size: 20)),
            const SizedBox(width: 10),
            const Text('DoseUp',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: _kPrimary, letterSpacing: -0.3)),
          ]),
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
      ]),
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
          child: Row(children: [
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
          ]),
        ),
      ),
    );
  }
}