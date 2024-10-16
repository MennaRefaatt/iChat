// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
//
// class AgoraService {
//   final String appId; // Your App ID from Agora
//   late RtcEngine _engine;
//
//   AgoraService(this.appId);
//
//   Future<void> init() async {
//     _engine = await RtcEngine.create(appId);
//     await _engine.enableAudio();
//     await _engine.enableVideo();
//   }
//
//   Future<void> joinChannel(String token, String channelName) async {
//     await _engine.joinChannel(token, channelName, null, 0);
//   }
//
//   Future<void> leaveChannel() async {
//     await _engine.leaveChannel();
//   }
//
//   void dispose() {
//     _engine.destroy();
//   }
// }