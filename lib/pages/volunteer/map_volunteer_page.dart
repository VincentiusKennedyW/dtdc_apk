import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dtdc/bloc/volunteers/volunteers_bloc.dart';
import 'package:dtdc/model/Volunteer.dart';
import 'package:dtdc/pages/volunteer/detail_volunteer_page.dart';

class MapVolunteerPage extends StatefulWidget {
  const MapVolunteerPage({super.key});

  @override
  State<MapVolunteerPage> createState() => _MapVolunteerPageState();
}

class _MapVolunteerPageState extends State<MapVolunteerPage> {
  final defaultAppLocation = const LatLng(-1.269160, 116.825264);
  late GoogleMapController mapController;
  geo.Placemark? placemark;
  MapType selectedMapType = MapType.normal;
  LatLng? selectedLocation;
  int page = 1;

  @override
  void initState() {
    super.initState();
  }

  // Fungsi untuk memuat marker dari data dummy
  Set<Marker> _loadMarkersFromDummyData(List<Volunteer> dataVolunteer) {
    Set<Marker> markers = {};
    for (var data in dataVolunteer) {
      final lat = data.latitude;
      final lng = data.longitude;
      final markerId = data.id;
      final status = data.status;

      // Set warna marker berdasarkan status
      BitmapDescriptor markerColor;
      switch (status) {
        case 'relawan':
          markerColor =
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
          break;
        case 'memilih':
          markerColor =
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
          break;
        case 'ragu':
          markerColor =
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
          break;
        case 'tidak_memilih':
          markerColor =
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
          break;
        default:
          markerColor = BitmapDescriptor.defaultMarker; // Default color
      }

      markers.add(
        Marker(
          markerId: MarkerId(markerId.toString()),
          position: LatLng(lat, lng),
          icon: markerColor,
          infoWindow: InfoWindow(
            title: data.volunteerFamily[0].name,
            snippet: '${data.status} - Klik untuk Detail',
            onTap: () {
              _showDetailScreen(data);
            },
          ),
        ),
      );
    }
    return markers;
  }

  // Fungsi untuk menampilkan detail dari marker yang diklik
  void _showDetailScreen(Volunteer data) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailVolunteerPage(data: data),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Lokasi'),
        centerTitle: true,
      ),
      body: BlocBuilder<VolunteersBloc, VolunteersState>(
        builder: (context, state) {
          if (state is VolunteersInitial || state is VolunteersLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is VolunteersLoadSuccess ||
              state is WaitingNewVolunteer) {
            List<Volunteer> listVolunteer = [];

            if (state is WaitingNewVolunteer) {
              listVolunteer = state.listVolunteer;
            } else if (state is VolunteersLoadSuccess) {
              listVolunteer = state.listVolunteer;
            }
            Set<Marker> markers = _loadMarkersFromDummyData(listVolunteer);

            return Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    zoom: 14,
                    target: defaultAppLocation,
                  ),
                  markers: markers,
                  mapType: selectedMapType,
                  onMapCreated: (controller) {
                    mapController = controller;
                  },
                  myLocationEnabled: true,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                  myLocationButtonEnabled: false,
                ),
                Positioned(
                  top: 16,
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
                // loading indicator
                if (state is WaitingNewVolunteer)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: SizedBox(
                        height: 40,
                        // circular progress indicator
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                      ),
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
                  bottom: 16,
                  left: 16,
                  child: FloatingActionButton.extended(
                    heroTag: null,
                    onPressed: () {
                      context
                          .read<VolunteersBloc>()
                          .add(FetchMoreVolunteer(page: page++));
                    },
                    label: const Text("Muat lebih banyak titik"),
                  ),
                ),
                // Positioned untuk Legenda
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLegendItem(Colors.blue, 'Ingin menjadi relawan'),
                        const SizedBox(height: 4),
                        _buildLegendItem(Colors.green, 'Memilih'),
                        const SizedBox(height: 4),
                        _buildLegendItem(Colors.yellow, 'Masih ragu'),
                        const SizedBox(height: 4),
                        _buildLegendItem(Colors.red, 'Tidak memilih'),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else if (state is VolunteersLoadFailure) {
            return Center(
              child: Text('Failed to load list tps ${state.error}'),
            );
          } else {
            return const Center(
              child: Text('Unknown state'),
            );
          }
        },
      ),
    );
  }

  // Fungsi untuk membangun item legenda
// Fungsi untuk membangun item legenda
  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
        const SizedBox(width: 4),
        Text(label),
      ],
    );
  }
}
