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
  final LatLng _center = const LatLng(-23.5557714, -46.6395571);
  List<Marker> markers = [];

  @override
  void initState() {
    super.initState();
    // Initial marker for the center
    markers.add(Marker(markerId: MarkerId("center"), position: _center));
    // Fetch places from the Places API
    fetchPlaces();
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

  void fetchPlaces() async {
    // Replace with your actual API key
    const apiKey = "AIzaSyBVDlAbQMfS__-HaoTPnii4p-XFVntg8VY";
    final url =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$_center.latitude,$_center.longitude&radius=5000&type=establishment&key=$apiKey";

    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);
    final places = data["results"] as List;

    // Add markers for each place
    setState(() {
      markers.addAll(places.map((place) {
        final lat = place["geometry"]["location"]["lat"];
        final lng = place["geometry"]["location"]["lng"];
        return Marker(
          markerId: MarkerId(place["place_id"]),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(title: place["name"]),
        );
      }));
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
        markers: markers.toSet(), // Use toSet() for unique markers
      ),
    );
  }
}
