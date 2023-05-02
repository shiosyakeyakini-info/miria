import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DebugInfoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DebugInfoPageState();
}

class DebugInfoPageState extends State<DebugInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("デバッグ")),
        body: ListView(
          children: [ListTile()],
        ));
  }
}
