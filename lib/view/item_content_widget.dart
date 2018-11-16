import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_v2ex/bean/reply_bean.dart';
import 'package:flutter_v2ex/data/parse_data.dart';
import 'package:flutter_v2ex/html/simple_html_text_widget.dart';
import 'package:flutter_v2ex/util/time_utils.dart';
import 'package:flutter_v2ex/bean/topic_bean.dart';
import 'package:flutter_v2ex/bean/topic_content_bean.dart';
import 'package:flutter_v2ex/common/view/circle_icon_widget.dart';
import 'package:flutter_v2ex/view/replies_list_widget.dart';
import 'package:flutter_v2ex/view/reply_item_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

///主题内容
class ItemContentWidget extends StatefulWidget {
  final Topic latest;

  const ItemContentWidget({Key key, this.latest}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ItemContentWidgetState(latest);
  }
}

class ItemContentWidgetState extends State {
  final Topic latest;
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
                ///返回头部
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
                        )
                      ],
                    ),
                  );
                }

                ///如果是奇数加入分隔线
                if(position.isOdd){
                  return Divider(height: 3.0);
                }

                ///查看更多
                if (isOnMore(position)) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return RepliesListWidget(topicContent: topicContent);
                      }));
                    },
                    child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Center(child: Text("查看更多"))),
                  );
                }
                ///向下取整,减去头部
                int realPosition = position ~/ 2 - 1;
                ///回复item
                Reply reply = topicContent.replies[realPosition];
                return Container(
                  padding: EdgeInsets.all(5.0),
                  child: ReplyItemWidget(reply: reply, position: realPosition + 1),
                );
              },
              itemCount: getListLength(),
            ),
    );
  }

  ///是否有查看更多的按钮
  isOnMore(position) {
    return topicContent.totalPage > 1 && position == getListLength() - 1;
  }

  ///获取ListView的长度,加一个头部，分隔线和是否有查看更多的按钮，如果总页大于1就有
  getListLength() {
    return (topicContent.replies.length + 1) * 2 +
        (topicContent.totalPage > 1 ? 1 : 0);
  }

  ///获取评论列表数据
  getData() async {
    http.Response response =
        await http.get("https://www.v2ex.com/t/${latest.id}?p=1");
    const platform = const MethodChannel("com.v2ex/android");
    parseTopicContent(response.body);
    String jsonString = await platform.invokeMethod(
        "parseReplyHtml", {"response": response.body, "id": latest.id});
    setState(() {
      topicContent = TopicContent.fromJson(json.decode(jsonString));
    });
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
