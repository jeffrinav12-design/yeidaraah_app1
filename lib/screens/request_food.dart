import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RequestFoodScreen extends StatefulWidget {
  const RequestFoodScreen({super.key});

  @override
  State<RequestFoodScreen> createState() => _RequestFoodScreenState();
}

class _RequestFoodScreenState extends State<RequestFoodScreen> {
  final TextEditingController _claimAmountController = TextEditingController();

  void _showClaimDialog(BuildContext context, String docId, double remainingQty, String foodName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Claim $foodName"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Available: ${remainingQty.toStringAsFixed(1)} kg"),
            const SizedBox(height: 10),
            TextField(
              controller: _claimAmountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "How much do you need? (kg)",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL")),
          ElevatedButton(
            onPressed: () => _processClaim(context, docId, remainingQty),
            child: const Text("CONFIRM CLAIM"),
          ),
        ],
      ),
    );
  }

  void _processClaim(BuildContext context, String docId, double available) async {
    double requested = double.tryParse(_claimAmountController.text) ?? 0;
    
    if (requested <= 0 || requested > available) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid quantity requested")),
      );
      return;
    }

    // Atomic update to prevent race conditions (if 5 NGOs click at once)
    final docRef = FirebaseFirestore.instance.collection("donations").doc(docId);
    
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(docRef);
      double currentQty = double.parse(snapshot.get('quantity').toString().split(' ')[0]);
      
      if (currentQty >= requested) {
        transaction.update(docRef, {
          'quantity': "${(currentQty - requested).toStringAsFixed(1)} kg",
          'status': (currentQty - requested) <= 0 ? 'fully_claimed' : 'available',
          'claims': FieldValue.arrayUnion([{
            'ngo_name': 'Akshaya Trust', // Hardcoded for demo
            'amount': requested,
            'time': DateTime.now().toString(),
          }])
        });
      }
    });

    Navigator.pop(context);
    _claimAmountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("NGO Matching Portal")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("donations")
            .where('status', isEqualTo: 'available')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              double qty = double.parse(data['quantity'].toString().split(' ')[0]);

              return Card(
                margin: const EdgeInsets.all(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(data['food'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(color: Colors.green[100], borderRadius: BorderRadius.circular(8)),
                            child: Text("${data['quantity']} Left", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text("Donor: ${data['donor']}"),
                      Text("Freshness: ${data['freshness']}"),
                      const Divider(),
                      Row(
                        children: [
                          const Icon(Icons.people, size: 16, color: Colors.grey),
                          const SizedBox(width: 5),
                          const Text("Demand: High (40 children waiting)", style: TextStyle(color: Colors.red, fontSize: 12)),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () => _showClaimDialog(context, docs[index].id, qty, data['food']),
                            child: const Text("CLAIM PORTION"),
                          ),
                        ],
                      )
                    ],
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
