import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dtdc/model/Volunteer.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailVolunteerPage extends StatelessWidget {
  final Volunteer data;

  const DetailVolunteerPage({super.key, required this.data});

  Widget _buildInfoTile(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 16, color: Colors.black),
        ),
        const Divider(height: 20, thickness: 1, color: Colors.grey),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informasi Pribadi'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informasi Pribadi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoTile(
                        'Name', data.volunteerFamily![0].name ?? "-"),
                    _buildInfoTile('Alamat', data.rt + data.houseNumber),
                    _buildInfoTile('DPT', data.dptCount),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (_) {
                            return DraggableScrollableSheet(
                              expand: false,
                              initialChildSize: 0.5,
                              minChildSize: 0.3,
                              maxChildSize: 0.8,
                              builder: (context, scrollController) {
                                return Container(
                                  padding: const EdgeInsets.all(16.0),
                                  child: GoogleMap(
                                    initialCameraPosition: CameraPosition(
                                      target:
                                          LatLng(data.latitude, data.longitude),
                                      zoom: 14,
                                    ),
                                    markers: {
                                      Marker(
                                        markerId: const MarkerId('location'),
                                        position: LatLng(
                                            data.latitude, data.longitude),
                                      ),
                                    },
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                      child: const Text(
                        'Lihat Lokasi di Peta',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Anggota Keluarga',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ...data.volunteerFamily.map((anggota) {
                      return ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 4.0),
                        title: Text(
                          '${anggota.name} (${anggota.position})',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          "${anggota.age} tahun",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Gambar dengan indikator loading
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                data.photo,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  if (wasSynchronouslyLoaded) {
                    return child;
                  } else {
                    return AnimatedOpacity(
                      child: child,
                      opacity: frame == null ? 0 : 1,
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeOut,
                    );
                  }
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error,
                          color: Colors.red,
                          size: 40,
                        ),
                        Text('Gagal memuat gambar'),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
