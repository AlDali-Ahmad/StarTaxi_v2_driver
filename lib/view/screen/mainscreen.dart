// import 'dart:async';
// import 'dart:convert';
// import 'package:driver_taxi/components/app_drawer.dart';
// import 'package:driver_taxi/components/custom_loading_button.dart';
// import 'package:driver_taxi/components22/custom_text.dart';
// import 'package:driver_taxi/location/location.dart';
// import 'package:driver_taxi/utils/app_colors.dart';
// import 'package:driver_taxi/view/screen/notifications.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class MainScreen extends StatefulWidget {
//   const MainScreen({Key? key}) : super(key: key);

//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }

// bool _isOnDuty = true; // حالة افتراضية

// Future<void> sendStatusToDataBase(bool isOnDuty) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   var token = prefs.getString('token');
//   String apiUrl = 'http://10.0.2.2:8000/api/drivers/change-state';
//   int stateParam = isOnDuty ? 1 : 0;

//   final Map<String, dynamic> data = {
//     'state': stateParam, // تعيين قيمة الـ state هنا
//   };
//   try {
//     // إرسال الطلب POST إلى API
//     final response = await http.post(
//       Uri.parse(apiUrl),
//       body: jsonEncode(data),
//       headers: <String, String>{
//         'Accept': 'application/json',
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token',
//       },
//     );
//     if (response.statusCode == 200) {
//       print('تم إرسال البيانات بنجاح.');
//     } else {
//       print('حدث خطأ.${response.statusCode}');
//       print('حدث خطأ.${response.body}');
//       // throw Exception(
//       //     'فشل في إرسال البيانات. الرمز الحالة: ${response.statusCode}');
//     }
//   } catch (e) {
//     throw Exception('حدث خطأ أثناء إرسال البيانات: $e');
//   }
// }

// class _MainScreenState extends State<MainScreen> {
//   // late String lastNotificationId; //

//   late Timer _timer;

//   @override
//   void initState() {
//     super.initState();
//     // sendLocation();
//     _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
//       sendLocation();
//     });
//   }

//   void sendLocation() async {
//     // ارسال الموقع إلى قاعدة البيانات
//     await LocationService.sendLocationToDatabase();
//     // print('تم إرسال الموقع.');
//   }
//   // WebViewController controller = WebViewController();
//     final Completer<GoogleMapController> _controller =Completer<GoogleMapController>();
//   GoogleMapController? gms;
//   List<Marker> markers = [];
//   Future<void> initalLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     // التحقق مما إذا كانت خدمات الموقع مفعلة
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       print('Location services are disabled.');
//       return;
//     }
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }

//     if (permission == LocationPermission.whileInUse ||
//         permission == LocationPermission.always) {
//       Position position = await Geolocator.getCurrentPosition();

