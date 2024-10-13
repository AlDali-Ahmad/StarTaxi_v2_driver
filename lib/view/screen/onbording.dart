// import 'package:driver_taxi/controller/onbording_controller.dart';
// import 'package:driver_taxi/core/contants/coloer.dart';
// import 'package:driver_taxi/view/wedget/onbording/custombutton.dart';
// import 'package:driver_taxi/view/wedget/onbording/customslider.dart';
// import 'package:driver_taxi/view/wedget/onbording/dotcontroller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// class OnBoarding extends StatelessWidget {
//   const OnBoarding({Key? key}) : super(key: key);

//   Color get foreground => AppColor.grey;

//   @override
//   Widget build(BuildContext context) {

//     Get.put(OnBoardingControllerImp());

//     return const Scaffold(
//         body: SafeArea(
//             child: Column(
//       children: [
//         Expanded(
//           flex: 3,
//           child: CustomSliderOnBoarding(),
//         ),
//         Expanded(
//             flex: 1,
//             child: Column(
//               children: [
//                 CustomDotControllerOnBoarding(),
//                 Spacer(flex: 1),
//                 CustomButtonOnBoarding(),
//               ],
//             ))
//       ],
//     )));
//   }
// }
