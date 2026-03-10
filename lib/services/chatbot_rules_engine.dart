enum IntentType {
  priceComparison,
  priceCheck,
  availability,
  shortage,
  general,
  unknown,
}

class ChatbotRule {
  final IntentType intent;
  final List<String> patterns;
  final String? response;
  final bool requiresMedicineExtraction;

  ChatbotRule({
    required this.intent,
    required this.patterns,
    this.response,
    this.requiresMedicineExtraction = false,
  });

  /// Check if user input matches this rule
  bool matches(String userInput) {
    final lowerInput = userInput.toLowerCase();
    return patterns.any((pattern) => lowerInput.contains(pattern));
  }
}

class ChatbotRulesEngine {
  late final List<ChatbotRule> rules;

  ChatbotRulesEngine() {
    _initializeRules();
  }

  void _initializeRules() {
    rules = [
      // Price Comparison Rules
      ChatbotRule(
        intent: IntentType.priceComparison,
        patterns: [
          'compare',
          'compare prices',
          'which is cheaper',
          'best price',
          'lowest price',
          'cheapest',
        ],
        requiresMedicineExtraction: true,
      ),
      // Price Check Rules
      ChatbotRule(
        intent: IntentType.priceCheck,
        patterns: [
          'price',
          'cost',
          'how much',
          'what is the price',
          'find',
          'check price',
          'medicine cost',
        ],
        requiresMedicineExtraction: true,
      ),
      // Availability Rules
      ChatbotRule(
        intent: IntentType.availability,
        patterns: [
          'available',
          'in stock',
          'do you have',
          'is there',
          'availability',
          'stock status',
        ],
        requiresMedicineExtraction: true,
      ),
      // Shortage Rules
      ChatbotRule(
        intent: IntentType.shortage,
        patterns: [
          'shortage',
          'out of stock',
          'not available',
          'unavailable',
          'shortage report',
          'medicine shortage',
        ],
      ),
      // General Help Rules
      ChatbotRule(
        intent: IntentType.general,
        patterns: [
          'hello',
          'hi',
          'help',
          'what can you do',
          'how can you help',
          'assist',
          'thank you',
          'thanks',
        ],
      ),
    ];
  }

  /// Detect intent from user input
  IntentType detectIntent(String userInput) {
    for (var rule in rules) {
      if (rule.matches(userInput)) {
        return rule.intent;
      }
    }
    return IntentType.unknown;
  }

  /// Get appropriate response based on intent
  String getIntentResponse(IntentType intent, String? medicineName) {
    switch (intent) {
      case IntentType.priceComparison:
        return "Comparing prices for $medicineName...";
      case IntentType.priceCheck:
        return "Checking prices for $medicineName...";
      case IntentType.availability:
        return "Checking availability for $medicineName...";
      case IntentType.shortage:
        return "Checking shortage reports...";
      case IntentType.general:
        return "I'm here to help! You can ask me about medicine prices, availability, or other health-related queries.";
      case IntentType.unknown:
        return "I'm not sure what you're asking. Try asking about medicine prices, availability, or shortages.";
    }
  }

  /// Add new rule dynamically
  void addRule(ChatbotRule rule) {
    rules.add(rule);
  }

  /// Remove rule by intent type
  void removeRule(IntentType intent) {
    rules.removeWhere((rule) => rule.intent == intent);
  }

  /// Update existing rule
  void updateRule(IntentType intent, List<String> newPatterns) {
    final index = rules.indexWhere((rule) => rule.intent == intent);
    if (index != -1) {
      final oldRule = rules[index];
      rules[index] = ChatbotRule(
        intent: oldRule.intent,
        patterns: newPatterns,
        response: oldRule.response,
        requiresMedicineExtraction: oldRule.requiresMedicineExtraction,
      );
    }
  }

  /// Get all patterns for an intent
  List<String> getPatternsForIntent(IntentType intent) {
    final rule = rules.firstWhere(
      (r) => r.intent == intent,
      orElse: () => ChatbotRule(
        intent: IntentType.unknown,
        patterns: [],
      ),
    );
    return rule.patterns;
  }
}

/// Response builder based on intent
class ChatbotResponseBuilder {
  final List<String> medicines = [
    'paracetamol',
    'aspirin',
    'ibuprofen',
    'amoxicillin',
    'metformin',
    'lisinopril',
    'atorvastatin',
    'omeprazole',
    'cetirizine',
    'loratadine',
  ];

  String extractMedicineName(String text) {
    for (var medicine in medicines) {
      if (text.toLowerCase().contains(medicine)) {
        return medicine.replaceFirst(medicine[0], medicine[0].toUpperCase());
      }
    }
    return "";
  }

  String buildPriceResponse(String medicineName) {
    return "🔍 Searching for $medicineName prices across all shops...";
  }

  String buildAvailabilityResponse(String medicineName) {
    return "📋 Checking availability for $medicineName...";
  }

  String buildShortageResponse() {
    return "⚠️ Checking latest shortage reports...";
  }

  String buildGeneralResponse() {
    return "I can help you with:\n"
        "💰 Medicine prices and comparisons\n"
        "📊 Price trends\n"
        "📋 Availability status\n"
        "⚠️ Shortage reports\n\n"
        "Try asking: 'What's the price of Paracetamol?' or 'Compare Aspirin prices'";
  }

  String buildUnknownResponse() {
    return "I didn't quite understand that. Could you rephrase your question?\n\n"
        "Example queries:\n"
        "• 'What is the price of Paracetamol?'\n"
        "• 'Compare Aspirin prices'\n"
        "• 'Is Ibuprofen available?'\n"
        "• 'Show me shortage reports'";
  }
}
