import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_gallery_saver/flutter_image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(
    MaterialApp(
      home: HomePage(),
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final imageSaver = ImageGallerySaver();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: Column(
          children: [
            Image.asset('assets/images/Icon-App.png'),
            FilledButton(
              onPressed: saveImage,
              child: Text('Save Image'),
            ),
            FilledButton(
              onPressed: saveImageFile,
              child: Text('Save Image File'),
            ),
            FilledButton(
              onPressed: saveVideoFile,
              child: Text('Save Video File'),
            ),
          ],
        ),
      ),
    );
  }

  void saveImage() async {
    try {
      final data = await rootBundle.load('assets/images/Icon-App.png');
      final bytes = data.buffer.asUint8List();

      await imageSaver.saveImage(bytes);

      showSuccessSnackBar();
    } catch (error) {
      showFailureSnackBar(error.toString());
    }
  }

  void saveImageFile() async {
    try {
      final data = await rootBundle.load('assets/images/Icon-App.png');
      final bytes = data.buffer.asUint8List();

      final dir = await getTemporaryDirectory();
      final filePath = '${dir.path}/Icon-App.png';
      final file = File(filePath);
      file.writeAsBytesSync(bytes);

      await imageSaver.saveFile(filePath);

      showSuccessSnackBar();
    } catch (error) {
      showFailureSnackBar(error.toString());
    }
  }

  void saveVideoFile() async {
    try {
      final data = await rootBundle.load('assets/videos/bee.mp4');
      final bytes = data.buffer.asUint8List();

      final dir = await getTemporaryDirectory();
      final filePath = '${dir.path}/bee.mp4';
      final file = File(filePath);
      file.writeAsBytesSync(bytes);

      await imageSaver.saveFile(filePath);

      showSuccessSnackBar();
    } catch (error) {
      showFailureSnackBar(error.toString());
    }
  }

  void showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Success'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void showFailureSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
