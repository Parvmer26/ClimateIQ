import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class PermissionPage extends StatelessWidget {
  final VoidCallback onPermissionGranted;

  const PermissionPage({super.key, required this.onPermissionGranted});

  Future<void> _requestPermission(BuildContext context) async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      onPermissionGranted(); // Callback to go back
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Permission is still not granted")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.location_off, size: 80, color: Colors.red),
              const SizedBox(height: 20),
              const Text(
                "Location Permission Required",
                style: TextStyle(fontSize: 24, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                "Please allow location access to fetch weather data.",
                style: TextStyle(fontSize: 16, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => _requestPermission(context),
                child: const Text("Grant Permission"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
