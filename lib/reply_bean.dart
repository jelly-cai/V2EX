import 'package:flutter_v2ex/member_bean.dart';

class Reply {
  String content;
  String contentRendered;
  int created;
  Member member;

  Reply({this.content, this.contentRendered, this.created, this.member});

  factory Reply.fromJson(Map<String, dynamic> json) {
    return Reply(
      content: json['content'],
      contentRendered: json['contentRendered'],
      created: json['created'],
      member: Member.fromJson(json['member']),
    );
  }
}
