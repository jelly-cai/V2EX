
String getDiffTime(int time) {
  Duration duration = DateTime.now()
      .difference(DateTime.fromMillisecondsSinceEpoch(time));
  if (duration.inDays != 0) {
    return "${duration.inDays}天前";
  } else if (duration.inHours != 0) {
    return "${duration.inHours}小时前";
  } else if (duration.inMinutes != 0) {
    return "${duration.inMinutes}分钟前";
  } else if (duration.inSeconds != 0) {
    return "${duration.inSeconds}秒前";
  } else {
    return "刚刚";
  }
}