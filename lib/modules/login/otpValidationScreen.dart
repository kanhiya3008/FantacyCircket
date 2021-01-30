import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frolicsports/utils/config.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:frolicsports/constance/constance.dart';
import 'package:frolicsports/constance/themes.dart';
import 'package:frolicsports/modules/login/continuebutton.dart';
import 'package:frolicsports/modules/login/otpProgressView.dart';
import 'package:frolicsports/modules/login/otpTimer.dart';
import 'package:frolicsports/modules/register/registerScreen.dart';
import 'package:frolicsports/constance/global.dart' as globals;

class OtpValidationScreen extends StatefulWidget {
  @override
  _OtpValidationScreenState createState() => _OtpValidationScreenState();
}

class _OtpValidationScreenState extends State<OtpValidationScreen> with TickerProviderStateMixin {
  var isLoginProsses = false;
  AnimationController _animationController;
  var otpText = '';
  var istimeFinish = false;
  var otpTimerView = false;
  var otpController = new TextEditingController();

  @override
  void initState() {
    _animationController = new AnimationController(
      vsync: this,
      duration: new Duration(milliseconds: 400),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          color: AllCoustomTheme.getThemeData().backgroundColor,
        ),
        SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: ModalProgressHUD(
              inAsyncCall: isLoginProsses,
              child: Stack(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                    },
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width,
                          maxHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
                        ),
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(top: 24),
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 14),
                                      child: Text(
                                        appName,
                                        style: TextStyle(
                                          fontSize: 40,
                                          color: AllCoustomTheme.getThemeData().primaryColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              OtpProgressView(),
                              SizedBox(
                                height: 16,
                              ),
                              Container(
                                height: 60,
                                child: Container(
                                  width: 130,
                                  decoration: new BoxDecoration(
                                    color: AllCoustomTheme.getThemeData().backgroundColor,
                                    border: new Border.all(
                                      width: 1.0,
                                      color: AllCoustomTheme.getTextThemeColors().withOpacity(0.5),
                                    ),
                                  ),
                                  child: TextField(
                                    cursorColor: AllCoustomTheme.getThemeData().primaryColor,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    style: TextStyle(
                                      letterSpacing: 10.0,
                                      fontSize: ConstanceData.SIZE_TITLE18,
                                      color: AllCoustomTheme.getBlackAndWhiteThemeColors(),
                                    ),
                                    maxLength: 6,
                                    keyboardType: TextInputType.number,
                                    decoration: new InputDecoration(
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        counterStyle: TextStyle(color: Colors.transparent)),
                                    onEditingComplete: () {
                                      FocusScope.of(context).requestFocus(FocusNode());
                                    },
                                    onChanged: (txt) {
                                      otpText = txt;
                                      if (!istimeFinish) {
                                        if (txt.length == 6) {
                                          _animationController.forward();
                                        } else {
                                          _animationController.reverse();
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              otpTimerView
                                  ? OtpTimerView(timeCallBack: (isfinish) {
                                      if (isfinish) {
                                        if (!mounted) return;
                                        setState(() {
                                          istimeFinish = true;
                                          _animationController.forward();
                                        });
                                      }
                                    })
                                  : OtpTimerView(timeCallBack: (isfinish) {
                                      if (isfinish) {
                                        if (!mounted) return;
                                        setState(() {
                                          istimeFinish = true;
                                          _animationController.forward();
                                        });
                                      }
                                    }),
                              Flexible(
                                child: Container(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: <Widget>[
                              new SizeTransition(
                                sizeFactor: new CurvedAnimation(parent: _animationController, curve: Curves.fastOutSlowIn),
                                axis: Axis.horizontal,
                                child: ContinueButton(
                                  name: 'Next',
                                  callBack: () async {
                                    FocusScope.of(context).requestFocus(new FocusNode());
                                    if (globals.connectivityBloc.isOffLine == true) {
                                      Fluttertoast.showToast(msg: ConstanceData.NoInternet, timeInSecForIos: 3);
                                      return;
                                    }
                                    setState(() {
                                      isLoginProsses = true;
                                    });
                                    await Future.delayed(
                                      const Duration(seconds: 1),
                                    );

                                    Fluttertoast.showToast(msg: "Your phone verification successful.", timeInSecForIos: 3);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RegisterScreen(),
                                      ),
                                    );

                                    setState(() {
                                      isLoginProsses = false;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
