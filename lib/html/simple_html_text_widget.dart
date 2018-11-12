import 'package:flutter/material.dart';

class SimpleHtmlText extends StatelessWidget {
  final String data;

  ///默认的TextStyle
  final TextStyle defaultStyle;

  const SimpleHtmlText({Key key, this.data, this.defaultStyle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    TextSpan textSpan = parseHtml(data, null);
    return RichText(
        text: TextSpan(
            style: defaultStyle, children: [textSpan]));
  }

  parseHtml(String data, TextStyle style) {
    if(data == null){
      return TextSpan(text: "");
    }
    int index = data.indexOf("<");
    if (data.isEmpty || index < 0) {
      return TextSpan(text: data);
    }

    RegExp startExp = RegExp(
        r'^<([-A-Za-z0-9_]+)((?:\s+\w+(?:\s*=\s*(?:(?:"[^"]*")' +
            "|(?:'[^']*')|[^>\\s]+))?)*)\\s*(\/?)>");
    RegExp ignoreExp = RegExp("<\/?([-A-Za-z0-9_]+)[^>]*\/?>");
    RegExp attrExp = RegExp(
        r'([-A-Za-z0-9_]+)(?:\s*=\s*(?:(?:"((?:\\.|[^"])*)")' +
            r"|(?:'((?:\\.|[^'])*)')|([^>\s]+)))?");
    TextSpan textSpan;

    if (data.startsWith("<")) {
      //解析标签
      Match matchStart = startExp.firstMatch(data);
      if (matchStart != null) {
        String tag = matchStart[0];
        String tagName = matchStart[1];
        data = data.substring(tag.length);
        if (tag == '<br>') {
          textSpan = parseHtml(data, null);
        } else {
          TextStyle textStyle = parseTagStyle(tagName);
          textSpan = TextSpan(
              text: "",
              style: textStyle,
              children: [parseHtml(data, null)]);
        }
      } else {
        Match matchIgnore = ignoreExp.firstMatch(data);
        String tag = matchIgnore[0];

        data = data.substring(tag.length);
        data = parseEndWrapTag(data,tag);

        TextStyle textStyle = parseEndStyleTag(tag);

        textSpan = parseHtml(data, textStyle);
      }
    } else{
      String text = data.substring(0, index);
      data = data.substring(index);
      textSpan =
          TextSpan(text: text, style: style, children: [parseHtml(data, null)]);
    }
    return textSpan;
  }

  ///结束特殊样式标签处理,需要把后面的恢复原样
  parseEndStyleTag(String tag){
    TextStyle textStyle;
    if (tag == "</strong>") {
      textStyle = TextStyle(fontWeight: defaultStyle.fontWeight);
    }else if(tag == "</a>"){
      textStyle = TextStyle(color: defaultStyle.color,decoration: defaultStyle.decoration);
    }
    return textStyle;
  }

  ///结束空格标签的处理
  parseEndWrapTag(String data,String tag){
    if (tag == "</p>") {
      data = "\n" + data;
    } else if (tag == "</h2>") {
      data = "\n" + data;
    } else if(tag == "</h3>"){
      data = "\n" + data;
    }
    return data;
  }

  ///解析特殊tag
  parseTagStyle(String tag) {
    Color color;
    FontWeight fontWeight;
    FontStyle fontStyle;
    TextDecoration textDecoration;
    double fontSize;

    switch (tag) {
      case 'a':
        color = new Color(int.parse('0xFF1965B5'));
        textDecoration = TextDecoration.underline;
        break;
      case 'b':
      case 'strong':
        fontWeight = FontWeight.bold;
        color = Colors.black;
        break;
      case 'i':
      case 'em':
        fontStyle = FontStyle.italic;
        break;
      case 'u':
        textDecoration = TextDecoration.underline;
        break;
      case 'h2':
        fontSize = 18.0;
        fontWeight = FontWeight.w500;
        color = Colors.black;
        break;
      case 'h3':
        fontSize = 17.0;
        fontWeight = FontWeight.w500;
        color = Colors.black;
        break;
      case 'p':
        color = defaultStyle.color;
        fontWeight = defaultStyle.fontWeight;
        fontStyle = defaultStyle.fontStyle;
        textDecoration = defaultStyle.decoration;
        fontSize = defaultStyle.fontSize;
        break;
    }

    return TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        decoration: textDecoration);
  }
}
