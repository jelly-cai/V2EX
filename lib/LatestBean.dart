

import 'package:flutter_v2ex/MemberBean.dart';
import 'package:flutter_v2ex/NodeBean.dart';

class Latest {
  String lastReplyBy;
  int lastTouched;
  String title;
  String url;
  int created;
  String content;
  String contentRendered;
  int lastModified;
  int replies;
  int id;
  Node node;
  Member member;

  Latest(
      {this.lastReplyBy,
      this.lastTouched,
      this.title,
      this.url,
      this.created,
      this.content,
      this.contentRendered,
      this.lastModified,
      this.replies,
      this.id,
      this.node,
      this.member});

  factory Latest.formJson(Map<String, dynamic> json) {
    return Latest(
        lastReplyBy: json['lastReplyBy'],
        lastTouched: json['last_touched'],
        title: json['title'],
        url: json['url'],
        created: json['created'],
        content: json['content'],
        contentRendered: json['content_rendered'],
        lastModified: json['last_modified'],
        replies: json['replies'],
        id: json['id'],
        node: Node.fromJson(json['node']),
        member: Member.fromJson(json['member']));
  }
}
