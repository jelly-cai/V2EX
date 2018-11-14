import 'package:flutter/cupertino.dart';
import 'package:flutter_v2ex/common/style/item_text_style.dart';

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
        style: ItemTextHintStyle(),
      ),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 245, 245, 245),
      ),
    );
  }
}