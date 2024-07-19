import 'dart:ffi';
import 'dart:io';

import 'package:favorite_places/provider/places_provider.dart';
import 'package:favorite_places/widgets/image_input.dart';
import 'package:favorite_places/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/place.dart';

class NewPlacePage extends ConsumerStatefulWidget {
  const NewPlacePage({super.key});

  @override
  ConsumerState<NewPlacePage> createState() => _NewPlacePageState();
}

class _NewPlacePageState extends ConsumerState<NewPlacePage> {
  final _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? _selectImage;
  PlaceLocation? _selectLocation;

  void _pickImage(File pickedImage) {
    setState(() {
      _selectImage = pickedImage;
    });
  }

  void _savePlace() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectImage != null && _selectLocation != null) {
        final newPlace = Place(
          title: _titleController.text,
          image: _selectImage!,
          location: _selectLocation!,
        );
        await ref.read(placesProvider.notifier).addPlace(newPlace); // Wait for the place to be added to the database
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select an image and location.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Place'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          style: TextStyle(color: Colors.white),
                          controller: _titleController,
                          decoration: const InputDecoration(
                            labelText: 'Place Title',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please write something, the title is empty!';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        ImageInput(onPickImage: _pickImage),
                        const SizedBox(height: 20),
                        LocationInput(
                          onSelectLocation: (location) {
                            _selectLocation = location;
                          },
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel'),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: _savePlace,
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.add),
                                  SizedBox(width: 5),
                                  Text('Add'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
