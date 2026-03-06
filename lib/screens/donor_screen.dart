import 'package:flutter/material.dart';
import '../theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class DonorScreen extends StatefulWidget {
  const DonorScreen({super.key});

  @override
  State<DonorScreen> createState() => _DonorScreenState();
}

class _DonorScreenState extends State<DonorScreen> {
  final TextEditingController _menuController = TextEditingController();
  final TextEditingController _bookingsController = TextEditingController();
  bool _isPredicting = false;
  String? _predictionResult;

  // Replace this with your actual Gemini API Key for the live demo
  final String _geminiApiKey = 'YOUR_GEMINI_API_KEY_HERE';

  void _predictSurplus() async {
    if (_menuController.text.isEmpty || _bookingsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter menu and booking details')),
      );
      return;
    }

    setState(() {
      _isPredicting = true;
      _predictionResult = null;
    });

    try {
      if (_geminiApiKey == 'YOUR_GEMINI_API_KEY_HERE') {
        // Fallback for demo if API Key is not set yet
        await Future.delayed(const Duration(seconds: 2));
        setState(() {
          _isPredicting = false;
          _predictionResult = "Predicted Surplus: 35-40 kg of ${_menuController.text} by 9:30 PM";
        });
        return;
      }

      final model = GenerativeModel(model: 'gemini-pro', apiKey: _geminiApiKey);
      final prompt = "Act as an expert food waste analyst for a Tamil Nadu hotel. "
          "Today's Menu: ${_menuController.text}. "
          "Total Bookings/Guests: ${_bookingsController.text}. "
          "Estimate the exact surplus weight in kg that will be left by 9 PM. "
          "Respond in exactly one short sentence like 'Predicted Surplus: X kg of Y by 9:00 PM'";

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      setState(() {
        _isPredicting = false;
        _predictionResult = response.text ?? "Unable to predict. Please try again.";
      });
    } catch (e) {
      setState(() {
        _isPredicting = false;
        _predictionResult = "Error: Could not connect to Gemini AI.";
      });
      debugPrint("Gemini Error: $e");
    }
  }

  void _listFood() async {
    if (_menuController.text.isEmpty || _predictionResult == null) return;

    await FirebaseFirestore.instance.collection('food_listings').add({
      'donor_name': 'Hotel Raj', 
      'food_type': _menuController.text,
      'quantity': _predictionResult,
      'status': 'available',
      'timestamp': FieldValue.serverTimestamp(),
      'predicted': true,
      'location': const GeoPoint(13.0827, 80.2707), // Chennai Default
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('AI-Predicted Surplus listed! NGOs alerted.')),
    );
    
    // Auto-navigate to journey tracker
    Navigator.pushNamed(context, '/food_journey');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Donor - Predict Surplus')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Predictive Surplus Engine',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _menuController,
              decoration: const InputDecoration(
                labelText: 'Today\'s Menu (e.g., Chicken Biryani, Sambar Meals)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.restaurant),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _bookingsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Number of Bookings/Guests',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.people),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _isPredicting ? null : _predictSurplus,
              icon: _isPredicting 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.psychology),
              label: Text(_isPredicting ? 'AI ANALYZING DATA...' : 'AI PREDICT SURPLUS'),
            ),
            if (_predictionResult != null) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AnnaTheme.secondaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AnnaTheme.secondaryGreen),
                ),
                child: Column(
                  children: [
                    const Text(
                      'AI PREDICTION',
                      style: TextStyle(fontWeight: FontWeight.bold, color: AnnaTheme.secondaryGreen),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _predictionResult!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _listFood,
                style: ElevatedButton.styleFrom(backgroundColor: AnnaTheme.secondaryGreen),
                child: const Text('CONFIRM & ALERT NGOs IN ADVANCE'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
