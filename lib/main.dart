import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:v2ex/LatestBean.dart';
import 'dart:convert';

import 'package:v2ex/TabListWidget.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'V2EX'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Latest> latestList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getAllList();
    return DefaultTabController(
        child: new Scaffold(
            appBar: new AppBar(
              title: new Text(widget.title),
              bottom: TabBar(
                tabs: tabs.map((tab) {
                  return Tab(text: tab.title);
                }).toList(),
                isScrollable: true,
              ),
            ),
            body: TabBarView(
                children: tabs.map((tab) {
              return Container(
                child: TabListWidget(latestList: latestList),
              );
            }).toList())),
        length: tabs.length);
  }

  getAllList() {
    var url = "https://www.v2ex.com/api/topics/latest.json";
    http.get(url).then((response) {
      List list = json.decode(response.body);
      latestList = list.map((dynamic) => Latest.formJson(dynamic)).toList();
      setState(() {});
    });
  }
}

class TabBean {
  final String title;

  TabBean(this.title);
}

List<TabBean> tabs = [
  TabBean("全部"),
  TabBean("最热"),
  TabBean("技术"),
  TabBean("创意"),
  TabBean("好玩"),
  TabBean("APPLE"),
  TabBean("酷工作"),
  TabBean("交易"),
  TabBean("城市"),
  TabBean("问与答"),
  TabBean("R2"),
  TabBean("关注"),
  TabBean("最近")
];
