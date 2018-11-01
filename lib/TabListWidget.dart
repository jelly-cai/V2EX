import 'package:flutter/material.dart';
import 'package:flutter_v2ex/LatestBean.dart';
import 'package:flutter_v2ex/TabListItemWidget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class TabListWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TabListWidgetState();
  }
}

class TabListWidgetState extends State {
  List<Latest> latestList;

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
  getListData(){
    var url = "https://www.v2ex.com/api/topics/latest.json";
    http.get(url).then((response) {
      setState(() {
        List list = json.decode(response.body);
        latestList = list.map((dynamic) => Latest.formJson(dynamic)).toList();
      });
    });
  }

  ///处理刷新
  Future<Null> _handleRefresh() async{
    getListData();
  }
}
