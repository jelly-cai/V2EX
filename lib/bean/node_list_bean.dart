import 'package:flutter_v2ex/bean/node_bean.dart';
import 'package:flutter_v2ex/bean/topic_bean.dart';

class NodeListBean {
  NodeBean node;
  List<Topic> topics;
  int currPage;
  int totalPage;

  NodeListBean({this.node, this.topics, this.currPage, this.totalPage});
}