//       // إضافة Marker على الخريطة وتحريك الكاميرا إلى الموقع الحالي
//       markers.add(Marker(
//           markerId: MarkerId("2"),
//           position: LatLng(position.latitude, position.longitude)));
//       gms!.animateCamera(CameraUpdate.newLatLng(
//           LatLng(position.latitude, position.longitude)));
//       // startLatitude = position.latitude;
//       // startLongitude = position.longitude;
//       print('***********************');
//       print(position.latitude);
//       print(position.longitude);
//       print('***************************');
//       setState(() {});
//     }
//   }
//     CameraPosition cameraPosition = const CameraPosition(
//     target: LatLng(33.504307, 36.304141),
//     zoom: 10.4746,
//   );
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
// drawer: AppDrawer(),
// appBar: AppBar(
//   title: CustomText(
//     text: 'Main Screen',
//     fontSize: 18.sp,
//     color: Colors.amber,
//     alignment: Alignment.center,
//   ),
//   backgroundColor: AppColors.BackgroundColor,
//   automaticallyImplyLeading: true,
//   iconTheme: IconThemeData(color: AppColors.orange1),
// ),
//       body: Column(
//         children: [
//           SizedBox(
//             height: 40,
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 10),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 LoadingButtonWidget(
//                   width: 100.w,
//                   height: 35.h,
//                   onPressed: () {
//                     Get.to(Notifications());
//                   },
//                   text: "Orders",
//                 ),
//                 LoadingButtonWidget(
//                   width: 140.w,
//                   height: 35.h,
//                   onPressed: () {
//                     setState(() {
//                       _isOnDuty = !_isOnDuty;
//                       sendStatusToDataBase(_isOnDuty);
//                     });
//                   },
//                   borderColor: _isOnDuty ? AppColors.orange2 : AppColors.grey,
//                   backgroundColor1:
//                       _isOnDuty ? AppColors.orange1 : AppColors.white,
//                   backgroundColor2:
//                       _isOnDuty ? AppColors.orange2 : AppColors.white,
//                   textColor:
//                       _isOnDuty ? AppColors.white : AppColors.BackgroundColor,
//                   fontSize: 12,
//                   lodingColor:
//                       _isOnDuty ? AppColors.white : AppColors.BackgroundColor,
//                   text: _isOnDuty ? 'on break' : 'Ready to take orders',
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 50,
//           ),
//           Container(
//                 height: 400.h,
//                 child: GoogleMap(
//                   onTap: (LatLng latLng) async {
//                     // endLatitude = latLng.latitude;
//                     // endLongitude = latLng.longitude;
//                     // try {
//                     // List<Placemark> placemarks = await placemarkFromCoordinates(
//                     //     latLng.latitude, latLng.longitude);

//                     // if (placemarks.isNotEmpty) {
//                     //   print('***************************************************');
//                     print('**************');
//                     print(latLng.latitude);
//                     print(latLng.longitude);
//                     print('**************');
//                     // Get.snackbar('title', '${placemarks[0].country}');
//                     markers.add(Marker(
//                         markerId: MarkerId("1"),
//                         position: LatLng(latLng.latitude, latLng.longitude)));
//                     setState(() {});
//                     //   } else {
//                     //     print("No placemarks found.");
//                     //   }
//                     // } catch (e) {
//                     //   print("Error occurred: $e");
//                     // }
//                   },
//                   markers: markers.toSet(),
//                   initialCameraPosition: cameraPosition,
//                   mapType: MapType.normal,
//                   onMapCreated: (mapController) {
//                     gms = mapController;
//                   },
//                 )),
//           // Image.asset('assets/images/car1.png'),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }
// }

// import 'dart:async';
// import 'dart:convert';
// import 'package:driver_taxi/components/app_drawer.dart';
// import 'package:driver_taxi/components/custom_loading_button.dart';
// import 'package:driver_taxi/components22/custom_text.dart';
// import 'package:driver_taxi/location/location.dart';
// import 'package:driver_taxi/utils/app_colors.dart';
// import 'package:driver_taxi/view/screen/notifications.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class MainScreen extends StatefulWidget {
//   const MainScreen({Key? key}) : super(key: key);

//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }

// bool _isOnDuty = true;

// Future<void> sendStatusToDataBase(bool isOnDuty) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   var token = prefs.getString('token');
//   String apiUrl = 'http://10.0.2.2:8000/api/drivers/change-state';
//   int stateParam = isOnDuty ? 1 : 0;

//   final Map<String, dynamic> data = {
//     'state': stateParam,
//   };
//   try {
//     final response = await http.post(
//       Uri.parse(apiUrl),
//       body: jsonEncode(data),
//       headers: <String, String>{
//         'Accept': 'application/json',
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token',
//       },
//     );
//     if (response.statusCode == 200) {
//       print('تم إرسال البيانات بنجاح.');
//     } else {
//       print('حدث خطأ.${response.statusCode}');
//       print('حدث خطأ.${response.body}');
//     }
//   } catch (e) {
//     throw Exception('حدث خطأ أثناء إرسال البيانات: $e');
//   }
// }

// class _MainScreenState extends State<MainScreen> {
//   late Timer _timer;
//   final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
//   GoogleMapController? gms;
//   List<Marker> markers = [];
//   CameraPosition cameraPosition = const CameraPosition(
//     target: LatLng(33.504307, 36.304141),
//     zoom: 10.4746,
//   );

//   @override
//   void initState() {
//     super.initState();
//     getCurrentLocation(); // استدعاء دالة الحصول على الموقع الحالي
//     sendLocation();
//     _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
//       sendLocation();
//     });
//   }

//   Future<void> getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     // التحقق مما إذا كانت خدمات الموقع مفعلة
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       print('Location services are disabled.');
//       return;
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }

