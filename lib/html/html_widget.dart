import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:url_launcher/url_launcher.dart';

class HtmlWidget extends StatelessWidget {
  final String data;
  final Color defaultColor;
  final double defaultSize;
  final FontWeight defaultFontWeight;
  final FontStyle defaultFontStyle;
  final Function aClick;

  const HtmlWidget({
    Key key,
    this.data,
    this.defaultColor = Colors.black,
    this.defaultSize = 15.0,
    this.defaultFontWeight = FontWeight.normal,
    this.defaultFontStyle = FontStyle.normal,
    this.aClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return parseHtml();
  }

  parseHtml() {
    if (data == null || data.isEmpty) {
      return Container(child: Text(""));
    }
    dom.Document document = parse(data);
    dom.Element body = document.body;
    dom.NodeList nodes = body.nodes;
    List nodeParses = parseChildren(nodes);
    List<Widget> widgets = listToWidgetList(nodeParses);
    return Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.start,
        children: widgets);
  }

  ///list转换为List<Widget>
  List<Widget> listToWidgetList(List nodeParses) {
    List<Widget> widgets = [];
    int index = 0;
    for (int i = 0; i < nodeParses.length; i++) {
      if (nodeParses[i] is Widget) {
        widgets.add(
          RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              children: nodeParses.sublist(index, i).map((span) {
                if (span is TextSpan) {
                  return span;
                }
              }).toList(),
              style: getTextStyle(),
            ),
          ),
        );
        index = i + 1;
        widgets.add(nodeParses[i]);
      }
    }
    widgets.add(
      RichText(
        text: TextSpan(
          children: nodeParses.sublist(index, nodeParses.length).map((span) {
            if (span is TextSpan) {
              return span;
            }
          }).toList(),
          style: getTextStyle(),
        ),
      ),
    );
    return widgets;
  }

  List parseChildren(dom.NodeList nodes) {
    List list = [];
    for (int i = 0; i < nodes.length; i++) {
      dom.Node node = nodes[i];
      if (node.children.length == 0) {
        if (node is dom.Element) {
          list.addAll(parseNoChildNode(node));
        } else {
          list.add(
              TextSpan(text: node.text, style: TextStyle(color: defaultColor)));
        }
      } else {
        if (node is dom.Element) {
          list.addAll(parseChildNode(node));
        } else {
          list.addAll(parseChildren(node.nodes));
        }
      }
    }
    return list;
  }

  ///解析Li
  parseLi(dom.NodeList nodes) {
    List<Widget> widgets = [Text(nodes[0].parent.attributes["value"])];
    widgets.add(Expanded(child: listToWidgetList(parseChildren(nodes))[0]));
    return Padding(
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      ),
    );
  }

  ///解析有子节点的node
  parseChildNode(dom.Element node) {
    List list = [];
    if (node.localName == "p") {
      list.add(TextSpan(text: "\n"));
      list.addAll(parseChildren(node.nodes));
      list.add(TextSpan(text: "\n"));
    } else if (node.localName == "ul") {
      node.nodes.forEach((node) {
        if (node is dom.Element) {
          if (node.localName == "li") {
            node.attributes["value"] = "• ";
          }
        }
      });
      list.addAll(parseChildren(node.nodes));
    } else if (node.localName == "ol") {
      node.nodes.asMap().forEach((index, node) {
        if (node is dom.Element) {
          if (node.localName == "li") {
            node.attributes["value"] = "${index + 1}. ";
          }
        }
      });
      list.addAll(parseChildren(node.nodes));
    } else if (node.localName == "li") {
      list.add(parseLi(node.nodes));
    }
    return list;
  }

  ///解析没有子节点的node
  parseNoChildNode(dom.Element element){
    List list = [];
    if (element.localName == "br") {
      list.add(TextSpan(text: "\n", style: getTextStyle()));
    } else if (element.localName == "a") {
      list.add(GestureDetector(onTap: () async{
        await openUrl(element.attributes["href"]);
      },child: Text(
        element.text,
        style: TextStyle(
          color: Color(int.parse('0xFF1965B5')),
          decoration: TextDecoration.underline,
        ),
      )));
    } else if (element.localName == "img") {
      list.add(Image.network(element.attributes["src"]));
    } else if (element.localName == "em") {
      list.add(TextSpan(
        text: element.text,
        style: getTextStyle(fontStyle: FontStyle.italic),
      ));
    } else if (element.localName == "strong") {
      list.add(TextSpan(
        text: element.text,
        style: getTextStyle(fontWeight: FontWeight.bold),
      ));
    } else if (element.localName == "h2") {
      list.add(Padding(
        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(element.text, style: getTextStyle(fontSize: 18.0)),
            Divider()
          ],
        ),
      ));
    } else if (element.localName == "h3") {
      list.add(Padding(
        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(element.text, style: getTextStyle(fontSize: 17.0)),
            Divider()
          ],
        ),
      ));
    } else if (element.localName == "li") {
      list.add(Padding(
        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(element.attributes["value"]),
            Expanded(
              child: Text(element.text),
            )
          ],
        ),
      ));
    } else if (element.localName == "p") {
      list.add(TextSpan(text: "\n"));
      list.add(TextSpan(text: element.text, style: getTextStyle()));
      list.add(TextSpan(text: "\n"));
    }
    return list;
  }

  ///基于参数和默认值获得TextStyle
  getTextStyle(
      {Color color,
      double fontSize,
      FontWeight fontWeight,
      FontStyle fontStyle}) {
    return TextStyle(
      color: color == null ? defaultColor : color,
      fontSize: fontSize == null ? defaultSize : fontSize,
      fontWeight: fontWeight == null ? defaultFontWeight : fontWeight,
      fontStyle: fontStyle == null ? defaultFontStyle : fontStyle,
    );
  }

  ///打开网页
  openUrl(String url) async{
    if(await canLaunch(url)){
      await launch(url);
    }else{
      aClick(url);
    }
  }

}
