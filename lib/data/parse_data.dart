import 'dart:async';
import 'package:flutter_v2ex/bean/member_bean.dart';
import 'package:flutter_v2ex/bean/node_bean.dart';
import 'package:flutter_v2ex/bean/node_list_bean.dart';
import 'package:flutter_v2ex/bean/reply_bean.dart';
import 'package:flutter_v2ex/bean/topic_bean.dart';
import 'package:flutter_v2ex/bean/topic_content_bean.dart';
import 'package:flutter_v2ex/bean/user_info_bean.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

///解析node中的主题列表
parseNodeList(String htmlString) async{
  Document document = parse(htmlString);
  Element body = document.body;
  NodeListBean nodeList = NodeListBean();
  //node
  NodeBean node = NodeBean();
  Element nodeHeaderElement = body.querySelector(".node_header");
  if(nodeHeaderElement != null){
    //头像
    Element imgElement = nodeHeaderElement.querySelector("img");
    if(imgElement != null){
      node.avatarNormal = imgElement.attributes['src'];
    }
    //主题总数
    Element topicsElement = nodeHeaderElement.querySelector("div.fr.f12");
    if(topicsElement != null){
      node.topics = int.parse(topicsElement.text.replaceAll("主题总数", ""));
    }
    //node信息
    Element infoElement = nodeHeaderElement.querySelector("span.f12");
    if(infoElement != null){
      node.info = infoElement.text;
    }
  }
  nodeList.node = node;
  //页码
  Element inputElement = body.querySelector(".page_input");
  if(inputElement != null){
    nodeList.currPage = int.parse(inputElement.attributes["value"]);
    nodeList.totalPage = int.parse(inputElement.attributes["max"]);
  }
  List<Element> tableElements = body.querySelectorAll("div.cell table");
  tableElements = tableElements.sublist(2,tableElements.length - 2);
  List<Topic> topics = tableElements.map((element){
    Topic topic = Topic();
    Member member = Member();
    //头像
    Element avatarElement = element.querySelector(".avatar");
    if(avatarElement != null){
      member.avatarNormal = avatarElement.attributes["src"];
    }
    //标题
    Element itemTitleElement = element.querySelector(".item_title");
    if(itemTitleElement != null){
      topic.title = itemTitleElement.text;
    }
    Element smallFadeElement = element.querySelector(".small.fade");
    if(smallFadeElement != null){
      List<String> infoStrings = smallFadeElement.text.split("  •  ");
      //发帖用户名
      if(infoStrings.length > 0){
        member.userName = infoStrings[0];
      }
      //最后修改时间
      if(infoStrings.length > 1){
        topic.lastModifiedString = infoStrings[1];
      }
      //最后回复人
      if(infoStrings.length > 2){
        topic.lastReply = infoStrings[2].replaceAll("最后回复来自 ", "");
      }
    }
    Element repliesElement = element.querySelector(".count_livid");
    if(repliesElement != null){
      topic.replies = int.parse(repliesElement.text);
    }
    topic.member = member;
    return topic;
  }).toList();
  nodeList.topics = topics;
  return nodeList;
}

///解析用户信息
Future<UserInfo> parseUserInfo(String htmlString) async{
  Document document = parse(htmlString);
  Element body = document.body;
  UserInfo userInfo = UserInfo();
  Member member = Member();
  Element cellElement = body.querySelector("div.cell table");
  //头像
  Element avatarElement = cellElement.querySelector("img.avatar");
  if(avatarElement != null){
    member.avatarNormal = avatarElement.attributes["src"];
  }
  //姓名
  Element nameElement = cellElement.querySelector("h1");
  if(nameElement != null){
    member.userName = nameElement.text;
  }
  //info
  Element infoElement = cellElement.querySelector("span.gray");
  if(infoElement != null){
    member.info = infoElement.text;
  }
  userInfo.member = member;
  //回复列表
  List<Element> cellItemElement = body.querySelectorAll(".cell.item");
  List<Topic> topics = cellItemElement.map((element){
    Topic topic = Topic();
    NodeBean node = NodeBean();
    Member member = Member();
    Element titleElement = element.querySelector("a");
    if(titleElement != null){
      topic.title = titleElement.text;
      List<String> titleStrings = titleElement.attributes['href'].split("#");
      if(titleStrings.length > 1){
        topic.id = int.parse(titleStrings[0].replaceAll("/t/", ""));
        topic.replies = int.parse(titleStrings[1].replaceAll("reply", ""));
      }
    }
    Element infoElement = element.querySelector(".topic_info");
    if(infoElement != null){
      List<String> infoStrings = infoElement.text.split("  •  ");
      if(infoStrings.length > 0){
        node.title = parseNodeTitle(contentTrim(infoStrings[0]));
      }
      if(infoStrings.length > 1){
        member.userName = contentTrim(infoStrings[1]);
      }
      if(infoStrings.length > 2){
        topic.createdString = contentTrim(infoStrings[2]);
      }
      if(infoStrings.length > 3){
        topic.lastReply = contentTrim(infoStrings[3]).replaceAll("最后回复来自", "");
      }
    }
    topic.member = member;
    topic.node = node;
    return topic;
  }).toList();
  userInfo.topics = topics;
  return userInfo;
}

