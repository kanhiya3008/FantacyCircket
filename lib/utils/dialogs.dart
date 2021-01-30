import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:frolicsports/constance/constance.dart';
import 'package:frolicsports/constance/routes.dart';
import 'package:frolicsports/constance/themes.dart';

class Dialogs {
  static void showDialogWithOneButton(
    BuildContext context,
    String title,
    String content, {
    String buttonLabel = "Okay",
    VoidCallback onButtonPress(),
    barrierDismissible = true,
  }) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext buildContext) {
        return new AlertDialog(
          title: new Text(title),
          content: new Text(content),
          actions: <Widget>[
            new FlatButton(
              child: new Text(buttonLabel),
              onPressed: () => onButtonPress != null
                  ? onButtonPress()
                  : Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  static void showDialogWithTwoButtons(
    BuildContext context,
    String title,
    String content, {
    String button1Label = "Okay",
    VoidCallback onButton1Press,
    String button2Label = "Cancel",
    VoidCallback onButton2Press,
    barrierDismissible = true,
  }) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext buildContext) {
        return new AlertDialog(
          title: new Text(title),
          content: new Text(content),
          actions: <Widget>[
            new FlatButton(
              child: new Text(button1Label),
              onPressed: () => onButton1Press != null
                  ? onButton1Press()
                  : Navigator.pop(context),
            ),
            new FlatButton(
              child: new Text(button2Label),
              onPressed: () => onButton2Press != null
                  ? onButton2Press()
                  : Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  static void showDeadlineDialogWithOneButton(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext buildContext) {
        return new AlertDialog(
          title: new Text(
            'The deadline has passed!',
          ),
          content: new Text(
            "Check out the contests you've joined for this match.",
            style: TextStyle(
              fontSize: ConstanceData.SIZE_TITLE16,
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                "Ok",
                style: TextStyle(
                  color: AllCoustomTheme.getThemeData().primaryColor,
                  fontSize: ConstanceData.SIZE_TITLE18,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    ).then((onValue) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(Routes.TAB, (Route<dynamic> route) => false);
    });
  }
}
