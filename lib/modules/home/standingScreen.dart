import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:frolicsports/bloc/standingsTabBloc.dart';
import 'package:frolicsports/constance/constance.dart';
import 'package:frolicsports/constance/sharedPreferences.dart';
import 'package:frolicsports/constance/themes.dart';
import 'package:frolicsports/models/scheduleResponseData.dart';
import 'package:frolicsports/models/userData.dart';
import 'package:frolicsports/modules/contests/contestsScreen.dart';
import 'package:frolicsports/modules/home/homeScreen.dart';
import 'package:frolicsports/modules/home/machTimerView.dart';
import 'package:frolicsports/modules/notification/notificationScreen.dart';
import 'package:frolicsports/utils/avatarImage.dart';
import 'package:frolicsports/constance/global.dart' as globals;

class StandingScreen extends StatefulWidget {
  final void Function() menuCallBack;
  final VoidCallback upComingMatchesClick;

  const StandingScreen({Key key, this.menuCallBack, this.upComingMatchesClick}) : super(key: key);
  @override
  _StandingScreenState createState() => _StandingScreenState();
}

class _StandingScreenState extends State<StandingScreen> with SingleTickerProviderStateMixin {
  ScrollController _scrollController = new ScrollController();
  final standingsTabBloc = StandingsTabBloc();
  TabController controller;
  double _appBarHeight = 100.0;
  AppBarBehavior _appBarBehavior = AppBarBehavior.pinned;
  UserData userData;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKeyF = new GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKeyL = new GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKeyR = new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    updateData();
    controller = new TabController(length: 3, vsync: this);
    standingsTabBloc.cleanList();
  }

  updateData() async {
    userData = await MySharedPreferences().getUserData();
    setState(() {});
  }

  void openDrawer() {
    widget.menuCallBack();
  }

  Widget drawerButton() {
    return InkWell(
      onTap: openDrawer,
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: AllCoustomTheme.getThemeData().scaffoldBackgroundColor,
            radius: 14,
            child: AvatarImage(
              imageUrl: 'pank_image',//TODO globals.userdata.image,
//              ConstanceData.appIcon,
              isCircle: true,
              radius: 28,
              sizeValue: 28,
              isAssets: false,
            ),
          ),
          Icon(
            Icons.sort,
            color: AllCoustomTheme.getReBlackAndWhiteThemeColors(),
          )
        ],
      ),
    );
  }

  Widget notificationButton() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NotificationScreen(),
            fullscreenDialog: true,
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(12),
        child: Icon(
          Icons.notifications,
          color: AllCoustomTheme.getReBlackAndWhiteThemeColors(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new NestedScrollView(
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
              actions: <Widget>[
                drawerButton(),
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
              StandingsTabScreen(
                tabType: TabType.Upcoming,
                refreshIndicatorKey: refreshIndicatorKeyF,
                context: context,
                standingsTabBloc: standingsTabBloc,
                upComingMatchesClick: () {
                  widget.upComingMatchesClick();
                },
                click: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContestsScreen(null),//TODO
                    ),
                  );
                  standingsTabBloc.cleanList();
                },
              ),
              StandingsTabScreen(
                upComingMatchesClick: () {
                  widget.upComingMatchesClick();
                },
                tabType: TabType.Live,
                refreshIndicatorKey: refreshIndicatorKeyL,
                context: context,
                standingsTabBloc: standingsTabBloc,
                click: () async {
                  standingsTabBloc.cleanList();
                },
              ),
              StandingsTabScreen(
                tabType: TabType.Results,
                refreshIndicatorKey: refreshIndicatorKeyR,
                upComingMatchesClick: () {
                  widget.upComingMatchesClick();
                },
                standingsTabBloc: standingsTabBloc,
                context: context,
                click: () async {
                  standingsTabBloc.cleanList();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget sliverText() {
    return FlexibleSpaceBar(
      centerTitle: false,
      titlePadding: EdgeInsetsDirectional.only(start: 16, bottom: 8, top: 0),
      title: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Standings',
              style: TextStyle(
                fontSize: 26,
                color: AllCoustomTheme.getThemeData().backgroundColor,
              ),
            ),
          ],
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
              new Tab(text: 'Fixtures'),
              new Tab(text: 'Live'),
              new Tab(text: 'Results'),
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

enum TabType { Upcoming, Live, Results }

class StandingsTabScreen extends StatelessWidget {
  final Function() click;
  final VoidCallback upComingMatchesClick;
  final StandingsTabBloc standingsTabBloc;
  final TabType tabType;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey;
  final BuildContext context;

  const StandingsTabScreen({
    Key key,
    this.click,
    this.upComingMatchesClick,
    this.standingsTabBloc,
    this.tabType,
    this.refreshIndicatorKey,
    this.context,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocBuilder<StandingsTabBloc, StandingsTabBlocState>(
//        bloc: standingsTabBloc,
        builder: (context, StandingsTabBlocState state) {
          return standingsTabBloc.getData(tabType).length == 0 && state.isProgress
              ? Container(
                  child: Center(
                    child: Container(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                )
              : Column(
                  children: <Widget>[
                    Expanded(
                        child: standingsTabBloc.getData(tabType).length > 0
                            ? Container(
                                child: RefreshIndicator(
                                  key: refreshIndicatorKey,
                                  onRefresh: () async {
                                    if (tabType == TabType.Upcoming) {
                                      await standingsTabBloc.upcoming();
                                    } else if (tabType == TabType.Live) {
                                      await standingsTabBloc.live();
                                    } else if (tabType == TabType.Results) {
                                      await standingsTabBloc.results();
                                    }
                                  },
                                  child: ListView.builder(
                                    itemCount: 5,
                                    itemBuilder: (context, index) {
                                      return listItems();
                                    },
                                  ),
                                ),
                              )
                            : Container(
                                child: Column(
                                  children: <Widget>[
                                    Expanded(
                                      child: RefreshIndicator(
                                        key: refreshIndicatorKey,
                                        onRefresh: () async {
                                          if (tabType == TabType.Upcoming) {
                                            await standingsTabBloc.upcoming();
                                          } else if (tabType == TabType.Live) {
                                            await standingsTabBloc.live();
                                          } else if (tabType == TabType.Results) {
                                            await standingsTabBloc.results();
                                          }
                                        },
                                        child: ListView.builder(
                                          itemCount: standingsTabBloc.getScheduleData().length,
                                          itemBuilder: (context, index) {
                                            return index == 0 ? infoView() : sheduallist(standingsTabBloc.getScheduleData()[index]);
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )),
                  ],
                );
        },
      ),
    );
  }

  Widget infoView() {
    var txt = '';
    if (tabType == TabType.Upcoming) {
      txt = 'upcoming';
    } else if (tabType == TabType.Live) {
      txt = 'live';
    } else {
      txt = 'completed recently';
    }
    return Container(
      color: AllCoustomTheme.getThemeData().backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 24,
          ),
          Container(
            width: 120,
            height: 120,
            child: Image.asset(
              ConstanceData.cupImage,
              width: 80,
              height: 80,
              scale: 0.2,
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Text(
              tabType == TabType.Upcoming ? "You haven't joined any $txt contests" : "You haven't joined any contests that are $txt",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: ConstanceData.SIZE_TITLE14,
                color: AllCoustomTheme.getTextThemeColors(),
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            'Join contests for any of the upcoming matches',
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
          )
        ],
      ),
    );
  }

  Widget listItems() {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () {
            click();
          },
          child: Container(
            padding: EdgeInsets.only(left: 16, top: 16, right: 16),
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(top: 4, bottom: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle),
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
                            'South Africa vs India',
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Text(
                                      'SA',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: ConstanceData.SIZE_TITLE14,
                                        fontWeight: FontWeight.bold,
                                        color: AllCoustomTheme.getBlackAndWhiteThemeColors(),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    'vs',
                                    style: TextStyle(
                                      fontSize: ConstanceData.SIZE_TITLE12,
                                      fontWeight: FontWeight.bold,
                                      color: AllCoustomTheme.getTextThemeColors(),
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
                                        fontSize: ConstanceData.SIZE_TITLE14,
                                        fontWeight: FontWeight.bold,
                                        color: AllCoustomTheme.getBlackAndWhiteThemeColors(),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'Mon, 9 Sep',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          )
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
                Container(
                  padding: EdgeInsets.only(left: 0, right: 8, bottom: 8, top: 4),
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Text(
                          '2',
                          style: TextStyle(
                            fontSize: ConstanceData.SIZE_TITLE14,
                            fontWeight: FontWeight.bold,
                            color: AllCoustomTheme.getBlackAndWhiteThemeColors(),
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          '  contest joined',
                          style: TextStyle(
                            fontSize: ConstanceData.SIZE_TITLE14,
                            color: AllCoustomTheme.getBlackAndWhiteThemeColors().withOpacity(0.5),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Divider(
          height: 1,
        )
      ],
    );
  }

  String getData(ShedualData shedualData) {
    var timeCountDountxt = '';
    final date = DateFormat('yyyy-MM-dd').parse(shedualData.dateStart);
    final today = DateFormat('yyyy-MM-dd').parse(DateTime.now().toString());
    print(today);
    if (today.difference(date).inDays == 1) {
      timeCountDountxt = 'Yesterday';
    } else {
      timeCountDountxt = DateFormat.E().format(date) + ', ' + DateFormat.d().format(date) + ' ' + DateFormat.MMM().format(date);
    }
    return timeCountDountxt;
  }

  Widget sheduallist(ShedualData shedualData) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () {
            if (shedualData.preSquad == 'true') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ContestsScreen(null),//TODO
                ),
              );
            } else {
              showInSnackBar('Contests for this match will open soon. Stay tuned!');
            }
          },
          onLongPress: () {
            if (shedualData.preSquad == 'true') {
              showModalBottomSheet<void>(
                context: context,
                builder: (
                  BuildContext context,
                ) =>
                    UnderGroundDrawer(shedualData: shedualData),
              );
            } else {
              showInSnackBar('Contests for this match will open soon. Stay tuned!');
            }
          },
          child: Opacity(
            opacity: shedualData.preSquad == 'true' ? 1.0 : 0.4,
            child: Column(
              children: <Widget>[
                shedualData.lineupsOut == 'true'
                    ? Container(
                        padding: const EdgeInsets.only(left: 8, top: 4, bottom: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle),
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
                      )
                    : SizedBox(),
                Container(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    top: shedualData.lineupsOut == 'true' ? 0 : 16,
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 50,
                        height: 50,
                        child: new CachedNetworkImage(
                          imageUrl: shedualData.teamLogo.a.logoUrl,
                          placeholder: (context, url) => Center(
                            child: Container(
                              padding: EdgeInsets.all(12),
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => new Icon(Icons.error),
                          fit: BoxFit.contain,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Text(
                              shedualData.seriesName,
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.only(left: 8),
                                      child: Text(
                                        shedualData.teamLogo.a.shortName,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: ConstanceData.SIZE_TITLE14,
                                          fontWeight: FontWeight.bold,
                                          color: AllCoustomTheme.getBlackAndWhiteThemeColors(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      'vs',
                                      style: TextStyle(
                                        fontSize: ConstanceData.SIZE_TITLE12,
                                        fontWeight: FontWeight.bold,
                                        color: AllCoustomTheme.getTextThemeColors(),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.only(right: 8),
                                      child: Text(
                                        shedualData.teamLogo.b.shortName,
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                          fontSize: ConstanceData.SIZE_TITLE14,
                                          fontWeight: FontWeight.bold,
                                          color: AllCoustomTheme.getBlackAndWhiteThemeColors(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TimerView(
                              dateStart: shedualData.dateStart,
                              timestart: shedualData.timeStart,
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        child: new CachedNetworkImage(
                          imageUrl: shedualData.teamLogo.b.logoUrl,
                          placeholder: (context, url) => Center(
                            child: Container(
                              padding: EdgeInsets.all(12),
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => new Icon(Icons.error),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(
          height: 1,
        )
      ],
    );
  }

  void showInSnackBar(String value) {
    Scaffold.of(context).showSnackBar(
      new SnackBar(
        content: new Text(
          value,
          style: TextStyle(
            fontSize: ConstanceData.SIZE_TITLE14,
            color: AllCoustomTheme.getReBlackAndWhiteThemeColors(),
          ),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}
