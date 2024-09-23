import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dtdc/components/modal_bottom_sheet_component.dart';
import 'package:dtdc/model/Volunteer.dart';
import 'package:dtdc/model/VolunteerFamily.dart';
import 'package:dtdc/utils/auth.dart';
import '../config.dart';

class VolunteerRepository {
  // API base URL
  final String baseUrl = Config.apiUrl;

  // Get all volunteers
  Future<List<Volunteer>> getVolunteers(String token, int page) async {
    final response = await http.get(
      Uri.parse('$baseUrl/volunteer/get?count=10&page=$page'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Parse the response body
      final List<dynamic> volunteers = jsonDecode(response.body)['data'];
      return volunteers
          .map((volunteer) => Volunteer.fromJson(volunteer))
          .toList();
    } else {
      throw Exception('Failed to load volunteers');
    }
  }

  // Add a volunteer
  Future<Map<String, dynamic>> addVolunteer({
    required String token,
    required String photo,
    required String phone_number,
    required String house_number,
    required String rt,
    required double latitude,
    required double longitude,
    required String address,
    required String status,
    required List<VolunteerFamily> family,
    required String answer1,
    required String answer2,
    required String answer3,
  }) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/volunteer/create'),
    );

    var imageFile = await http.MultipartFile.fromPath(
      'photo',
      photo,
      filename: "volunteer_photo.jpg",
    );

    request.files.add(imageFile);

    request.headers['Accept'] = 'application/json';
    request.headers['Content-Type'] = 'multipart/form-data';
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['latitude'] = latitude.toString();
    request.fields['longitude'] = longitude.toString();
    request.fields['phone_number'] = phone_number;
    request.fields['house_number'] = house_number.toString();
    request.fields['rt'] = rt.toString();
    request.fields['address'] = address;
    request.fields['status'] = status;
    request.fields['answer1'] = answer1;
    request.fields['answer2'] = answer2;
    request.fields['answer3'] = answer3;

    for (var i = 0; i < family.length; i++) {
      request.fields['family[$i][name]'] = family[i].name;
      request.fields['family[$i][age]'] = family[i].age;
      request.fields['family[$i][position]'] = family[i].position;
    }

    final response = await request.send();

    if (int.parse(response.statusCode.toString()[0]) == 2) {
      return {"success": true, "message": 'Data berhasil dikirim'};
    } else {
      var result = await response.stream.bytesToString();
      String message = result.split('"message":"')[1].split('"}')[0];

      return {"success": false, "message": message};
    }
  }
}