///解析主题内容和回复列表
parseTopicContentAndReplies(String htmlString) async{
  Document document = parse(htmlString);
  Element body = document.body;
  TopicContent content = TopicContent();

  Element pageInputElement = body.querySelector(".page_input");
  if(pageInputElement != null){
    content.currentPage = int.parse(pageInputElement.attributes["value"]);
    content.totalPage = int.parse(pageInputElement.attributes['max']);
  }else{
    content.currentPage = 1;
    content.totalPage = 1;
  }

  Topic topic = await parseTopicContent(body: body);
  List<Reply> replies = await parseTopicReplies(body: body,isEnd: content.totalPage == 1 ? false : true);
  content.topic = topic;
  content.replies = replies;
  return content;
}

///解析回复列表
parseTopicReplies({String htmlString,Element body,bool isEnd}) async{
  if(body == null){
    Document document = parse(htmlString);
    body = document.body;
  }
  List<Element> tableElements = body.querySelectorAll("div.cell table");
  tableElements = tableElements.sublist(isEnd ? 2 : 0, isEnd ? tableElements.length - 2 : tableElements.length);
  return tableElements.map((element){
    Reply reply = Reply();
    Member member = Member();
    //头像
    Element avatarElement = element.querySelector("img.avatar");
    if(avatarElement != null){
      member.avatarNormal = avatarElement.attributes["src"];
    }
    //内容
    Element contentElement = element.querySelector("div.reply_content");
    if(contentElement != null){
      reply.content = contentElement.text;
      reply.contentRendered = contentElement.innerHtml.replaceAll("@\n", "");
    }
    //名称
    Element userNameElements = element.querySelector("a.dark");
    if(userNameElements != null){
      member.userName = userNameElements.attributes["href"].replaceAll("/member/", "");
    }
    //时间
    Element createdElements = element.querySelector("span.ago");
    if(createdElements != null){
      reply.createdString = createdElements.text;
    }
    reply.member = member;
    return reply;
  }).toList();
}

