import 'package:flutter/cupertino.dart';

///圆形头像
class CircleIconWidget extends StatelessWidget {
  final String iconUrl;
  final double width;
  final double height;

  const CircleIconWidget({Key key, this.iconUrl, this.width, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ClipOval(
      child: Image.network(
        iconUrl,
        width: width,
        height: width,
        fit: BoxFit.fitWidth,
      ),
    );
  }
}