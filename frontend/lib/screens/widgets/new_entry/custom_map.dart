import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'dart:convert';

import 'package:my_nikki/utils/colors.dart';

class CustomMap extends StatefulWidget {
  final Function(LatLng) onCoordinatesSelected;

  const CustomMap({super.key, required this.onCoordinatesSelected});

  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<CustomMap> {
  final TextEditingController _addressController = TextEditingController();
  final MapController _mapController = MapController();
  LatLng? _selectedCoordinates;
  String _errorMessage = '';

  void _onTap(LatLng position) {
    setState(() {
      _selectedCoordinates = position;
    });
  }

  void _sendCoordinates() {
    if (_selectedCoordinates != null) {
      widget.onCoordinatesSelected(_selectedCoordinates!);
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a location on the map')),
      );
    }
  }

  Future<void> _searchAddress(String address) async {
    final response = await http.get(
      Uri.parse(
          'https://nominatim.openstreetmap.org/search?q=$address&format=json&addressdetails=1'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> results = json.decode(response.body);
      if (results.isNotEmpty) {
        final firstResult = results.first;
        final lat = firstResult['lat'];
        final lon = firstResult['lon'];
        final latLng = LatLng(double.parse(lat), double.parse(lon));
        setState(() {
          _selectedCoordinates = latLng;
          _mapController.move(latLng, 15);
          _errorMessage = '';
        });
      } else {
        setState(() {
          _errorMessage = 'No results found for this address';
        });
      }
    } else {
      setState(() {
        _errorMessage = 'Failed to get address. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondaryColor,
        title: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  hintText: 'Enter ZIP code',
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onSubmitted: (value) {
                  _searchAddress(value);
                },
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black, size: 32),
            onPressed: () {
              _searchAddress(_addressController.text);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(
                  37.7749, -122.4194), // Example coordinates (San Francisco)
              initialZoom: 10,
              onTap: (tapPosition, point) => _onTap(point),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
              if (_selectedCoordinates != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: _selectedCoordinates!,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40.0,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: _sendCoordinates,
              child: const Text('Send Coordinates'),
            ),
          ),
        ],
      ),
    );
  }
}
