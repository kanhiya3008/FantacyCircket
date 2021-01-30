import 'package:flutter/material.dart';
import 'package:frolicsports/modules/signin/firstView.dart';
import 'package:frolicsports/utils/config.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:frolicsports/api/logout.dart';
import 'package:frolicsports/constance/themes.dart';
import 'package:frolicsports/models/userData.dart';
import 'package:frolicsports/modules/register/registerView.dart';

var loginUserData = UserData();

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {

  var isLoginProsses = false;

  @override
  Widget build(BuildContext context) {
    var isLoginProsses = false;

    @override
    Widget build(BuildContext context) {
      return WillPopScope(
        onWillPop: () async => await LogOut().backSplashScreen(context),
        child: Stack(
          children: <Widget>[
            Container(
              color: AllCoustomTheme
                  .getThemeData()
                  .backgroundColor,
            ),
            SafeArea(
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: ModalProgressHUD(
                  inAsyncCall: isLoginProsses,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Container(
                            constraints: BoxConstraints(
                              minHeight: MediaQuery
                                  .of(context)
                                  .size
                                  .height -
                                  MediaQuery
                                      .of(context)
                                      .padding
                                      .top,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(top: 24),
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 14),
                                        child: Text(
                                          appName,
                                          style: TextStyle(
                                            fontSize: 40,
                                            color: AllCoustomTheme
                                                .getThemeData()
                                                .primaryColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                FirstView(
                                  callBack: () {},
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }
  }
}
