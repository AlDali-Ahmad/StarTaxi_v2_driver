// import 'package:driver_taxi/controller/onbording_controller.dart';
// import 'package:driver_taxi/core/contants/coloer.dart';
// import 'package:driver_taxi/data/datasource/static/static.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class CustomDotControllerOnBoarding extends StatelessWidget {
//   const CustomDotControllerOnBoarding({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<OnBoardingControllerImp>(
//       builder: (controller) => Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           ...List.generate(
//               onBoardingList.length,
//               (index) => AnimatedContainer(
//                     margin: const EdgeInsets.only(right: 3),
//                     duration: const Duration(milliseconds: 900),
//                     width: controller.currentPage == index ? 20 : 5,
//                     height: 6,
//                     decoration: BoxDecoration(color: AppColor.primaryColor),
//                   )),
//         ],
//       ),
//     );
//   }
// }
