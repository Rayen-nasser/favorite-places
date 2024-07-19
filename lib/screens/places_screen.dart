import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/place.dart';
import '../provider/places_provider.dart';
import '../screens/add_place.dart';
import '../widgets/places_list.dart';

class PlacesScreen extends ConsumerStatefulWidget {
  const PlacesScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends ConsumerState<PlacesScreen> {
  // This Future is used to trigger the initial fetch and subsequent updates
  late Future<List<Place>> _fetchPlacesFuture;

  @override
  void initState() {
    super.initState();
    // Initialize the Future to fetch places
    _fetchPlacesFuture = ref.read(placesProvider.notifier).fetchPlaces();
  }

  void _refreshPlaces() {
    setState(() {
      // Refresh the Future to fetch places
      _fetchPlacesFuture = ref.read(placesProvider.notifier).fetchPlaces();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Places"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NewPlacePage()),
              ).then((_) {
                // Handle the return from NewPlacePage to refresh places
                _refreshPlaces();
              });
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<Place>>(
          future: _fetchPlacesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No places found.'));
            } else {
              return PlacesList(placesList: snapshot.data!);
            }
          },
        ),
      ),
    );
  }
}
