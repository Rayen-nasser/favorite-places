import 'package:favorite_places/provider/places_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/place.dart';
import '../screens/places_detail.dart';

class PlacesList extends ConsumerWidget {
  const PlacesList( {super.key, required this.placesList,});

  final List<Place> placesList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {


    return Scaffold(
      body: placesList.isEmpty
          ? Center(
        child: Text(
          'No places added yet.',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Theme.of(context).colorScheme.onBackground
          ),
        ),
      )
          : ListView.builder(
        itemCount: placesList.length,
        itemBuilder: (context, index) {
          final item = placesList[index];
          return Dismissible(
            key: ValueKey(item.id),
            onDismissed: (direction) {
              ref.read(placesProvider.notifier).removePlace(item.id);
            },
            child: ListTile(
              leading: CircleAvatar(
                radius: 26,
                backgroundImage: FileImage(item.image),
              ),
              title: Text(
                item.title,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              subtitle: item.location.address.isNotEmpty
                  ? Text(
                item.location.address,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              )
                  : Text(
                'No address provided',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlacesDetail(place: item),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
