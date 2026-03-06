import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme.dart';

class HungerMapScreen extends StatefulWidget {
  const HungerMapScreen({super.key});

  @override
  State<HungerMapScreen> createState() => _HungerMapScreenState();
}

class _HungerMapScreenState extends State<HungerMapScreen> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadHungerSpots();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = position;
    });

    _mapController?.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(position.latitude, position.longitude),
      ),
    );
  }

  void _loadHungerSpots() {
    FirebaseFirestore.instance.collection('hunger_spots').snapshots().listen((snapshot) {
      setState(() {
        _markers.clear();
        for (var doc in snapshot.docs) {
          final data = doc.data();
          final GeoPoint geoPoint = data['location'];
          _markers.add(
            Marker(
              markerId: MarkerId(doc.id),
              position: LatLng(geoPoint.latitude, geoPoint.longitude),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
              infoWindow: InfoWindow(title: 'Hunger Spot', snippet: 'Intensity: ${data['intensity']}'),
            ),
          );
        }
      });
    });
  }

  void _reportHunger() async {
    if (_currentPosition == null) return;

    await FirebaseFirestore.instance.collection('hunger_spots').add({
      'location': GeoPoint(_currentPosition!.latitude, _currentPosition!.longitude),
      'intensity': 5,
      'timestamp': FieldValue.serverTimestamp(),
      'resolved': false,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Hunger spot reported. Help is on the way!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Hunger Heatmap')),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(13.0827, 80.2707), // Chennai Default
              zoom: 12,
            ),
            onMapCreated: (controller) => _mapController = controller,
            markers: _markers,
            myLocationEnabled: true,
          ),
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: _reportHunger,
              style: ElevatedButton.styleFrom(
                backgroundColor: AnnaTheme.urgentRed,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text(
                'I AM HUNGRY (MARK LOCATION)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
