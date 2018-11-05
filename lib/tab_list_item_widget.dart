import 'package:flutter/material.dart';
import 'package:flutter_v2ex/latest_bean.dart';

class TabListItemWidget extends StatelessWidget {
  final Latest latest;

  const TabListItemWidget({Key key, this.latest}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: (){
        Navigator.of(context).pushNamed("/item_content");
      },
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ItemIconWidget(iconUrl: "https:${latest.member.avatarNormal}"),
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
                      DiffTimeTextWidget(lastModified: latest.lastModified * 1000)
                    ],
                  ),
                )
              ],
            ),
          ),
          RepliesTextWidget(replies: latest.replies)
        ],
      ),
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
    return
    Container(
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

  const DiffTimeTextWidget({Key key, this.lastModified}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.only(left: 10.0),
      child: Text(
        getDiffTime(),
        style: TextStyle(
          fontSize: 12.0,
          color: Color.fromARGB(255, 204, 204, 204),
        ),
      ),
    );
  }

  String getDiffTime() {
    Duration duration = DateTime.now()
        .difference(DateTime.fromMillisecondsSinceEpoch(lastModified));
    if (duration.inDays != 0) {
      return "${duration.inDays}天前";
    } else if (duration.inHours != 0) {
      return "${duration.inHours}小时前";
    } else if (duration.inMinutes != 0) {
      return "${duration.inMinutes}分钟前";
    } else if (duration.inSeconds != 0) {
      return "${duration.inSeconds}秒前";
    } else {
      return "刚刚";
    }
  }
}