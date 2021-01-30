import 'package:flutter/material.dart';
import 'package:frolicsports/constance/themes.dart';
import 'package:frolicsports/main.dart';

class SetColorScreen extends StatefulWidget {
  @override
  _SetColorScreenState createState() => _SetColorScreenState();
}

class _SetColorScreenState extends State<SetColorScreen> {
  bool selectFirstColor = false;
  bool selectSecondColor = false;
  bool selectThirdColor = false;
  bool selectFourthColor = false;
  bool selectFifthColor = false;
  bool selectSixthColor = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AllCoustomTheme.getThemeData().primaryColor,
            AllCoustomTheme.getThemeData().primaryColor,
            Colors.white,
            Colors.white,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: AllCoustomTheme.getThemeData().backgroundColor,
        appBar: AppBar(
          title: Text(
            "Choose Color",
            style: TextStyle(
              color: AllCoustomTheme.getReBlackAndWhiteThemeColors(),
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 14, right: 14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      selectfirstColor();
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Color(0xFF3145f5),
                      child: !selectFirstColor
                          ? CircleAvatar(
                              radius: 6,
                              backgroundColor: Colors.white,
                            )
                          : SizedBox(),
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  InkWell(
                    onTap: () {
                      selectsecondColor();
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Color(0xFF32a852),
                      child: selectSecondColor
                          ? CircleAvatar(
                              radius: 8,
                              backgroundColor: Colors.white,
                            )
                          : SizedBox(),
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  InkWell(
                    onTap: () {
                      selectthirdColor();
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Color(0xFFe6230e),
                      child: selectThirdColor
                          ? CircleAvatar(
                              radius: 8,
                              backgroundColor: Colors.white,
                            )
                          : SizedBox(),
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  InkWell(
                    onTap: () {
                      selectfourthColor();
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Color(0xFF760ee6),
                      child: selectFourthColor
                          ? CircleAvatar(
                              radius: 8,
                              backgroundColor: Colors.white,
                            )
                          : SizedBox(),
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  InkWell(
                    onTap: () {
                      selectfifthColor();
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Color(0xFFdb0ee6),
                      child: selectFifthColor
                          ? CircleAvatar(
                              radius: 8,
                              backgroundColor: Colors.white,
                            )
                          : SizedBox(),
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  InkWell(
                    onTap: () {
                      selectsixthColor();
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Color(0xFFdb164e),
                      child: selectSixthColor
                          ? CircleAvatar(
                              radius: 8,
                              backgroundColor: Colors.white,
                            )
                          : SizedBox(),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  selectfirstColor() {
    if (selectFirstColor) {
      setState(() {
        selectFirstColor = false;
        selectSecondColor = false;
        selectThirdColor = false;
        selectFourthColor = false;
        selectFifthColor = false;
        selectSixthColor = false;
      });
      MyApp.setCustomeTheme(context, 0);
    }
  }

  selectsecondColor() {
    if (!selectSecondColor) {
      setState(() {
        selectFirstColor = true;
        selectSecondColor = true;
        selectThirdColor = false;
        selectFourthColor = false;
        selectFifthColor = false;
        selectSixthColor = false;
      });
      MyApp.setCustomeTheme(context, 1);
    }
  }

  selectthirdColor() {
    if (!selectThirdColor) {
      setState(() {
        selectFirstColor = true;
        selectSecondColor = false;
        selectThirdColor = true;
        selectFourthColor = false;
        selectFifthColor = false;
        selectSixthColor = false;
      });
    }
    MyApp.setCustomeTheme(context, 2);
  }

  selectfourthColor() {
    if (!selectFourthColor) {
      setState(() {
        selectFirstColor = true;
        selectSecondColor = false;
        selectThirdColor = false;
        selectFourthColor = true;
        selectFifthColor = false;
        selectSixthColor = false;
      });
    }
    MyApp.setCustomeTheme(context, 3);
  }

  selectfifthColor() {
    if (!selectFifthColor) {
      setState(() {
        selectFirstColor = true;
        selectSecondColor = false;
        selectThirdColor = false;
        selectFourthColor = false;
        selectFifthColor = true;
        selectSixthColor = false;
      });
    }
    MyApp.setCustomeTheme(context, 4);
  }

  selectsixthColor() {
    if (!selectSixthColor) {
      setState(() {
        selectFirstColor = true;
        selectSecondColor = false;
        selectThirdColor = false;
        selectFourthColor = false;
        selectFifthColor = false;
        selectSixthColor = true;
      });
    }
    MyApp.setCustomeTheme(context, 5);
  }
}
