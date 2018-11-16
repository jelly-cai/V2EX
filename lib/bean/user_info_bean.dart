import 'package:flutter_v2ex/bean/topic_bean.dart';
import 'package:flutter_v2ex/bean/member_bean.dart';

class UserInfo {
  Member member;
  List<Topic> topics;

  UserInfo({this.member, this.topics});

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    List list = json['topics'] as List;
    List<Topic> topics =
        list.map((dynamic) => Topic.formJson(dynamic)).toList();
    return UserInfo(member: Member.fromJson(json['member']), topics: topics);
  }
}
