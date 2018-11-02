class TabBean {
  final String title;
  final String url;
  final int type;

  static const int JSON = 1;
  static const int HTML = 2;

  TabBean(this.title, this.url, this.type);
}