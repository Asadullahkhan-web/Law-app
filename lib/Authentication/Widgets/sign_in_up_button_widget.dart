// // ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

// import 'package:flutter/material.dart';

// class SignInUpButtonWidget extends StatelessWidget {
//   SignInUpButtonWidget({
//     super.key,
//     required this.btntextcolor,
//     required this.btnname,
//     required this.targetScreen,
//     this.btnBkgdColor,
//   });

//   Color btntextcolor;
//   String btnname;
//   final targetScreen;
//   var btnBkgdColor;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (context) => targetScreen,
//           ),
//         );
//       },
//       child: Container(
//         height: 53,
//         width: 320,
//         decoration: BoxDecoration(
//           color: btnBkgdColor,
//           borderRadius: BorderRadius.circular(30),
//           border: Border.all(color: Colors.white),
//         ),
//         child: Center(
//           child: Text(
//             btnname,
//             style: TextStyle(
//                 fontSize: 20, fontWeight: FontWeight.bold, color: btntextcolor),
//           ),
//         ),
//       ),
//     );
//   }
// }
