import 'dart:io';
import 'package:uuid/uuid.dart';

class PlaceLocation {
  const PlaceLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  final double latitude;
  final double longitude;
  final String address;
}

class Place {
  Place({
    required this.title,
    required this.image,
    required this.location,
    String? id, // make id nullable and assign it a default value
  }) : id = id ?? const Uuid().v4(); // assign a default value using Uuid if id is null

  final String id;
  final String title;
  final File image;
  final PlaceLocation location;
}
