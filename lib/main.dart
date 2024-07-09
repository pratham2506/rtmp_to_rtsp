import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('RTSP to RTMP Stream')),
        body: StreamForm(),
      ),
    );
  }
}

class StreamForm extends StatefulWidget {
  @override
  _StreamFormState createState() => _StreamFormState();
}

class _StreamFormState extends State<StreamForm> {
  static const platform = MethodChannel('com.example.rtsp_to_rtmp/stream');

  final TextEditingController _rtspController = TextEditingController();
  final TextEditingController _rtmpController = TextEditingController();

  Future<void> _startStreaming() async {
  try {
    print("Invoking startStreaming method on platform channel");
    final String result = await platform.invokeMethod('startStreaming', {
      'rtspUrl': _rtspController.text,
      'rtmpUrl': _rtmpController.text,
    });
    print("Platform response: $result");
  } on PlatformException catch (e) {
    print("Failed to start streaming: '${e.message}'.");
  } catch (e) {
    print("Unexpected error: $e");
  }
}


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          TextField(
            controller: _rtspController,
            decoration: InputDecoration(labelText: 'RTSP URL'),
          ),
          TextField(
            controller: _rtmpController,
            decoration: InputDecoration(labelText: 'RTMP URL'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _startStreaming,
            child: Text('Start Streaming'),
          ),
        ],
      ),
    );
  }
}
