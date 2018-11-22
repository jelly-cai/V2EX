import 'package:flutter/material.dart';
import 'package:flutter_v2ex/bean/node_bean.dart';
import 'package:flutter_v2ex/bean/node_list_bean.dart';
import 'package:flutter_v2ex/bean/topic_bean.dart';
import 'package:flutter_v2ex/common/style/item_text_style.dart';
import 'package:flutter_v2ex/common/view/item_hint_point_widget.dart';
import 'package:flutter_v2ex/common/view/replies_text_widget.dart';
import 'package:flutter_v2ex/common/view/round_rect_icon_widget.dart';
import 'package:flutter_v2ex/data/parse_data.dart';
import 'package:flutter_v2ex/view/item_content_widget.dart';
import 'package:http/http.dart' as http;

class NodeListWidget extends StatefulWidget {
  final NodeBean node;

  const NodeListWidget({Key key, this.node}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NodeListWidgetState(node);
  }
}

class NodeListWidgetState extends State {
  final NodeBean node;
  NodeListBean nodeList;
  int currPage = 1;

  ///滚动控制器
  ScrollController controller;

  ///是否已经没有数据了
  bool isNoData = false;

  NodeListWidgetState(this.node);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = ScrollController();
    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        loadMore();
      }
    });
    getData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text(node.title)),
      body: nodeList == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: _handleRefresh,
              child: ListView.builder(
                itemBuilder: (context, position) {
                  if (position == 0) {
                    return ListHeaderWidget(
                      iconUrl: "http:" + nodeList.node.avatarNormal,
                      title: node.title,
                      topics: nodeList.node.topics,
                      info: nodeList.node.info,
                    );
                  }

                  if (position == getListLength() - 1) {
                    return Container(
                        padding: EdgeInsets.all(3.0),
                        child: Center(
                            child:
                                isNoData ? Text("已经到底了！") : Text("努力加载中...")));
                  }

                  if (position.isOdd) {
                    return Divider(height: 1);
                  }

                  Topic topic = nodeList.topics[position ~/ 2 - 1];
                  return GestureDetector(child: ListItemWidget(topic: topic),onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context){
                      return ItemContentWidget(topic: topic);
                    }));
                  });
                },
                itemCount: getListLength(),
                controller: controller,
              ),
            ),
    );
  }

  getListLength() {
    return (nodeList.topics.length + 1) * 2 + 1;
  }

  ///处理刷新
  Future<Null> _handleRefresh() async {
    nodeList.currPage = currPage = 1;
    isNoData = false;
    getData();
  }

  loadMore() async {
    currPage++;
    if (currPage > nodeList.totalPage) {
      currPage = nodeList.totalPage;
    }
    getData();
  }

  getData() async {
    http.Response response =
        await http.get("https://www.v2ex.com/go/" + node.name + "?p=$currPage");
    String html = response.body;
    NodeListBean nodeList = await parseNodeList(html);
    setState(() {
      if (nodeList.currPage == 1) {
        this.nodeList = nodeList;
      } else if (nodeList.currPage > this.nodeList.currPage) {
        this.nodeList.currPage = currPage;
        this.nodeList.topics.addAll(nodeList.topics);
      } else {
        isNoData = true;
      }
    });
  }
}

class ListItemWidget extends StatelessWidget {
  final Topic topic;

  const ListItemWidget({Key key, this.topic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.all(5.0),
      child: Row(children: <Widget>[
        RoundRectIconWidget(
          iconUrl: "http:" + topic.member.avatarNormal,
          width: 50.0,
          height: 50.0,
          radius: 5.0,
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(left: 5.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(topic.title),
                  Padding(
                      padding: EdgeInsets.only(top: 5.0),
                      child: Wrap(
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.start,
                        children: <Widget>[
                          Text(
                            topic.member.userName,
                            style: ItemTextBoldStyle(),
                          ),
                          topic.lastModifiedString == null
                              ? Container(child: Text(""))
                              : ItemHintPointWidget(),
                          Text(
                              topic.lastModifiedString == null
                                  ? ""
                                  : topic.lastModifiedString,
                              style: ItemTextHintStyle()),
                          topic.lastReply == null
                              ? Container(child: Text(""))
                              : ItemHintPointWidget(),
                          topic.lastReply == null
                              ? Container(child: Text(""))
                              : Text("最后回复来自", style: ItemTextHintStyle()),
                          Text(topic.lastReply == null ? "" : topic.lastReply,
                              style: ItemTextBoldStyle())
                        ],
                      ))
                ]),
          ),
        ),
        RepliesTextWidget(replies: topic.replies)
      ]),
    );
  }
}

///列表头
class ListHeaderWidget extends StatelessWidget {
  final String iconUrl;
  final String title;
  final int topics;
  final String info;

  const ListHeaderWidget(
      {Key key, this.iconUrl, this.title, this.topics, this.info})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        padding: EdgeInsets.all(5.0),
        child: Row(children: <Widget>[
          RoundRectIconWidget(
            iconUrl: iconUrl,
            width: 70.0,
            height: 70.0,
            radius: 5.0,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 5.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(title, style: TextStyle(fontSize: 16.0)),
                          Text(
                            "主题总数$topics",
                            style: TextStyle(fontSize: 12.0),
                          )
                        ]),
                    Padding(
                      padding: EdgeInsets.only(top: 5.0),
                      child: Text(info),
                    )
                  ]),
            ),
          )
        ]));
  }
}
