
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_compress/video_compress.dart';



class VideoCompression extends StatefulWidget {
  @override
  _VideoCompressionState createState() => _VideoCompressionState();
}

class _VideoCompressionState extends State<VideoCompression> {

  String _counter = "video";
  File _thumbnailpath;
  bool _visibility = false;

  @override
  void initState() {
    super.initState();
    _visibility = false;
  }

  void showimage(){
    setState(() {
      _visibility = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Video Compression"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          File file = await ImagePicker.pickVideo(source: ImageSource.gallery);
          final info = await VideoCompress.compressVideo(
            file.path,
            quality: VideoQuality.LowQuality,
            deleteOrigin: false,
          );

          _counter = info.path;
          File thumb = await VideoCompress.getFileThumbnail(
              info.path,
              quality: 50,
            position: -1
          );

          setState(() {
            _thumbnailpath = thumb;
            print(_thumbnailpath);
          });
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
