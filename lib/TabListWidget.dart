import 'package:flutter/material.dart';
import 'package:v2ex/LatestBean.dart';
import 'package:v2ex/TabListItemWidget.dart';

class TabListWidget extends StatelessWidget {
  final List<Latest> latestList;

  const TabListWidget({Key key, this.latestList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
      itemBuilder: (context, position) {
        return TabListItemWidget(latest: latestList[position]);
      },
      itemCount: latestList.length,
    );
  }
}
