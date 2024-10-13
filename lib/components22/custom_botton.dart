// import 'package:flutter/material.dart';

// class CustomButton extends StatelessWidget {
//   final VoidCallback onPressed;
//   final String text;
//   final Color startColor;
//   final Color endColor;
//   final Color textColor;
//   final double? width;
//   final bool showBorder;

//   const CustomButton({
//     Key? key,
//     required this.onPressed,
//     required this.text,
//     this.startColor = const Color.fromARGB(255, 90, 166, 237),
//     this.endColor = const Color.fromARGB(255, 18, 129, 255),
//     this.textColor = Colors.white,
//     this.width,
//     this.showBorder = false,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: width,
//       child: ElevatedButton(
//         onPressed: onPressed,
//         style: ElevatedButton.styleFrom(
//           padding: EdgeInsets.zero,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10.0),
//             side: showBorder
//                 ? BorderSide(
//                     color: Color.fromARGB(255, 0, 118, 235),
//                     width: 2.0,
//                   )
//                 : BorderSide.none,
//           ),
//           minimumSize: Size(150, 50),
//           elevation: 0,
//           textStyle: TextStyle(fontSize: 20),
//           animationDuration: Duration.zero,
//         ),
//         child: Ink(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [startColor, endColor],
//               begin: Alignment.bottomCenter,
//               end: Alignment.topCenter,
//             ),
//             borderRadius: BorderRadius.circular(10.0),
//           ),
//           child: Container(
//             constraints: BoxConstraints(minWidth: 150, minHeight: 50),
//             alignment: Alignment.center,
//             child: Text(
//               text,
//               style: TextStyle(
//                 color: textColor,
//                 fontSize: 17,
//                 fontFamily: 'Cairo',
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
