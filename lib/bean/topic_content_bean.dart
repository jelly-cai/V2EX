import 'package:flutter_v2ex/bean/topic_bean.dart';
import 'package:flutter_v2ex/bean/reply_bean.dart';

class TopicContent {
  int currentPage;
  int totalPage;
  List<Reply> replies;
  Topic latest;

  TopicContent({this.currentPage, this.totalPage, this.replies, this.latest});

  factory TopicContent.fromJson(Map<String, dynamic> jsonMap) {
    List list = jsonMap['replies'] as List;
    List<Reply> replies =
        list.map((dynamic) => Reply.fromJson(dynamic)).toList();

    return TopicContent(
        currentPage: jsonMap['currentPage'],
        totalPage: jsonMap['totalPage'],
        replies: replies,
        latest: Topic.formJson(jsonMap['topic']));
  }
}