//     if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
//       Position position = await Geolocator.getCurrentPosition();

//       // إضافة Marker على الخريطة للموقع الحالي
//       markers.add(Marker(
//         markerId: MarkerId("current_location"),
//         position: LatLng(position.latitude, position.longitude),
//         infoWindow: InfoWindow(title: 'موقعك الحالي'),
//       ));

//       // تحريك الكاميرا إلى الموقع الحالي
//       gms?.animateCamera(CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)));

//       setState(() {});
//     }
//   }

//   void sendLocation() async {
//     await LocationService.sendLocationToDatabase();
//     print('تم إرسال الموقع.');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: AppDrawer(),
//       appBar: AppBar(
//         title: CustomText(
//           text: 'Main Screen',
//           fontSize: 18.sp,
//           color: Colors.white,
//         ),
//         backgroundColor: AppColors.orange1,
//         automaticallyImplyLeading: true,
//         iconTheme: IconThemeData(color: Colors.white),
//       ),
//       body: Container(
//         child: Column(
//           children: [
//             SizedBox(height: 40),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   LoadingButtonWidget(
//                     width: 140.w,
//                     height: 40.h,
//                     onPressed: () {
//                       Get.to(Notifications());
//                     },
//                     text: "Orders",
//                     fontSize: 14,
//                     backgroundColor1: AppColors.orange1,
//                     backgroundColor2: AppColors.orange2,
//                     textColor: Colors.white,
//                   ),
//                   LoadingButtonWidget(
//                     width: 140.w,
//                     height: 40.h,
//                     onPressed: () {
//                       setState(() {
//                         _isOnDuty = !_isOnDuty;
//                         sendStatusToDataBase(_isOnDuty);
//                       });
//                     },
//                     borderColor: _isOnDuty ? AppColors.orange2 : AppColors.grey,
//                     backgroundColor1:
//                         _isOnDuty ? AppColors.orange1 : AppColors.white,
//                     backgroundColor2:
//                         _isOnDuty ? AppColors.orange2 : AppColors.white,
//                     textColor:
//                         _isOnDuty ? AppColors.white : AppColors.BackgroundColor,
//                     fontSize: 14,
//                     lodingColor:
//                         _isOnDuty ? AppColors.white : AppColors.BackgroundColor,
//                     text: _isOnDuty ? 'on break' : 'Ready to take orders',
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 20),
//             Expanded(
//               child: GoogleMap(
//                 markers: markers.toSet(),
//                 initialCameraPosition: cameraPosition,
//                 mapType: MapType.normal,
//                 onMapCreated: (mapController) {
//                   gms = mapController;
//                 },
//                 onTap: (LatLng latLng) {
//                   markers.add(Marker(
//                     markerId: MarkerId("1"),
//                     position: LatLng(latLng.latitude, latLng.longitude),
//                   ));
//                   setState(() {});
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }
// }

