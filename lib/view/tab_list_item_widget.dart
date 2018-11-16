import 'package:flutter/material.dart';
import 'package:flutter_v2ex/common/style/item_text_style.dart';
import 'package:flutter_v2ex/common/view/item_hint_point_widget.dart';
import 'package:flutter_v2ex/util/time_utils.dart';
import 'package:flutter_v2ex/bean/topic_bean.dart';
import 'package:flutter_v2ex/common/view/node_title_text_widget.dart';
import 'package:flutter_v2ex/common/view/replies_text_widget.dart';
import 'package:flutter_v2ex/common/view/round_rect_icon_widget.dart';
import 'package:flutter_v2ex/view/user_info_widget.dart';

///首页列表Item
class TabListItemWidget extends StatelessWidget {
  final Topic latest;

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
                style: ItemTextTitleStyle(),
              ),
              Container(
                margin: EdgeInsets.only(top: 5.0),
                child: Row(
                  children: <Widget>[
                    NodeTitleTextWidget(nodeTitle: latest.node.title),
                    ItemHintPointWidget(),
                    UserNameTextWidget(userName: latest.member.userName),
                    latest.lastModified == null &&
                            latest.lastModifiedString == null
                        ? Container()
                        : ItemHintPointWidget(),
                    DiffTimeTextWidget(
                        lastModified: latest.lastModified,
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
          ? lastModified == null ? "" : getDiffTime(lastModified)
          : lastModifiedString,
      style: ItemTextHintStyle(),
    );
  }
}
