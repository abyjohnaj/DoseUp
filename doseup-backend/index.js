import express from "express";
import cors from "cors";
import multer from "multer";
import fetch from "node-fetch";
import Tesseract from "tesseract.js";

// ── Helper: extract valid JSON from LLM output ─────────────────────────────
function extractJson(text) {
  const clean = text
    .replace(/```json/g, "")
    .replace(/```/g, "")
    .trim();

  const match = clean.match(/\{[\s\S]*\}/);
  if (!match) {
    return { medicine: "", strength: "", form: "", frequency: "" };
  }
  try {
    return JSON.parse(match[0]);
  } catch {
    return { medicine: "", strength: "", form: "", frequency: "" };
  }
}

const app = express();
const upload = multer();
app.use(cors());

// ── MAIN ENDPOINT ──────────────────────────────────────────────────────────
app.post("/extract-prescription", upload.single("image"), async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ error: "No image uploaded" });
    }

    /* =====================================================
       1️⃣  OCR via Tesseract.js
       ===================================================== */
    console.log("Running Tesseract OCR...");

    const { data } = await Tesseract.recognize(
      req.file.buffer,
      "eng",
      {
        logger: m => {
          if (m.status === "recognizing text") {
            process.stdout.write(
              `\r  OCR progress: ${Math.round(m.progress * 100)}%`
            );
          }
        },
        // These parameters improve accuracy for medical text
        tessedit_char_whitelist:
          "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789.,/-() ",
        preserve_interword_spaces: "1",
      }
    );

    process.stdout.write("\n");
    const rawText = data.text.replace(/\s+/g, " ").trim();
    console.log("OCR result:", rawText.substring(0, 150));

    // Guard: blank or unreadable image
    if (!rawText || rawText.length < 10) {
      return res.json({
        success: true,
        ocr_text: rawText,
        extracted: { medicine: "", strength: "", form: "", frequency: "" }
      });
    }

    /* =====================================================
       2️⃣  Ollama prompt
       ===================================================== */
    const prompt = `
You are a strict JSON generator for medical prescriptions.

Rules (MUST FOLLOW):
- Output ONLY valid JSON, nothing else
- Do NOT use markdown or code fences
- Do NOT explain anything
- Do NOT return arrays
- If a field is unclear or missing, use an empty string ""

Return EXACTLY this structure:
{
  "medicine": "",
  "strength": "",
  "form": "",
  "frequency": ""
}

Where:
- medicine = drug/medicine name
- strength = dosage amount e.g. "500mg", "10mg"
- form = tablet / capsule / syrup / injection / cream etc
- frequency = how often to take e.g. "twice daily", "1-0-1", "8 hourly"

Prescription OCR text:
${rawText}
`;

    /* =====================================================
       3️⃣  Call Ollama (Mistral)
       ===================================================== */
    console.log("Calling Ollama/Mistral...");

    const ollamaResp = await fetch("http://localhost:11434/api/generate", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        model: "mistral",
        prompt,
        stream: false
      })
    });

    if (!ollamaResp.ok) {
      throw new Error(
        `Ollama returned HTTP ${ollamaResp.status}. Is Ollama running?`
      );
    }

    const ollamaData = await ollamaResp.json();

    if (!ollamaData?.response) {
      return res.status(500).json({
        error: "Extraction failed",
        details: "Ollama returned an empty response"
      });
    }

    console.log("Ollama response:", ollamaData.response.substring(0, 200));

    /* =====================================================
       4️⃣  Parse and return
       ===================================================== */
    const extractedJson = extractJson(ollamaData.response);

    res.json({
      success: true,
      ocr_text: rawText,
      extracted: extractedJson
    });

  } catch (err) {
    console.error("\nBACKEND ERROR:", err.message);
    res.status(500).json({
      error: "Extraction failed",
      details: err.message
    });
  }
});

app.listen(3000, () => {
  console.log("✅ DoseUp backend running  → http://localhost:3000");
  console.log("   Ollama expected on      → http://localhost:11434");
});