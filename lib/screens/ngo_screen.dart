import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme.dart';

class NgoScreen extends StatelessWidget {
  const NgoScreen({super.key});

  void _acceptFood(BuildContext context, String docId, String donorName) async {
    await FirebaseFirestore.instance.collection('food_listings').doc(docId).update({
      'status': 'matched',
      'ngo_name': 'Global Relief NGO', // Hardcoded for demo
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Accepted food from $donorName. Navigating...')),
    );
    
    // Navigate to journey tracker or map
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NGO - Available Food')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('food_listings')
            .where('status', isEqualTo: 'available')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text('Error loading data'));
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(
              child: Text('No food listings available right now.'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final bool isPredicted = data['predicted'] ?? false;

              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(15),
                  leading: CircleAvatar(
                    backgroundColor: isPredicted ? AnnaTheme.primaryOrange : AnnaTheme.secondaryGreen,
                    child: Icon(isPredicted ? Icons.timer : Icons.restaurant, color: Colors.white),
                  ),
                  title: Text(
                    data['food_type'] ?? 'Unknown Food',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Donor: ${data['donor_name']}'),
                      Text('Qty: ${data['quantity']}'),
                      if (isPredicted)
                        const Text(
                          'PREDICTED SURPLUS - READY IN 2 HOURS',
                          style: TextStyle(color: AnnaTheme.primaryOrange, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                    ],
                  ),
                  trailing: ElevatedButton(
                    onPressed: () => _acceptFood(context, docs[index].id, data['donor_name']),
                    style: ElevatedButton.styleFrom(backgroundColor: AnnaTheme.secondaryGreen),
                    child: const Text('ACCEPT'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