///解析主题内容
parseTopicContent({String htmlString,Element body}) async{
  if(body == null){
    Document document = parse(htmlString);
    body = document.body;
  }
  Element headerElement = body.querySelector(".header");
  Topic topic = Topic();
  Member member = Member();
  NodeBean node = NodeBean();
  //id
  Element idElement = headerElement.querySelector(".votes");
  if(idElement != null){
    List<String> idStrings = idElement.attributes["id"].split("_");
    if(idStrings.length > 2){
      topic.id = int.parse(idStrings[1]);
    }
  }
  //头像
  Element avatarElement = headerElement.querySelector("img.avatar");
  if (avatarElement != null) {
    member.avatarNormal = avatarElement.attributes['src'];
  }
  //会员名
  Element memberElement = headerElement.querySelector("a");
  if (memberElement != null) {
    member.userName =
        memberElement.attributes['href'].replaceAll("/member/", "");
  }
  //node名称和标题
  List<Element> aElements = headerElement.querySelectorAll("a");
  if (aElements != null && aElements.length > 2) {
    Element nodeElement = aElements[2];
    node.name = nodeElement.attributes['href'].replaceAll("/go/", "");
    node.title = nodeElement.text;
  }
  //主题标题
  Element hElement = headerElement.querySelector("h1");
  if (hElement != null) {
    topic.title = hElement.text;
  }
  //时间created
  Element createdElement = headerElement.querySelector(".gray");
  if (createdElement != null) {
    List<String> createdStrings = createdElement.text.split(" · ");
    if (createdStrings.length >= 2) {
      topic.createdString = createdStrings[1];
    }
  }
  //内容
  Element contentElement = body.querySelector(".topic_content");
  if (contentElement != null) {
    Element markDownElement = contentElement.querySelector(".markdown_body");
    if (markDownElement != null) {
      topic.content = markDownElement.text;
      topic.contentRendered = markDownElement.innerHtml;
      if (topic.contentRendered == null) {
        topic.contentRendered = markDownElement.outerHtml;
      }
    } else {
      topic.content = contentElement.text;
      topic.contentRendered = contentElement.innerHtml;
      if (topic.contentRendered == null) {
        topic.contentRendered = contentElement.outerHtml;
      }
    }
  }
  //回复数
  Element repliesElement = body.querySelector("span.gray");
  if (repliesElement != null) {
    List<String> repliesStrings = repliesElement.text.split("  |  ");
    if (repliesStrings.length == 2) {
      String replyContent = repliesStrings[0].replaceAll("回复", "").trim();
      topic.replies = int.parse(replyContent);
    }
  }
  topic.member = member;
  topic.node = node;
  return topic;
}

///解析主题列表
Future<List<Topic>> parseTopics({String htmlString,Element body}) async {
  if(body == null){
    Document document = parse(htmlString);
    body = document.body;
  }
  List<Element> itemElements = body.querySelectorAll(".cell.item");
  return itemElements.map((itemElement) {
    Topic topic = Topic();
    Member member = Member();
    NodeBean node = NodeBean();
    //用户名
    Element memberElement = itemElement.querySelector("a");
    if (memberElement != null) {
      member.userName =
          memberElement.attributes['href'].replaceAll("/member/", "");
    }
    //头像
    Element avatarElement = memberElement.querySelector("img");
    if (avatarElement != null) {
      member.avatarNormal = avatarElement.attributes['src'];
    }
    //nodeName
    Element nodeNameElement = itemElement.querySelector("a.node");
    if (nodeNameElement != null) {
      node.name = nodeNameElement.attributes['href'].replaceAll("/go/", "");
      node.title = nodeNameElement.text;
    }
    //主题
    Element itemTitleElement = itemElement.querySelector(".item_title");
    if (itemTitleElement != null) {
      Element topicElement = itemTitleElement.querySelector("a");
      topic.title = parseTitle(topicElement.text);
      List<String> topicStrings = topicElement.attributes["href"].split("#");
      topic.id = int.parse(topicStrings[0].replaceAll("/t/", ""));
      //回复数量
      topic.replies = int.parse(topicStrings[1].replaceAll("reply", ""));
    }
    //时间
    Element lastModifiedElement = itemElement.querySelector("span.topic_info");
    if (lastModifiedElement != null) {
      List<String> createdStrings = lastModifiedElement.text.split("  •  ");
      if (createdStrings.length > 3) {
        topic.lastModifiedString = contentTrim(createdStrings[2]);
      }
    }
    topic.member = member;
    topic.node = node;
    return topic;
  }).toList();
}

///解析标题
///参数中后面有可能会是回复数量的数字，中间用空格隔开,所以去掉它，返回真的标题
parseTitle(String title) {
  List<String> strings = title.split(" ");
  //判断最后是不是数字结尾
  if (strings[strings.length - 1] is int) {
    return title.replaceAll(" " + strings[strings.length - 1], "");
  } else {
    return title;
  }
}

///解析node的title
///由于参数中会带有附件内容的数量在前面，中间会用空格隔开，现在只需要去标题
parseNodeTitle(String nodeTitle){
  List<String> strings = nodeTitle.split("  ");
  if(strings.length > 1){
    return strings[1];
  }else{
    return nodeTitle;
  }
}

///去掉字符串内容中的空格
String contentTrim(String string){
  return string.replaceAll(" ","");
}

