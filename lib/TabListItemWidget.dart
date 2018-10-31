import 'package:flutter/material.dart';
import 'package:v2ex/LatestBean.dart';

class TabListItemWidget extends StatelessWidget{

  final Latest latest;

  const TabListItemWidget({Key key, this.latest}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print("https${latest.node.avatarLarge}");
    return Row(
      children: <Widget>[
        Image.network("https${latest.node.avatarLarge}"),
        Column(
          children: <Widget>[
            Text("新款 Air 用来做 J2EE 开发怎么样"),
            Text("Apple  •  mrsen  •  刚刚  •  最后回复来自 EIJAM")
          ],
        )
      ],
    );
  }

}