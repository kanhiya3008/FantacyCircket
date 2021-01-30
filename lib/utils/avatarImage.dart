import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frolicsports/constance/constance.dart';
import 'package:frolicsports/constance/themes.dart';
import 'package:frolicsports/widgets/topBarClipare.dart';

class AvatarImage extends StatelessWidget {
  final double sizeValue;
  final bool isAssets;
  final String imageUrl;
  final double radius;
  final isCircle;
  final isProgressPrimaryColor;

  const AvatarImage({
    Key key,
    this.imageUrl,
    this.isProgressPrimaryColor = false,
    this.sizeValue = 10,
    this.radius = 10,
    this.isCircle = false,
    this.isAssets = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: sizeValue,
        height: sizeValue,
        child: new ClipPath(
          clipper: isCircle
              ? TopBarClipper(
                  topLeft: true,
                  topRight: true,
                  bottomLeft: true,
                  bottomRight: true,
                  radius: radius,
                )
              : null,
          child: Container(
            decoration: new BoxDecoration(
              color: Colors.transparent,
            ),
            child: Container(
              child: imageUrl == ''
                  ? Container(
                      padding: EdgeInsets.all(sizeValue * 0.15),
                      child: Image.asset(
                        ConstanceData.appIcon,
                      ),
                    )
                  : isAssets
                      ? Image.asset(imageUrl)
                      : new CachedNetworkImage(
                          imageUrl: imageUrl,
                          placeholder: (context, url) => Center(
                            child: Container(
                              padding: EdgeInsets.all(sizeValue * 0.3),
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    isProgressPrimaryColor
                                        ? AllCoustomTheme.getThemeData()
                                            .primaryColor
                                        : Colors.white),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            child: Image.asset(ConstanceData.userAvatar),
                          ),
                          fit: BoxFit.cover,
                        ),
            ),
          ),
        ),
      ),
    );
  }
}
