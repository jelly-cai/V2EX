import 'package:flutter/material.dart';

class ItemContentWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ItemContentWidgetState();
  }
}

class ItemContentWidgetState extends State {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("主题详情"),
      ),
      body: Text("123"),
    );
  }
}