// Ahamd code
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
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
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
        print('Failed to load user data: id or token is null');
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
        print('Received event: $event');
        if (event.contains('connection_established')) {
          await _authenticateWebSocket(event);
        }
        try {
          _handleWebSocketEvent(event);
        } catch (e) {
          print('Error decoding event: $e');
        }
      },
      onError: (error) {
        print('WebSocket error: $error');
        _isConnected = false;
        _attemptReconnect();
      },
      onDone: () {
        print('WebSocket connection closed');
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
    print('Socket ID1111: $socketId');

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
      print('Auth data: $authData');
      _channel.sink.add(jsonEncode({
        "event": "pusher:subscribe",
        "data": {
          "channel": "driver.$id",
          "auth": authData['auth'].toString(),
        },
      }));
    } else {
      print('Failed to authenticate: ${authResponse.body}');
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
      print('Accepted request data: ${decodedEvent['data']}');
    }
  }

  void _attemptReconnect() {
    if (!_isConnected) {
      _reconnectTimer = Timer(const Duration(seconds: 5), () {
        print('Trying to reconnect...');
        _connectToWebSocket();
      });
    }
  }

  Future<void> playNotificationSound() async {
    try {
      await _audioPlayer.setSource(AssetSource('sound/notification.mp3'));
      await _audioPlayer.resume();
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
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
    print('تم إرسال الموقع.');
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
        print('تم إرسال البيانات بنجاح.');
      } else {
        print('حدث خطأ: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('حدث خطأ أثناء إرسال البيانات: $e');
    }
  }

  // late WebSocketChannel _channel2;
  // String _receivedMessage = 'No message received yet';

  // int _reconnectAttempts = 0;
  // final int _maxReconnectAttempts = 5;
  // final Duration _reconnectDelay = Duration(seconds: 5);
  // @override
  // void initState() {
  //   super.initState();
  //   loadUserData();
  // }

  // Future<void> loadUserData2() async {
  //   Map<String, String?> userInfo = await UserPreferences.getUserInfo();

  //   setState(() {
  //     id = userInfo['id'];
  //     _token = userInfo['token'];
  //     _chat_id = userInfo['chat_id'];
  //     _customer_id = userInfo['customer_id'];
  //     if (id != null && _token != null) {
  //       _connectToWebSocket2();
  //     } else {
  //       print('Failed to load user data: id or token is null');
  //     }
  //   });
  // }

  // void _connectToWebSocket2() {
  //   _reconnectAttempts = 0; 
  //   _channel2 = WebSocketChannel.connect(
  //     Uri.parse(
  //       'ws://10.0.2.2:8080/app/ni31bwqnyb4g9pbkk7sn?protocol=7&client=js&version=4.3.1',
  //     ),
  //   );

  //   _channel2.stream.listen(
  //     (event) async {
  //       print('Received event: $event');

  //       // إذا تم تأسيس الاتصال
  //       if (event.contains('connection_established')) {
  //         final decodedEvent = jsonDecode(event);
  //         final decodeData = jsonDecode(decodedEvent['data']);
  //         final socketId = decodeData['socket_id'];
  //         print('Socket ID: $socketId'); 

  //         const authUrl = 'http://10.0.2.2:8000/api/broadcasting/auth';
  //         final authResponse = await http.post(
  //           Uri.parse(authUrl),
  //           headers: {
  //             'Authorization': 'Bearer $_token',
  //             'Accept': 'application/json',
  //             'Content-Type': 'application/json',
  //           },
  //           body: jsonEncode(
  //             {'channel_name': 'send-message.${_customer_id}', 'socket_id': socketId},
  //           ),
  //         );

  //         if (authResponse.statusCode == 200) {
  //           final authData = jsonDecode(authResponse.body);
  //           print('Auth data: $authData');
  //           _channel2.sink.add(jsonEncode({
  //             "event": "pusher:subscribe",
  //             "data": {
  //               "channel": "send-message.${_customer_id}",
  //               "auth": authData['auth'].toString(),
  //             },
  //           }));
  //         } else {
  //           print('Failed to authenticate: ${authResponse.body}');
  //         }
  //       }

  //       // معالجة الأحداث الأخرى
  //       try {
  //         final decodedEvent = jsonDecode(event);
  //         print('Decoded event3231: $decodedEvent');
  //         if (decodedEvent is Map<String, dynamic>) {
  //           print('Decoded event:212121 $decodedEvent');

  //           if (decodedEvent.containsKey('event') &&
  //               decodedEvent['event'] == 'sendMessage') {
  //             print('Decoded event:3131313 $decodedEvent');
  //             if (mounted) {
  //               setState(() {
  //                 final data = jsonDecode(decodedEvent['data']);

                  
  //                   Get.snackbar(
  //                     "",
  //                     'sssssssssssssssssss'.tr,
  //                     colorText: AppColors.white,
  //                   );
  //                   playNotificationSound();
                 
  //               });
  //             }
  //           }
  //         }
  //       } catch (e) {
  //         print('Error decoding event: $e');
  //       }
  //     },
  //     onError: (error) {
  //       print('WebSocket error: $error');
  //     },
  //     onDone: () {
  //       print('WebSocket connection closed');
  //       _reconnect();
  //     },
  //     cancelOnError: true,
  //   );
  // }

  // void _reconnect() {
  //   if (_reconnectAttempts < _maxReconnectAttempts) {
  //     _reconnectAttempts++;
  //     print('Attempting to reconnect... ($_reconnectAttempts)');
  //     Future.delayed(_reconnectDelay, () {
  //       _connectToWebSocket();
  //     });
  //   } else {
  //     print('Max reconnect attempts reached. Giving up.');
  //   }
  // }

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

  // @override
  // void dispose() {
  //   // _timer.cancel();
  //   _channel2.sink.close();
  //   super.dispose();
  // }
}



