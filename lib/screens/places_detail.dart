import 'package:favorite_places/model/place.dart';
import 'package:favorite_places/screens/map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesDetail extends ConsumerWidget {
  const PlacesDetail({super.key, required this.place});

  final Place place;

  String get locationImage {
    if (place.location == null) {
      return '';
    }

    final lat = place.location!.latitude;
    final lng = place.location!.longitude;
    final apiKey = '70b2f5ec097d4d59887a3c0e7967b4c3'; // Replace with your actual Geoapify API key
    return 'https://maps.geoapify.com/v1/staticmap?style=osm-carto&width=400&height=400&center=lonlat:$lng,$lat&zoom=14&apiKey=$apiKey&marker=lonlat:$lng,$lat;color:%23ff0000;size:medium';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
      ),
      body: Stack(
        children: [
          Image.file(
            place.image,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          if (place.location != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      // Navigator.of(context).push(MaterialPageRoute(
                      //   builder: (ctx) => MapScreen(
                      //     location: place.location!,
                      //     isSelecting: false,
                      //   ),
                      // ));
                    },
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: NetworkImage(locationImage),
                      onBackgroundImageError: (exception, stackTrace) {
                        print('Error loading location image: $exception');
                      },
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black54],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Text(
                      place.location!.address,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.black54],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Text(
                  'No location information available',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
