import 'package:flutter/material.dart';
import 'package:frolicsports/constance/constance.dart';
import 'package:frolicsports/constance/themes.dart';

class OtpProgressView extends StatefulWidget {
  @override
  _OtpProgressViewState createState() => _OtpProgressViewState();
}

class _OtpProgressViewState extends State<OtpProgressView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            child: Text(
              'Sit back and relax, while we\nare verifying your number',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: ConstanceData.SIZE_TITLE14,
                fontWeight: FontWeight.bold,
                color: AllCoustomTheme.getBlackAndWhiteThemeColors(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
