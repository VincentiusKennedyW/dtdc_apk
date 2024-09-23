import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DetailAttachmentPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const DetailAttachmentPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    LatLng location = LatLng(
      data['Latitude'] ?? 0.0,
      data['Longitude'] ?? 0.0,
    );

    String imageUrl = data['Foto'] ?? 'https://via.placeholder.com/200';
    String status = data['status'] ?? 'Status tidak tersedia';
    String timestamp = data['timestamp'] ?? 'Tanggal tidak tersedia';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Foto Saksi'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Membungkus gambar dengan Container dan memberikan border serta shadow
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1), // Warna shadow
                    blurRadius: 8, // Blur radius
                    offset: Offset(0, 4), // Posisi shadow
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.broken_image,
                        size: 50,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Status: $status',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tanggal: $timestamp',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Container(
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: location,
                    zoom: 14,
                  ),
                  markers: {
                    Marker(
                      markerId: const MarkerId('locationMarker'),
                      position: location,
                    ),
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
    ;
  }
}
