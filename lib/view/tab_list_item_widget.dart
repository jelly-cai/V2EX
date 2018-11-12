import 'package:flutter/material.dart';
import 'package:flutter_v2ex/util/time_utils.dart';
import 'package:flutter_v2ex/view/item_content_widget.dart';
import 'package:flutter_v2ex/bean/latest_bean.dart';

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
        ItemIconWidget(iconUrl: "http:${latest.member.avatarNormal}"),
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

///回复数量显示
class RepliesTextWidget extends StatelessWidget {
  final int replies;

  const RepliesTextWidget({Key key, this.replies}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (replies <= 0) {
      return Container();
    } else {
      return Container(
        padding: EdgeInsets.only(left: 5.0, right: 5.0),
        alignment: Alignment.center,
        child: Text(
          replies.toString(),
          style: TextStyle(fontSize: 10.0, color: Colors.white),
        ),
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 170, 176, 198),
            borderRadius: BorderRadius.circular(5.0)),
      );
    }
  }
}

///icon显示
class ItemIconWidget extends StatelessWidget {
  final String iconUrl;

  const ItemIconWidget({Key key, this.iconUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.only(right: 10.0),
      width: 50.0,
      height: 50.0,
      decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(iconUrl),
            fit: BoxFit.fill,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          )),
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

///Node标题
class NodeTitleTextWidget extends StatelessWidget {
  final String nodeTitle;

  const NodeTitleTextWidget({Key key, this.nodeTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.all(2.0),
      child: Text(
        nodeTitle,
        style: TextStyle(
          fontSize: 12.0,
          color: Color.fromARGB(255, 153, 153, 153),
        ),
      ),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 245, 245, 245),
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
