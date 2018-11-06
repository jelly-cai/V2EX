import 'package:flutter/material.dart';
import 'package:flutter_v2ex/html_text_widget.dart';
import 'package:flutter_v2ex/latest_bean.dart';

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

  ItemContentWidgetState(this.latest);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("主题详情"),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                IconInfoWidget(
                  iconUrl: "https:${latest.member.avatarNormal}",
                  userName: latest.member.userName,
                  replies: latest.replies,
                ),
                Padding(
                    padding: EdgeInsets.only(top: 3.0),
                    child: Text(latest.node.title))
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: HtmlTextWidget(
                data: '<span style="font-size:17.0">${latest.title}</span>',
              ),
            ),
            Divider(),
            HtmlTextWidget(data: '<div style="font-size:15.0">${latest.contentRendered}</div>')
          ],
        ),
      ),
    );
  }
}

///头像用户信息
class IconInfoWidget extends StatelessWidget {
  final String iconUrl;
  final String userName;
  final int replies;

  const IconInfoWidget({Key key, this.iconUrl, this.userName, this.replies})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      children: <Widget>[
        ClipOval(
          child: Image.network(
            iconUrl,
            width: 45.0,
            height: 45.0,
            fit: BoxFit.fitWidth,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.0, top: 3.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(userName),
              Padding(
                padding: EdgeInsets.only(top: 3.0),
                child: Text("3分钟前 $replies个回复"),
              )
            ],
          ),
        ),
      ],
    );
  }
}
