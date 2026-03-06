import 'package:flutter/material.dart';
import '../theme.dart';

class EventModuleScreen extends StatefulWidget {
  const EventModuleScreen({super.key});

  @override
  State<EventModuleScreen> createState() => _EventModuleScreenState();
}

class _EventModuleScreenState extends State<EventModuleScreen> {
  String _eventType = 'Marriage Hall';
  final TextEditingController _guestCountController = TextEditingController();
  String? _prediction;

  void _calculateSurplus() {
    int guests = int.tryParse(_guestCountController.text) ?? 0;
    double surplusKg;
    
    // Simple logic for hackathon demo: ~20% surplus estimation
    if (_eventType == 'Marriage Hall') {
      surplusKg = guests * 0.15; // 150g per person surplus
    } else if (_eventType == 'Temple Festival') {
      surplusKg = guests * 0.10;
    } else {
      surplusKg = guests * 0.05;
    }

    setState(() {
      _prediction = "Estimated Surplus: ${surplusKg.toStringAsFixed(1)} kg\n"
          "Recommendation: Alert NGOs for pickup at 3:30 PM";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TN Event Surplus Module')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Cultural Event Predictor',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: _eventType,
              decoration: const InputDecoration(labelText: 'Event Type', border: OutlineInputBorder()),
              items: ['Marriage Hall', 'Temple Festival', 'Corporate Event']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => setState(() => _eventType = val!),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _guestCountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Expected Guest Count',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateSurplus,
              child: const Text('ESTIMATE SURPLUS'),
            ),
            if (_prediction != null) ...[
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AnnaTheme.primaryOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AnnaTheme.primaryOrange),
                ),
                child: Text(
                  _prediction!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
