import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:frolicsports/api/apiProvider.dart';
import 'package:frolicsports/api/logout.dart';
import 'package:frolicsports/constance/constance.dart';
import 'package:frolicsports/constance/sharedPreferences.dart';
import 'package:frolicsports/constance/themes.dart';
import 'package:frolicsports/models/userData.dart';
import 'package:frolicsports/modules/home/homeScreen.dart';
import 'package:frolicsports/modules/myProfile/transectionHistoryScreen.dart';
import 'package:frolicsports/modules/myProfile/updateProfileScreen.dart';
import 'package:frolicsports/modules/pymentOptions/withdrawScreen.dart';
import 'package:frolicsports/utils/avatarImage.dart';

var responseData;

class MyProfileScreen extends StatefulWidget {
  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> with SingleTickerProviderStateMixin {
  double _appBarHeight = 100.0;
  AppBarBehavior _appBarBehavior = AppBarBehavior.pinned;
  var name = '';
  TabController controller;
  var imageUrl = '';
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    getUserData();
    super.initState();
    controller = new TabController(length: 3, vsync: this);

    var profileData = ApiProvider().getProfile();
    if (profileData != null && profileData.data != null) {
      final txt = profileData.data.name.trim().split(' ');
      name = txt[0][0].toUpperCase() + txt[0].substring(1, txt[0].length);
      imageUrl = profileData.data.image;
      MySharedPreferences().setUserDataString(profileData.data);
    }
  }

