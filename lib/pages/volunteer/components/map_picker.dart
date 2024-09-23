import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:location/location.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPicker extends StatefulWidget {
  const MapPicker({super.key});

  @override
  State<MapPicker> createState() => _MapPickerState();
}

class _MapPickerState extends State<MapPicker> {
  final defaultAppLocation = const LatLng(-1.269160, 116.825264);
  late GoogleMapController mapController;
  final Set<Marker> markers = {};
  geo.Placemark? placemark;
  MapType selectedMapType = MapType.normal;
  LatLng? selectedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Lokasi'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      zoom: 14,
                      target: defaultAppLocation,
                    ),
                    markers: markers,
                    mapType: selectedMapType,
                    onMapCreated: (controller) async {
                      setState(() {
                        mapController = controller;
                      });
                    },
                    onLongPress: (LatLng latLng) {
                      onLongPressGoogleMap(latLng);
                      selectedLocation = latLng;
                    },
                    myLocationEnabled: true,
                    zoomControlsEnabled: false,
                    mapToolbarEnabled: false,
                    myLocationButtonEnabled: false,
                  ),
                  Positioned(
                    top: 76,
                    right: 16,
                    child: FloatingActionButton.small(
                      heroTag: null,
                      onPressed: null,
                      child: PopupMenuButton<MapType>(
                        onSelected: (MapType item) {
                          setState(() {
                            selectedMapType = item;
                          });
                        },
                        offset: const Offset(0, 54),
                        icon: const Icon(Icons.layers_outlined),
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<MapType>>[
                          const PopupMenuItem<MapType>(
                            value: MapType.normal,
                            child: Text('Normal'),
                          ),
                          const PopupMenuItem<MapType>(
                            value: MapType.satellite,
                            child: Text('Satelit'),
                          ),
                          const PopupMenuItem<MapType>(
                            value: MapType.terrain,
                            child: Text('Medan'),
                          ),
                          const PopupMenuItem<MapType>(
                            value: MapType.hybrid,
                            child: Text('Hybrid'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: FloatingActionButton(
                      heroTag: null,
                      child: const Icon(Icons.my_location),
                      onPressed: () {
                        onMyLocationButtonPress();
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: Column(
                      children: [
                        FloatingActionButton.small(
                          heroTag: null,
                          onPressed: () {
                            showModalInfoText(context);
                          },
                          child: const Icon(Icons.info_outline_rounded),
                        ),
                        FloatingActionButton.small(
                          heroTag: null,
                          onPressed: () {
                            mapController.animateCamera(
                              CameraUpdate.zoomIn(),
                            );
                          },
                          child: const Icon(Icons.add),
                        ),
                        FloatingActionButton.small(
                          heroTag: null,
                          onPressed: () {
                            mapController.animateCamera(
                              CameraUpdate.zoomOut(),
                            );
                          },
                          child: const Icon(Icons.remove),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 16,
                    right: 78,
                    bottom: 24,
                    child: ElevatedButton(
                      onPressed: (selectedLocation != null)
                          ? () {
                              var address =
                                  '${placemark?.subLocality}, ${placemark?.locality}, ${placemark?.postalCode}, ${placemark?.country}';
                              Navigator.pop(
                                  context, [selectedLocation, address]);
                            }
                          : null,
                      child: (selectedLocation != null)
                          ? const Text('Pilih Lokasi Ini')
                          : const Text('Tekan dan Tahan untuk Pilih Lokasi'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void defineMarker(LatLng latLng, String? street, String address) {
    final marker = Marker(
      markerId: const MarkerId('source'),
      position: latLng,
      infoWindow: InfoWindow(
        title: street,
        snippet: address,
      ),
    );
    setState(() {
      markers.clear();
      markers.add(marker);
    });
  }

  void onMyLocationButtonPress() async {
    final Location location = Location();
    late bool serviceEnabled;
    late PermissionStatus permissionGranted;
    late LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();
    final latLng = LatLng(locationData.latitude!, locationData.longitude!);
    selectedLocation = latLng;

    final info =
        await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    final place = info[0];
    final street = place.street;
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    setState(() {
      placemark = place;
    });

    defineMarker(latLng, street, address);
    mapController.animateCamera(
      CameraUpdate.newLatLng(latLng),
    );
  }

  void onLongPressGoogleMap(LatLng latLng) async {
    final info =
        await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    final place = info[0];
    final street = place.street!;
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    setState(() {
      placemark = place;
    });
    defineMarker(latLng, street, address);
  }
}

void showModalInfoText(BuildContext context) {
  showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    builder: (context) {
      return const ListTile(
        title: Text('Informasi Lokasi'),
      );
    },
  );
}
