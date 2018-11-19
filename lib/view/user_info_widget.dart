import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_v2ex/bean/topic_bean.dart';
import 'package:flutter_v2ex/bean/user_info_bean.dart';
import 'package:flutter_v2ex/bean/member_bean.dart';
import 'package:flutter_v2ex/common/style/item_text_style.dart';
import 'package:flutter_v2ex/common/view/item_hint_point_widget.dart';
import 'package:flutter_v2ex/data/parse_data.dart';
import 'package:flutter_v2ex/view/item_content_widget.dart';
import 'package:flutter_v2ex/common/view/node_title_text_widget.dart';
import 'package:flutter_v2ex/common/view/replies_text_widget.dart';
import 'package:flutter_v2ex/common/view/round_rect_icon_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

///用户信息展示界面
class UserInfoWidget extends StatefulWidget {
  final Member member;

  const UserInfoWidget({Key key, this.member}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UserInfoWidgetState(member.userName);
  }
}

class UserInfoWidgetState extends State {
  final String userName;
  UserInfo userInfo;

  UserInfoWidgetState(this.userName);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("用户信息"),
        ),
        body: userInfo == null
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemBuilder: (context, position) {
                  if (position == 0) {
                    return Container(
                      margin: EdgeInsets.all(5.0),
                      child: UserInfoHeaderWidget(
                        avatarNormal: userInfo.member.avatarNormal,
                        userName: userInfo.member.userName,
                        info: userInfo.member.info,
                      ),
                    );
                  } else if (position == 1) {
                    return Divider(height: 2.0);
                  }

                  Topic topic = userInfo.topics[position - 2];

                  return GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return ItemContentWidget(latest: topic);
                        }));
                      },
                      child: Container(
                          padding: EdgeInsets.all(5.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ItemNameWidget(
                                  nodeName: topic.node.title,
                                  userName: topic.member.userName,
                                ),
                                Container(
                                  padding:
                                      EdgeInsets.only(top: 3.0, bottom: 3.0),
                                  child: ItemTitleWidget(
                                    title: topic.title,
                                    replies: topic.replies,
                                  ),
                                ),
                                ItemInfoWidget(
                                  createdString: topic.createdString,
                                  lastReply: topic.lastReply,
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 5.0),
                                  child: Divider(height: 1.0),
                                )
                              ])));
                },
                itemCount: userInfo.topics.length + 2,
              ));
  }

  ///获取数据
  getData() async {
    http.Response response =
        await http.get("https://www.v2ex.com/member/" + userName);
    UserInfo userInfo = await parseUserInfo(response.body);
    setState(() {
      this.userInfo = userInfo;
    });
  }
}

///item的底部布局
class ItemInfoWidget extends StatelessWidget {
  final String createdString;
  final String lastReply;

  const ItemInfoWidget({Key key, this.createdString, this.lastReply})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return createdString == null && lastReply == null
        ? Container()
        : Row(children: <Widget>[
            Text(
              createdString == null ? "" : createdString,
              style: ItemTextHintStyle(),
            ),
            Text("  •  最后回复来自", style: ItemTextHintStyle()),
            Text(lastReply == null ? "" : lastReply, style: ItemTextBoldStyle())
          ]);
  }
}

///列表中间布局
class ItemTitleWidget extends StatelessWidget {
  final String title;
  final int replies;

  const ItemTitleWidget({Key key, this.title, this.replies}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(child: Text(title, style: ItemTextTitleStyle())),
          RepliesTextWidget(replies: replies)
        ]);
  }
}

///列表顶部布局
class ItemNameWidget extends StatelessWidget {
  final String nodeName;
  final String userName;

  const ItemNameWidget({Key key, this.nodeName, this.userName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      children: <Widget>[
        NodeTitleTextWidget(nodeTitle: nodeName),
        ItemHintPointWidget(),
        Text(userName, style: ItemTextBoldStyle())
      ],
    );
  }
}

///头部用户信息
class UserInfoHeaderWidget extends StatelessWidget {
  final String avatarNormal;
  final String userName;
  final String info;

  const UserInfoHeaderWidget(
      {Key key, this.avatarNormal, this.userName, this.info})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(children: <Widget>[
      Container(
          margin: EdgeInsets.only(right: 5.0),
          child: RoundRectIconWidget(
              iconUrl: avatarNormal == null ? null : "http:" + avatarNormal,
              width: 60.0,
              height: 60.0,
              radius: 5.0)),
      Expanded(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(userName, style: TextStyle(fontSize: 20.0)),
          Container(
              margin: EdgeInsets.only(top: 5.0),
              child: Text(info,
                  style: TextStyle(
                      fontSize: 13.0,
                      color: Color.fromARGB(255, 153, 153, 153))))
        ],
      ))
    ]);
  }
}
