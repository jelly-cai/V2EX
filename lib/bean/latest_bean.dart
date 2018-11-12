import 'package:flutter_v2ex/bean/member_bean.dart';
import 'package:flutter_v2ex/bean/node_bean.dart';

class Latest {
  String lastReplyBy;
  int lastTouched;
  String title;
  String url;
  int created;
  String createdString;
  String content;
  String contentRendered;
  int lastModified;
  String lastModifiedString;
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
      this.createdString,
      this.content,
      this.contentRendered,
      this.lastModified,
      this.lastModifiedString,
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
        createdString: json['createdString'],
        content: json['content'],
        contentRendered: json['content_rendered'],
        lastModified: json['last_modified'],
        lastModifiedString: json["last_modified_string"],
        replies: json['replies'],
        id: json['id'],
        node: Node.fromJson(json['node']),
        member: Member.fromJson(json['member']));
  }
}