/*
  // void _connectToWebSocket() {
  //   _channel = WebSocketChannel.connect(
  //     Uri.parse(
  //         'ws://10.0.2.2:8080/app/ni31bwqnyb4g9pbkk7sn?protocol=7&client=js&version=4.3.1'),
  //   );
  //   _channel.stream.listen(
  //     (event) async {
  //       print('Received event: $event');
  //       // إذا تم تأسيس الاتصال
  //       if (event.contains('connection_established')) {
  //         final decodedEvent = jsonDecode(event);
  //         final decodeData = jsonDecode(decodedEvent['data']);
  //         final socketId = decodeData['socket_id'];
  //         print('Socket ID: $socketId'); // طباعة Socket ID
  //         const authUrl = 'http://10.0.2.2:8000/api/broadcasting/auth';
  //         final authResponse = await http.post(
  //           Uri.parse(authUrl),
  //           headers: {
  //             'Authorization': 'Bearer $_token',
  //             'Accept': 'application/json',
  //             'Content-Type': 'application/json'
  //           },
  //           body: jsonEncode(
  //               {'channel_name': 'driver.${id}', 'socket_id': socketId}),
  //         );
  //         if (authResponse.statusCode == 200) {
  //           final authData = jsonDecode(authResponse.body);
  //           print('Auth data: $authData');
  //           _channel.sink.add(jsonEncode({
  //             "event": "pusher:subscribe",
  //             "data": {
  //               "channel": "driver.${id}",
  //               "auth": authData['auth'].toString(),
  //             },
  //           }));
  //         } else {
  //           print('Failed to authenticate: ${authResponse.body}');
  //         }
  //       }
  //       final AudioPlayer _audioPlayer = AudioPlayer();
  //       // معالجة الأحداث الأخرى
  //       try {
  //         final decodedEvent = jsonDecode(event);
  //         print('Decoded event: $decodedEvent');
  //         if (decodedEvent is Map<String, dynamic>) {
  //           print('Decoded event:222 $decodedEvent');
  //           if (decodedEvent.containsKey('event') &&
  //               decodedEvent['event'] == 'acceptRequest') {
  //             print('Decoded event:333 $decodedEvent');
  //             if (mounted) {
  //               setState(() {
  //                 final data = jsonDecode(decodedEvent['data']);
  //                 // _receivedMessage = 'recived';
  //                 // notifications.add('تم قبول طلبك: ');
  //                 // Get.find<NotificationController>().addNotification('${decodedEvent['data']} تم  قبول طلبك' ,);
  //                 Get.snackbar('', 'تم إرسال طلب جديد إليك',
  //                     colorText: AppColors.BackgroundColor,
  //                     backgroundColor: AppColors.green1,
  //                     duration: Duration(seconds: 5), );
  //                 playNotificationSound();
  //               });
  //               print('Accepted request data: ${decodedEvent['data']}');
  //             }
  //           }
  //         }
  //       } catch (e) {
  //         print('Error decoding event: $e');
  //       }
  //     },
  //     onError: (error) {
  //       print('WebSocket error: $error');
  //     },
  //     onDone: () {
  //       print('WebSocket connection closed');
  //     },
  //     cancelOnError: true,
  //   );
  // }
 */


