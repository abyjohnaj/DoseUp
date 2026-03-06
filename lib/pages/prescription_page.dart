import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/gemini_service.dart';


// CHANGE 1: StatefulWidget
class PrescriptionPage extends StatefulWidget {
  const PrescriptionPage({super.key});

  @override
  State<PrescriptionPage> createState() => _PrescriptionPageState();
}

class _PrescriptionPageState extends State<PrescriptionPage> {

  // CHANGE 2: Variables at class level
  Uint8List? imageBytes;
  String? geminiOutput;
  bool isLoading = false;

  // CHANGE 3: pickImage() as a class method
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? file =
        await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      final bytes = await file.readAsBytes();
      setState(() {
        imageBytes = bytes;
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
      geminiOutput = null;
    });

    try {
      final result =
          await GeminiService.extractPrescriptionText(imageBytes!);

      setState(() {
        geminiOutput = result;
      });
    } catch (e) {
      print("Gemini error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }

    setState(() {
      isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Prescription Reader"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Upload Prescription",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            // Upload Button
            ElevatedButton(
              onPressed: pickImage,
              child: const Text("Upload Image"),
            ),

            if (imageBytes != null)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  "Image selected ✅",
                  style: TextStyle(color: Colors.green),
                ),
              ),

            const SizedBox(height: 16),

            // Extract Button
            ElevatedButton(
              onPressed: extractPrescription,
              child: const Text("Extract Prescription"),
            ),

            const SizedBox(height: 16),

            if (isLoading) const CircularProgressIndicator(),

            if (geminiOutput != null) ...[
              const SizedBox(height: 16),
              const Text(
                "Prescription Summary",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(geminiOutput!),
            ],

            const SizedBox(height: 24),
            const Divider(),

            const Text(
              "⚠ This is a readable representation of the prescription text. "
              "It does not replace professional medical or pharmacy advice.",
              style: TextStyle(color: Colors.red, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
