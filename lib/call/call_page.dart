import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:helping_hand/constants/constants.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallPage extends StatefulWidget {
  const CallPage({
    Key? key,
    required this.callType,
    required this.callID,
    required this.userID,
    required this.userName,
    this.recipientUserId,
  }) : super(key: key);

  final String callType;
  final String userID;
  final String userName;
  final String callID;
  final String? recipientUserId;

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  ZegoUIKitPrebuiltCallController? callController;

  @override
  void initState() {
    super.initState();
    callController = ZegoUIKitPrebuiltCallController();
  }

  @override
  void dispose() {
    super.dispose();

    callController = null;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ZegoUIKitPrebuiltCall(
      appID: Constants.appId,
      appSign: Constants
          .appSign, // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
      userID: widget.userID,
      userName: widget.userName,
      callID: widget.callID,
      controller: callController!,
      // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
      config: widget.callType == 'video'
          ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
          : widget.callType == 'voice'
              ? ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()
              : ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
        ..layout = ZegoLayout.pictureInPicture(
          isSmallViewDraggable: true,
          smallViewSize: Size(width * 0.3, height * 0.3),
          smallViewMargin:
              EdgeInsets.only(top: height * 0.1, right: width * 0.05),
          smallViewPosition: ZegoViewPosition.bottomRight,
          showNewScreenSharingViewInFullscreenMode: true,
          spacingBetweenSmallViews:
              EdgeInsets.symmetric(horizontal: width * 0.05),
          switchLargeOrSmallViewByClick: true,
          showScreenSharingFullscreenModeToggleButtonRules:
              ZegoShowFullscreenModeToggleButtonRules.alwaysShow,
        )
        ..onHangUp = () async {
          await FirebaseFirestore.instance
              .collection('Call')
              .doc(widget.recipientUserId)
              .get()
              .then((doc) async {
            if (doc.exists) {
              await FirebaseFirestore.instance
                  .collection('Call')
                  .doc(widget.recipientUserId)
                  .delete();
            } else {
              await FirebaseFirestore.instance
                  .collection('Call')
                  .doc(widget.userID)
                  .get()
                  .then((doc) async {
                if (doc.exists) {
                  await FirebaseFirestore.instance
                      .collection('Call')
                      .doc(widget.userID)
                      .delete();
                }
              });
            }
          }).then((value) => Navigator.pop(context));
        },
    );
  }
}
