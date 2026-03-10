// CHATBOT RULES ENGINE - TRAINING GUIDE
// =====================================

/*
The chatbot now uses a rule-based system that makes it easy to train and customize responses.

INTENT CATEGORIES:
==================
1. priceComparison - For comparing prices between shops
2. priceCheck      - For general price queries
3. availability    - For checking if medicine is in stock
4. shortage        - For shortage reports
5. general         - For general help and greetings
6. unknown         - For unrecognized queries

HOW TO ADD NEW PATTERNS:
========================

Example 1: Add new price-related patterns
------------------------------------------
_rulesEngine.updateRule(
  IntentType.priceCheck,
  [
    'price',
    'cost',
    'how much',
    'what is the price',
    'find',
    'check price',
    'medicine cost',
    'rate',           // NEW
    'fee',            // NEW
    'charges',        // NEW
  ],
);

Example 2: Add a completely new rule for pharmacy locations
-----------------------------------------------------------
_rulesEngine.addRule(ChatbotRule(
  intent: IntentType.general,  // or create new enum value
  patterns: [
    'location',
    'where',
    'pharmacy near me',
    'nearby pharmacy',
    'address',
  ],
  requiresMedicineExtraction: false,
));

CUSTOM RESPONSE EXAMPLES:
=========================

For price queries:
------------------
String buildPriceResponse(String medicineName) {
  return "🔍 Finding the best prices for $medicineName...";
}

For availability:
-----------------
String buildAvailabilityResponse(String medicineName) {
  return "📋 Checking stock status for $medicineName...";
}

For general help:
-----------------
String buildGeneralResponse() {
  return "I can help you with:\n"
      "💰 Medicine prices\n"
      "📊 Price comparisons\n"
      "📍 Store locations\n";
}

USAGE IN CODE:
==============

In chatbot_page.dart:

void _sendMessage() async {
  final intent = _rulesEngine.detectIntent(userMessage);
  
  switch(intent) {
    case IntentType.priceCheck:
      // Your custom handling
      break;
    case IntentType.availability:
      // Your custom handling
      break;
    // ... other cases
  }
}

KEY METHODS:
============

1. detectIntent(String userInput) -> IntentType
   Determines what the user is asking about

2. addRule(ChatbotRule rule)
   Add a new pattern rule dynamically

3. removeRule(IntentType intent)
   Remove all patterns for an intent

4. updateRule(IntentType intent, List<String> newPatterns)
   Update patterns for an intent

5. getPatternsForIntent(IntentType intent) -> List<String>
   Get all patterns for a specific intent

EXAMPLE: DYNAMIC RULE MANAGEMENT
=================================

// Add new pattern at runtime
_rulesEngine.addRule(ChatbotRule(
  intent: IntentType.priceCheck,
  patterns: ['bulk order', 'wholesale', 'discount'],
  requiresMedicineExtraction: true,
));

// Get current patterns
List<String> patterns = _rulesEngine.getPatternsForIntent(IntentType.priceCheck);
print(patterns); // Shows all patterns

// Update patterns
_rulesEngine.updateRule(
  IntentType.availability,
  ['stock', 'available', 'in stock', 'warehouse check'],
);

BEST PRACTICES:
===============

1. Keep patterns simple and lowercase
2. Use common keywords and synonyms
3. Avoid ambiguous patterns that match multiple intents
4. Test new patterns thoroughly
5. Group related patterns in one rule
6. Use requiresMedicineExtraction = true when medicine name is needed

TESTING PATTERNS:
=================

To test if a pattern works:

final rulesEngine = ChatbotRulesEngine();
final intent = rulesEngine.detectIntent("What's the price of Aspirin?");
print(intent); // Should print: IntentType.priceCheck

// Test multiple inputs
final testInputs = [
  "Compare prices for Paracetamol",
  "Is Ibuprofen available?",
  "Show me shortage reports",
  "Hello, how can you help?",
];

for (var input in testInputs) {
  final detected = rulesEngine.detectIntent(input);
  print("'$input' -> $detected");
}
*/