  void getUserData() async {
    var responseData = await ApiProvider().drawerInfoList();
    if (responseData != null) {
      setState(() {
        final words = responseData.data.name.split(' ');
        final fname = words.length > 0 ? words[0] : '';
        final lName = words.length > 1 ? words[1] : '';
        if (fname != null && fname != '' && lName != null && lName != '') {
          name = fname[0].toUpperCase() + fname.substring(1, fname.length);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          color: AllCoustomTheme.getThemeData().primaryColor,
        ),
        SafeArea(
          child: Scaffold(
            backgroundColor: AllCoustomTheme.getThemeData().backgroundColor,
            body: Stack(
              children: <Widget>[
                new NestedScrollView(
                  controller: _scrollController,
                  headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverAppBar(
                        leading: Container(),
                        expandedHeight: _appBarHeight,
                        pinned: _appBarBehavior == AppBarBehavior.pinned,
                        floating: _appBarBehavior == AppBarBehavior.floating || _appBarBehavior == AppBarBehavior.snapping,
                        snap: _appBarBehavior == AppBarBehavior.snapping,
                        backgroundColor: AllCoustomTheme.getThemeData().primaryColor,
                        primary: true,
                        centerTitle: false,
                        flexibleSpace: sliverText(),
                        elevation: 0.0,
                      ),
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: PersistentHeader(controller),
                      ),
                    ];
                  },
                  body: Container(
                    color: AllCoustomTheme.getThemeData().backgroundColor,
                    child: TabBarView(
                      controller: controller,
                      children: <Widget>[
                        AccountInfoScreen(
                          update: () {
                            getUserData();
                          },
                        ),
                        PlayingHistory(),
                        Wallet(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget sliverText() {
    return FlexibleSpaceBar(
      titlePadding: EdgeInsetsDirectional.only(start: 16, bottom: 8, top: 0),
      centerTitle: false,
      title: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 44,
            width: 44,
            child: AvatarImage(
              sizeValue: 44,
              radius: 44,
              isCircle: true,
              imageUrl: ConstanceData.appIcon,
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            '$name',
            style: TextStyle(
              fontSize: 24,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
              color: AllCoustomTheme.getThemeData().backgroundColor,
            ),
          ),
        ],
      ),
    );
  }
}

class AccountInfoScreen extends StatefulWidget {
  final Function update;

  const AccountInfoScreen({Key key, this.update}) : super(key: key);
  @override
  _AccountInfoScreenState createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
  bool isLoginProsses = false;
  UserData data = UserData();

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    setState(() {
      isLoginProsses = true;
    });
    var responseData = ApiProvider().getProfile();
    data = responseData.data;
    setState(() {
      isLoginProsses = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AllCoustomTheme.getThemeData().backgroundColor,
      floatingActionButton: FloatingActionButton(
        foregroundColor: AllCoustomTheme.getThemeData().backgroundColor,
        backgroundColor: AllCoustomTheme.getThemeData().primaryColor,
        onPressed: () async {
          if (data.name != '') {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UpdateProfileScreen(
                  loginUserData: data,
                ),
              ),
            );
            getUserData();
            widget.update();
          }
        },
        child: Icon(Icons.edit),
      ),
      body: Container(
        child: ModalProgressHUD(
          inAsyncCall: isLoginProsses,
          color: Colors.transparent,
          progressIndicator: CircularProgressIndicator(
            strokeWidth: 2.0,
          ),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: data.name != ''
                ? Container(
                    padding: EdgeInsets.only(top: 16),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(right: 16, left: 16, top: 16, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: 100,
                                child: Text(
                                  'Name',
                                  style: TextStyle(
                                    fontSize: ConstanceData.SIZE_TITLE16,
                                    color: AllCoustomTheme.getTextThemeColors(),
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  data.name,
                                  style: TextStyle(
                                    fontSize: ConstanceData.SIZE_TITLE16,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(),
                        Container(
                          padding: EdgeInsets.only(right: 16, left: 16, top: 16, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: 100,
                                child: Text(
                                  'Email',
                                  style: TextStyle(
                                    fontSize: ConstanceData.SIZE_TITLE16,
                                    color: AllCoustomTheme.getTextThemeColors(),
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  data.email,
                                  style: TextStyle(
                                    fontSize: ConstanceData.SIZE_TITLE16,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(),
                        Container(
                          padding: EdgeInsets.only(right: 16, left: 16, top: 16, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: 100,
                                child: Text(
                                  'Mobile No',
                                  style: TextStyle(
                                    fontSize: ConstanceData.SIZE_TITLE16,
                                    color: AllCoustomTheme.getTextThemeColors(),
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  data.mobileNumber,
                                  style: TextStyle(
                                    fontSize: ConstanceData.SIZE_TITLE16,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(),
                        Container(
                          padding: EdgeInsets.only(right: 16, left: 16, top: 16, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: 100,
                                child: Text(
                                  'Date of Birth',
                                  style: TextStyle(
                                    fontSize: ConstanceData.SIZE_TITLE16,
                                    color: AllCoustomTheme.getTextThemeColors(),
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  DateFormat('dd MMM, yyyy').format(DateFormat('dd/MM/yyyy').parse(data.dob)),
                                  style: TextStyle(
                                    fontSize: ConstanceData.SIZE_TITLE16,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(),
                        Container(
                          padding: EdgeInsets.only(right: 16, left: 16, top: 16, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: 100,
                                child: Text(
                                  'Gender',
                                  style: TextStyle(
                                    fontSize: ConstanceData.SIZE_TITLE16,
                                    color: AllCoustomTheme.getTextThemeColors(),
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  data.gender[0].toUpperCase() + data.gender.substring(1),
                                  style: TextStyle(
                                    fontSize: ConstanceData.SIZE_TITLE16,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(),
                        Container(
                          padding: EdgeInsets.only(right: 16, left: 16, top: 16, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: 100,
                                child: Text(
                                  'Country',
                                  style: TextStyle(
                                    fontSize: ConstanceData.SIZE_TITLE16,
                                    color: AllCoustomTheme.getTextThemeColors(),
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  data.country == '' ? 'India' : '',
                                  style: TextStyle(
                                    fontSize: ConstanceData.SIZE_TITLE16,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(),
                        Container(
                          padding: EdgeInsets.only(right: 16, left: 16, top: 16, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: 100,
                                child: Text(
                                  'State',
                                  style: TextStyle(
                                    fontSize: ConstanceData.SIZE_TITLE16,
                                    color: AllCoustomTheme.getTextThemeColors(),
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  data.state,
                                  style: TextStyle(
                                    fontSize: ConstanceData.SIZE_TITLE16,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(),
                        Container(
                          padding: EdgeInsets.only(right: 16, left: 16, top: 16, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: 100,
                                child: Text(
                                  'City',
                                  style: TextStyle(
                                    fontSize: ConstanceData.SIZE_TITLE16,
                                    color: AllCoustomTheme.getTextThemeColors(),
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  data.city,
                                  style: TextStyle(
                                    fontSize: ConstanceData.SIZE_TITLE16,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(),
                        logoutButton(),
                      ],
                    ),
                  )
                : SizedBox(),
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
          LogOut().logout(context);
        },
        child: Padding(
          padding: EdgeInsets.only(left: 14, right: 14),
          child: new Row(
            children: <Widget>[
              Container(
                child: Icon(
                  FontAwesomeIcons.powerOff,
                  size: 22,
                ),
              ),
              SizedBox(
                width: 30,
              ),
              Expanded(
                child: Container(
                  child: Text(
                    'Logout',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: AllCoustomTheme.getBlackAndWhiteThemeColors(),
                      fontSize: ConstanceData.SIZE_TITLE14,
                      fontWeight: FontWeight.w400,
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

class PlayingHistory extends StatefulWidget {
  @override
  _PlayingHistoryState createState() => _PlayingHistoryState();
}

class _PlayingHistoryState extends State<PlayingHistory> {
  bool isLoginProsses = false;
  UserData data = UserData();

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    setState(() {
      isLoginProsses = true;
    });
    var responseData = ApiProvider().getProfile();
    if (responseData != null && responseData.data != null) {
      data = responseData.data;
    }
    if (!mounted) return;
    setState(() {
      isLoginProsses = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 16),
      child: Center(
        child: ModalProgressHUD(
          inAsyncCall: isLoginProsses,
          color: Colors.transparent,
          progressIndicator: CircularProgressIndicator(
            strokeWidth: 2.0,
          ),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(right: 16, left: 16, top: 16, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: 100,
                      child: Text(
                        'Contests',
                        style: TextStyle(
                          fontSize: ConstanceData.SIZE_TITLE16,
                          color: AllCoustomTheme.getTextThemeColors(),
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        '88',
                      ),
                    )
                  ],
                ),
              ),
              Divider(),
              Container(
                padding: EdgeInsets.only(right: 16, left: 16, top: 16, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: 100,
                      child: Text(
                        'Matches',
                        style: TextStyle(
                          fontSize: ConstanceData.SIZE_TITLE16,
                          color: AllCoustomTheme.getTextThemeColors(),
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        '43',
                      ),
                    )
                  ],
                ),
              ),
              Divider(),
              Container(
                padding: EdgeInsets.only(right: 16, left: 16, top: 16, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: 100,
                      child: Text(
                        'Series',
                        style: TextStyle(
                          fontSize: ConstanceData.SIZE_TITLE16,
                          color: AllCoustomTheme.getTextThemeColors(),
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        '4',
                      ),
                    )
                  ],
                ),
              ),
              Divider(),
              Container(
                padding: EdgeInsets.only(right: 16, left: 16, top: 16, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: 100,
                      child: Text(
                        'Wins',
                        style: TextStyle(
                          fontSize: ConstanceData.SIZE_TITLE16,
                          color: AllCoustomTheme.getTextThemeColors(),
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        '7',
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Wallet extends StatefulWidget {
  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  bool isLoginProsses = false;
  UserData data = UserData();
  bool emialApproved = false;
  bool pancardApproved = false;
  bool bankApproved = false;
  bool allApproved = false;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    setState(() {
      isLoginProsses = true;
    });

    var responseData = ApiProvider().getProfile();

    if (responseData != null && responseData.data != null) {
      data = responseData.data;
    }

    var email = await ApiProvider().getEmailResponce();

    if ('Your E-mail and Mobile Number are Verified.' == email.message) {
      emialApproved = true;
    }

    var pancard = await ApiProvider().getPanCardResponce();

    if (pancard.success == '1') {
      if (pancard.pancardDetail != null) {
        if (pancard.pancardDetail.length > 0) {
          if (pancard.pancardDetail[0].pancardNo != '') {
            if ('Your Pan Card Verification Has been Approved' == pancard.message) {
              pancardApproved = true;
            }
          }
        }
      }
    }

    var bankData = await ApiProvider().bankListApprovedResponseData();
    if (bankData.success == 1) {
      if (bankData.accountDetail != null) {
        if (bankData.accountDetail.length > 0) {
          bankApproved = true;
        }
      }
    }

    if (emialApproved && pancardApproved && bankApproved) {
      allApproved = true;
    }

    setState(() {
      isLoginProsses = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8),
      child: Center(
        child: ModalProgressHUD(
          inAsyncCall: isLoginProsses,
          color: Colors.transparent,
          progressIndicator: CircularProgressIndicator(
            strokeWidth: 2.0,
          ),
          child: data.name != ''
              ? Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(right: 16, left: 16, top: 16, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: 110,
                            child: Text(
                              'Total balance',
                              style: TextStyle(
                                fontSize: ConstanceData.SIZE_TITLE16,
                                color: AllCoustomTheme.getTextThemeColors(),
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              '₹' + data.balance,
                              style: TextStyle(
                                fontSize: ConstanceData.SIZE_TITLE16,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Divider(),
                    Container(
                      padding: EdgeInsets.only(right: 16, left: 16, top: 16, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: 110,
                            child: Text(
                              'Deposit',
                              style: TextStyle(
                                fontSize: ConstanceData.SIZE_TITLE16,
                                color: AllCoustomTheme.getTextThemeColors(),
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              '₹0',
                              style: TextStyle(
                                fontSize: ConstanceData.SIZE_TITLE16,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Divider(),
                    Container(
                      padding: EdgeInsets.only(right: 16, left: 16, top: 4, bottom: 4),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 110,
                            child: Text(
                              'Winning',
                              style: TextStyle(
                                fontSize: ConstanceData.SIZE_TITLE16,
                                color: AllCoustomTheme.getTextThemeColors(),
                              ),
                            ),
                          ),
                          Expanded(
                            child: SizedBox(),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WithdrawScreen(),
                                  fullscreenDialog: true,
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                              decoration: new BoxDecoration(
                                color: AllCoustomTheme.getThemeData().backgroundColor,
                                borderRadius: new BorderRadius.circular(50.0),
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
                                  'withdraw'.toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: ConstanceData.SIZE_TITLE14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Container(
                            child: Text(
                              '₹0',
                              style: TextStyle(
                                fontSize: ConstanceData.SIZE_TITLE16,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    !allApproved
                        ? Container(
                            padding: EdgeInsets.only(top: 4),
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Verify your account to be eligible to withdraw.      ',
                              style: TextStyle(
                                fontSize: ConstanceData.SIZE_TITLE12,
                                color: Colors.red,
                              ),
                            ),
                          )
                        : SizedBox(),
                    Divider(),
                    Container(
                      padding: EdgeInsets.only(right: 16, left: 16, top: 16, bottom: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: 110,
                            child: Text(
                              'Bonus',
                              style: TextStyle(
                                fontSize: ConstanceData.SIZE_TITLE16,
                                color: AllCoustomTheme.getTextThemeColors(),
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              '₹' + data.cashBonus,
                              style: TextStyle(
                                fontSize: ConstanceData.SIZE_TITLE16,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TransectionHistoryScreen(),
                            fullscreenDialog: true,
                          ),
                        );
                      },
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 60,
                            color: AllCoustomTheme.getThemeData().primaryColor.withOpacity(0.2),
                            padding: EdgeInsets.only(left: 16, right: 16),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    "My Transactions",
                                    style: TextStyle(
                                      fontSize: ConstanceData.SIZE_TITLE16,
                                      fontWeight: FontWeight.bold,
                                      color: AllCoustomTheme.getThemeData().primaryColor,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  size: ConstanceData.SIZE_TITLE22,
                                  color: AllCoustomTheme.getThemeData().primaryColor,
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : SizedBox(),
        ),
      ),
    );
  }
}

class PersistentHeader extends SliverPersistentHeaderDelegate {
  final TabController controller;

  PersistentHeader(
    this.controller,
  );

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Column(
      children: <Widget>[
        Container(
          height: 40,
          color: AllCoustomTheme.getThemeData().backgroundColor,
          child: new TabBar(
            unselectedLabelColor: AllCoustomTheme.getTextThemeColors(),
            indicatorColor: AllCoustomTheme.getThemeData().primaryColor,
            labelColor: AllCoustomTheme.getThemeData().primaryColor,
            tabs: [
              new Tab(text: 'Account Info'),
              new Tab(text: 'Playing History'),
              new Tab(text: 'Wallet'),
            ],
            controller: controller,
          ),
        ),
        Divider(
          height: 1,
        )
      ],
    );
  }

  @override
  double get maxExtent => 41.0;

  @override
  double get minExtent => 41.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
