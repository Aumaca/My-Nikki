import 'package:logger/logger.dart';
import 'package:my_nikki/screens/widgets/snack_bar.dart';
import 'package:my_nikki/screens/widgets/button.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'dart:convert';

import 'package:my_nikki/utils/colors.dart';

class CustomMap extends StatefulWidget {
  final LatLng? initialCoordinates;
  final Function(LatLng) onCoordinatesSelected;
  bool? isReadOnly = false;

  CustomMap(
      {super.key,
      this.initialCoordinates,
      this.isReadOnly,
      required this.onCoordinatesSelected});

  @override
  CustomMapState createState() => CustomMapState();
}

class CustomMapState extends State<CustomMap> {
  final TextEditingController _addressController = TextEditingController();
  final MapController _mapController = MapController();
  LatLng? _selectedCoordinates;

  @override
  void initState() {
    super.initState();
    _selectedCoordinates = widget.initialCoordinates;
  }

  void _onTap(LatLng position) {
    Logger().i(widget.isReadOnly);
    if (!(widget.isReadOnly == true)) {
      setState(() {
        _selectedCoordinates = position;
      });
    }
  }

  void _sendCoordinates() {
    if (_selectedCoordinates != null) {
      widget.onCoordinatesSelected(_selectedCoordinates!);
      Navigator.of(context).pop();
    } else {
      showSnackBar(context, 'Please select a location on the map', Colors.red);
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
        });
      }
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
              widget.isReadOnly == true
                  ? Container()
                  : TextField(
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
          widget.isReadOnly == true
              ? Container()
              : IconButton(
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
              initialCenter: _selectedCoordinates != null
                  ? _selectedCoordinates!
                  : const LatLng(37.7749, -122.4194),
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
          widget.isReadOnly == true
              ? Container()
              : Positioned(
                  bottom: 50,
                  right: 20,
                  child: customFloatingActionButton(
                      _sendCoordinates, Colors.green[400]!, Icons.check))
        ],
      ),
    );
  }
}
