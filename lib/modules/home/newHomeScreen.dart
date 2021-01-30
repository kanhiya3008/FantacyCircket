import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:frolicsports/bloc/authBloc.dart';
import 'package:frolicsports/bloc/contestDataBloc.dart';
import 'package:frolicsports/bloc/sportsDataBloc.dart';
import 'package:frolicsports/constance/constance.dart';
import 'package:frolicsports/constance/themes.dart';
import 'package:frolicsports/models/userData.dart';
import 'package:frolicsports/modules/contests/contestsScreen.dart';
import 'package:frolicsports/modules/home/homeScreen.dart';
import 'package:frolicsports/modules/result/standingResult.dart';
import 'package:frolicsports/utils/avatarImage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frolicsports/constance/global.dart' as globals;
import 'package:frolicsports/validator/validator.dart';
import 'package:intl/intl.dart';

class NewHomeScreen extends StatefulWidget {
  final void Function() menuCallBack;

  const NewHomeScreen({Key key, this.menuCallBack}) : super(key: key);
  @override
  NewHomeScreenState createState() => NewHomeScreenState();
}

class NewHomeScreenState extends State<NewHomeScreen>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController = new ScrollController();
  double _appBarHeight = 100.0;
  AppBarBehavior _appBarBehavior = AppBarBehavior.pinned;
  TabController controller;

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKeyF =
      new GlobalKey<RefreshIndicatorState>();
  @override
  void initState() {
    super.initState();
    updateData();
  }

  updateData() async {
    //print('data11111111111');
    print(context.bloc<SportsDataBloc>().getSportsList());
    controller = new TabController(
        length: context.bloc<SportsDataBloc>().getSportsList() == 0
            ? 1
            : context.bloc<SportsDataBloc>().getSportsList(),
        vsync: this);
//    controller = new TabController(length: 1, vsync: this);
//    userData = await MySharedPreferences().getUserData();
//    setState(() {});
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
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverAppBar(
                        leading: Container(),
                        expandedHeight: _appBarHeight,
                        pinned: _appBarBehavior == AppBarBehavior.pinned,
                        floating: _appBarBehavior == AppBarBehavior.floating ||
                            _appBarBehavior == AppBarBehavior.snapping,
                        snap: _appBarBehavior == AppBarBehavior.snapping,
                        backgroundColor:
                            AllCoustomTheme.getThemeData().primaryColor,
                        primary: true,
                        centerTitle: false,
                        flexibleSpace: sliverText(),
                        elevation: 0.0,
                        actions: <Widget>[
                          drawerButton(context),
                        ],
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
                        Matches(),
//                        Live(),
//                        Results(),
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

  UserData userData;

  Widget drawerButton(BuildContext context) {
    return InkWell(
      onTap: openDrawer,
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundColor:
                AllCoustomTheme.getThemeData().scaffoldBackgroundColor,
            radius: 14,
            child: AvatarImage(
              imageUrl: context.bloc<AuthBloc>().getCurrentUser().image,
              isCircle: true,
              radius: 28,
              sizeValue: 28,
              isAssets: false,
            ),
          ),
          Icon(Icons.sort,
              color: AllCoustomTheme.getReBlackAndWhiteThemeColors())
        ],
      ),
    );
  }

  Widget sliverText() {
    return FlexibleSpaceBar(
      centerTitle: false,
      titlePadding: EdgeInsetsDirectional.only(start: 0, bottom: 8, top: 0),
      title: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Text(
                'Matches',
                style: TextStyle(
                  fontSize: 24,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500,
                  color: AllCoustomTheme.getThemeData().backgroundColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void openDrawer() {
    widget.menuCallBack();
  }
}

class Matches extends StatefulWidget {
  @override
  _MatchesState createState() => _MatchesState();
}

class _MatchesState extends State<Matches> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SportsDataBloc, SportsDataBlocState>(
        builder: (_, sportsState) {
      return Column(
        children: sportsState.sportsMap[globals.defaultSports]
            .map(
              (matchDataForApp) => Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ContestsScreen(matchDataForApp),
                        ),
                      );
                    },
                    onLongPress: () {
                      showModalBottomSheet<void>(
                        context: context,
                        builder: (
                          BuildContext context,
                        ) =>
                            UnderGroundDrawer(),
                      );
                    },
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            bottom: 10,
                            top: 16,
                          ),
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 50,
                                height: 50,
                                child: Image.asset('assets/19.png'),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new Text(
                                      matchDataForApp.tournamentName,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: ConstanceData.SIZE_TITLE12,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.only(left: 8),
                                              child: Text(
                                                matchDataForApp
                                                    .firstTeamShortName,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: AllCoustomTheme
                                                          .getThemeData()
                                                      .primaryColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              'vs',
                                              style: TextStyle(
                                                fontSize:
                                                    ConstanceData.SIZE_TITLE14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding:
                                                  EdgeInsets.only(right: 8),
                                              child: Text(
                                                matchDataForApp
                                                    .secondTeamShortName,
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: AllCoustomTheme
                                                          .getThemeData()
                                                      .primaryColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
//                              Text(
                                    CountdownTimer(
                                      endTime: matchDataForApp.deadlineTime,
                                      onEnd: () {
                                        print('onEnd');
                                        context
                                            .bloc<SportsDataBloc>()
                                            .deleteMatchfromList(
                                                matchDataForApp);
                                      },
                                    ),
//                                    matchDataForApp.startDate + ' ' + matchDataForApp.startTime,
//
//                                style: TextStyle(
//                                  color: HexColor(
//                                    '#AAAFBC',
//                                  ),
//                                  fontWeight: FontWeight.w600,
//                                  fontSize: 14,
//                                ),
//                              ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 50,
                                height: 50,
                                child: Image.asset('assets/25.png'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                ],
              ),
            )
            .toList(),
      );
    });
  }
}

