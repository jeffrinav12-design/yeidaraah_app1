import 'package:flutter/material.dart';
import 'dart:async';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [
    {
      "role": "bot",
      "text": "Vanakkam! I am ShareBite AI, your dedicated assistant for YEIDARAAH. How can I help you save food today?"
    },
  ];

  void _handleMessage(String text) {
    if (text.isEmpty) return;

    setState(() {
      _messages.add({"role": "user", "text": text});
    });
    _controller.clear();

    // AI Response Logic based on keywords
    String botReply = "";
    String lowerText = text.toLowerCase();

    if (lowerText.contains("hotel") || lowerText.contains("restaurant")) {
      botReply = "Hotels can use our AI scanner to detect food freshness. Once verified, the surplus is automatically matched with the nearest NGO within a 10km radius.";
    } else if (lowerText.contains("ngo") || lowerText.contains("charity")) {
      botReply = "NGOs receive real-time alerts for nearby donations. You can claim specific quantities (KG) needed for your children or community.";
    } else if (lowerText.contains("delivery") || lowerText.contains("driver")) {
      botReply = "Delivery partners bridge the gap. They receive tasks once an NGO claims food, use Google Maps for routing, and use a secure 4-digit OTP for pickup verification.";
    } else if (lowerText.contains("hungry") || lowerText.contains("food")) {
      botReply = "If you are hungry, use the 'I AM HUNGRY' button on the Live Map. This marks your location instantly for all nearby NGOs and donors.";
    } else {
      botReply = "I am ShareBite AI. I can help you with information about our Hotel, NGO, and Delivery portals. Ask me anything!";
    }

    Timer(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _messages.add({"role": "bot", "text": botReply});
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ShareBite AI Assistant"),
        backgroundColor: const Color(0xFFFF6B35),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, i) {
                bool isBot = _messages[i]['role'] == 'bot';
                return Align(
                  alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isBot ? const Color(0xFF1A1A2E) : const Color(0xFF1ABC9C),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      _messages[i]['text']!,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Ask ShareBite AI...",
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                    onSubmitted: _handleMessage,
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: const Color(0xFFFF6B35),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () => _handleMessage(_controller.text),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
