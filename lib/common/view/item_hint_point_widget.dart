import 'package:flutter/material.dart';
import 'package:flutter_v2ex/common/style/item_text_style.dart';

///主题列表item中的分隔点
class ItemHintPointWidget extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Text("  •  ",style: ItemTextHintStyle());
  }

}