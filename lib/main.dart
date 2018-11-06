import 'package:flutter/material.dart';
import 'package:flutter_v2ex/item_content_widget.dart';
import 'package:flutter_v2ex/latest_bean.dart';
import 'package:flutter_v2ex/tab_bean.dart';
import 'package:flutter_v2ex/tab_list_widget.dart';

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
      routes: {"/item_content": (context) => ItemContentWidget()},
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
  final List<TabBean> tabs = [
    TabBean("最热", "https://www.v2ex.com/api/topics/hot.json", TabBean.JSON),
    TabBean("最新", "https://www.v2ex.com/api/topics/latest.json", TabBean.JSON),
    TabBean("技术", "https://www.v2ex.com/?tab=tech", TabBean.HTML),
    TabBean("创意", "https://www.v2ex.com/?tab=creative", TabBean.HTML),
    TabBean("好玩", "https://www.v2ex.com/?tab=play", TabBean.HTML),
    TabBean("APPLE", "https://www.v2ex.com/?tab=apple", TabBean.HTML),
    TabBean("酷工作", "https://www.v2ex.com/?tab=jobs", TabBean.HTML),
    TabBean("交易", "https://www.v2ex.com/?tab=deals", TabBean.HTML),
    TabBean("城市", "https://www.v2ex.com/?tab=city", TabBean.HTML),
    TabBean("问与答", "https://www.v2ex.com/?tab=qna", TabBean.HTML),
    TabBean("R2", "https://www.v2ex.com/?tab=r2", TabBean.HTML)
  ];
  List<Tab> tabWidgets;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabWidgets = tabs.map((tab) {
      return Tab(text: tab.title);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      child: new Scaffold(
          appBar: new AppBar(
            title: new Text(widget.title),
            bottom: TabBar(tabs: tabWidgets, isScrollable: true),
          ),
          body: TabBarView(
              children: tabs.map((tab) {
            return Container(
              child: TabListWidget(tabBean: tab),
            );
          }).toList())),
      length: tabs.length,
      initialIndex: 0,
    );
  }
}
