import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(
      const MaterialApp(
        title: 'Video Demo',
        home: VideoApp(),
      ),
    );

class VideoApp extends StatefulWidget {
  const VideoApp({Key? key}) : super(key: key);

  @override
  VideoAppState createState() => VideoAppState();
}

class VideoAppState extends State<VideoApp> {
  late VideoPlayerController _controller;
  late MediaQueryData mediaQueryData;

  @override
  void initState() {
    super.initState();
    final options = VideoPlayerOptions(allowBackgroundPlayback: true);
    _controller = VideoPlayerController.network(
        'https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_10mb.mp4',
        videoPlayerOptions: options)
      ..initialize().then((_) {
        _controller.play();
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(),
          TextButton(
              onPressed: () => {onPip(mediaQueryData)},
              child: const Text("PIP"))
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    // _controller.dispose();
  }

  void onPip(MediaQueryData mediaQueryData) async {
    if (!Platform.isIOS) return;
    await _controller.pause();
    final MediaQueryData data = mediaQueryData;
    EdgeInsets paddingSafeArea = data.padding;
    double widthScreen = data.size.width;
    _controller.setPIP(true,
        left: 0, top: paddingSafeArea.top, width: 640, height: 360);
    _controller.play();
  }
}
