// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:dtdc/bloc/volunteers/volunteers_bloc.dart';
import 'package:dtdc/components/modal_bottom_sheet_component.dart';
import 'package:dtdc/model/Volunteer.dart';
import 'package:dtdc/model/VolunteerFamily.dart';
import 'package:dtdc/pages/volunteer/components/family_form.dart';
import 'package:dtdc/pages/volunteer/components/map_picker.dart';
import 'package:dtdc/repositories/volunteer_repository.dart';
import 'package:dtdc/utils/auth.dart';

class FormVolunteerPage extends StatefulWidget {
  const FormVolunteerPage({super.key});

  @override
  _FormVolunteerPageState createState() => _FormVolunteerPageState();
}

class _FormVolunteerPageState extends State<FormVolunteerPage> {
  XFile? _image;
  final _picker = ImagePicker();

  final _phoneController = TextEditingController();
  final _rtController = TextEditingController();
  final _houseNumberController = TextEditingController();
  final _alamatController = TextEditingController();
  final _dptController = TextEditingController();
  final _answer3Controller = TextEditingController();

  List<FamilyData> anggotaKeluargaList = [];
  String? selectedStatus;
  String? _answer1;
  String? _answer2;

  Future<void> _pickImage() async {
    final pickedFile = await showModalBottomSheet<XFile>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galeri'),
                onTap: () async {
                  Navigator.pop(context,
                      await _picker.pickImage(source: ImageSource.gallery));
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Kamera'),
                onTap: () async {
                  Navigator.pop(context,
                      await _picker.pickImage(source: ImageSource.camera));
                },
              ),
            ],
          ),
        );
      },
    );

    setState(() {
      _image = pickedFile;
    });
  }

  Future<LocationData?> _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    locationData = await location.getLocation();

    return locationData;
  }

  void _addAnggotaKeluarga() {
    setState(() {
      anggotaKeluargaList.add(FamilyData());
    });
  }

  void _removeAnggotaKeluarga(int index) {
    setState(() {
      anggotaKeluargaList.removeAt(index);
    });
  }

  void _submitForm() async {
    FocusManager.instance.primaryFocus?.unfocus();

    String phone = _phoneController.text;
    String rt = _rtController.text;
    String houseNumber = _houseNumberController.text;
    String alamat = _alamatController.text;
    String dpt = _dptController.text;
    String answer3 = _answer3Controller.text;
    String latitude = "0";
    String longitude = "0";

    // Validate form
    if (phone.isEmpty) {
      ModalBottomSheetComponent()
          .errorIndicator(context, "Nomor telepon belum diisi");
      return;
    }
    if (rt.isEmpty) {
      ModalBottomSheetComponent().errorIndicator(context, "RT belum diisi");
      return;
    }
    if (houseNumber.isEmpty) {
      ModalBottomSheetComponent()
          .errorIndicator(context, "Nomor rumah belum diisi");
      return;
    }
    if (alamat.isEmpty) {
      ModalBottomSheetComponent().errorIndicator(context, "Alamat belum diisi");
      return;
    }
    if (dpt.isEmpty) {
      ModalBottomSheetComponent()
          .errorIndicator(context, "Jumlah DPT belum diisi");
      return;
    }
    if (selectedStatus == null) {
      ModalBottomSheetComponent().errorIndicator(context, "Status belum diisi");
      return;
    }
    if (_answer1 == null) {
      ModalBottomSheetComponent()
          .errorIndicator(context, "Pilihan calon walikota belum diisi");
      return;
    }
    if (_answer2 == null) {
      ModalBottomSheetComponent().errorIndicator(
          context, "Apakah menerima serangan fajar belum diisi");
      return;
    }

    List<VolunteerFamily> anggotaKeluargaData = [];
    if (anggotaKeluargaList.isEmpty) {
      ModalBottomSheetComponent().errorIndicator(
          context, "Anggota keluarga belum diisi, tambahkan minimal 1");
      return;
    }

    if (anggotaKeluargaList.isNotEmpty) {
      for (var anggota in anggotaKeluargaList) {
        String nama = anggota.namaController.text;
        String age = anggota.ageController.text;
        String posisi = anggota.posisiController.text;

        anggotaKeluargaData.add(VolunteerFamily(
          id: 0,
          name: nama,
          age: age,
          position: posisi,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ));
      }
    }

    if (_image == null) {
      ModalBottomSheetComponent().errorIndicator(context, "Foto belum diisi");
      return;
    }

    ModalBottomSheetComponent().loadingIndicator(context, "Mengecek lokasi...");

    LocationData? locationData = await _getCurrentLocation();

    if (locationData != null) {
      latitude = locationData.latitude.toString();
      longitude = locationData.longitude.toString();
    } else {
      ModalBottomSheetComponent()
          .errorIndicator(context, "Gagal mendapatkan lokasi");
      return;
    }

    Navigator.pop(context);
    ModalBottomSheetComponent()
        .loadingIndicator(context, "Sedang mengirim data...");

    Volunteer volunteer = Volunteer(
      id: 0,
      photo: _image?.path ?? '',
      phoneNumber: phone,
      houseNumber: houseNumber,
      dptCount: dpt,
      rt: rt,
      latitude: double.parse(latitude),
      longitude: double.parse(longitude),
      address: alamat,
      status: selectedStatus ?? '',
      volunteerFamily: anggotaKeluargaData,
      answer1: _answer1 ?? "",
      answer2: _answer2 ?? "",
      answer3: answer3,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    String? token = await Auth().getToken();

    try {
      final response = await VolunteerRepository().addVolunteer(
        token: token ?? "",
        photo: volunteer.photo,
        phone_number: volunteer.phoneNumber,
        house_number: volunteer.houseNumber,
        rt: volunteer.rt,
        latitude: volunteer.latitude,
        longitude: volunteer.longitude,
        address: volunteer.address,
        status: volunteer.status,
        family: volunteer.volunteerFamily,
        answer1: volunteer.answer1,
        answer2: volunteer.answer2,
        answer3: volunteer.answer3,
      );

      if (response['success']) {
        context.read<VolunteersBloc>().add(AddVolunteer(
              volunteer: volunteer,
            ));

        Navigator.pop(context);
        ModalBottomSheetComponent()
            .loadingIndicator(context, 'Data berhasil dikirim');
      } else {
        Navigator.pop(context);
        ModalBottomSheetComponent()
            .errorIndicator(context, response['message']);
      }
    } catch (e) {
      Navigator.pop(context);
      ModalBottomSheetComponent().errorIndicator(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Keluarga'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
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
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      keyboardType: TextInputType.number,
                      controller: _phoneController,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Nomor Telpon',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      keyboardType: TextInputType.number,
                      controller: _rtController,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: const InputDecoration(
                        labelText: 'RT',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      keyboardType: TextInputType.number,
                      controller: _houseNumberController,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Nomor Rumah',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _alamatController,
                      decoration: const InputDecoration(
                        labelText: 'Alamat',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      keyboardType: TextInputType.number,
                      controller: _dptController,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Jumlah DPT',
                        border: OutlineInputBorder(),
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
                          value: 'relawan',
                          child: Text('Ingin Menjadi Relawan'),
                        ),
                        DropdownMenuItem(
                          value: 'memilih',
                          child: Text('Ingin Memilih'),
                        ),
                        DropdownMenuItem(
                          value: 'ragu',
                          child: Text('Masih Ragu'),
                        ),
                        DropdownMenuItem(
                          value: 'tidak_memilih',
                          child: Text('Tidak Memilih'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedStatus = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text('Pilihan Calon Walikota'),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      value: _answer1,
                      items: const [
                        DropdownMenuItem(
                          value: 'Bulat memilih RB',
                          child: SizedBox(
                            width: double.maxFinite,
                            child: Text(
                              "Bulat memilih RB",
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'Bulat memilih RE',
                          child: SizedBox(
                            width: double.maxFinite,
                            child: Text(
                              "Bulat memilih RE",
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'Bulat memilih SS',
                          child: SizedBox(
                            width: double.maxFinite,
                            child: Text(
                              "Bulat memilih SS",
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value:
                              'Tidak suka dengan incumbent tapi belum ada pilihan',
                          child: SizedBox(
                            width: double.maxFinite,
                            child: Text(
                              "Tidak suka dengan incumbent tapi belum ada pilihan",
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'Belum ada pilihan/mengenal pilihan',
                          child: SizedBox(
                            width: double.maxFinite,
                            child: Text(
                              "Belum ada pilihan/mengenal pilihan",
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'Bingung pilih RE/SS',
                          child: SizedBox(
                            width: double.maxFinite,
                            child: Text(
                              "Bingung pilih RE/SS",
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'Pilih Paslon yang paling besar nominalnya',
                          child: SizedBox(
                            width: double.maxFinite,
                            child: Text(
                              "Pilih Paslon yang paling besar nominalnya",
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'Golput',
                          child: SizedBox(
                            width: double.maxFinite,
                            child: Text(
                              "Golput",
                            ),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _answer1 = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text('Apakah menerima serangan fajar ?'),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      value: _answer2,
                      items: const [
                        DropdownMenuItem(
                          value: 'Tidak Menerima',
                          child: SizedBox(
                            width: double.maxFinite,
                            child: Text('Tidak Menerima'),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'Menerima yg paling besar nominalnya',
                          child: SizedBox(
                            width: double.maxFinite,
                            child: Text('Menerima yg paling besar nominalnya'),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'Menerima tetapi milih sesuai hati nurani',
                          child: SizedBox(
                            width: double.maxFinite,
                            child: Text(
                                'Menerima tetapi milih sesuai hati nurani'),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _answer2 = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      keyboardType: TextInputType.number,
                      controller: _answer3Controller,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Berapa Nominal yg di inginkan ?',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _addAnggotaKeluarga,
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              label: const Text(
                'Tambah Anggota Keluarga',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: anggotaKeluargaList.length,
              itemBuilder: (context, index) {
                return FamilyForm(
                  index: index,
                  data: anggotaKeluargaList[index],
                  onRemove: () => _removeAnggotaKeluarga(index),
                );
              },
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton(
          onPressed: _submitForm,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: Colors.blueAccent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
          child: const Text(
            'Kirim',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
