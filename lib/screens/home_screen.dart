import 'package:flutter/material.dart';
import '../theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ANNA - AI Food Rescue'),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics),
            tooltip: 'Impact Dashboard',
            onPressed: () => Navigator.pushNamed(context, '/impact'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Operating System for Zero Waste',
              style: TextStyle(fontSize: 18, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25),
            _RoleCard(
              title: 'Donor / Hotel',
              subtitle: 'Predict & List Surplus',
              icon: Icons.restaurant_menu,
              color: AnnaTheme.primaryOrange,
              onTap: () => Navigator.pushNamed(context, '/donor'),
            ),
            const SizedBox(height: 15),
            _RoleCard(
              title: 'Marriage/Event Hall',
              subtitle: 'TN Cultural Event Predictor',
              icon: Icons.temple_hindu,
              color: Colors.brown,
              onTap: () => Navigator.pushNamed(context, '/event_module'),
            ),
            const SizedBox(height: 15),
            _RoleCard(
              title: 'NGO / Volunteer',
              subtitle: 'Accept & Pick Up Food',
              icon: Icons.local_shipping,
              color: AnnaTheme.secondaryGreen,
              onTap: () => Navigator.pushNamed(context, '/ngo'),
            ),
            const SizedBox(height: 15),
            _RoleCard(
              title: 'I AM HUNGRY',
              subtitle: 'Crowdsource Hunger Spot',
              icon: Icons.location_on,
              color: AnnaTheme.urgentRed,
              onTap: () => Navigator.pushNamed(context, '/hunger_map'),
            ),
            const SizedBox(height: 30),
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'PROJECT ANNA by Team Manna Hackers',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: Row(
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    Text(subtitle, style: const TextStyle(fontSize: 14, color: Colors.blueGrey)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
