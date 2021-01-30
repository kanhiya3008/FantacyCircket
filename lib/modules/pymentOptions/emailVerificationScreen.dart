import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:frolicsports/constance/constance.dart';
import 'package:frolicsports/constance/themes.dart';
import 'package:frolicsports/models/bankinfoResponce.dart';

class EmailVerificationScreen extends StatefulWidget {
  @override
  _EmailVerificationScreenState createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isProsses = false;
  bool isFirstTime = true;
  bool isRejected = false;
  bool approved = false;
  var pancardDetail = PancardDetail();

  var noController = new TextEditingController();
  var emailController = new TextEditingController();

  @override
  void initState() {
    getPancardData();
    super.initState();
  }

  void getPancardData() async {
    setState(() {
      isProsses = true;
      noController.text = '98765433210';
      emailController.text = 'oliver123@gmail.com';
    });

    setState(() {
      isFirstTime = false;
      isProsses = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Colors.white,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: <Widget>[
          SafeArea(
            child: Scaffold(
              key: _scaffoldKey,
              backgroundColor: AllCoustomTheme.getThemeData().backgroundColor,
              body: ModalProgressHUD(
                inAsyncCall: isProsses,
                color: Colors.transparent,
                progressIndicator: CircularProgressIndicator(
                  strokeWidth: 2.0,
                ),
                child: isFirstTime
                    ? SizedBox()
                    : Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: <Widget>[
                          isRejected
                              ? Positioned(
                                  top: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        top: 8, left: 32, right: 32),
                                    child: Text(
                                      isRejected
                                          ? 'Your Pan Card Verification Has been Rejected'
                                          : '',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ),
                                )
                              : SizedBox(),
                          Column(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  child: expandData(),
                                ),
                              )
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.all(16),
                            child: Text(
                              'Your E-mail and Mobile Number are Verified.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.green),
                            ),
                          )
                        ],
                      ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget expandData() {
    return Container(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: new Container(
                child: new TextField(
                  controller: noController,
                  style: TextStyle(
                    fontSize: ConstanceData.SIZE_TITLE16,
                    color: AllCoustomTheme.getBlackAndWhiteThemeColors(),
                  ),
                  autofocus: false,
                  decoration: new InputDecoration(
                    labelText: 'Mobile No',
                  ),
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  onChanged: (value) {
                    pancardDetail.accountNo = value;
                  },
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: new Container(
                child: new TextField(
                  controller: emailController,
                  style: TextStyle(
                    fontSize: ConstanceData.SIZE_TITLE16,
                    color: AllCoustomTheme.getBlackAndWhiteThemeColors(),
                  ),
                  autofocus: false,
                  decoration: new InputDecoration(
                    labelText: 'Emial',
                  ),
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  onChanged: (value) {
                    pancardDetail.accountPhoto = value;
                  },
                ),
              ),
            ),
            SizedBox(
              height: 80,
            ),
          ],
        ),
      ),
    );
  }
}
