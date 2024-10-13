import 'dart:convert';
import 'package:driver_taxi/utils/global.dart';
import 'package:http/http.dart' as http;
// ignore: unused_import
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart';

class ApiNotifications {
  static Future<List<dynamic>> Notifcations() async {
    // ignore: unnecessary_string_interpolations
    String apiUrl = '$apiPath_Notifcations';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load prices');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }

  goToMaps(double latitude, double longitude) async {
    String LapLocationUrl =
        "https:/www.google.com/maps/search/?api=1&query=$latitude ,$longitude";
    final String encodeURL = Uri.decodeFull(LapLocationUrl);
    if (await canLaunch(encodeURL)) {
      await launch(encodeURL);
      
    } else {
      print('Could not launch $encodeURL');
      throw 'Could not launch $encodeURL';
    }
  }
}
