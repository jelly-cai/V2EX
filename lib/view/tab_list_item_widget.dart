import 'package:flutter/material.dart';
import 'package:flutter_v2ex/util/time_utils.dart';
import 'package:flutter_v2ex/bean/latest_bean.dart';
import 'package:flutter_v2ex/view/node_title_text_widget.dart';
import 'package:flutter_v2ex/view/replies_text_widget.dart';
import 'package:flutter_v2ex/view/round_rect_icon_widget.dart';
import 'package:flutter_v2ex/view/user_info_widget.dart';

///首页列表Item
class TabListItemWidget extends StatelessWidget {
  final Latest latest;

  const TabListItemWidget({Key key, this.latest}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
            child: Container(
                margin: EdgeInsets.only(right: 5.0),
                child: RoundRectIconWidget(
                    iconUrl: "http:${latest.member.avatarNormal}",
                    width: 50.0,
                    height: 50.0,
                    radius: 5.0)),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return UserInfoWidget(member: latest.member);
              }));
            }),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                latest.title,
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 15.0),
              ),
              Container(
                margin: EdgeInsets.only(top: 5.0),
                child: Row(
                  children: <Widget>[
                    NodeTitleTextWidget(nodeTitle: latest.node.title),
                    UserNameTextWidget(userName: latest.member.userName),
                    DiffTimeTextWidget(
                        lastModified: latest.lastModified * 1000,
                        lastModifiedString: latest.lastModifiedString)
                  ],
                ),
              )
            ],
          ),
        ),
        RepliesTextWidget(replies: latest.replies)
      ],
    );
  }
}

///用户名显示
class UserNameTextWidget extends StatelessWidget {
  final String userName;

  const UserNameTextWidget({Key key, this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.only(left: 10.0),
      child: Text(
        userName,
        style: TextStyle(
          color: Color.fromARGB(255, 119, 128, 135),
        ),
      ),
    );
  }
}

///显示差异时间Widget
class DiffTimeTextWidget extends StatelessWidget {
  final int lastModified;
  final String lastModifiedString;

  const DiffTimeTextWidget(
      {Key key, this.lastModified, this.lastModifiedString})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.only(left: 10.0),
      child: Text(
        lastModifiedString == null
            ? getDiffTime(lastModified)
            : lastModifiedString,
        style: TextStyle(
          fontSize: 12.0,
          color: Color.fromARGB(255, 204, 204, 204),
        ),
      ),
    );
  }
}
