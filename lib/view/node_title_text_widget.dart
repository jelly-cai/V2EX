import 'package:flutter/cupertino.dart';

///Node标题
class NodeTitleTextWidget extends StatelessWidget {
  final String nodeTitle;

  const NodeTitleTextWidget({Key key, this.nodeTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.all(2.0),
      child: Text(
        nodeTitle,
        style: TextStyle(
          fontSize: 12.0,
          color: Color.fromARGB(255, 153, 153, 153),
        ),
      ),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 245, 245, 245),
      ),
    );
  }
}