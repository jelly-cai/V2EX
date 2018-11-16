class NodeBean {
  String avatarLarge;
  String name;
  String avatarNormal;
  String title;
  String url;
  int topics;
  String footer;
  String header;
  String titleAlternative;
  String avatarMini;
  int stars;
  bool root;
  int id;
  String parentNodeName;

  NodeBean(
      {this.avatarLarge,
      this.name,
      this.avatarNormal,
      this.title,
      this.url,
      this.topics,
      this.footer,
      this.header,
      this.titleAlternative,
      this.avatarMini,
      this.stars,
      this.root,
      this.id,
      this.parentNodeName});

  factory NodeBean.fromJson(Map<String, dynamic> json) {
    return NodeBean(
        avatarLarge: json['avatar_large'],
        name: json['name'],
        avatarNormal: json['avatar_normal'],
        title: json['title'],
        url: json['url'],
        topics: json['topics'],
        footer: json['footer'],
        header: json['header'],
        titleAlternative: json['title_alternative'],
        avatarMini: json['avatar_mini'],
        stars: json['stars'],
        root: json['root'],
        id: json['id'],
        parentNodeName: json['parent_node_name']);
  }
}
