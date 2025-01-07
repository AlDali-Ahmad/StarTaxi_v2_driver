
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:driver_taxi/view/screen/auth/UserPreference.dart';
import 'dart:async';
import 'dart:convert';
import 'package:driver_taxi/components/app_drawer.dart';
import 'package:driver_taxi/components/custom_loading_button.dart';
import 'package:driver_taxi/components/custom_text.dart';
import 'package:driver_taxi/location/location.dart';
import 'package:driver_taxi/utils/app_colors.dart';
import 'package:driver_taxi/view/screen/notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isOnDuty = true;
  late Timer _reconnectTimer;
  bool _isConnected = false;
  // final Completer<GoogleMapController> _controller =
  //     Completer<GoogleMapController>();
  GoogleMapController? gms;
  List<Marker> markers = [];
  CameraPosition cameraPosition = const CameraPosition(
    target: LatLng(33.504307, 36.304141),
    zoom: 10.4746,
  );

  late WebSocketChannel _channel;
  bool _isSnackbarVisible = false;
  String? id;
  String? _token;
  // String? _customer_id;
  // String? _chat_id;

  @override
  void initState() {
    super.initState();
    loadUserData();
    getCurrentLocation();
  }

  Future<void> loadUserData() async {
    Map<String, String?> userInfo = await UserPreferences.getUserInfo();
    setState(() {
      id = userInfo['id'];
      _token = userInfo['token'];
      // _chat_id = userInfo['chat_id'];
      // _customer_id = userInfo['customer_id'];
      if (id != null && _token != null) {
        _connectToWebSocket();
        // _connectToWebSocket2();
      } else {
        log('Failed to load user data: id or token is null');
      }
    });
  }

  void _connectToWebSocket() {
    if (_isConnected) return;

    _channel = WebSocketChannel.connect(
      Uri.parse(
          'ws://10.0.2.2:8080/app/ni31bwqnyb4g9pbkk7sn?protocol=7&client=js&version=4.3.1'),
    );

    _isConnected = true;
    _channel.stream.listen(
      (event) async {
        log('Received event: $event');
        if (event.contains('connection_established')) {
          await _authenticateWebSocket(event);
        }
        try {
          _handleWebSocketEvent(event);
        } catch (e) {
          log('Error decoding event: $e');
        }
      },
      onError: (error) {
        log('WebSocket error: $error');
        _isConnected = false;
        _attemptReconnect();
      },
      onDone: () {
        log('WebSocket connection closed');
        _isConnected = false;
        _attemptReconnect();
      },
      cancelOnError: true,
    );
  }

  Future<void> _authenticateWebSocket(String event) async {
    final decodedEvent = jsonDecode(event);
    final decodeData = jsonDecode(decodedEvent['data']);
    final socketId = decodeData['socket_id'];
    log('Socket ID1111: $socketId');

    const authUrl = 'http://10.0.2.2:8000/api/broadcasting/auth';
    final authResponse = await http.post(
      Uri.parse(authUrl),
      headers: {
        'Authorization': 'Bearer $_token',
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({'channel_name': 'driver.$id', 'socket_id': socketId}),
    );

    if (authResponse.statusCode == 200) {
      final authData = jsonDecode(authResponse.body);
      log('Auth data: $authData');
      _channel.sink.add(jsonEncode({
        "event": "pusher:subscribe",
        "data": {
          "channel": "driver.$id",
          "auth": authData['auth'].toString(),
        },
      }));
    } else {
      log('Failed to authenticate: ${authResponse.body}');
    }
  }

  void _handleWebSocketEvent(String event) {
    final decodedEvent = jsonDecode(event);
    if (decodedEvent['event'] == 'acceptRequest' && !_isSnackbarVisible) {
      setState(() {
        _isSnackbarVisible = true;
        Get.snackbar(
          '',
          'تم إرسال طلب جديد إليك',
          colorText: AppColors.BackgroundColor,
          backgroundColor: AppColors.green1,
          duration: const Duration(seconds: 5),
        );
        playNotificationSound();
        Timer(const Duration(seconds: 3), () {
          _isSnackbarVisible = false;
        });
      });
      log('Accepted request data: ${decodedEvent['data']}');
    }
  }

  void _attemptReconnect() {
    if (!_isConnected) {
      _reconnectTimer = Timer(const Duration(seconds: 5), () {
        log('Trying to reconnect...');
        _connectToWebSocket();
      });
    }
  }

  Future<void> playNotificationSound() async {
    try {
      await _audioPlayer.setSource(AssetSource('sound/notification.mp3'));
      await _audioPlayer.resume();
    } catch (e) {
      log('Error playing sound: $e');
    }
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      log('Location services are disabled.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition();

      markers.add(Marker(
        markerId: const MarkerId("current_location"),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: const InfoWindow(title: 'موقعك الحالي'),
      ));

      gms?.animateCamera(CameraUpdate.newLatLng(
          LatLng(position.latitude, position.longitude)));

      setState(() {});
    }
  }

  void sendLocation() async {
    await LocationService.sendLocationToDatabase();
    log('تم إرسال الموقع.');
  }

  Future<void> sendStatusToDataBase(int stateParam) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    String apiUrl = 'http://10.0.2.2:8000/api/drivers/change-state';
    // int stateParam = isOnDuty ? 1 : 0;

    final Map<String, dynamic> data = {
      'state': stateParam,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode(data),
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        log('تم إرسال البيانات بنجاح.');
      } else {
        log('حدث خطأ: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      log('حدث خطأ أثناء إرسال البيانات: $e');
    }
  }

  @override
  void dispose() {
    _channel.sink.close();
    // _channel2.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.orange1, AppColors.orange2],
              begin: Alignment.topLeft,
              end: Alignment.topRight,
            ),
          ),
          child: AppBar(
            title: CustomText(
              text: 'الصفحة الرئيسية',
              fontSize: 18.sp,
              color: Colors.white,
              alignment: Alignment.topRight,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: true,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                LoadingButtonWidget(
                  width: 140.w,
                  height: 40.h,
                  onPressed: () {
                    Get.to(() => const Notifications());
                  },
                  text: "الطلبات",
                  fontSize: 14,
                  backgroundColor1: AppColors.orange1,
                  backgroundColor2: AppColors.orange2,
                  textColor: Colors.white,
                ),
                LoadingButtonWidget(
                  width: 140.w,
                  height: 40.h,
                  onPressed: () {
                    setState(() {
                      _isOnDuty = !_isOnDuty;
                      // إرسال الحالة بناءً على القيمة الجديدة
                      sendStatusToDataBase(_isOnDuty ? 0 : 1);
                    });
                  },
                  borderColor: _isOnDuty ? AppColors.orange2 : AppColors.grey,
                  backgroundColor1:
                      _isOnDuty ? AppColors.orange1 : AppColors.white,
                  backgroundColor2:
                      _isOnDuty ? AppColors.orange2 : AppColors.white,
                  textColor:
                      _isOnDuty ? AppColors.white : AppColors.BackgroundColor,
                  fontSize: 14,
                  lodingColor:
                      _isOnDuty ? AppColors.white : AppColors.BackgroundColor,
                  text: _isOnDuty ? 'مستعد للرحلات' : 'انت في استراحة',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GoogleMap(
              markers: markers.toSet(),
              initialCameraPosition: cameraPosition,
              mapType: MapType.normal,
              onMapCreated: (mapController) {
                gms = mapController;
              },
              onTap: (LatLng latLng) {
                markers.add(Marker(
                  markerId: const MarkerId("1"),
                  position: LatLng(latLng.latitude, latLng.longitude),
                ));
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }
}