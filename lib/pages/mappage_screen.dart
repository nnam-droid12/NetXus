import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductLocation extends StatefulWidget {
  const ProductLocation({Key? key}) : super(key: key);

  @override
  State<ProductLocation> createState() => _ProductLocationState();
}

class _ProductLocationState extends State<ProductLocation> {
  late GoogleMapController? mapController;
  static const LatLng _center = LatLng(6.5244, 3.3792);
  static const LatLng _pMicrosoftPark = LatLng(6.4548, 3.4316);
  List<Marker> markers = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Find Nearby NetXus System"),
        backgroundColor: Colors.green[700],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 13.0,
        ),
        markers: {
          Marker(
              markerId: MarkerId("_currentLocation"),
              icon: BitmapDescriptor.defaultMarker,
              position: _center),
          Marker(
            markerId: MarkerId("_sourceLocation"),
            icon: BitmapDescriptor.defaultMarker,
            position: _pMicrosoftPark,
          )
        },
      ),
    );
  }
}
