import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String _apiKey = "AIzaSyBrK5Hfhcp6KJzitC5SCgupmZX1WqU86x0";

  static Future<String> extractPrescriptionText(
      Uint8List imageBytes) async {

    final url = Uri.parse(
      "https://generativelanguage.googleapis.com/v1/models/gemini-1.0-pro-vision:generateContent?key=$_apiKey",

    );

    final body = {
      "contents": [
        {
          "parts": [
            {
              "text":
                  "Extract the following fields from the prescription image if clearly visible:\n"
                  "- Medicine name\n"
                  "- Strength\n"
                  "- Dosage form\n"
                  "- Frequency text exactly as written\n\n"
                  "Do NOT explain medical purpose.\n"
                  "Do NOT suggest dosage.\n"
                  "Do NOT provide medical advice.\n"
                  "Return structured plain text."
            },
            {
              "inlineData": {
                "mimeType": "image/jpeg",
                "data": base64Encode(imageBytes)
              }
            }
          ]
        }
      ]
    };

    // ✅ CALL API FIRST
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    // ✅ THEN PRINT DEBUG INFO
    print("STATUS CODE: ${response.statusCode}");
    print("RESPONSE BODY:");
    print(response.body);

    if (response.statusCode != 200) {
      throw Exception(
        "Gemini API failed (${response.statusCode}): ${response.body}",
      );
    }

    final decoded = jsonDecode(response.body);

    return decoded['candidates'][0]['content']['parts'][0]['text'];
  }
}
