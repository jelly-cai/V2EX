import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_v2ex/reply_bean.dart';
import 'package:flutter_v2ex/time_utils.dart';
import 'package:flutter_v2ex/html_text_widget.dart';
import 'package:flutter_v2ex/latest_bean.dart';
import 'package:flutter_v2ex/topic_content_bean.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ItemContentWidget extends StatefulWidget {
  final Latest latest;

  const ItemContentWidget({Key key, this.latest}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ItemContentWidgetState(latest);
  }
}

class ItemContentWidgetState extends State {
  final Latest latest;
  TopicContent topicContent;

  ItemContentWidgetState(this.latest);

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
        title: Text("主题详情"),
      ),
      body: topicContent == null
          ? Container()
          : ListView.builder(
              itemBuilder: (context, position) {
                if (position == 0) {
                  return Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            IconInfoWidget(
                              iconUrl:
                                  "https:${topicContent.latest.member.avatarNormal}",
                              userName: topicContent.latest.member.userName,
                              replies: topicContent.latest.replies,
                              created: topicContent.latest.created * 1000,
                            ),
                            Padding(
                                padding: EdgeInsets.only(top: 3.0),
                                child: Text(topicContent.latest.node.title))
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: HtmlTextWidget(
                            data:
                                '<span style="font-size:17.0">${topicContent.latest.title}</span>',
                          ),
                        ),
                        Divider(),
                        HtmlTextWidget(
                          data:
                              '<span style="font-size:14.0">${topicContent.latest.contentRendered}</span>',
                        ),
                        Divider()
                      ],
                    ),
                  );
                }

                ///回复对象
                Reply reply = topicContent.replies[position - 1];
                return Container(
                  padding: EdgeInsets.only(left: 5.0, right: 5.0),
                  child: ReplyItemWidget(reply: reply, position: position),
                );
              },
              itemCount: topicContent.replies.length + 1,
            ),
    );
  }

  ///获取List数据
  getData() async {
    http.Response response =
        await http.get("https://www.v2ex.com/t/${latest.id}?p=1");
    const platform = const MethodChannel("com.v2ex/android");
    String jsonString = await platform.invokeMethod(
        "parseReplyHtml", {"response": response.body, "id": latest.id});
    setState(() {
      topicContent = TopicContent.fromJson(json.decode(jsonString));
    });
  }
}

///回复列表item
class ReplyItemWidget extends StatelessWidget {
  final Reply reply;
  final int position;

  const ReplyItemWidget({Key key, this.reply, this.position}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(right: 5.0),
            child: CircleIconWidget(
              iconUrl: reply.member.avatarNormal,
            )),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ReplyUserInfoWidget(
                userName: reply.member.userName,
                created: reply.created,
                position: position),
            Container(
                margin: EdgeInsets.only(top: 3.0),
                child: HtmlTextWidget(data: reply.contentRendered)),
            Divider()
          ],
        ))
      ],
    );
  }
}

///回复列表的用户信息
class ReplyUserInfoWidget extends StatelessWidget {
  final String userName;
  final int created;
  final int position;

  const ReplyUserInfoWidget(
      {Key key, this.userName, this.created, this.position})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(userName),
            Container(
                margin: EdgeInsets.only(left: 3.0),
                child: Text(getDiffTime(created)))
          ],
        ),
        Text("第$position楼",style: TextStyle(fontSize: 10.0))
      ],
    );
  }
}

///圆形头像
class CircleIconWidget extends StatelessWidget {
  final String iconUrl;

  const CircleIconWidget({Key key, this.iconUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ClipOval(
      child: Image.network(
        iconUrl,
        width: 35.0,
        height: 35.0,
        fit: BoxFit.fitWidth,
      ),
    );
  }
}

///头像用户信息
class IconInfoWidget extends StatelessWidget {
  final String iconUrl;
  final String userName;
  final int replies;
  final int created;

  const IconInfoWidget(
      {Key key, this.iconUrl, this.userName, this.replies, this.created})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      children: <Widget>[
        CircleIconWidget(iconUrl: iconUrl),
        Padding(
          padding: EdgeInsets.only(left: 10.0, top: 3.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                userName,
                style: TextStyle(fontSize: 13.0, color: Colors.black),
              ),
              Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: Text(
                  getDiffTime(created) + " $replies个回复",
                  style: TextStyle(
                      fontSize: 11.0,
                      color: Color.fromARGB(255, 153, 153, 153)),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
