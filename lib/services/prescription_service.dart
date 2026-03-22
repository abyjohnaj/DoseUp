import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class PrescriptionService {
  // Backend runs on your machine
  // For local web dev this works fine as both run on same machine
  static const String _baseUrl = "http://localhost:3000";

  /// Sends image bytes to Node backend.
  /// Tesseract.js does OCR, Ollama structures the result.
  static Future<Map<String, dynamic>> extractPrescription(
      Uint8List imageBytes) async {
    final uri = Uri.parse("$_baseUrl/extract-prescription");

    // Multipart request — backend expects field name "image"
    final request = http.MultipartRequest("POST", uri);
    request.files.add(
      http.MultipartFile.fromBytes(
        "image",
        imageBytes,
        filename: "prescription.jpg",
      ),
    );

    final streamed = await request.send().timeout(
      const Duration(seconds: 120), // Tesseract + Ollama can take time
      onTimeout: () => throw Exception(
          "Timed out. Make sure the backend is running on port 3000."),
    );

    final body = await streamed.stream.bytesToString();

    if (streamed.statusCode != 200) {
      try {
        final err = jsonDecode(body);
        throw Exception(err['details'] ?? err['error'] ?? "Backend error");
      } catch (_) {
        throw Exception("Backend returned status ${streamed.statusCode}");
      }
    }

    final data = jsonDecode(body) as Map<String, dynamic>;
    final extracted = (data['extracted'] as Map<String, dynamic>?) ?? {};

    return {
      'medicine': extracted['medicine'] as String? ?? '',
      'strength': extracted['strength'] as String? ?? '',
      'form': extracted['form'] as String? ?? '',
      'frequency': extracted['frequency'] as String? ?? '',
      'ocr_text': data['ocr_text'] as String? ?? '',
    };
  }
}