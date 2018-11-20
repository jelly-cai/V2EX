class NodeBean {
  String name;
  String avatarNormal;
  String title;
  String info;
  ///主题数量
  int topics;
  int id;

  NodeBean(
      {this.name,
      this.avatarNormal,
      this.title,
      this.info,
      this.topics,
      this.id});

  factory NodeBean.fromJson(Map<String, dynamic> json) {
    return NodeBean(
        name: json['name'],
        avatarNormal: json['avatar_normal'],
        title: json['title'],
        info: json['info'],
        topics: json['topics'],
        id: json['id']);
  }
}
