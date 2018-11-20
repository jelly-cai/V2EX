import 'package:flutter/material.dart';
import 'package:flutter_v2ex/common/style/item_text_style.dart';
import 'package:flutter_v2ex/common/view/item_hint_point_widget.dart';
import 'package:flutter_v2ex/util/time_utils.dart';
import 'package:flutter_v2ex/bean/topic_bean.dart';
import 'package:flutter_v2ex/common/view/node_title_text_widget.dart';
import 'package:flutter_v2ex/common/view/replies_text_widget.dart';
import 'package:flutter_v2ex/common/view/round_rect_icon_widget.dart';
import 'package:flutter_v2ex/view/node_list_widget.dart';
import 'package:flutter_v2ex/view/user_info_widget.dart';

///首页列表Item
class TabListItemWidget extends StatelessWidget {
  final Topic topic;

  const TabListItemWidget({Key key, this.topic}) : super(key: key);

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
                    iconUrl: "http:${topic.member.avatarNormal}",
                    width: 50.0,
                    height: 50.0,
                    radius: 5.0)),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return UserInfoWidget(member: topic.member);
              }));
            }),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                topic.title,
                style: ItemTextTitleStyle(),
              ),
              Container(
                margin: EdgeInsets.only(top: 5.0),
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                        child: NodeTitleTextWidget(nodeTitle: topic.node.title),
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return NodeListWidget(node: topic.node);
                          }));
                        }),
                    ItemHintPointWidget(),
                    UserNameTextWidget(userName: topic.member.userName),
                    topic.lastModified == null &&
                            topic.lastModifiedString == null
                        ? Container(child: Text(""))
                        : ItemHintPointWidget(),
                    DiffTimeTextWidget(
                        lastModified: topic.lastModified,
                        lastModifiedString: topic.lastModifiedString)
                  ],
                ),
              )
            ],
          ),
        ),
        RepliesTextWidget(replies: topic.replies)
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
    return Text(
      userName,
      style: ItemTextBoldStyle(),
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
    return Text(
      lastModifiedString == null
          ? lastModified == null ? "" : getDiffTime(lastModified * 1000)
          : lastModifiedString,
      style: ItemTextHintStyle(),
    );
  }
}
