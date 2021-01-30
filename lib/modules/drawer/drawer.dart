import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info/package_info.dart';
import 'package:frolicsports/api/logout.dart';
import 'package:frolicsports/constance/constance.dart';
import 'package:frolicsports/constance/themes.dart';
import 'package:frolicsports/modules/color/setColor.dart';
import 'package:frolicsports/modules/notification/notificationScreen.dart';
import 'package:frolicsports/modules/pymentOptions/pymentOptionsScreen.dart';
import 'package:frolicsports/utils/avatarImage.dart';
import 'package:frolicsports/constance/global.dart' as globals;

class AppDrawer extends StatefulWidget {
  final VoidCallback mySettingClick;
  final VoidCallback referralClick;

  const AppDrawer({Key key, this.mySettingClick, this.referralClick}) : super(key: key);
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  var appVerison = '1.0.0';
  bool isLoginProsses = false;
  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      print(packageInfo.appName);
      print(packageInfo.packageName);
      print(packageInfo.buildNumber);
      print(packageInfo.version);
      setState(() {
        appVerison = packageInfo.version;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: Column(
        children: <Widget>[
          Container(
            color: AllCoustomTheme.getThemeData().primaryColor,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).padding.top,
                ),
                userDetail(),
              ],
            ),
          ),
          Flexible(
            child: ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    myNotification(),
                    Divider(
                      height: 1,
                    ),
                    myProfile(),
                    Divider(
                      height: 1,
                    ),
                    myBalance(),
                    Divider(
                      height: 1,
                    ),
                    myReferrals(),
                    Divider(
                      height: 1,
                    ),
                    myInfoSetting(),
                    Divider(
                      height: 1,
                    ),
                    poinSystem(),
                    Divider(
                      height: 1,
                    ),
                    logoutButton(),
                    Divider(
                      height: 1,
                    )
                  ],
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(4),
            child: Column(
              children: <Widget>[
                Text('v $appVerison'),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget userDetail() {
    return Container(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 32),
            child: Icon(
              FontAwesomeIcons.chevronLeft,
              size: 22,
              color: AllCoustomTheme.getReBlackAndWhiteThemeColors(),
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            new Text(
                              'pank',//TODO globals.userdata.name.substring(0,8),
                              style: TextStyle(
                                fontSize: ConstanceData.SIZE_TITLE22,
                                color: AllCoustomTheme.getReBlackAndWhiteThemeColors(),
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.location_on,
                              size: 10,
                              color: AllCoustomTheme.getThemeData().backgroundColor.withOpacity(0.5),
                            ),
                            new Text(
                              ' ' + '',
                              style: TextStyle(
                                fontSize: ConstanceData.SIZE_TITLE14,
                                color: AllCoustomTheme.getThemeData().backgroundColor.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Container(
                    width: 50.0,
                    height: 50.0,
                    child: AvatarImage(
                      isCircle: true,
                      imageUrl: 'pank_image',//TODO globals.userdata.image,
//                      'https://www.menshairstylesnow.com/wp-content/uploads/2018/03/Hairstyles-for-Square-Faces-Slicked-Back-Undercut.jpg',
                      radius: 50,
                      sizeValue: 50,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget myNotification() {
    return Container(
      height: 54,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotificationScreen(),
              fullscreenDialog: true,
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.only(left: 14, right: 14),
          child: new Row(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.solidBell,
                    size: 22,
                    color: AllCoustomTheme.getThemeData().primaryColor,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 3,
                  )
                ],
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  'Notification',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: AllCoustomTheme.getThemeData().primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget myBalance() {
    return Container(
      height: 54,
      child: Padding(
        padding: EdgeInsets.only(left: 14, right: 14),
        child: new Row(
          children: <Widget>[
            Container(
              child: Icon(
                FontAwesomeIcons.wallet,
                color: AllCoustomTheme.getThemeData().primaryColor,
                size: 22,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Container(
                child: Text(
                  'My Balance',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: AllCoustomTheme.getThemeData().primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PymentScreen(
                          isOnlyAddMoney: true,
                          isTruePayment: () {},
                        ),
                        fullscreenDialog: true,
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
                    decoration: new BoxDecoration(
                      color: AllCoustomTheme.getThemeData().backgroundColor,
                      borderRadius: new BorderRadius.circular(4.0),
                      border: Border.all(
                        color: Colors.green,
                        width: 1,
                      ),
                      boxShadow: <BoxShadow>[
                        BoxShadow(color: Colors.black.withOpacity(0.2), offset: Offset(0, 1), blurRadius: 5.0),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'ADD CASH'.toUpperCase(),
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: ConstanceData.SIZE_TITLE12,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget myRewardsOffers() {
    return Container(
      height: 54,
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: EdgeInsets.only(left: 14, right: 14),
          child: new Row(
            children: <Widget>[
              Container(
                child: Icon(
                  FontAwesomeIcons.gift,
                  color: AllCoustomTheme.getThemeData().primaryColor,
                  size: 22,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Container(
                  child: Text(
                    'My Rewards & Offers',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: AllCoustomTheme.getThemeData().primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget myReferrals() {
    return Container(
      height: 54,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          widget.referralClick();
        },
        child: Padding(
          padding: EdgeInsets.only(left: 12, right: 14),
          child: new Row(
            children: <Widget>[
              Container(
                child: Icon(
                  Icons.group_add,
                  color: AllCoustomTheme.getThemeData().primaryColor,
                  size: 28,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Container(
                  child: Text(
                    'My Referrals',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: AllCoustomTheme.getThemeData().primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget myInfoSetting() {
    return Container(
      height: 54,
      child: InkWell(
        onTap: () async {
          widget.mySettingClick();
          await Future.delayed(const Duration(milliseconds: 100));
          Navigator.pop(context);
        },
        child: Padding(
          padding: EdgeInsets.only(left: 14, right: 14),
          child: new Row(
            children: <Widget>[
              Container(
                child: Icon(
                  FontAwesomeIcons.cog,
                  color: AllCoustomTheme.getThemeData().primaryColor,
                  size: 22,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Container(
                  child: Text(
                    'My Info & Settings',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: AllCoustomTheme.getThemeData().primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget poinSystem() {
    return Container(
      height: 54,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SetColorScreen(),
              fullscreenDialog: true,
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.only(left: 14, right: 14),
          child: new Row(
            children: <Widget>[
              Container(
                child: Icon(
                  Icons.color_lens,
                  color: AllCoustomTheme.getThemeData().primaryColor,
                  size: 22,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Container(
                  child: Text(
                    'Set Color',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: AllCoustomTheme.getThemeData().primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget myProfile() {
    return Container(
      height: 54,
      child: InkWell(
        onTap: () async {
          widget.mySettingClick();
          await Future.delayed(const Duration(milliseconds: 100));
          Navigator.pop(context);
        },
        child: Padding(
          padding: EdgeInsets.only(left: 14, right: 14),
          child: new Row(
            children: <Widget>[
              Container(
                child: Icon(
                  FontAwesomeIcons.solidUserCircle,
                  color: AllCoustomTheme.getThemeData().primaryColor,
                  size: 22,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Container(
                  child: Text(
                    'My Profile',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: AllCoustomTheme.getThemeData().primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget logoutButton() {
    return Container(
      height: 54,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          LogOut().logout(context);
        },
        child: Padding(
          padding: EdgeInsets.only(left: 14, right: 14),
          child: new Row(
            children: <Widget>[
              Container(
                child: Icon(
                  FontAwesomeIcons.powerOff,
                  color: AllCoustomTheme.getThemeData().primaryColor,
                  size: 22,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Container(
                  child: Text(
                    'Logout',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: AllCoustomTheme.getThemeData().primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
