import 'package:flutter/material.dart';
import 'package:object_zoom/screens/HomePage/home_page.dart';
import 'package:object_zoom/states/object_detect_state.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Object Zoom',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider(
        create: (context) => ObjectDetectState(),
        child: const HomePage()
      )
    );
  }
}
