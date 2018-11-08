import 'package:flutter/material.dart';

class SimpleHtmlText extends StatelessWidget {
  final String data;

  const SimpleHtmlText({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    TextSpan textSpan = parseHtml(data);
    return RichText(
        text: TextSpan(
            style: TextStyle(color: Colors.black), children: [textSpan]));
  }

  parseHtml(String data) {
    if (data.isEmpty) {
      return TextSpan(text: null);
    }

    RegExp startExp = RegExp(
        r'^<([-A-Za-z0-9_]+)((?:\s+\w+(?:\s*=\s*(?:(?:"[^"]*")' +
            "|(?:'[^']*')|[^>\\s]+))?)*)\\s*(\/?)>");
    RegExp ignoreExp = RegExp("<\/?([-A-Za-z0-9_]+)[^>]*\/?>");
    RegExp attrExp = RegExp(
        r'([-A-Za-z0-9_]+)(?:\s*=\s*(?:(?:"((?:\\.|[^"])*)")' +
            r"|(?:'((?:\\.|[^'])*)')|([^>\s]+)))?");
    RegExp styleExp = RegExp(r'([a-zA-Z\-]+)\s*:\s*([^;]*)');
    RegExp colorExp = RegExp(r'^#([a-fA-F0-9]{6})$');
    int index = data.indexOf("<");
    TextSpan textSpan;

    if (data.startsWith("<")) {
      //解析标签
      Match matchStart = startExp.firstMatch(data);
      if (matchStart != null) {
        String tag = matchStart[0];
        data = data.substring(tag.length);
        if (tag == '<br>') {
          textSpan = parseHtml(data);
        } else {
          Map attrs = {};

          Iterable<Match> matches = attrExp.allMatches(matchStart[2]);

          if (matches != null) {
            for (Match match in matches) {
              String attribute = match[1];
              String value;

              if (match[2] != null) {
                value = match[2];
              } else if (match[3] != null) {
                value = match[3];
              } else if (match[4] != null) {
                value = match[4];
              }

              attrs[attribute] = value;
            }
          }
          if (attrs.length != 0 && attrs['style'] != null) {
            Color color = new Color(0xFF000000);
            FontWeight fontWeight = FontWeight.normal;
            FontStyle fontStyle = FontStyle.normal;
            TextDecoration textDecoration = TextDecoration.none;
            double fontSize = 12.0;
            String style = attrs['style'];
            matches = styleExp.allMatches(style);
            for (Match match in matches) {
              String param = match[1].trim();
              String value = match[2].trim();

              switch (param) {
                case 'color':
                  if (colorExp.hasMatch(value)) {
                    value = value.replaceAll('#', '').trim();
                    color = Color(int.parse('0xFF' + value));
                  }
                  break;
                case 'font-weight':
                  fontWeight =
                      (value == 'bold') ? FontWeight.bold : FontWeight.normal;
                  break;
                case 'font-style':
                  fontStyle =
                      (value == 'italic') ? FontStyle.italic : FontStyle.normal;
                  break;
                case 'text-decoration':
                  textDecoration = (value == 'underline')
                      ? TextDecoration.underline
                      : TextDecoration.none;
                  break;
                case 'font-size':
                  fontSize = double.parse(value);
                  break;
              }
            }
            textSpan = TextSpan(
                text: null,
                style: TextStyle(
                    fontSize: fontSize,
                    color: color,
                    fontWeight: fontWeight,
                    fontStyle: fontStyle,
                    decoration: textDecoration),
                children: [parseHtml(data)]);
          } else {
            textSpan = TextSpan(text: null, children: [parseHtml(data)]);
          }
        }
      } else {
        Match matchIgnore = ignoreExp.firstMatch(data);
        String tag = matchIgnore[0];
        data = data.substring(tag.length);
        textSpan = parseHtml(data);
      }
    } else {
      String text = data.substring(0, index);
      data = data.substring(index);
      textSpan = TextSpan(text: text, children: [parseHtml(data)]);
    }
    return textSpan;
  }
}
