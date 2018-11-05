import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_v2ex/latest_bean.dart';
import 'package:flutter_v2ex/tab_bean.dart';
import 'package:flutter_v2ex/tab_list_item_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

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
          return Container(
            padding: EdgeInsets.all(5.0),
            child: Column(
              children: <Widget>[
                TabListItemWidget(latest: latestList[position]),
                Divider()
              ],
            ),
          );
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
      setState(() {
        if (tabBean.type == TabBean.JSON) {
          parseJson(response.body);
        } else if (tabBean.type == TabBean.HTML) {
          parseHtml(response.body);
        }
      });
    }
  }

  ///解析json
  parseJson(jsonString) {
    List list = json.decode(jsonString);
    latestList = list.map((dynamic) => Latest.formJson(dynamic)).toList();
  }

  ///解析html
  parseHtml(htmlString) async {
    const platform = const MethodChannel("com.v2ex/android");
    String jsonString = await platform.invokeMethod("parseHtml", {"response": htmlString});
    parseJson(jsonString);
  }

  ///处理刷新
  Future<Null> _handleRefresh() async {
    getListData();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

}
