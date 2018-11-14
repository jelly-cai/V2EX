import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_v2ex/bean/reply_bean.dart';
import 'package:flutter_v2ex/html/simple_html_text_widget.dart';
import 'package:flutter_v2ex/util/time_utils.dart';
import 'package:flutter_v2ex/bean/latest_bean.dart';
import 'package:flutter_v2ex/bean/topic_content_bean.dart';
import 'package:flutter_v2ex/common/view/circle_icon_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

///主题内容
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
          ? Center(child: CircularProgressIndicator())
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
                                  "http:${topicContent.latest.member.avatarNormal}",
                              userName: topicContent.latest.member.userName,
                              replies: topicContent.latest.replies,
                              created: topicContent.latest.created * 1000,
                              createdString: topicContent.latest.createdString,
                            ),
                            Padding(
                                padding: EdgeInsets.only(top: 3.0),
                                child: Text(topicContent.latest.node.title))
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text(
                            topicContent.latest.title,
                            style:
                                TextStyle(fontSize: 17.0, color: Colors.black),
                          ),
                        ),
                        Divider(),
                        SimpleHtmlText(
                          data: topicContent.latest.contentRendered,
                          defaultStyle: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black54,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal,
                              decoration: TextDecoration.none),
                        ),
                        Divider()
                      ],
                    ),
                  );
                }

                ///查看更多
                if (topicContent.totalPage > 1 &&
                    position == getListLength() - 1) {
                  return Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Center(child: Text("查看更多")));
                }

                ///回复对象
                Reply reply = topicContent.replies[position - 1];
                return Container(
                  padding: EdgeInsets.only(left: 5.0, right: 5.0),
                  child: ReplyItemWidget(reply: reply, position: position),
                );
              },
              itemCount: getListLength(),
            ),
    );
  }

  ///获取ListView的长度
  getListLength() {
    return (topicContent.replies.length + 1) +
        (topicContent.totalPage > 1 ? 1 : 0);
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
                iconUrl: "https:${reply.member.avatarNormal}",
                width: 35.0,
                height: 35.0)),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ReplyUserInfoWidget(
                userName: reply.member.userName,
                created: reply.created * 1000,
                createdString: reply.createdString,
                position: position),
            Container(
                margin: EdgeInsets.only(top: 3.0),
                child: SimpleHtmlText(
                  data: "<span>${reply.contentRendered}</span>",
                  defaultStyle: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                      decoration: TextDecoration.none),
                )),
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
  final String createdString;

  const ReplyUserInfoWidget(
      {Key key, this.userName, this.created, this.position, this.createdString})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(userName,
                style: TextStyle(fontSize: 12.0, color: Colors.black)),
            Container(
              margin: EdgeInsets.only(left: 5.0),
              child: Text(
                createdString == null ? getDiffTime(created) : createdString,
                style: TextStyle(
                  fontSize: 10.0,
                  color: Color.fromARGB(255, 153, 153, 153),
                ),
              ),
            )
          ],
        ),
        Text("第$position楼", style: TextStyle(fontSize: 10.0))
      ],
    );
  }
}

///头像用户信息
class IconInfoWidget extends StatelessWidget {
  final String iconUrl;
  final String userName;
  final int replies;
  final int created;
  final String createdString;

  const IconInfoWidget(
      {Key key,
      this.iconUrl,
      this.userName,
      this.replies,
      this.created,
      this.createdString})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      children: <Widget>[
        CircleIconWidget(iconUrl: iconUrl, width: 35.0, height: 35.0),
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
                  (createdString == null
                          ? getDiffTime(created)
                          : createdString) +
                      " $replies个回复",
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
