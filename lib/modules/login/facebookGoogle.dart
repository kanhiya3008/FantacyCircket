import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frolicsports/constance/constance.dart';
import 'package:frolicsports/constance/themes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frolicsports/modules/phoneauth/PhoneValidationScreen.dart';
import 'package:frolicsports/validator/validator.dart';
import 'package:frolicsports/constance/global.dart' as globals;

class FacebookGoogleView extends StatefulWidget {
  final loginCallBack;

  const FacebookGoogleView({Key key, this.loginCallBack}) : super(key: key);
  @override
  _FacebookGoogleViewState createState() => _FacebookGoogleViewState();
}

class _FacebookGoogleViewState extends State<FacebookGoogleView> {

  var emailtxt = '';
  var name = '';
  var id = '';
  var imageUrl = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 8,
          ),
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  decoration: new BoxDecoration(
                    color: HexColor('#4267B2'),
                    borderRadius: new BorderRadius.circular(4.0),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: new BorderRadius.circular(8.0),
                      onTap: () {
                        setFaceBookLogin();
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 12, bottom: 12),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(
                                FontAwesomeIcons.facebookF,
                                size: 18,
                                color: AllCoustomTheme.getThemeData()
                                    .backgroundColor,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                'Continue with Facebook',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: ConstanceData.SIZE_TITLE14,
                                  color: AllCoustomTheme.getThemeData()
                                      .backgroundColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  decoration: new BoxDecoration(
                    color: Colors.red,
                    borderRadius: new BorderRadius.circular(4.0),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: new BorderRadius.circular(8.0),
                      onTap: () async {
                        _handleSignIn(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 12, bottom: 12),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(
                                FontAwesomeIcons.googlePlusG,
                                size: 18,
                                color: AllCoustomTheme.getThemeData()
                                    .backgroundColor,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                'Continue with Google',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: ConstanceData.SIZE_TITLE14,
                                  color: AllCoustomTheme.getThemeData()
                                      .backgroundColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void setFaceBookLogin() async {
    FocusScope.of(context).requestFocus(new FocusNode());
    if (globals.connectivityBloc.isOffLine == true) {
      Fluttertoast.showToast(msg: ConstanceData.NoInternet, timeInSecForIos: 3);
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhoneValidationScreen(),
      ),
    );
  }
}

Future<void> _handleSignIn(context) async {
  if (globals.connectivityBloc.isOffLine == true) {
    Fluttertoast.showToast(msg: ConstanceData.NoInternet, timeInSecForIos: 3);
    return;
  }
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PhoneValidationScreen(),
    ),
  );
}
