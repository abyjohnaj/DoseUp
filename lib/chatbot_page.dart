import 'package:flutter/material.dart';
import 'services/price_comparison_service.dart';
import 'services/chatbot_rules_engine.dart';

class Message {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final PriceComparisonResult? priceData;

  Message({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.priceData,
  });
}

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _messageController = TextEditingController();
  final PriceComparisonService _priceService = PriceComparisonService();
  final ChatbotRulesEngine _rulesEngine = ChatbotRulesEngine();
  final ChatbotResponseBuilder _responseBuilder = ChatbotResponseBuilder();
  final List<Message> _messages = [
    Message(
      text: "How can I assist you?",
      isUser: false,
      timestamp: DateTime.now(),
    ),
  ];
  bool _isLoading = false;

  void _sendMessage() async {
    if (_messageController.text.isEmpty) return;

    final userMessage = _messageController.text;
    _messageController.clear();

    setState(() {
      _messages.add(Message(
        text: userMessage,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isLoading = true;
    });

    // Simulate AI response delay
    await Future.delayed(const Duration(milliseconds: 1500));

    // Use rules engine to detect intent
    final intent = _rulesEngine.detectIntent(userMessage);
    String aiResponse = "";
    PriceComparisonResult? priceData;

    switch (intent) {
      case IntentType.priceComparison:
      case IntentType.priceCheck:
        final medicineName = _responseBuilder.extractMedicineName(userMessage);
        if (medicineName.isEmpty) {
          aiResponse = "Could you please specify which medicine you'd like to check prices for?\n\n"
              "Available medicines: Paracetamol, Aspirin, Ibuprofen, Metformin, and more.";
        } else {
          aiResponse = _responseBuilder.buildPriceResponse(medicineName);
          setState(() {
            _messages.add(Message(
              text: aiResponse,
              isUser: false,
              timestamp: DateTime.now(),
            ));
            _isLoading = true;
          });

          await Future.delayed(const Duration(milliseconds: 1500));

          priceData = _priceService.comparePrices(medicineName);

          if (priceData.found) {
            aiResponse = "✓ Found ${priceData.allPrices.length} options for $medicineName\n\n"
                "💰 Cheapest: ₹${priceData.cheapest!.price.toStringAsFixed(2)} at ${priceData.cheapest!.shopName}\n"
                "📊 Average: ₹${priceData.averagePrice!.toStringAsFixed(2)}\n"
                "⚠️ Most Expensive: ₹${priceData.costliest!.price.toStringAsFixed(2)} at ${priceData.costliest!.shopName}";
          } else {
            aiResponse = "Sorry, I couldn't find price data for \"$medicineName\". Try searching for: Paracetamol, Aspirin, Ibuprofen, or Metformin.";
          }
        }
        break;

      case IntentType.availability:
        final medicineName = _responseBuilder.extractMedicineName(userMessage);
        if (medicineName.isEmpty) {
          aiResponse = "Could you specify which medicine's availability you want to check?";
        } else {
          aiResponse = _responseBuilder.buildAvailabilityResponse(medicineName);
          setState(() {
            _messages.add(Message(
              text: aiResponse,
              isUser: false,
              timestamp: DateTime.now(),
            ));
            _isLoading = true;
          });

          await Future.delayed(const Duration(milliseconds: 1500));

          aiResponse = "✓ $medicineName is currently in stock at most pharmacies.\n\n"
              "📍 Available at:\n"
              "• MediCare Pharmacy\n"
              "• Health Plus\n"
              "• City Pharmacy\n"
              "• Wellness Store";
        }
        break;

      case IntentType.shortage:
        aiResponse = _responseBuilder.buildShortageResponse();
        setState(() {
          _messages.add(Message(
            text: aiResponse,
            isUser: false,
            timestamp: DateTime.now(),
          ));
          _isLoading = true;
        });

        await Future.delayed(const Duration(milliseconds: 1500));

        aiResponse = "⚠️ Shortage Reports:\n\n"
            "No critical shortages reported.\n"
            "All major medicines are in stock.";
        break;

      case IntentType.general:
        aiResponse = _responseBuilder.buildGeneralResponse();
        break;

      case IntentType.unknown:
        aiResponse = _responseBuilder.buildUnknownResponse();
        break;
    }

    setState(() {
      _messages.add(Message(
        text: aiResponse,
        isUser: false,
        timestamp: DateTime.now(),
        priceData: priceData,
      ));
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: const Color(0xFF2D7A4A).withOpacity(0.2),
        leadingWidth: 220,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Row(
            children: [
              Image.asset(
                "assets/images/doseuplogo.png",
                height: 32,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 8),
              const Text(
                "DoseUp",
                style: TextStyle(
                  color: Color(0xFF2D7A4A),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/landing');
            },
            child: const Text(
              "Dashboard",
              style: TextStyle(
                  color: Color(0xFF2D7A4A),
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
            child: const Text(
              "Search",
              style: TextStyle(
                  color: Color(0xFF2D7A4A),
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/shortage');
            },
            child: const Text(
              "Reports",
              style: TextStyle(
                  color: Color(0xFF2D7A4A),
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Row(
        children: [
          // Left Sidebar
          Container(
            width: 250,
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: const Color(0xFF2D7A4A).withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              color: const Color(0xFFF9FFFE),
            ),
            child: Column(
              children: [
                _buildSidebarItem(
                  icon: Icons.dashboard,
                  label: "Dashboard",
                  onTap: () {
                    Navigator.pushNamed(context, '/landing');
                  },
                ),
                _buildSidebarItem(
                  icon: Icons.search,
                  label: "Search",
                  onTap: () {
                    Navigator.pushNamed(context, '/search');
                  },
                ),
                _buildSidebarItem(
                  icon: Icons.warning_amber_rounded,
                  label: "Shortage\nReports",
                  onTap: () {
                    Navigator.pushNamed(context, '/shortage');
                  },
                ),
                _buildSidebarItem(
                  icon: Icons.chat_rounded,
                  label: "AI Assistant",
                  isActive: true,
                  onTap: () {
                    Navigator.pushNamed(context, '/chatbot');
                  },
                ),
              ],
            ),
          ),
          // Main Chat Area
          Expanded(
            child: Column(
              children: [
                // Chat Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(
                        color: const Color(0xFF2D7A4A).withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                  ),
                  child: const Text(
                    "AI Assistant",
                    style: TextStyle(
                      color: Color(0xFF2D7A4A),
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                // Messages Area
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    itemCount: _messages.length + (_isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _messages.length && _isLoading) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2D7A4A)
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation(
                                        const Color(0xFF2D7A4A)
                                            .withOpacity(0.6),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    "AI is typing...",
                                    style: TextStyle(
                                      color: Color(0xFF2D7A4A),
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }

                      final message = _messages[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Align(
                          alignment: message.isUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: message.isUser
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.6,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: message.isUser
                                      ? const Color(0xFF2D7A4A)
                                      : const Color(0xFF2D7A4A).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                  border: message.isUser
                                      ? null
                                      : Border.all(
                                          color: const Color(0xFF2D7A4A)
                                              .withOpacity(0.3),
                                          width: 1.5,
                                        ),
                                ),
                                child: Text(
                                  message.text,
                                  style: TextStyle(
                                    color: message.isUser
                                        ? Colors.white
                                        : const Color(0xFF2D7A4A),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              // Show price comparison table if available
                              if (message.priceData != null &&
                                  message.priceData!.found)
                                Padding(
                                  padding: const EdgeInsets.only(top: 12.0),
                                  child: Container(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.6,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color(0xFF2D7A4A)
                                            .withOpacity(0.3),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      children: [
                                        // Header
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF2D7A4A)
                                                .withOpacity(0.2),
                                            border: Border(
                                              bottom: BorderSide(
                                                color: const Color(0xFF2D7A4A)
                                                    .withOpacity(0.3),
                                                width: 1,
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  "Shop",
                                                  style: const TextStyle(
                                                    color: Color(0xFF2D7A4A),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  "Price",
                                                  style: const TextStyle(
                                                    color: Color(0xFF2D7A4A),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  textAlign: TextAlign.right,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Price rows
                                        ...List.generate(
                                          message.priceData!.allPrices.length,
                                          (i) {
                                            final price =
                                                message.priceData!.allPrices[i];
                                            final isCheapest = price.price ==
                                                message.priceData!.cheapest!
                                                    .price;
                                            return Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 8,
                                              ),
                                              decoration: BoxDecoration(
                                                color: isCheapest
                                                    ? Colors.green.withOpacity(
                                                        0.1)
                                                    : Colors.transparent,
                                                border: Border(
                                                  bottom: i <
                                                          message.priceData!
                                                                  .allPrices
                                                                  .length -
                                                              1
                                                      ? BorderSide(
                                                          color: const Color(
                                                                  0xFF2D7A4A)
                                                              .withOpacity(0.15),
                                                          width: 0.5,
                                                        )
                                                      : BorderSide.none,
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child: Text(
                                                      price.shopName,
                                                      style: TextStyle(
                                                        color:
                                                            const Color(
                                                                0xFF2D7A4A),
                                                        fontSize: 12,
                                                        fontWeight: isCheapest
                                                            ? FontWeight.w700
                                                            : FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      "₹${price.price.toStringAsFixed(2)}",
                                                      style: TextStyle(
                                                        color:
                                                            const Color(
                                                                0xFF2D7A4A),
                                                        fontSize: 12,
                                                        fontWeight: isCheapest
                                                            ? FontWeight.w700
                                                            : FontWeight.w500,
                                                      ),
                                                      textAlign: TextAlign.right,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Message Input Area
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(
                        color: const Color(0xFF2D7A4A).withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: "Type your message...",
                            hintStyle: TextStyle(
                              color: const Color(0xFF2D7A4A)
                                  .withOpacity(0.5),
                              fontSize: 14,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: const Color(0xFF2D7A4A)
                                    .withOpacity(0.3),
                                width: 1.5,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: const Color(0xFF2D7A4A)
                                    .withOpacity(0.3),
                                width: 1.5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFF2D7A4A),
                                width: 2,
                              ),
                            ),
                          ),
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.send),
                        label: const Text("Send"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2D7A4A),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _sendMessage,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFF2D7A4A).withOpacity(0.1)
            : Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFF2D7A4A).withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFF2D7A4A),
                      width: 1.5,
                    ),
                    color: isActive
                        ? const Color(0xFF2D7A4A)
                        : Colors.transparent,
                  ),
                  child: isActive
                      ? const Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.white,
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Color(0xFF2D7A4A),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
