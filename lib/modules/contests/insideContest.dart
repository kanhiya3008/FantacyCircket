import 'package:flutter/material.dart';
import 'package:frolicsports/bloc/contestDataBloc.dart';
import 'package:frolicsports/models/sportsData.dart';
import 'package:frolicsports/models/sportsDataForApp.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:frolicsports/constance/constance.dart';
import 'package:frolicsports/constance/themes.dart';
import 'package:frolicsports/modules/contests/contestsScreen.dart';

class InsideContest extends StatefulWidget {
  final MatchDataForApp _matchDataForApp;
  final Contest contest;

  const InsideContest(this._matchDataForApp, this.contest);

  @override
  _InsideContestState createState() => _InsideContestState();
}

class _InsideContestState extends State<InsideContest>
    with SingleTickerProviderStateMixin {
  bool iscontestsProsses = false;

  ScrollController _scrollController = new ScrollController();
  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = new TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AllCoustomTheme.getThemeData().primaryColor,
            AllCoustomTheme.getThemeData().primaryColor,
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
              backgroundColor: AllCoustomTheme.getThemeData().backgroundColor,
              body: Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        color: AllCoustomTheme.getThemeData().primaryColor,
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: AppBar().preferredSize.height,
                              child: Row(
                                children: <Widget>[
                                  Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        width: AppBar().preferredSize.height,
                                        height: AppBar().preferredSize.height,
                                        child: Icon(
                                          Icons.arrow_back,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        'Contests',
                                        style: TextStyle(
                                          fontSize: ConstanceData.SIZE_TITLE22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: AppBar().preferredSize.height,
                                  )
                                ],
                              ),
                            ),
                            MatchHadder(
                                matchDataForApp: widget._matchDataForApp),
                          ],
                        ),
                      ),
                      Flexible(
                        child: ModalProgressHUD(
                          inAsyncCall: iscontestsProsses,
                          color: Colors.transparent,
                          progressIndicator: CircularProgressIndicator(
                            strokeWidth: 2.0,
                          ),
                          child: Container(
                            child: contestsData(),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget contestsData() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 6),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Prize Pool',
                        style: TextStyle(
                          color: AllCoustomTheme.getTextThemeColors(),
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        ContestDataBloc().getPrizePool(widget.contest),
//                        '₹10000',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Winners',
                        style: TextStyle(
                          color: AllCoustomTheme.getTextThemeColors(),
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        ContestDataBloc()
                            .getPrizeWinners(widget.contest)
                            .toString(),
//                        '1',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: AllCoustomTheme.getThemeData().primaryColor,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        'Entry',
                        style: TextStyle(
                          color: AllCoustomTheme.getTextThemeColors(),
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Container(
                        height: 30,
                        width: 80,
                        child: RaisedButton(
                          onPressed: () {},
                          child: Text(
                            widget.contest.entryAmount.toString(),
//                            '₹575',
                            style: TextStyle(
                              backgroundColor:
                                  AllCoustomTheme.getThemeData().primaryColor,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              LinearPercentIndicator(
                lineHeight: 6,
                percent: 0.5,
                linearStrokeCap: LinearStrokeCap.roundAll,
                backgroundColor:
                    AllCoustomTheme.getThemeData().scaffoldBackgroundColor,
                progressColor: AllCoustomTheme.getThemeData().primaryColor,
              ),
              SizedBox(
                height: 4,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Row(
                  children: <Widget>[
                    Text(
                      '2 spot left',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[400]),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 6,
              ),
              Divider(
                color: AllCoustomTheme.getThemeData().primaryColor,
              ),
            ],
          ),
        ),
        Expanded(child: contestsListData())
      ],
    );
  }

  Widget contestsListData() {
    return NestedScrollView(
      controller: _scrollController,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverPersistentHeader(
            pinned: true,
            delegate: ContestTabHeader(controller),
          ),
        ];
      },
      body: TabBarView(
        controller: controller,
        children: <Widget>[
          dowunloadbar(),
          prizeBreackup(),
        ],
      ),
    );
  }

  Widget prizeBreackup() {
    print('prize');
    print(widget.contest.prizeList.length);
    return Column(
      children: <Widget>[
        Container(
          color: AllCoustomTheme.getTextThemeColors().withOpacity(0.1),
          height: 50,
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'RANK',
                  style: TextStyle(
                    fontSize: ConstanceData.SIZE_TITLE12,
                    color: AllCoustomTheme.getTextThemeColors(),
                  ),
                ),
                Text(
                  'PRIZE',
                  style: TextStyle(
                    fontSize: ConstanceData.SIZE_TITLE12,
                    color: AllCoustomTheme.getTextThemeColors(),
                  ),
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: widget.contest.prizeList
                .map(
                  (prize) => Column(children: [
                    Container(
                      padding: EdgeInsets.only(left: 10, top: 4, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('# ' +
                              prize.rankRangeStart.toString() +
                              (prize.rankRangeStart.toString() !=
                                      prize.rankRangeEnd.toString()
                                  ? ' - ' + prize.rankRangeEnd.toString()
                                  : '')),
                          Text(
                            '₹ ' + prize.prizeAmount.toString(),
                            style: TextStyle(
                              color: AllCoustomTheme.getTextThemeColors(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                  ]),
                )
                .toList(),
          ),
        ),
        Container(
          padding: EdgeInsets.only(right: 8, left: 8, bottom: 4),
          child: Text(
            'Note: The actual prize money may be different than the prize money mentioned above if there is a tie for any of the winning position. Check FQAs for further details.as per government regulations, a tax of 31.2% will be deducted if an individual wins more than Rs. 10,000',
            textAlign: TextAlign.justify,
            style: TextStyle(
              color: AllCoustomTheme.getTextThemeColors(),
              fontSize: ConstanceData.SIZE_TITLE14,
            ),
          ),
        )
      ],
    );
  }

  Widget dowunloadbar() {
    return Column(
      children: <Widget>[
        Container(
          height: 50,
          color: AllCoustomTheme.getTextThemeColors().withOpacity(0.1),
          child: Container(
            padding: EdgeInsets.only(left: 10, top: 10, right: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'view all teams \nafter the deadline',
                  style: TextStyle(
                    fontSize: ConstanceData.SIZE_TITLE12,
                    color: AllCoustomTheme.getTextThemeColors(),
                  ),
                ),
                Container(
                  child: Opacity(
                    opacity: 0.6,
                    child: Container(
                      width: 150,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AllCoustomTheme.getThemeData().backgroundColor,
                        borderRadius: new BorderRadius.circular(4.0),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color:
                                  AllCoustomTheme.getBlackAndWhiteThemeColors()
                                      .withOpacity(0.3),
                              offset: Offset(0, 1),
                              blurRadius: 5.0),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Text(
                                'Download Teams ',
                                style: TextStyle(
                                    fontSize: ConstanceData.SIZE_TITLE10,
                                    color:
                                        AllCoustomTheme.getTextThemeColors()),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 2),
                              child: Icon(
                                Icons.file_download,
                                color: AllCoustomTheme.getTextThemeColors(),
                                size: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 10, top: 4, right: 10),
          child: Row(
            children: <Widget>[
              Text(
                'All Teams',
                style: TextStyle(
                  color: AllCoustomTheme.getTextThemeColors(),
                ),
              ),
            ],
          ),
        ),
        Divider(),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                Text(
                  'No Team has Joined this contest yet',
                  style: TextStyle(
                    color: AllCoustomTheme.getTextThemeColors(),
                  ),
                  textAlign: TextAlign.center,
                ),
                Container(
                  width: 100,
                  height: 100,
                  child: Image.asset(ConstanceData.users),
                ),
                Container(
                  child: Text(
                    'Be the first one to join this contest & start winning!',
                    style: TextStyle(
                      fontSize: ConstanceData.SIZE_TITLE14,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class ContestTabHeader extends SliverPersistentHeaderDelegate {
  final TabController controller;

  ContestTabHeader(this.controller);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AllCoustomTheme.getThemeData().backgroundColor,
      child: Column(
        children: <Widget>[
          Expanded(
            child: new TabBar(
              unselectedLabelColor:
                  AllCoustomTheme.getTextThemeColors().withOpacity(0.6),
              indicatorColor: AllCoustomTheme.getThemeData().primaryColor,
              labelColor: AllCoustomTheme.getThemeData().primaryColor,
              labelStyle: TextStyle(
                fontSize: ConstanceData.SIZE_TITLE14,
              ),
              tabs: [
                new Tab(text: 'Leaderboard'),
                new Tab(text: 'Prize Breakup'),
              ],
              controller: controller,
            ),
          ),
          Divider(
            height: 1,
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 42.0;

  @override
  double get minExtent => 42.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
