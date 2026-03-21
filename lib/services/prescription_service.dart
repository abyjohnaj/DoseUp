import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class PrescriptionService {
  // Change this to your machine's IP if testing on a physical device
  // e.g. "http://192.168.1.10:3000"
  // For web/emulator on same machine, localhost works fine
  static const String _baseUrl = "http://localhost:3000";

  /// Sends the image bytes to the Node backend and returns structured result.
  /// Returns a map with keys: medicine, strength, form, frequency, ocr_text
  static Future<Map<String, dynamic>> extractPrescription(
      Uint8List imageBytes) async {
    final uri = Uri.parse("$_baseUrl/extract-prescription");

    // Build multipart request — backend expects field name "image"
    final request = http.MultipartRequest("POST", uri);
    request.files.add(
      http.MultipartFile.fromBytes(
        "image",
        imageBytes,
        filename: "prescription.jpg",
      ),
    );

    final streamedResponse = await request.send().timeout(
      const Duration(seconds: 60), // OCR + LLM can take time
      onTimeout: () => throw Exception(
          "Request timed out. Make sure the backend is running on port 3000."),
    );

    final responseBody = await streamedResponse.stream.bytesToString();

    if (streamedResponse.statusCode != 200) {
      // Try to parse error message from backend
      try {
        final errorJson = jsonDecode(responseBody);
        throw Exception(errorJson['details'] ?? errorJson['error'] ?? "Backend error");
      } catch (_) {
        throw Exception("Backend returned status ${streamedResponse.statusCode}");
      }
    }

    final data = jsonDecode(responseBody) as Map<String, dynamic>;

    // Normalize — ensure all expected keys exist
    final extracted = data['extracted'] as Map<String, dynamic>? ?? {};
    return {
      'medicine': extracted['medicine'] as String? ?? '',
      'strength': extracted['strength'] as String? ?? '',
      'form': extracted['form'] as String? ?? '',
      'frequency': extracted['frequency'] as String? ?? '',
      'ocr_text': data['ocr_text'] as String? ?? '',
    };
  }
}