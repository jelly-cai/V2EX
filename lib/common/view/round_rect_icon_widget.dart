import 'package:flutter/cupertino.dart';

///圆角矩形
class RoundRectIconWidget extends StatelessWidget {
  final String iconUrl;
  final double width;
  final double height;
  final double radius;

  const RoundRectIconWidget(
      {Key key, this.iconUrl, this.width, this.height, this.radius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          image: DecorationImage(
            image: iconUrl == null ? null : NetworkImage(iconUrl),
            fit: BoxFit.fill,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(radius),
          )),
    );
  }
}
