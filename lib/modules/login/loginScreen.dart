import 'package:flutter/material.dart';
import 'package:frolicsports/utils/config.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:frolicsports/constance/constance.dart';
import 'package:frolicsports/constance/themes.dart';
import 'package:frolicsports/models/userData.dart';
import 'package:frolicsports/modules/login/facebookGoogle.dart';
import 'package:frolicsports/modules/login/sliderView.dart';

var loginUserData = UserData();

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var isLoginType = '';
  var email = '';
  var name = '';
  var id = '';
  var imageUrl = '';

  var isLoginProsses = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AllCoustomTheme.getThemeData().primaryColor,
                AllCoustomTheme.getThemeData().primaryColor,
                AllCoustomTheme.getThemeData().backgroundColor,
                AllCoustomTheme.getThemeData().backgroundColor,
              ],
            ),
          ),
        ),
        SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: ModalProgressHUD(
              inAsyncCall: isLoginProsses,
              child: Stack(
                children: <Widget>[
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            color:
                                AllCoustomTheme.getThemeData().primaryColor,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(top: 24),
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 14),
                                        child: Text(
                                          appName,
                                          style: TextStyle(
                                            fontSize: 40,
                                            color:
                                                AllCoustomTheme.getThemeData()
                                                    .primaryColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Flexible(
                                  child: SliderView(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        FacebookGoogleView(),
                        Container(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'By continue, you are agree to our ',
                                  style: TextStyle(
                                    fontSize: ConstanceData.SIZE_TITLE12,
                                    color:
                                        AllCoustomTheme.getTextThemeColors(),
                                  ),
                                ),
                                TextSpan(
                                  text: 'Terms of Service',
                                  style: TextStyle(
                                    fontSize: ConstanceData.SIZE_TITLE12,
                                    color: AllCoustomTheme.getThemeData()
                                        .primaryColor,
                                  ),
                                ),
                                TextSpan(
                                  text: '\n & ',
                                  style: TextStyle(
                                    fontSize: ConstanceData.SIZE_TITLE12,
                                    color:
                                        AllCoustomTheme.getTextThemeColors(),
                                  ),
                                ),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: TextStyle(
                                    fontSize: ConstanceData.SIZE_TITLE12,
                                    color: AllCoustomTheme.getThemeData()
                                        .primaryColor,
                                  ),
                                ),
                                TextSpan(
                                  text: '.',
                                  style: TextStyle(
                                    fontSize: ConstanceData.SIZE_TITLE12,
                                    color:
                                        AllCoustomTheme.getTextThemeColors(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
