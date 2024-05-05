import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart';
import 'package:netxus/screens/const.dart';
import 'package:http/http.dart' as http;

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Location _locationController = new Location();
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  LatLng? _currentLocation;
  LatLng? _sourceLocation;
  LatLng? _destinationLocation;
  Map<PolylineId, Polyline> polylines = {};

  final TextEditingController _sourceLocationController =
      TextEditingController();
  final TextEditingController _destinationLocationController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Installed NetXus System'),
        backgroundColor: Colors.green,
      ),
      body: Stack(
        children: [
          _currentLocation == null
              ? const Center(child: Text("Loading..."))
              : GoogleMap(
                  onMapCreated: (GoogleMapController controller) =>
                      _mapController.complete(controller),
                  initialCameraPosition: CameraPosition(
                    target: _currentLocation!,
                    zoom: 13,
                  ),
                  markers: {
                    if (_sourceLocation != null)
                      Marker(
                        markerId: MarkerId("_sourceLocation"),
                        icon: BitmapDescriptor.defaultMarker,
                        position: _sourceLocation!,
                      ),
                    if (_destinationLocation != null)
                      Marker(
                        markerId: MarkerId("_destinationLocation"),
                        icon: BitmapDescriptor.defaultMarker,
                        position: _destinationLocation!,
                      ),
                    Marker(
                      markerId: MarkerId("_currentLocation"),
                      icon: BitmapDescriptor.defaultMarker,
                      position: _currentLocation!,
                    ),
                  },
                  polylines: Set<Polyline>.of(polylines.values),
                ),
          Positioned(
            bottom: 20,
            left: 10,
            right: 10,
            child: Column(
              children: [
                TextField(
                  controller: _sourceLocationController,
                  decoration: const InputDecoration(
                    labelText: "Source Location",
                  ),
                ),
                TextField(
                  controller: _destinationLocationController,
                  decoration: const InputDecoration(
                    labelText: "Destination Location",
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _getPolylinePoints(),
                  child: const Text('Show Route'),
                  
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(
      target: pos,
      zoom: 13,
    );
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(_newCameraPosition),
    );
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          _currentLocation =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
          _cameraToPosition(_currentLocation!);
        });
      }
    });
  }

  Future<void> _getPolylinePoints() async {
    // Get source and destination locations from TextFields
    String source = _sourceLocationController.text;
    String destination = _destinationLocationController.text;

    // Check if both fields are filled
    if (source.isEmpty || destination.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both source and destination locations'),
        ),
      );
      return;
    }

    // Convert user input to LatLng objects using geocoding
    List<LatLng> latLngPoints = [];
    try {
      // Geocode source location
      final Uri sourceUri = Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?address=$source&key=$GOOGLE_MAPS_API_KEY');
      final http.Response sourceResponse = await http.get(sourceUri);
      if (sourceResponse.statusCode == 200) {
        final Map<String, dynamic> sourceData = jsonDecode(sourceResponse.body);
        if (sourceData['results'].isNotEmpty) {
          final double sourceLatitude =
              sourceData['results'][0]['geometry']['location']['lat'];
          final double sourceLongitude =
              sourceData['results'][0]['geometry']['location']['lng'];
          latLngPoints.add(LatLng(sourceLatitude, sourceLongitude));
        } else {
          throw Exception('Source location not found');
        }
      } else {
        throw Exception('Failed to geocode source location');
      }

      // Geocode destination location
      final Uri destinationUri = Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?address=$destination&key=$GOOGLE_MAPS_API_KEY');
      final http.Response destinationResponse = await http.get(destinationUri);
      if (destinationResponse.statusCode == 200) {
        final Map<String, dynamic> destinationData =
            jsonDecode(destinationResponse.body);
        if (destinationData['results'].isNotEmpty) {
          final double destinationLatitude =
              destinationData['results'][0]['geometry']['location']['lat'];
          final double destinationLongitude =
              destinationData['results'][0]['geometry']['location']['lng'];
          latLngPoints.add(LatLng(destinationLatitude, destinationLongitude));
        } else {
          throw Exception('Destination location not found');
        }
      } else {
        throw Exception('Failed to geocode destination location');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error finding location: ${e.toString()}'),
        ),
      );
      return;
    }

    _sourceLocation = latLngPoints[0];
    _destinationLocation = latLngPoints[1];

    // Update markers on the map
    setState(() {});

    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      GOOGLE_MAPS_API_KEY,
      PointLatLng(latLngPoints[0].latitude, latLngPoints[0].longitude),
      PointLatLng(latLngPoints[1].latitude, latLngPoints[1].longitude),
      travelMode: TravelMode.walking,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });

      PolylineId id = PolylineId("poly");
      Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.blue,
        points: polylineCoordinates,
        width: 8,
      );

      setState(() {
        polylines[id] = polyline;
      });
    } else {
      print(result.errorMessage);
    }
  }

  // void generatePolyLineFromPoints(List<LatLng> polylineCoordinates) async {
  //   PolylineId id = PolylineId("poly");
  //   Polyline polyline = Polyline(
  //       polylineId: id,
  //       color: Colors.blue,
  //       points: polylineCoordinates,
  //       width: 8);
  //   setState(() {
  //     polylines[id] = polyline;
  //   });
  // }
}