class Fixtures extends StatefulWidget {
  @override
  _FixturesState createState() => _FixturesState();
}

class _FixturesState extends State<Fixtures> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Column(
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContestsScreen(null), //TODO
                    ),
                  );
                },
                onLongPress: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (
                      BuildContext context,
                    ) =>
                        UnderGroundDrawer(),
                  );
                },
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 16,
                        top: 16,
                      ),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 50,
                            height: 50,
                            child: Image.asset('assets/19.png'),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Text(
                                  'ICC Cricket World Cup',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: ConstanceData.SIZE_TITLE12,
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.only(left: 8),
                                          child: Text(
                                            'SA',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize:
                                                  ConstanceData.SIZE_TITLE14,
                                              fontWeight: FontWeight.bold,
                                              color: AllCoustomTheme
                                                  .getBlackAndWhiteThemeColors(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: Text(
                                          'vs',
                                          style: TextStyle(
                                            fontSize:
                                                ConstanceData.SIZE_TITLE12,
                                            fontWeight: FontWeight.bold,
                                            color: AllCoustomTheme
                                                .getTextThemeColors(),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.only(right: 8),
                                          child: Text(
                                            'IND',
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                              fontSize:
                                                  ConstanceData.SIZE_TITLE14,
                                              fontWeight: FontWeight.bold,
                                              color: AllCoustomTheme
                                                  .getBlackAndWhiteThemeColors(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '01 : 30 : 00',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            child: Image.asset('assets/25.png'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContestsScreen(null), //TODO
                    ),
                  );
                },
                onLongPress: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (
                      BuildContext context,
                    ) =>
                        UnderGroundDrawer(),
                  );
                },
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 16,
                        top: 16,
                      ),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 50,
                            height: 50,
                            child: Image.asset('assets/21.png'),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Text(
                                  'ICC Cricket World Cup',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: ConstanceData.SIZE_TITLE12,
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.only(left: 8),
                                          child: Text(
                                            'SR',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize:
                                                  ConstanceData.SIZE_TITLE14,
                                              fontWeight: FontWeight.bold,
                                              color: AllCoustomTheme
                                                  .getBlackAndWhiteThemeColors(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: Text(
                                          'vs',
                                          style: TextStyle(
                                            fontSize:
                                                ConstanceData.SIZE_TITLE12,
                                            fontWeight: FontWeight.bold,
                                            color: AllCoustomTheme
                                                .getTextThemeColors(),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.only(right: 8),
                                          child: Text(
                                            'BNG',
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                              fontSize:
                                                  ConstanceData.SIZE_TITLE14,
                                              fontWeight: FontWeight.bold,
                                              color: AllCoustomTheme
                                                  .getBlackAndWhiteThemeColors(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '11 : 40 : 45',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            child: Image.asset('assets/23.png'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContestsScreen(null), //TODO
                    ),
                  );
                },
                onLongPress: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (
                      BuildContext context,
                    ) =>
                        UnderGroundDrawer(),
                  );
                },
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 16,
                        top: 16,
                      ),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 50,
                            height: 50,
                            child: Image.asset('assets/13.png'),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Text(
                                  'ICC Cricket World Cup',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: ConstanceData.SIZE_TITLE12,
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.only(left: 8),
                                          child: Text(
                                            'PAK',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize:
                                                  ConstanceData.SIZE_TITLE14,
                                              fontWeight: FontWeight.bold,
                                              color: AllCoustomTheme
                                                  .getBlackAndWhiteThemeColors(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: Text(
                                          'vs',
                                          style: TextStyle(
                                            fontSize:
                                                ConstanceData.SIZE_TITLE12,
                                            fontWeight: FontWeight.bold,
                                            color: AllCoustomTheme
                                                .getTextThemeColors(),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.only(right: 8),
                                          child: Text(
                                            'WI',
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                              fontSize:
                                                  ConstanceData.SIZE_TITLE14,
                                              fontWeight: FontWeight.bold,
                                              color: AllCoustomTheme
                                                  .getBlackAndWhiteThemeColors(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '09 : 30 : 00',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            child: Image.asset('assets/17.png'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContestsScreen(null), //TODO
                    ),
                  );
                },
                onLongPress: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (
                      BuildContext context,
                    ) =>
                        UnderGroundDrawer(),
                  );
                },
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 16,
                        top: 16,
                      ),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 50,
                            height: 50,
                            child: Image.asset('assets/19.png'),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Text(
                                  'ICC Cricket World Cup',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: ConstanceData.SIZE_TITLE12,
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.only(left: 8),
                                          child: Text(
                                            'SA',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize:
                                                  ConstanceData.SIZE_TITLE14,
                                              fontWeight: FontWeight.bold,
                                              color: AllCoustomTheme
                                                  .getBlackAndWhiteThemeColors(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: Text(
                                          'vs',
                                          style: TextStyle(
                                            fontSize:
                                                ConstanceData.SIZE_TITLE12,
                                            fontWeight: FontWeight.bold,
                                            color: AllCoustomTheme
                                                .getTextThemeColors(),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.only(right: 8),
                                          child: Text(
                                            'IND',
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                              fontSize:
                                                  ConstanceData.SIZE_TITLE14,
                                              fontWeight: FontWeight.bold,
                                              color: AllCoustomTheme
                                                  .getBlackAndWhiteThemeColors(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '04 : 28 : 10',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            child: Image.asset('assets/25.png'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContestsScreen(null), //TODO
                    ),
                  );
                },
                onLongPress: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (
                      BuildContext context,
                    ) =>
                        UnderGroundDrawer(),
                  );
                },
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 16,
                        top: 16,
                      ),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 50,
                            height: 50,
                            child: Image.asset('assets/21.png'),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Text(
                                  'ICC Cricket World Cup',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: ConstanceData.SIZE_TITLE12,
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.only(left: 8),
                                          child: Text(
                                            'SR',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize:
                                                  ConstanceData.SIZE_TITLE14,
                                              fontWeight: FontWeight.bold,
                                              color: AllCoustomTheme
                                                  .getBlackAndWhiteThemeColors(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: Text(
                                          'vs',
                                          style: TextStyle(
                                            fontSize:
                                                ConstanceData.SIZE_TITLE12,
                                            fontWeight: FontWeight.bold,
                                            color: AllCoustomTheme
                                                .getTextThemeColors(),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.only(right: 8),
                                          child: Text(
                                            'BNG',
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                              fontSize:
                                                  ConstanceData.SIZE_TITLE14,
                                              fontWeight: FontWeight.bold,
                                              color: AllCoustomTheme
                                                  .getBlackAndWhiteThemeColors(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '11 : 16 : 36',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            child: Image.asset('assets/23.png'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContestsScreen(null), //TODO
                    ),
                  );
                },
                onLongPress: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (
                      BuildContext context,
                    ) =>
                        UnderGroundDrawer(),
                  );
                },
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 16,
                        top: 16,
                      ),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 50,
                            height: 50,
                            child: Image.asset('assets/13.png'),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Text(
                                  'ICC Cricket World Cup',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: ConstanceData.SIZE_TITLE12,
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.only(left: 8),
                                          child: Text(
                                            'PAK',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize:
                                                  ConstanceData.SIZE_TITLE14,
                                              fontWeight: FontWeight.bold,
                                              color: AllCoustomTheme
                                                  .getBlackAndWhiteThemeColors(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: Text(
                                          'vs',
                                          style: TextStyle(
                                            fontSize:
                                                ConstanceData.SIZE_TITLE12,
                                            fontWeight: FontWeight.bold,
                                            color: AllCoustomTheme
                                                .getTextThemeColors(),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.only(right: 8),
                                          child: Text(
                                            'WI',
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                              fontSize:
                                                  ConstanceData.SIZE_TITLE14,
                                              fontWeight: FontWeight.bold,
                                              color: AllCoustomTheme
                                                  .getBlackAndWhiteThemeColors(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '07 : 56 : 07',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            child: Image.asset('assets/17.png'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Live extends StatefulWidget {
  @override
  _LiveState createState() => _LiveState();
}

class _LiveState extends State<Live> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: AllCoustomTheme.getTextThemeColors(),
          width: 100,
          height: 100,
          child: Image.asset(
            'assets/cup.png',
            width: 50,
            height: 50,
          ),
        ),
        Text(
          "You haven't joined any contests that are Live\nJoin contests for any of the upcoming matches",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: ConstanceData.SIZE_TITLE14,
            color: AllCoustomTheme.getTextThemeColors(),
          ),
        ),
        SizedBox(
          height: 34,
        ),
        Divider(
          height: 1,
        ),
        Expanded(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContestsScreen(null), //TODO
                    ),
                  );
                },
                onLongPress: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (
                      BuildContext context,
                    ) =>
                        UnderGroundDrawer(),
                  );
                },
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 16,
                        top: 16,
                      ),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                padding:
                                    const EdgeInsets.only(top: 4, bottom: 4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                          shape: BoxShape.circle),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 4),
                                      child: Text(
                                        'Lineups Out',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                          fontSize: ConstanceData.SIZE_TITLE12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                width: 50,
                                height: 50,
                                child: Image.asset('assets/21.png'),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new Text(
                                      'ICC Cricket World Cup',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: ConstanceData.SIZE_TITLE12,
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.only(left: 8),
                                              child: Text(
                                                'SR',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontSize: ConstanceData
                                                      .SIZE_TITLE14,
                                                  fontWeight: FontWeight.bold,
                                                  color: AllCoustomTheme
                                                      .getBlackAndWhiteThemeColors(),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              'vs',
                                              style: TextStyle(
                                                fontSize:
                                                    ConstanceData.SIZE_TITLE12,
                                                fontWeight: FontWeight.bold,
                                                color: AllCoustomTheme
                                                    .getTextThemeColors(),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding:
                                                  EdgeInsets.only(right: 8),
                                              child: Text(
                                                'BNG',
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                  fontSize: ConstanceData
                                                      .SIZE_TITLE14,
                                                  fontWeight: FontWeight.bold,
                                                  color: AllCoustomTheme
                                                      .getBlackAndWhiteThemeColors(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      'Thu,5 Sep',
                                      style: TextStyle(
                                        color: AllCoustomTheme
                                            .getTextThemeColors(),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 50,
                                height: 50,
                                child: Image.asset('assets/23.png'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContestsScreen(null), //TODO
                    ),
                  );
                },
                onLongPress: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (
                      BuildContext context,
                    ) =>
                        UnderGroundDrawer(),
                  );
                },
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 16,
                        top: 16,
                      ),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                padding:
                                    const EdgeInsets.only(top: 4, bottom: 4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                          shape: BoxShape.circle),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 4),
                                      child: Text(
                                        'Lineups Out',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                          fontSize: ConstanceData.SIZE_TITLE12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                width: 50,
                                height: 50,
                                child: Image.asset('assets/21.png'),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new Text(
                                      'ICC Cricket World Cup',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: ConstanceData.SIZE_TITLE12,
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.only(left: 8),
                                              child: Text(
                                                'SR',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontSize: ConstanceData
                                                      .SIZE_TITLE14,
                                                  fontWeight: FontWeight.bold,
                                                  color: AllCoustomTheme
                                                      .getBlackAndWhiteThemeColors(),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              'vs',
                                              style: TextStyle(
                                                fontSize:
                                                    ConstanceData.SIZE_TITLE12,
                                                fontWeight: FontWeight.bold,
                                                color: AllCoustomTheme
                                                    .getTextThemeColors(),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding:
                                                  EdgeInsets.only(right: 8),
                                              child: Text(
                                                'BNG',
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                  fontSize: ConstanceData
                                                      .SIZE_TITLE14,
                                                  fontWeight: FontWeight.bold,
                                                  color: AllCoustomTheme
                                                      .getBlackAndWhiteThemeColors(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      'Thu,5 Sep',
                                      style: TextStyle(
                                        color: AllCoustomTheme
                                            .getTextThemeColors(),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 50,
                                height: 50,
                                child: Image.asset('assets/23.png'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContestsScreen(null), //TODO
                    ),
                  );
                },
                onLongPress: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (
                      BuildContext context,
                    ) =>
                        UnderGroundDrawer(),
                  );
                },
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 16,
                        top: 16,
                      ),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                padding:
                                    const EdgeInsets.only(top: 4, bottom: 4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                          shape: BoxShape.circle),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 4),
                                      child: Text(
                                        'Lineups Out',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                          fontSize: ConstanceData.SIZE_TITLE12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                width: 50,
                                height: 50,
                                child: Image.asset('assets/21.png'),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new Text(
                                      'ICC Cricket World Cup',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: ConstanceData.SIZE_TITLE12,
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.only(left: 8),
                                              child: Text(
                                                'SR',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontSize: ConstanceData
                                                      .SIZE_TITLE14,
                                                  fontWeight: FontWeight.bold,
                                                  color: AllCoustomTheme
                                                      .getBlackAndWhiteThemeColors(),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              'vs',
                                              style: TextStyle(
                                                fontSize:
                                                    ConstanceData.SIZE_TITLE12,
                                                fontWeight: FontWeight.bold,
                                                color: AllCoustomTheme
                                                    .getTextThemeColors(),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding:
                                                  EdgeInsets.only(right: 8),
                                              child: Text(
                                                'BNG',
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                  fontSize: ConstanceData
                                                      .SIZE_TITLE14,
                                                  fontWeight: FontWeight.bold,
                                                  color: AllCoustomTheme
                                                      .getBlackAndWhiteThemeColors(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      'Thu,5 Sep',
                                      style: TextStyle(
                                        color: AllCoustomTheme
                                            .getTextThemeColors(),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 50,
                                height: 50,
                                child: Image.asset('assets/23.png'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class Results extends StatefulWidget {
  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StandingResult(),
                    ),
                  );
                },
                onLongPress: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (
                      BuildContext context,
                    ) =>
                        UnderGroundDrawer(),
                  );
                },
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 16,
                        top: 16,
                      ),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                width: 50,
                                height: 50,
                                child: Image.asset('assets/19.png'),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new Text(
                                      'ICC Cricket World Cup',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: ConstanceData.SIZE_TITLE12,
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.only(left: 8),
                                              child: Text(
                                                'SA',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontSize: ConstanceData
                                                      .SIZE_TITLE14,
                                                  fontWeight: FontWeight.bold,
                                                  color: AllCoustomTheme
                                                      .getBlackAndWhiteThemeColors(),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              'vs',
                                              style: TextStyle(
                                                fontSize:
                                                    ConstanceData.SIZE_TITLE12,
                                                fontWeight: FontWeight.bold,
                                                color: AllCoustomTheme
                                                    .getTextThemeColors(),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding:
                                                  EdgeInsets.only(right: 8),
                                              child: Text(
                                                'IND',
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                  fontSize: ConstanceData
                                                      .SIZE_TITLE14,
                                                  fontWeight: FontWeight.bold,
                                                  color: AllCoustomTheme
                                                      .getBlackAndWhiteThemeColors(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      'Thu,5 Sep',
                                      style: TextStyle(
                                        color: AllCoustomTheme
                                            .getTextThemeColors(),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 50,
                                height: 50,
                                child: Image.asset('assets/25.png'),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                '1',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                'contest joined',
                                style: TextStyle(
                                  color: AllCoustomTheme.getTextThemeColors(),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StandingResult(),
                    ),
                  );
                },
                onLongPress: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (
                      BuildContext context,
                    ) =>
                        UnderGroundDrawer(),
                  );
                },
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 16,
                        top: 16,
                      ),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                width: 50,
                                height: 50,
                                child: Image.asset('assets/21.png'),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new Text(
                                      'ICC Cricket World Cup',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: ConstanceData.SIZE_TITLE12,
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.only(left: 8),
                                              child: Text(
                                                'SR',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontSize: ConstanceData
                                                      .SIZE_TITLE14,
                                                  fontWeight: FontWeight.bold,
                                                  color: AllCoustomTheme
                                                      .getBlackAndWhiteThemeColors(),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              'vs',
                                              style: TextStyle(
                                                fontSize:
                                                    ConstanceData.SIZE_TITLE12,
                                                fontWeight: FontWeight.bold,
                                                color: AllCoustomTheme
                                                    .getTextThemeColors(),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding:
                                                  EdgeInsets.only(right: 8),
                                              child: Text(
                                                'BNG',
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                  fontSize: ConstanceData
                                                      .SIZE_TITLE14,
                                                  fontWeight: FontWeight.bold,
                                                  color: AllCoustomTheme
                                                      .getBlackAndWhiteThemeColors(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      'Thu,5 Sep',
                                      style: TextStyle(
                                        color: AllCoustomTheme
                                            .getTextThemeColors(),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 50,
                                height: 50,
                                child: Image.asset('assets/23.png'),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                '3',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                'contest joined',
                                style: TextStyle(
                                  color: AllCoustomTheme.getTextThemeColors(),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StandingResult(),
                    ),
                  );
                },
                onLongPress: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (
                      BuildContext context,
                    ) =>
                        UnderGroundDrawer(),
                  );
                },
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 16,
                        top: 16,
                      ),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                padding:
                                    const EdgeInsets.only(top: 4, bottom: 4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                          shape: BoxShape.circle),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 4),
                                      child: Text(
                                        'Lineups Out',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                          fontSize: ConstanceData.SIZE_TITLE12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                width: 50,
                                height: 50,
                                child: Image.asset('assets/13.png'),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new Text(
                                      'ICC Cricket World Cup',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: ConstanceData.SIZE_TITLE12,
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.only(left: 8),
                                              child: Text(
                                                'PAK',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontSize: ConstanceData
                                                      .SIZE_TITLE14,
                                                  fontWeight: FontWeight.bold,
                                                  color: AllCoustomTheme
                                                      .getBlackAndWhiteThemeColors(),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              'vs',
                                              style: TextStyle(
                                                fontSize:
                                                    ConstanceData.SIZE_TITLE12,
                                                fontWeight: FontWeight.bold,
                                                color: AllCoustomTheme
                                                    .getTextThemeColors(),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding:
                                                  EdgeInsets.only(right: 8),
                                              child: Text(
                                                'WI',
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                  fontSize: ConstanceData
                                                      .SIZE_TITLE14,
                                                  fontWeight: FontWeight.bold,
                                                  color: AllCoustomTheme
                                                      .getBlackAndWhiteThemeColors(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      'Thu,5 Sep',
                                      style: TextStyle(
                                        color: AllCoustomTheme
                                            .getTextThemeColors(),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 50,
                                height: 50,
                                child: Image.asset('assets/17.png'),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                '3',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                'contest joined',
                                style: TextStyle(
                                  color: AllCoustomTheme.getTextThemeColors(),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class PersistentHeader extends SliverPersistentHeaderDelegate {
  final TabController controller;

  PersistentHeader(
    this.controller,
  );

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
//    print("##############");
//    print(context.bloc<SportsDataBloc>().state.sportsMap.keys.length);
    return Column(
      children: <Widget>[
        Container(
          height: 40,
          color: AllCoustomTheme.getThemeData().backgroundColor,
          child: TabBar(
            isScrollable: true,
            unselectedLabelColor: AllCoustomTheme.getTextThemeColors(),
            indicatorColor: AllCoustomTheme.getThemeData().primaryColor,
            labelColor: AllCoustomTheme.getThemeData().primaryColor,
            tabs: context.bloc<SportsDataBloc>().state.sportsMap.keys.map((e) {
              return Tab(
                text: e,
              );
            }).toList(),
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
