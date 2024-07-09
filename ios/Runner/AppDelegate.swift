import UIKit
import Flutter
import mobileffmpeg

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller = window?.rootViewController as! FlutterViewController
        let streamChannel = FlutterMethodChannel(name: "com.example.rtsp_to_rtmp/stream",
                                                 binaryMessenger: controller.binaryMessenger)
        streamChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if call.method == "startStreaming" {
                let args = call.arguments as! [String: String]
                let rtspUrl = args["rtspUrl"]!
                let rtmpUrl = args["rtmpUrl"]!
                self.startStreaming(rtspUrl: rtspUrl, rtmpUrl: rtmpUrl)
                result("Streaming started")
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func startStreaming(rtspUrl: String, rtmpUrl: String) {
        let cmd = "-i \(rtspUrl) -f flv \(rtmpUrl)"
        MobileFFmpeg.executeAsync(cmd) { returnCode in
            if returnCode == RETURN_CODE_SUCCESS {
                print("Stream ended successfully")
            } else {
                print("Stream failed with return code \(returnCode)")
            }
        }
    }
}
