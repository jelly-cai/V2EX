import 'package:flutter_v2ex/bean/latest_bean.dart';
import 'package:flutter_v2ex/bean/member_bean.dart';

class UserInfo {
  Member member;
  List<Latest> topics;

  UserInfo({this.member, this.topics});

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    List list = json['topics'] as List;
    List<Latest> topics =
        list.map((dynamic) => Latest.formJson(dynamic)).toList();
    return UserInfo(member: Member.fromJson(json['member']), topics: topics);
  }
}
