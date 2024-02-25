import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ProductLocation extends StatefulWidget {
  const ProductLocation({Key? key}) : super(key: key);

  @override
  State<ProductLocation> createState() => _ProductLocationState();
}

class _ProductLocationState extends State<ProductLocation> {
  late GoogleMapController? mapController; // Change to nullable type

  final LatLng _center = const LatLng(-23.5557714, -46.6395571);

  @override
  void initState() {
    super.initState();
    // Initialize mapController here
    // This ensures it's initialized before it's accessed
    // within the GoogleMap widget
    mapController = null;
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Find Nearby NetXus System"),
        backgroundColor: Colors.green[700],
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
      ),
    );
  }
}
