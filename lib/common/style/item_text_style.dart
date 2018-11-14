import 'package:flutter/material.dart';

///用于主题的item中使用粗体文字，名字等
class ItemTextBoldStyle extends TextStyle {
  ItemTextBoldStyle()
      : super(
            fontSize: 12.0,
            color: Color.fromARGB(255, 119, 128, 135),
            fontWeight: FontWeight.bold);
}

///主题的item中的浅色文字，时间，连接字符串等
class ItemTextHintStyle extends TextStyle {
  ItemTextHintStyle()
      : super(fontSize: 12.0, color: Color.fromARGB(255, 190, 190, 190));
}

///主题item的title样式
class ItemTextTitleStyle extends TextStyle {
  ItemTextTitleStyle()
      : super(fontSize: 15.0, color: Color.fromARGB(255, 119, 128, 135));
}
