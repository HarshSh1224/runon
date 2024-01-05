import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:runon/utils/app_methods.dart';
import 'package:runon/video_call/call_methods.dart';
import 'package:runon/video_call/call_model.dart';
import 'package:runon/video_call/call_utils.dart';
import 'package:runon/video_call/configs.dart' as agora_configs;
import 'package:runon/video_call/widgets/avatar.dart';
import 'package:runon/video_call/widgets/call_action_button.dart';
import 'package:runon/video_call/widgets/toolbar_button.dart';

class VideoCallScreen extends StatefulWidget {
  VideoCallScreen({required this.call, super.key});
  final Call call;
  final callMethods = CallMethods();

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  late StreamSubscription callStreamSubscription;
  late String appointmentId;
  String? token;
  int? _remoteUid;
  bool _isCurrentUserJoined = false;
  late RtcEngine agoraEngine;
  int uid = 0;
  bool agoraIsInitialized = false;
  bool audioMuted = false;
  bool videoMuted = false;
  bool remoteVideoMuted = true;

  @override
  void initState() {
    super.initState();
    appointmentId = widget.call.appointment.appointmentId;
    addPostFrameCallback(); // Subscribe to Firebase vaudeo collection stream
    setupVideoSDKEngine(); // Init Agora
  }

  showMessage(String message) {
    AppMethods.showSnackbar(context, message);
  }

  @override
  void dispose() {
    widget.callMethods.endCall(call: widget.call);
    if (agoraIsInitialized) {
      Future.delayed(Duration.zero, () async {
        await agoraEngine.leaveChannel();
        await agoraEngine.release();
      });
    }
    callStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: <Widget>[
            _viewColumn(),
            _toolbar(),
          ],
        ),
      ),
    );
  }

  addPostFrameCallback() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callStreamSubscription =
          widget.callMethods.callStream(uid: appointmentId).listen((DocumentSnapshot snapshot) {
        if (snapshot.data() == null) {
          Navigator.pop(context);
        }
      });
    });
  }

  Future<void> setupVideoSDKEngine() async {
    await [Permission.microphone, Permission.camera].request();

    try {
      token = await CallUtilities.getToken(
        channelId: widget.call.channelId,
      );
    } catch (e) {
      showMessage("Error Occurred. Please Retry");
      widget.callMethods.endCall(call: widget.call);
    }
    if (token == null) {
      showMessage("Error Occurred. Please Retry");
      widget.callMethods.endCall(call: widget.call);
    }

    if (mounted) {
      agoraEngine = createAgoraRtcEngine();
      await agoraEngine.initialize(const RtcEngineContext(appId: agora_configs.appId));
      VideoEncoderConfiguration videoConfig = VideoEncoderConfiguration(
        dimensions:
            VideoDimensions(width: agora_configs.videoWidth, height: agora_configs.videoHeight),
        frameRate: agora_configs.frameRate,
        bitrate: agora_configs.bitrate,
      );

      agoraIsInitialized = true;

      agoraEngine.setVideoEncoderConfiguration(videoConfig);

      await agoraEngine.enableVideo();

      agoraEngine.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            // Local User Joins the Channel
            showMessage('Channel joined');
            setState(() {
              _isCurrentUserJoined = true;
            });
          },
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            // Remote user joins the channel
            showMessage('Remote user joined');
            setState(() {
              _remoteUid = remoteUid;
            });
          },
          onRemoteVideoStateChanged: (connection, remoteUid, state, reason, elapsed) {
            // Show Avatar When Remote video is stopped/muted/frozen
            showMessage('Remote video state changed');
            if (state == RemoteVideoState.remoteVideoStateStopped ||
                state == RemoteVideoState.remoteVideoStateFrozen ||
                state == RemoteVideoState.remoteVideoStateFailed) {
              setState(() {
                remoteVideoMuted = true;
              });
            } else {
              setState(() {
                remoteVideoMuted = false;
              });
            }
          },
          onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
            // End call if Remote user loses connection
            showMessage('Remote user exited');
            setState(() {
              _remoteUid = null;
            });
            widget.callMethods.endCall(call: widget.call);
          },
        ),
      );
      joinChannel();
    }
  }

  void joinChannel() async {
    await agoraEngine.startPreview();

    ChannelMediaOptions options = const ChannelMediaOptions(
      clientRoleType: ClientRoleType.clientRoleBroadcaster,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    );

    await agoraEngine.joinChannel(
      token: token!,
      channelId: widget.call.channelId,
      options: options,
      uid: uid,
    );
  }

  Widget _viewColumn() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(child: _remoteVideo()),
        Expanded(child: _localPreview()),
      ],
    );
  }

  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ToolbarButton(
            icon: audioMuted ? Icons.mic_off : Icons.mic,
            toggleWith: audioMuted,
            onPressed: _onToggleMute,
            isDisabled: !_isCurrentUserJoined,
          ),
          ToolbarButton(
            onPressed: _onToggleVideo,
            icon: videoMuted ? Icons.videocam_off_rounded : Icons.videocam,
            toggleWith: videoMuted,
            isDisabled: !_isCurrentUserJoined,
          ),
          ToolbarButton(
            onPressed: _onSwitchCamera,
            icon: Icons.switch_camera,
            toggleWith: false,
            isDisabled: !_isCurrentUserJoined,
          ),
          Padding(
            padding: const EdgeInsets.all(30),
            child: CallActionButton(
              onTap: () => widget.callMethods.endCall(call: widget.call),
              size: 60,
            ),
          ),
        ],
      ),
    );
  }

  void _onToggleMute() {
    setState(() {
      audioMuted = !audioMuted;
    });
    agoraEngine.muteLocalAudioStream(audioMuted);
  }

  void _onSwitchCamera() {
    agoraEngine.switchCamera();
  }

  void _onToggleVideo() {
    setState(() {
      videoMuted = !videoMuted;
    });
    agoraEngine.muteLocalVideoStream(videoMuted);
  }

  Widget _noVideoAvatar({required String image, required title}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          VideoCallAvatar(
            networkImage: image,
            widgetSize: VideoCallAvatarSize.small,
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _localPreview() {
    return Container(
      alignment: Alignment.center,
      child: _isCurrentUserJoined
          ? videoMuted
              ? _noVideoAvatar(
                  image: '',
                  title: 'First Last',
                )
              : AgoraVideoView(
                  controller: VideoViewController(
                    rtcEngine: agoraEngine,
                    canvas: const VideoCanvas(uid: 0),
                  ),
                )
          : const Text(
              "Joining Channel",
              style: TextStyle(
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
    );
  }

  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return remoteVideoMuted
          ? _noVideoAvatar(
              image: '',
              title: 'First Last',
            )
          : AgoraVideoView(
              controller: VideoViewController.remote(
                rtcEngine: agoraEngine,
                canvas: VideoCanvas(uid: _remoteUid),
                connection: RtcConnection(channelId: widget.call.channelId),
              ),
            );
    } else {
      String msg = "Awaiting Client";
      return Center(
          child: Text(
        msg,
        style: const TextStyle(
          color: Colors.white,
        ),
      ));
    }
  }
}
