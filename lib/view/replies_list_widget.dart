import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_v2ex/bean/reply_bean.dart';
import 'package:flutter_v2ex/bean/topic_content_bean.dart';
import 'package:flutter_v2ex/view/reply_item_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

///完整的回复列表
class RepliesListWidget extends StatefulWidget {
  final TopicContent topicContent;

  const RepliesListWidget({Key key, this.topicContent}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RepliesListState(topicContent);
  }
}

class RepliesListState extends State {
  ///主题内容，里面有评论列表
  TopicContent topicContent;

  ///当前为第几页评论
  int currPage = 1;

  ///滚动控制器
  ScrollController controller;

  ///是否已经没有数据了
  bool isNoData = false;

  RepliesListState(this.topicContent);

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
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("评论列表")),
      body: RefreshIndicator(
          child: ListView.builder(
              controller: controller,
              itemBuilder: (context, position) {
                ///加载更多进度
                if (position == getListLength() - 1) {
                  return Container(
                      padding: EdgeInsets.all(3.0),
                      child: Center(
                          child: isNoData ? Text("已经到底了！") : Text("努力加载中...")));
                }
                ///如果是奇数就返回一条分割线
                if(position.isOdd){
                  return Divider(height: 3.0);
                }
                ///评论item
                int realPosition = position ~/ 2;
                Reply reply = topicContent.replies[realPosition];
                return Container(
                  padding: EdgeInsets.all(5.0),
                  child: ReplyItemWidget(reply: reply, position: realPosition + 1),
                );
              },
              itemCount: getListLength()),
          onRefresh: _handleRefresh),
    );
  }

  ///list的长度，加入分隔线和最后的加载更多item
  getListLength(){
    return topicContent.replies.length * 2 + 1;
  }

  ///处理刷新
  Future<Null> _handleRefresh() async {
    currPage = 1;
    isNoData = false;
    getData();
  }

  ///加载下一页数据
  loadMore() async {
    currPage++;
    if (currPage > topicContent.totalPage) {
      currPage = topicContent.totalPage;
    }
    getData();
  }

  ///获取评论列表数据
  getData() async {
    http.Response response = await http
        .get("https://www.v2ex.com/t/${topicContent.latest.id}?p=$currPage");
    const platform = const MethodChannel("com.v2ex/android");
    String jsonString = await platform.invokeMethod("parseReplyHtml",
        {"response": response.body, "id": topicContent.latest.id});
    setState(() {
      TopicContent temp = TopicContent.fromJson(json.decode(jsonString));

      ///如果返回的页码大于当前显示的页码不同，就是加载下一页数据
      if (temp.currentPage > topicContent.currentPage) {
        topicContent.currentPage = currPage;
        topicContent.replies.addAll(temp.replies);
      } else if (temp.currentPage == 1) {
        topicContent = temp;
      } else {
        isNoData = true;
      }
    });
  }
}
