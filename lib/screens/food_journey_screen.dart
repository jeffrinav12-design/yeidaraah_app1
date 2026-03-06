import 'package:flutter/material.dart';
import '../theme.dart';

class FoodJourneyScreen extends StatelessWidget {
  final String foodId;
  const FoodJourneyScreen({super.key, required this.foodId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Food Journey Tracker')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              'Tracking your donation...',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            _buildTimelineStep(
              'Food Prepared/Predicted',
              'Hotel Raj, 6:00 PM',
              Icons.check_circle,
              AnnaTheme.secondaryGreen,
              true,
            ),
            _buildTimelineStep(
              'NGO Accepted',
              'Global Relief NGO, 6:15 PM',
              Icons.check_circle,
              AnnaTheme.secondaryGreen,
              true,
            ),
            _buildTimelineStep(
              'Out for Delivery',
              'NGO Vehicle TN-01-AB-1234',
              Icons.local_shipping,
              AnnaTheme.primaryOrange,
              true,
            ),
            _buildTimelineStep(
              'Delivered & Distributed',
              '67 children at XYZ Orphanage, 8:45 PM',
              Icons.star,
              Colors.grey,
              false,
            ),
            const Spacer(),
            Card(
              color: AnnaTheme.secondaryGreen.withOpacity(0.1),
              child: const Padding(
                padding: EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Icon(Icons.eco, color: AnnaTheme.secondaryGreen),
                    SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        'Your donation prevented 12kg of CO2 emissions from food waste!',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineStep(String title, String subtitle, IconData icon, Color color, bool isDone) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(icon, color: color, size: 30),
            Container(
              width: 2,
              height: 50,
              color: isDone ? AnnaTheme.secondaryGreen : Colors.grey[300],
            ),
          ],
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(subtitle, style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ],
    );
  }
}
