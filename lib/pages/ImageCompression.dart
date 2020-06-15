import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'package:image_picker/image_picker.dart' show ImagePicker, ImageSource;
import 'package:video_player/video_player.dart';



class ImageCompression extends StatefulWidget {
  @override
  _ImageCompressionState createState() => _ImageCompressionState();
}

class _ImageCompressionState extends State<ImageCompression> {
  final _flutterVideoCompress = FlutterVideoCompress();
  Subscription _subscription;

  Image _thumbnailFileImage;
  Image _gifFileImage;

  MediaInfo _originalVideoInfo = MediaInfo(path: '');
  MediaInfo _compressedVideoInfo = MediaInfo(path: '');
  String _taskName;
  double _progressState = 0;

  final _loadingStreamCtrl = StreamController<bool>.broadcast();

  @override
  void initState() {
    super.initState();
    _subscription =
        _flutterVideoCompress.compressProgress$.subscribe((progress) {
          setState(() {
            _progressState = progress;
          });
        });
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.unsubscribe();
    _loadingStreamCtrl.close();
  }

  Future<void> runFlutterVideoCompressMethods(File videoFile) async {
    _loadingStreamCtrl.sink.add(true);

    var _startDateTime = DateTime.now();
    print('[Compressing Video] on progress start');
    _taskName = '[Compressing Video .......]';
    final compressedVideoInfo = await _flutterVideoCompress.compressVideo(
      videoFile.path,
      quality: VideoQuality.MediumQuality,
      deleteOrigin: false,
    );
    _taskName = null;
    print(
        '[Compressing Video] done! ${DateTime
            .now()
            .difference(_startDateTime)
            .inSeconds}s');

    _startDateTime = DateTime.now();

    print('[Getting Thumbnail File] start');
    final thumbnailFile = await _flutterVideoCompress
        .getThumbnailWithFile(videoFile.path, quality: 50);
    print(
        '[Getting Thumbnail File] done! ${DateTime
            .now()
            .difference(_startDateTime)
            .inSeconds}s');

    print("******************$thumbnailFile");

    _startDateTime = DateTime.now();
    print('[Getting Gif File] start');
    _taskName = '[Getting Gif File]';


    final videoInfo = await _flutterVideoCompress.getMediaInfo(videoFile.path);

    setState(() {
      _thumbnailFileImage = Image.file(thumbnailFile);
      _originalVideoInfo = videoInfo;
      _compressedVideoInfo = compressedVideoInfo;
    });
    _loadingStreamCtrl.sink.add(false);
  }

  Widget _buildMaterialWarp(Widget body) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text("video and image compression"),
            actions: <Widget>[
              IconButton(
                onPressed: () async {
                  await _flutterVideoCompress.deleteAllCache();
                },
                icon: Icon(Icons.delete_forever),
              ),
            ],
          ),
          body: body),
    );
  } //'/data/user/0/com.example.LearningFlutter/cache/image_picker5142527956243551007.jpg'
  //'/storage/emulated/0/Android/data/com.example.LearningFlutter/files/Pictures/7c0522cf-9e64-4e38-98fe-09f31040fb1b8539505496066942093.mp4'

  Widget _buildRoundedRectangleButton(String text, ImageSource source) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Text(text, style: TextStyle(color: Colors.white)),
        color: Colors.grey[800],
        onPressed: () async {
           var image = await ImagePicker.pickVideo(source: source);
          if (image != null) {
            print("videoFile.toString()");
            print(image.toString());
            runFlutterVideoCompressMethods(image);
          }
        },
      ),
    );
  }

  String _infoConvert(MediaInfo info) {
    return 'path: ${info.path}\n'
        'duration: ${info.duration} microseconds\n'
        'size: ${info.filesize} bytes\n'
        'size: ${info.width} x ${info.height}\n'
        'orientation: ${info.orientation}°\n'
        'compression cancelled: ${info.isCancel}\n'
        'author: ${info.author}';
  }

  List<Widget> _buildInfoPanel(String title,
      {MediaInfo info, Image image, bool isVideoModel = false}) {
    if (info?.file == null && image == null && !isVideoModel) return [];
    return [
      if (!isVideoModel || info?.file != null)
        Card(
          child: ListTile(
            title: Text(title),
            dense: true,
          ),
        ),
      if (info?.file != null)
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(_infoConvert(info)),
        ),
      if (image != null) image,
      if (isVideoModel && info?.file != null) VideoPlayerView(file: info.file)
    ];
  }

  @override
  Widget build(context) {
    return _buildMaterialWarp(
      Stack(children: <Widget>[
        ListView(
          children: <Widget>[
            const SizedBox(height: 20),
            _buildRoundedRectangleButton(
              'Take video from camera with Image Picker',
              ImageSource.camera,
            ),
            _buildRoundedRectangleButton(
              'Take video from gallery with Image Picker',
              ImageSource.gallery,
            ),
            ..._buildInfoPanel(
              'Original video information',
              info: _originalVideoInfo,
            ),
            ..._buildInfoPanel(
              'Original video view',
              info: _originalVideoInfo,
              isVideoModel: true,
            ),
            ..._buildInfoPanel(
              'Compressed video information',
              info: _compressedVideoInfo,
            ),
            ..._buildInfoPanel(
              'Compressed video view',
              info: _compressedVideoInfo,
              isVideoModel: true,
            ),
            ..._buildInfoPanel(
              'Thumbnail image from file preview',
              image: _thumbnailFileImage,
            ),

          ].expand((widget) {
            if (widget is SizedBox || widget is Card) {
              return [widget];
            }
            return [widget, const SizedBox(height: 8)];
          }).toList(),
        ),
        StreamBuilder<bool>(
          stream: _loadingStreamCtrl.stream,
          builder: (context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.data == true) {
              return GestureDetector(
                onTap: () {
                  _flutterVideoCompress.cancelCompression();
                },
                child: Card(
                  child: Container(
                    color: Colors.black54,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        CircularProgressIndicator(),
                        if (_taskName != null)
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text('[$_taskName] $_progressState％'),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: const Text('click cancel...'),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
            return Container();
          },
        ),
      ]),
    );
  }


}

class VideoPlayerView extends StatefulWidget {
  VideoPlayerView({this.file});

  final File file;

  @override
  _VideoPlayerViewState createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.file)
      ..initialize().then((_) {
        setState(() {});
      })
      ..setVolume(1)
      ..play();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _controller.value.isPlaying
              ? _controller.pause()
              : _controller.play();
        });
      },
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                _controller.value.initialized
                    ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
                    : Container(),
                Icon(
                  _controller.value.isPlaying ? null : Icons.play_arrow,
                  size: 80,
                ),
              ],
            ),
            VideoProgressIndicator(
              _controller,
              allowScrubbing: true,
              colors: VideoProgressColors(
                playedColor: Color.fromRGBO(255, 255, 255, 0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