/*
// Khaled Code
import 'dart:async';
import 'dart:convert';
import 'package:driver_taxi/components/app_drawer.dart';
import 'package:driver_taxi/components/custom_loading_button.dart';
import 'package:driver_taxi/components22/custom_text.dart';
import 'package:driver_taxi/location/location.dart';
import 'package:driver_taxi/utils/app_colors.dart';
import 'package:driver_taxi/view/screen/notifications.dart';
import 'package:driver_taxi/view/screen/pusherConfig.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'dart:developer';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _isOnDuty = true;
  late Timer _timer;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  GoogleMapController? gms;
  List<Marker> markers = [];
  CameraPosition cameraPosition = const CameraPosition(
    target: LatLng(33.504307, 36.304141),
    zoom: 10.4746,
  );

  late PusherConfig _pusherConfig;


  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await getCurrentLocation();
      sendLocation();

      var userId = prefs.getString('userId');
      var authToken = prefs.getString('token');
      print(userId);
      print(authToken);

      if (userId == null || authToken == null) {
        print("لا يمكن العثور على userId أو token في SharedPreferences.");
        return;
      }

      _pusherConfig = PusherConfig();
      _pusherConfig.initPusher(onEvent,
          channelName: "private-driver", driver_id: userId);
    } catch (e) {
      print('فشل الاتصال بـ Pusher: $e');
    }
  }

  void onEvent(PusherEvent event) {
    log("event came: " + event.data.toString());
    try {
      log(event.eventName.toString());
      if (event.eventName == "accept-request") {
        log("here");
        _showAlert(context, "Request accepted: ${event.data}");
      }

      setState(() {});
    } catch (e) {
      log(e.toString());
    }
  }

  void _showAlert(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Notification"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
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

      // Add Marker on the map for the current location
      markers.add(Marker(
        markerId: const MarkerId("current_location"),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: const InfoWindow(title: 'موقعك الحالي'),
      ));

      // Move the camera to the current location
      gms?.animateCamera(CameraUpdate.newLatLng(
          LatLng(position.latitude, position.longitude)));

      setState(() {});
    }
  }

  void sendLocation() async {
    await LocationService.sendLocationToDatabase();
    print('تم إرسال الموقع.');
  }

  Future<void> sendStatusToDataBase(bool isOnDuty) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    String apiUrl = 'http://10.0.2.2:8000/api/drivers/change-state';
    int stateParam = isOnDuty ? 1 : 0;

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
        print('تم إرسال البيانات بنجاح.');
      } else {
        print('حدث خطأ.${response.statusCode}');
        print('حدث خطأ.${response.body}');
      }
    } catch (e) {
      throw Exception('حدث خطأ أثناء إرسال البيانات: $e');
    }
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
              text: 'Main Screen',
              fontSize: 18.sp,
              color: Colors.white,
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
                  text: "Orders",
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
                      sendStatusToDataBase(_isOnDuty);
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
                  text: _isOnDuty ? 'On Duty' : 'Off Duty',
                ),
              ],
            ),
          ),
          Expanded(
            child: GoogleMap(
              markers: Set<Marker>.of(markers),
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController controller) {
                gms = controller;
                _controller.complete(controller);
              },
              initialCameraPosition: cameraPosition,
            ),
          ),
        ],
      ),
    );
  }
}
*/