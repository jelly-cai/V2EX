import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_v2ex/data/parse_data.dart';
import 'package:flutter_v2ex/view/item_content_widget.dart';
import 'package:flutter_v2ex/bean/topic_bean.dart';
import 'package:flutter_v2ex/bean/tab_bean.dart';
import 'package:flutter_v2ex/view/tab_list_item_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
///Tab页面
class TabListWidget extends StatefulWidget {
  final TabBean tabBean;

  const TabListWidget({Key key, this.tabBean}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TabListWidgetState(tabBean);
  }
}

class TabListWidgetState extends State with AutomaticKeepAliveClientMixin{
  final TabBean tabBean;
  List<Topic> topics;

  TabListWidgetState(this.tabBean);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getListData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return RefreshIndicator(
      child: ListView.builder(
        itemBuilder: (context, position) {
          return GestureDetector(child: Container(
            padding: EdgeInsets.all(5.0),
            child: Column(
              children: <Widget>[
                TabListItemWidget(topic: topics[position]),
                Divider()
              ],
            ),
          ),onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return ItemContentWidget(latest: topics[position]);
            }));
          },);
        },
        itemCount: topics == null ? 0 : topics.length,
      ),
      onRefresh: _handleRefresh,
    );
  }

  ///获取List数据
  getListData() async{
    http.Response response = await http.get(tabBean.url);
    if(this.mounted){
      if (tabBean.type == TabBean.JSON) {
        parseJson(response.body);
      } else if (tabBean.type == TabBean.HTML) {
        parseHtml(response.body);
      }
    }
  }

  ///解析json，刷新界面
  parseJson(jsonString) {
    List list = json.decode(jsonString);
    List<Topic> topics = list.map((dynamic) => Topic.formJson(dynamic)).toList();
    updateTopics(topics);
  }

  ///更新界面
  updateTopics(topics){
    setState(() {
      this.topics = topics;
    });
  }

  ///解析html
  parseHtml(htmlString) {
    parseTopics(htmlString: htmlString).then((topics){
      updateTopics(topics);
    });
  }

  ///处理刷新
  Future<Null> _handleRefresh() async {
    getListData();
  }

  @override
  bool get wantKeepAlive => true;
}
