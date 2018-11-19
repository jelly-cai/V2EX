import 'package:flutter/material.dart';
import 'package:flutter_v2ex/bean/reply_bean.dart';
import 'package:flutter_v2ex/common/view/circle_icon_widget.dart';
import 'package:flutter_v2ex/html/simple_html_text_widget.dart';
import 'package:flutter_v2ex/util/time_utils.dart';

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
                    created: reply.created,
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
                    ))
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
                createdString == null ? getDiffTime(created * 1000) : createdString,
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
