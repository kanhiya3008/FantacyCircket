import 'package:flutter/material.dart';
import 'package:frolicsports/constance/constance.dart';
import 'package:frolicsports/constance/themes.dart';

class ContinueButton extends StatelessWidget {
  final void Function() callBack;
  final String name;

  const ContinueButton({Key key, this.callBack, this.name}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        decoration: new BoxDecoration(
          color: AllCoustomTheme.getThemeData().primaryColor,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () async {
              callBack();
            },
            child: Padding(
              padding: EdgeInsets.only(top: 16, bottom: 16),
              child: Center(
                child: Text(
                  (name != null && name != '') ? name : 'Continue',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: ConstanceData.SIZE_TITLE18,
                    fontWeight: FontWeight.bold,
                    color: AllCoustomTheme.getThemeData().backgroundColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
