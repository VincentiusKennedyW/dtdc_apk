import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

class FormAttachmentPage extends StatefulWidget {
  const FormAttachmentPage({super.key});

  @override
  State<FormAttachmentPage> createState() => _FormAttachmentPageState();
}

class _FormAttachmentPageState extends State<FormAttachmentPage> {
  XFile? _image;
  final _picker = ImagePicker();
  String? selectedStatus;
  bool _isLoading = false; // Tambahkan variabel untuk status loading

  final TextEditingController _latController = TextEditingController();
  final TextEditingController _longController = TextEditingController();

  // Function to pick image from camera
  Future<void> _pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = pickedFile;
    });
  }

  // Function to get current location
  void _getCurrentLocation() async {
    setState(() {
      _isLoading = true; // Set status loading menjadi true
    });

    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        setState(() {
          _isLoading = false; // Set status loading menjadi false jika gagal
        });
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        setState(() {
          _isLoading = false; // Set status loading menjadi false jika gagal
        });
        return;
      }
    }

    locationData = await location.getLocation();
    setState(() {
      _latController.text = locationData.latitude.toString();
      _longController.text = locationData.longitude.toString();
      _isLoading = false; // Set status loading menjadi false setelah selesai
    });

    // Print output to console
    _printFormOutput();
  }

  // Function to print the form output
  void _printFormOutput() {
    print('Status: $selectedStatus');
    print('Latitude: ${_latController.text}');
    print('Longitude: ${_longController.text}');
    print('Foto: ${_image?.path}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _pickImageFromCamera,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                width: double.infinity,
                height: 200,
                child: _image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child:
                            Image.file(File(_image!.path), fit: BoxFit.cover),
                      )
                    : Center(
                        child: Icon(
                          Icons.camera_alt,
                          size: 50,
                          color: Colors.grey[700],
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              value: selectedStatus,
              items: const [
                DropdownMenuItem(
                  value: 'Kondisi',
                  child: Text('Kondisi'),
                ),
                DropdownMenuItem(
                  value: 'Rekapitulasi',
                  child: Text('Rekapitulasi'),
                ),
                DropdownMenuItem(
                  value: 'Dokumen C1',
                  child: Text('Dokumen C1'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedStatus = value;
                });
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton(
          onPressed: _isLoading
              ? null
              : _getCurrentLocation, // Disable button saat loading
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.blueAccent,
          ),
          child: _isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
