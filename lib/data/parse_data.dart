import 'dart:async';
import 'package:flutter_v2ex/bean/member_bean.dart';
import 'package:flutter_v2ex/bean/node_bean.dart';
import 'package:flutter_v2ex/bean/topic_bean.dart';
import 'package:html/dom.dart';
import 'package:html/dom_parsing.dart';
import 'package:html/parser.dart';
import 'package:html/parser_console.dart';


parseTopicContent(String htmlString){
  Document document = parse(htmlString);
  Element header = document.head;
  Element body = document.body;
  print(document.outerHtml);
}

///解析主题列表
Future<List<Topic>> parseTopics(String htmlString) async{
  Document document = parse(htmlString);
  Element body = document.body;
  List<Element> itemElements = body.querySelectorAll(".cell.item");
  return itemElements.map((itemElement) {
    Topic topic = Topic();
    Member member = Member();
    NodeBean node = NodeBean();
    //用户名
    Element memberElement = itemElement.querySelector("a");
    member.userName =
        memberElement.attributes['href'].replaceAll("/member/", "");
    //头像
    Element avatarElement = memberElement.querySelector("img");
    member.avatarNormal = avatarElement.attributes['src'];
    //nodeName
    Element nodeNameElement = itemElement.querySelector("a.node");
    node.name = nodeNameElement.attributes['href'].replaceAll("/go/", "");
    node.title = nodeNameElement.text;
    //主题
    Element itemTitleElement = itemElement.querySelector(".item_title");
    Element topicElement = itemTitleElement.children[0];
    topic.title = parseTitle(topicElement.text);
    List<String> topicStrings = topicElement.attributes["href"].split("#");
    topic.id = int.parse(topicStrings[0].replaceAll("/t/", ""));
    //回复数量
    topic.replies = int.parse(topicStrings[1].replaceAll("reply", ""));
    //时间
    Element lastModifiedElement = itemElement.querySelector("span.topic_info");
    List<String> createdStrings = lastModifiedElement.text.split("  •  ");
    if (createdStrings.length > 3) {
      topic.lastModifiedString = createdStrings[2].replaceAll(" ", "");
    }
    topic.member = member;
    topic.node = node;
    return topic;
  }).toList();
}

///解析标题
parseTitle(String title) {
  List<String> strings = title.split(" ");
  if (strings[strings.length - 1] is int) {
    return title.replaceAll(" " + strings[strings.length - 1], "");
  } else {
    return title;
  }
}
