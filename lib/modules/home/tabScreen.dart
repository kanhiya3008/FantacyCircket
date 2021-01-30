import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frolicsports/modules/home/newHomeScreen.dart';
import 'package:share/share.dart';
import 'package:frolicsports/constance/constance.dart';
import 'package:frolicsports/constance/sharedPreferences.dart';
import 'package:frolicsports/constance/themes.dart';
import 'package:frolicsports/models/scheduleResponseData.dart';
import 'package:frolicsports/models/userData.dart';
import 'package:frolicsports/modules/drawer/drawer.dart';
import 'package:frolicsports/modules/home/homeScreen.dart';
import 'package:frolicsports/modules/home/termsAndConditions.dart';
import 'package:frolicsports/modules/myProfile/myProfileScreen.dart';
import 'package:frolicsports/modules/standingScreen/standingScreen.dart';
import 'package:frolicsports/validator/validator.dart';

import 'moreScreen.dart';

class TabScreen extends StatefulWidget {
  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  var sheduallist = List<ShedualData>();
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLoginProsses = false;
  Widget tabBody = Container();
  UserData userData;
  @override
  void initState() {
    tabBody = NewHomeScreen(
      menuCallBack: () {
        _scaffoldKey.currentState.openEndDrawer();
      },
    );
    //getData();
    print('Tab Screen');
    super.initState();
  }

  void getData() async {
    var response = await MySharedPreferences().getUserData();
    if (response != null && response.name != null && response.name != '') {
      userData = response;
    }
  }

