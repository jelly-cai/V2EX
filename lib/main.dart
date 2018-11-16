import 'package:flutter/material.dart';
import 'package:flutter_v2ex/view/item_content_widget.dart';
import 'package:flutter_v2ex/bean/tab_bean.dart';
import 'package:flutter_v2ex/view/replies_list_widget.dart';
import 'package:flutter_v2ex/view/tab_list_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: StartPage(),
        routes: {
          "/item_content": (context) => ItemContentWidget(),
          "/relpies_list": (context) => RepliesListWidget()
        });
  }
}

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Future.delayed(Duration(milliseconds: 500), () {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => MyHomePage(
                    title: "V2EX",
                  )),
          (route) => route == null);
    });
    return Container(color: Colors.white);
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  final List<TabBean> _tabs = [
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
        child: Scaffold(
            appBar: AppBar(
                title: Text(title),
                bottom: TabBar(
                  tabs: _tabs.map((tab) => Tab(text: tab.title)).toList(),
                  isScrollable: true,
                )),
            body: TabBarView(
              children:
                  _tabs.map((tab) => TabListWidget(tabBean: tab)).toList(),
            )),
        length: _tabs.length);
  }
}
