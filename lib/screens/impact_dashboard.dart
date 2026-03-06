import 'package:flutter/material.dart';
import '../theme.dart';

class ImpactDashboard extends StatelessWidget {
  const ImpactDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Impact Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Real-time Impact of ANNA',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildImpactCard(
              'Meals Saved',
              '1,245',
              Icons.restaurant,
              AnnaTheme.primaryOrange,
            ),
            const SizedBox(height: 15),
            _buildImpactCard(
              'CO2 Reduced',
              '450 kg',
              Icons.eco,
              AnnaTheme.secondaryGreen,
            ),
            const SizedBox(height: 15),
            _buildImpactCard(
              'People Fed',
              '892',
              Icons.people,
              Colors.blue,
            ),
            const SizedBox(height: 30),
            const Text(
              'Top Donors this Week',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildDonorTile('Hotel Raj', '320 Meals'),
            _buildDonorTile('Sangeetha Restaurant', '210 Meals'),
            _buildDonorTile('SRM University Canteen', '180 Meals'),
          ],
        ),
      ),
    );
  }

  Widget _buildImpactCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color, width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, size: 40, color: color),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(label, style: const TextStyle(fontSize: 16)),
              Text(
                value,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDonorTile(String name, String impact) {
    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.business)),
      title: Text(name),
      trailing: Text(impact, style: const TextStyle(fontWeight: FontWeight.bold, color: AnnaTheme.secondaryGreen)),
    );
  }
}