  @override
  void dispose() {
    if(_controller!=null) {
      _controller.dispose();
    }
    super.dispose();
  }

  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  end: Alignment.bottomCenter,
                  begin: Alignment.topCenter,
                  colors: [
                AllCoustomTheme.getThemeData().primaryColor,
                AllCoustomTheme.getThemeData().primaryColor,
                AllCoustomTheme.getThemeData().backgroundColor,
                AllCoustomTheme.getThemeData().backgroundColor,
              ])),
        ),
        SafeArea(
          top: false,
          child: Scaffold(
            key: _scaffoldKey,
            endDrawer: Container(
              width: MediaQuery.of(context).size.width * 0.75,
              child: AppDrawer(
                mySettingClick: () async {
                  setState(() {
                    currentIndex = 2;
                    tabBody = _buildTransitionsStack();
                  });
                },
                referralClick: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) => uderGroundDrawer(),
                  );
                },
              ),
            ),
            backgroundColor: AllCoustomTheme.getThemeData().backgroundColor,
            bottomNavigationBar: bottomNavyBar(),
            body: tabBody,
          ),
        ),
      ],
    );
  }

  Widget _buildTransitionsStack() {
    if (currentIndex == 0) {
      return NewHomeScreen(
        menuCallBack: () {
          _scaffoldKey.currentState.openEndDrawer();
        },
      );
    } else if (currentIndex == 1) {
      return StandingScree(
        menuCallBack: () {
          _scaffoldKey.currentState.openEndDrawer();
        },
      );
    } else if (currentIndex == 2) {
      return MyProfileScreen();
    } else if (currentIndex == 3) {
      return MoreScreen(inviteFriendClick: () {
        showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) => uderGroundDrawer(),
        );
      });
    } else {
      return Text("");
    }
  }

  Widget bottomNavyBar() {
    return BottomNavyBar(
      selectedIndex: currentIndex,
      onItemSelected: (index) => setState(() {
        currentIndex = index;
        tabBody = _buildTransitionsStack();
      }),
      items: [
        BottomNavyBarItem(
          icon: Icon(
            FontAwesomeIcons.home,
            size: 18,
          ),
          title: Text(
            ' Home',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          activeColor: AllCoustomTheme.getThemeData().primaryColor,
          inactiveColor: HexColor('#AAAFBC'),
        ),
        BottomNavyBarItem(
          icon: Icon(
            FontAwesomeIcons.trophy,
            size: 18,
          ),
          title: Text(
            ' Standings',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          activeColor: AllCoustomTheme.getThemeData().primaryColor,
          inactiveColor: HexColor('#AAAFBC'),
        ),
        BottomNavyBarItem(
          icon: Icon(
            FontAwesomeIcons.userAlt,
            size: 18,
          ),
          title: Text(
            ' Me',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          activeColor: AllCoustomTheme.getThemeData().primaryColor,
          inactiveColor: HexColor('#AAAFBC'),
        ),
        BottomNavyBarItem(
          icon: Icon(
            FontAwesomeIcons.cog,
            size: 18,
          ),
          title: Text(
            ' Setting',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          activeColor: AllCoustomTheme.getThemeData().primaryColor,
          inactiveColor: HexColor('#AAAFBC'),
        ),
      ],
    );
  }

  Widget uderGroundDrawer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          height: 16,
        ),
        Container(
          height: 40,
          padding: EdgeInsets.only(top: 4),
          color: Colors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Kick off your friend's Fixturers journey!",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: ConstanceData.SIZE_TITLE16,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(right: 16, left: 16, bottom: 16),
          child: Text(
            "For every friend that plays, you both get 100 for free!",
            textAlign: TextAlign.justify,
            style: TextStyle(
              color: AllCoustomTheme.getTextThemeColors(),
              fontSize: ConstanceData.SIZE_TITLE14,
            ),
          ),
        ),
        Divider(
          height: 1,
        ),
        Container(
          padding: EdgeInsets.all(8),
          child: Text(
            'SHARE YOUR INVITE CODE',
            style: TextStyle(
              color: AllCoustomTheme.getBlackAndWhiteThemeColors()
                  .withOpacity(0.6),
              fontSize: ConstanceData.SIZE_TITLE12,
            ),
          ),
        ),
        Container(
          height: 40,
          padding: EdgeInsets.only(top: 4),
          color: Colors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    "How it works",
                    style: TextStyle(
                      color: AllCoustomTheme.getThemeData().primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: ConstanceData.SIZE_TITLE14,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Container(
                  height: 24,
                  width: 1,
                  color: Colors.grey.withOpacity(0.5),
                ),
              ),
              InkWell(
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    "Rules of FairPlay",
                    style: TextStyle(
                      color: AllCoustomTheme.getThemeData().primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: ConstanceData.SIZE_TITLE14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(16),
          child: Text(
            'Cricket123',
            style: TextStyle(
              color: AllCoustomTheme.getBlackAndWhiteThemeColors(),
              fontWeight: FontWeight.bold,
              fontSize: ConstanceData.SIZE_TITLE20,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.pop(context);
            Share.share('check out my website https://example.com');
          },
          child: Container(
            padding: EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
            decoration: new BoxDecoration(
              color: AllCoustomTheme.getThemeData().backgroundColor,
              borderRadius: new BorderRadius.circular(4.0),
              border: Border.all(
                color: Colors.green,
                width: 1,
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: Offset(0, 1),
                    blurRadius: 5.0),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Share Code'.toUpperCase(),
                style: TextStyle(
                  color: Colors.green,
                  fontSize: ConstanceData.SIZE_TITLE12,
                ),
              ),
            ),
          ),
        ),
        Container(
          height: 16,
        ),
      ],
    );
  }

  showPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("What are the rules of FairPlay?"),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                child: new Text(
                  "-You cannot create multiple accounts",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: ConstanceData.SIZE_TITLE14,
                  ),
                ),
              ),
              SizedBox(
                height: 2,
              ),
              Container(
                child: new Text(
                  "-You cannot misuse your invite code in any way",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: ConstanceData.SIZE_TITLE14,
                  ),
                ),
              ),
              SizedBox(
                height: 2,
              ),
              Container(
                child: new Text(
                  "-You cannot misuse your cash bonus in any way",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: ConstanceData.SIZE_TITLE14,
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                child: new Text(
                  "What happens when:",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: ConstanceData.SIZE_TITLE14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Container(
                child: new Text(
                  "-You misuse your Invite Code by creating multiple accounts:",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: ConstanceData.SIZE_TITLE14,
                  ),
                ),
              ),
              SizedBox(
                height: 2,
              ),
              Container(
                child: new Text(
                  "WE BLOCK THE CASH BONUS AND THE INVITE CODE",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: ConstanceData.SIZE_TITLE14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Container(
                child: new Text(
                  "-You misuse the cash bonus and win contests:",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: ConstanceData.SIZE_TITLE14,
                  ),
                ),
              ),
              SizedBox(
                height: 2,
              ),
              Container(
                child: new Text(
                  "WE TAKE BACK WINNINGS OF THAT CONTEST",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: ConstanceData.SIZE_TITLE14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'For further details.refer to our ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: ConstanceData.SIZE_TITLE14,
                      ),
                    ),
                    TextSpan(
                      text: 'T&Cs',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: AllCoustomTheme.getThemeData().primaryColor,
                        fontSize: ConstanceData.SIZE_TITLE14,
                      ),
                      recognizer: new TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TermsAndConditionsScreen(),
                              fullscreenDialog: true,
                            ),
                          );
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
