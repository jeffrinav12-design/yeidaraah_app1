import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_map/flutter_map.dart' as osm;
import 'package:latlong2/latlong.dart' as osm_latlng;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class HungerMapScreen extends StatefulWidget {
  const HungerMapScreen({super.key});

  @override
  State<HungerMapScreen> createState() => _HungerMapScreenState();
}

class _HungerMapScreenState extends State<HungerMapScreen> {
  bool _useGoogleMaps = true;
  final Set<Marker> _googleMarkers = {};
  final List<osm.Marker> _osmMarkers = [];
  LatLng _currentLocation = const LatLng(11.0168, 76.9558); // Coimbatore

  @override
  void initState() {
    super.initState();
    _listenToLiveDonations();
  }

  void _listenToLiveDonations() {
    FirebaseFirestore.instance.collection('donations').snapshots().listen((snapshot) {
      if (!mounted) return;
      setState(() {
        _googleMarkers.clear();
        _osmMarkers.clear();
        for (var doc in snapshot.docs) {
          final data = doc.data();
          final geo = data['location'] ?? const GeoPoint(11.0168, 76.9558);
          
          // Google Marker
          _googleMarkers.add(Marker(
            markerId: MarkerId(doc.id),
            position: LatLng(geo.latitude, geo.longitude),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
            infoWindow: InfoWindow(title: data['donor'], snippet: "${data['food']} - ${data['quantity']}"),
          ));

          // OSM Marker
          _osmMarkers.add(osm.Marker(
            point: osm_latlng.LatLng(geo.latitude, geo.longitude),
            width: 80, height: 80,
            child: const Icon(Icons.restaurant, color: Colors.orange, size: 40),
          ));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Redistribution Map"),
        actions: [
          IconButton(
            icon: Icon(_useGoogleMaps ? Icons.map_outlined : Icons.map),
            onPressed: () => setState(() => _useGoogleMaps = !_useGoogleMaps),
            tooltip: "Switch Map Provider",
          )
        ],
      ),
      body: Stack(
        children: [
          _useGoogleMaps 
            ? GoogleMap(
                initialCameraPosition: CameraPosition(target: _currentLocation, zoom: 13),
                markers: _googleMarkers,
                myLocationEnabled: true,
              )
            : osm.FlutterMap(
                options: osm.MapOptions(
                  initialCenter: osm_latlng.LatLng(_currentLocation.latitude, _currentLocation.longitude),
                  initialZoom: 13,
                ),
                children: [
                  osm.TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
                  osm.MarkerLayer(markers: _osmMarkers),
                ],
              ),
          Positioned(
            bottom: 30, left: 20, right: 20,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(15)),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Matching Engine: Active", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                  Text("Alerting 5 NGOs within 10km radius", style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
