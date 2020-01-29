import 'package:flutter/material.dart';
import 'package:isolates_test/home.dart';

class IsolateTestApp extends StatefulWidget {
  @override
  _IsolateTestAppState createState() => _IsolateTestAppState();
}

class _IsolateTestAppState extends State<IsolateTestApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Isolates Test',
      home: HomePage(),
    );
  }
}