import 'package:flutter/material.dart';

class DebugInfoPage extends StatefulWidget {
  const DebugInfoPage({super.key});

  @override
  State<StatefulWidget> createState() => DebugInfoPageState();
}

class DebugInfoPageState extends State<DebugInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("デバッグ")),
        body: ListView(
          children: const [ListTile()],
        ));
  }
}
