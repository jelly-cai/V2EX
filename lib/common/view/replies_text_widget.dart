import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///回复数量显示
class RepliesTextWidget extends StatelessWidget {
  final int replies;

  const RepliesTextWidget({Key key, this.replies}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (replies == null || replies <= 0) {
      return Container();
    } else {
      return Container(
        padding: EdgeInsets.only(left: 5.0, right: 5.0),
        alignment: Alignment.center,
        child: Text(
          replies.toString(),
          style: TextStyle(fontSize: 10.0, color: Colors.white),
        ),
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 170, 176, 198),
            borderRadius: BorderRadius.circular(5.0)),
      );
    }
  }
}