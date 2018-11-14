import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_v2ex/view/item_content_widget.dart';
import 'package:flutter_v2ex/bean/latest_bean.dart';
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
  List<Latest> latestList;

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
                TabListItemWidget(latest: latestList[position]),
                Divider()
              ],
            ),
          ),onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return ItemContentWidget(latest: latestList[position]);
            }));
          },);
        },
        itemCount: latestList == null ? 0 : latestList.length,
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
    setState(() {
      List list = json.decode(jsonString);
      latestList = list.map((dynamic) => Latest.formJson(dynamic)).toList();
    });
  }

  ///解析html
  parseHtml(htmlString) async {
    const platform = const MethodChannel("com.v2ex/android");
    String jsonString = await platform.invokeMethod("parseTopicHtml", {"response": htmlString});
    parseJson(jsonString);
  }

  ///处理刷新
  Future<Null> _handleRefresh() async {
    getListData();
  }

  @override
  bool get wantKeepAlive => true;
}
