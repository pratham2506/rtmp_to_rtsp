package com.example.rtsp_to_rtmp

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.arthenica.mobileffmpeg.Config
import com.arthenica.mobileffmpeg.FFmpeg

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.rtsp_to_rtmp/stream"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
       MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
    call, result ->
    if (call.method == "startStreaming") {
        val rtspUrl = call.argument<String>("rtspUrl")
        val rtmpUrl = call.argument<String>("rtmpUrl")
        println("Received RTSP URL: $rtspUrl")
        println("Received RTMP URL: $rtmpUrl")
        startStreaming(rtspUrl, rtmpUrl)
        result.success("Streaming started")
    } else {
        result.notImplemented()
    }
}

    }

    private fun startStreaming(rtspUrl: String?, rtmpUrl: String?) {
        val cmd = "-fflags nobuffer -flags low_delay -strict experimental -i rtsp://192.168.144.123:554 -c:v copy -bufsize 10k -use_wallclock_as_timestamps 1 -f flv rtmp://131b62225f9b.global-contribute.live-video.net/app/sk_ap-south-1_qH37GBPgWHln_IBiU6O79SSj6j4My4AsrrinbvpaDxi"
        FFmpeg.executeAsync(cmd) { executionId, returnCode ->
            if (returnCode == Config.RETURN_CODE_SUCCESS) {
                println("Stream ended successfully")
            } else {
                println("Stream failed with return code $returnCode")
            }
        }
    }
}
