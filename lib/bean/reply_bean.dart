import 'package:flutter_v2ex/bean/member_bean.dart';

class Reply {
  String content;
  String contentRendered;
  int created;
  String createdString;
  Member member;

  Reply(
      {this.content,
      this.contentRendered,
      this.created,
      this.member,
      this.createdString});

  factory Reply.fromJson(Map<String, dynamic> json) {
    return Reply(
      content: json['content'],
      contentRendered: json['contentRendered'],
      created: json['created'],
      createdString: json['createdString'],
      member: Member.fromJson(json['member']),
    );
  }
}
