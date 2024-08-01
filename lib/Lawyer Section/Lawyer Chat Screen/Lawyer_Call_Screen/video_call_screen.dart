import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lawyers_application/Utilities/call_information.dart';

import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

final userId = Random().nextInt(9999);

class VideoCallScreen extends StatelessWidget {
  const VideoCallScreen(
      {super.key,
      required this.userId,
      required this.userName,
      required this.callID});

  final String userId;
  final String userName;
  final String callID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ZegoUIKitPrebuiltCall(
          appID: CallInformation
              .appId, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
          appSign: CallInformation
              .appSignIn, // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
          userID: userId,
          userName: userName,
          callID: callID.toString(),
          // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
          config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
        ),
      ),
    );
  }
}
