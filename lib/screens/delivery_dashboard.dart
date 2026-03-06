import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class DeliveryDashboard extends StatefulWidget {
  const DeliveryDashboard({super.key});

  @override
  State<DeliveryDashboard> createState() => _DeliveryDashboardState();
}

class _DeliveryDashboardState extends State<DeliveryDashboard> {
  // Mock Driver Details (In a real app, these would come from Auth)
  final Map<String, String> driverInfo = {
    "name": "Murugan",
    "phone": "+91 9876543210",
    "vehicle": "TN-37-BY-1234 (Electric Bike)",
  };

  Future<void> _launchMaps(String destination) async {
    final Uri url = Uri.parse("https://www.google.com/maps/dir/?api=1&destination=$destination");
    if (!await launchUrl(url)) throw 'Could not launch maps';
  }

  void _acceptTask(String docId) async {
    await FirebaseFirestore.instance.collection("donations").doc(docId).update({
      'status': 'out_for_pickup',
      'driver_name': driverInfo['name'],
      'driver_phone': driverInfo['phone'],
      'driver_vehicle': driverInfo['vehicle'],
      'otp': '4829', // Dynamic OTP simulation
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Task Accepted! Navigate to Hotel."), backgroundColor: Colors.blue),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Delivery Hero Portal")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("donations")
            .where('status', whereIn: ['claimed', 'out_for_pickup'])
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final tasks = snapshot.data!.docs;

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final data = tasks[index].data() as Map<String, dynamic>;
              bool isMyTask = data['status'] == 'out_for_pickup';

              return Card(
                margin: const EdgeInsets.all(12),
                color: isMyTask ? Colors.blue[50] : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.local_shipping, color: isMyTask ? Colors.blue : Colors.grey),
                          const SizedBox(width: 10),
                          Text("Task ID: ${tasks[index].id.substring(0, 5)}", style: const TextStyle(fontWeight: FontWeight.bold)),
                          const Spacer(),
                          Text(data['status'].toUpperCase(), style: TextStyle(color: isMyTask ? Colors.blue : Colors.orange, fontSize: 10, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const Divider(),
                      Text("From: ${data['donor']}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      Text("To: ${data['ngo_name'] ?? 'Multiple NGOs'}", style: const TextStyle(color: Colors.grey)),
                      if (isMyTask) ...[
                        const SizedBox(height: 15),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(8)),
                          child: const Row(
                            children: [
                              Icon(Icons.vpn_key, color: Colors.white, size: 16),
                              SizedBox(width: 10),
                              Text("Verification OTP: 4829", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          if (!isMyTask)
                            Expanded(child: ElevatedButton(onPressed: () => _acceptTask(tasks[index].id), child: const Text("ACCEPT TASK"))),
                          if (isMyTask) ...[
                            Expanded(child: OutlinedButton.icon(onPressed: () => _launchMaps(data['donor']), icon: const Icon(Icons.navigation), label: const Text("HOTEL"))),
                            const SizedBox(width: 10),
                            Expanded(child: ElevatedButton(
                              onPressed: () => FirebaseFirestore.instance.collection('donations').doc(tasks[index].id).update({'status': 'delivered'}),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                              child: const Text("DELIVERED"),
                            )),
                          ]
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
