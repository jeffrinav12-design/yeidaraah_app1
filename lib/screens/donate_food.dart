import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class DonateFoodScreen extends StatefulWidget {
  const DonateFoodScreen({super.key});

  @override
  State<DonateFoodScreen> createState() => _DonateFoodScreenState();
}

class _DonateFoodScreenState extends State<DonateFoodScreen> {
  final foodController = TextEditingController();
  final quantityController = TextEditingController();
  File? _image;
  bool _isScanning = false;
  String _freshness = "Scan to Detect";

  Future<void> _scanFood() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return;

    setState(() {
      _image = File(image.path);
      _isScanning = true;
    });

    // SIMULATED AI SCANNING Logic
    await Future.delayed(const Duration(seconds: 3));
    
    setState(() {
      _isScanning = false;
      _freshness = "Freshness: 98% (High Quality)";
    });
  }

  Future<void> _donateFood() async {
    if (_freshness.contains("98%")) {
      await FirebaseFirestore.instance.collection("donations").add({
        "donor": "Hotel Raj", // Hardcoded for demo
        "food": foodController.text,
        "quantity": quantityController.text,
        "freshness": _freshness,
        "status": "pending",
        "timestamp": FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("AI Confirmed! Local NGOs Notified."), backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please scan food freshness first!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hotel Dashboard")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text("AI Freshness Scanner", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _scanFood,
              child: Container(
                height: 200, width: double.infinity,
                decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
                child: _image == null 
                  ? const Icon(Icons.camera_enhance, size: 50, color: Colors.grey)
                  : Image.file(_image!, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 10),
            if (_isScanning) const LinearProgressIndicator(),
            Text(_freshness, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF6B35))),
            const Divider(height: 40),
            TextField(controller: foodController, decoration: const InputDecoration(labelText: "Food Item")),
            TextField(controller: quantityController, decoration: const InputDecoration(labelText: "Weight (KG)")),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _donateFood,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B35), 
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50)
              ),
              child: const Text("LIST FOOD & NOTIFY NGOs"),
            )
          ],
        ),
      ),
    );
  }
}
