import 'dart:collection';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frolicsports/bloc/authBloc.dart';
import 'package:frolicsports/bloc/contestDataBloc.dart';
import 'package:frolicsports/bloc/sportsDataBloc.dart';
import 'package:frolicsports/models/sportsData.dart';
import 'package:frolicsports/models/sportsDataForApp.dart';
import 'package:frolicsports/modules/home/newHomeScreen.dart';
import 'package:frolicsports/utils/config.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:frolicsports/constance/constance.dart';
import 'package:frolicsports/constance/themes.dart';
import 'package:frolicsports/models/contestsResponseData.dart';
import 'package:frolicsports/modules/contests/contestCodeScreen.dart';
import 'package:frolicsports/modules/contests/createContest.dart';
import 'package:frolicsports/modules/contests/createTeamButtonView.dart';
import 'package:frolicsports/modules/createTeam/createTeamScreen.dart';
import 'package:frolicsports/modules/home/standingScreen.dart';
import 'package:frolicsports/validator/validator.dart';
import 'package:sticky_headers/sticky_headers.dart';

import 'insideContest.dart';

class ContestsScreen extends StatefulWidget {
  final MatchDataForApp _matchDataForApp;

  const ContestsScreen(this._matchDataForApp);

  @override
  _ContestsScreenState createState() => _ContestsScreenState();
}

class _ContestsScreenState extends State<ContestsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool iscontestsProsses = false;
  var categoryList = ContestsLeagueResponseData();

  @override
  void initState() {
    print('sportsName');
    print(widget._matchDataForApp.sportsName);
    categoryList.contestsCategoryLeagueListData =
        List<ContestsLeagueCategoryListResponseData>();
    categoryList.teamlist = [];
    categoryList.totalcontest = 0;

    context
        .bloc<ContestDataBloc>()
        .getContestForMatchFromFirestore(widget._matchDataForApp);
    super.initState();
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
              key: _scaffoldKey,
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
                                          fontSize: 24,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w500,
                                          color: AllCoustomTheme.getThemeData()
                                              .backgroundColor,
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
                              matchDataForApp: widget._matchDataForApp,
                            )
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
                            child: contestsListData(),
                          ),
                        ),
                      ),
                    ],
                  ),
//                  IgnorePointer(
//                    ignoring: iscontestsProsses,
//                    child: Container(
//                      width: double.infinity,
//                      child: CreateTeamButton(
//                        contestJoinedList: categoryList.totalcontest,
//                        teamList: categoryList.teamlist.length,
//                        createTeam: () async {
//                          await Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                              builder: (context) => CreateTeamScreen(matchDataForApp : widget._matchDataForApp),
//                              fullscreenDialog: true,
//                            ),
//                          );
//                        },
//                      ),
//                    ),
//                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showInSnackBar(String value, {bool isGreeen = false}) {
    _scaffoldKey.currentState.showSnackBar(
      new SnackBar(
        content: new Text(
          value,
          style: TextStyle(
            fontSize: ConstanceData.SIZE_TITLE14,
            color: AllCoustomTheme.getReBlackAndWhiteThemeColors(),
          ),
        ),
        backgroundColor: isGreeen ? Colors.green : Colors.red,
      ),
    );
  }

  Widget contestsListData() {
    return Column(
      children: <Widget>[
        Container(
          height: 52,
          padding: EdgeInsets.only(bottom: 10, top: 10, left: 16, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.circular(20),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: AllCoustomTheme.getThemeData()
                              .primaryColor
                              .withOpacity(0.5),
                          offset: Offset(0, 1),
                          blurRadius: 5.0),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: AllCoustomTheme.getThemeData()
                          .primaryColor
                          .withOpacity(0.4),
                      borderRadius: new BorderRadius.circular(20),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ContestCodeScreen(),
                            fullscreenDialog: true,
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 8, right: 8),
                        child: Center(
                          child: Text(
                            'Enter Contest Code',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                                  AllCoustomTheme.getThemeData().primaryColor,
                              fontSize: ConstanceData.SIZE_TITLE10,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Container(
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.circular(20),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: AllCoustomTheme.getThemeData()
                              .primaryColor
                              .withOpacity(0.5),
                          offset: Offset(0, 1),
                          blurRadius: 5.0),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: AllCoustomTheme.getThemeData()
                          .primaryColor
                          .withOpacity(0.4),
                      borderRadius: new BorderRadius.circular(20),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateContestScreen(),
                            fullscreenDialog: true,
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 8, right: 8),
                        child: Center(
                          child: Text(
                            'Create a Contest',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                                  AllCoustomTheme.getThemeData().primaryColor,
                              fontSize: ConstanceData.SIZE_TITLE10,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
            //  child:
            child: StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance
              .collection(SPORTS_DATA)
              .document(widget._matchDataForApp.sportsName)
              .collection(TOURNAMENTS_DATA)
              .document(widget._matchDataForApp.tournamentName)
              .collection(MATCH_DATA)
              .document(widget._matchDataForApp.matchUniqueId.toString())
              .snapshots(),
          builder: (context, snapShot) {
            return !snapShot.hasData
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      var lengthOfContest =
                          snapShot.data.data['contest'].length;
                      print(lengthOfContest);
                      print(
                          "Length of Data is: ${snapShot.data.data['contest'][index]['max']}");

                      var tempContestString =
                          snapShot.data.data['contest'][index];
                      Contest contest = context
                          .bloc<ContestDataBloc>()
                          .convertStringToContest(tempContestString);

                      return StickyHeader(
                        header: new Container(
                          color: AllCoustomTheme.getThemeData()
                              .scaffoldBackgroundColor,
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 4, bottom: 6, left: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text(
                                  'Contest Number ${index + 1}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  contest.contestCategory.toString(),
                                  style: TextStyle(
                                    color:
                                        // Colors.red,
                                        AllCoustomTheme.getThemeData()
                                            .primaryColor,
                                    fontSize: ConstanceData.SIZE_TITLE12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        content: Padding(
                          padding:
                              const EdgeInsets.only(left: 8, right: 8, top: 6),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => InsideContest(
                                          widget._matchDataForApp, contest),
                                      fullscreenDialog: false,
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Prize Pool',
                                          style: TextStyle(
                                            color: AllCoustomTheme
                                                .getTextThemeColors(),
                                            fontSize: 14,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Text(
                                          context
                                              .bloc<ContestDataBloc>()
                                              .getPrizePool(contest),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 24,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          'Winners',
                                          style: TextStyle(
                                            color: AllCoustomTheme
                                                .getTextThemeColors(),
                                            fontSize: 14,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Text(
                                          ContestDataBloc()
                                              .getPrizeWinners(contest)
                                              .toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20,
                                            color:
                                                AllCoustomTheme.getThemeData()
                                                    .primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          'Entry',
                                          style: TextStyle(
                                            color: AllCoustomTheme
                                                .getTextThemeColors(),
                                            fontSize: 14,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Container(
                                          height: 30,
                                          width: 84,
                                          child: RaisedButton(
                                            onPressed: () {
                                              setshowDialog(contest);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      CreateTeamScreen(
                                                          matchDataForApp: widget
                                                              ._matchDataForApp,
                                                          selectedContest:
                                                              contest),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              contest.entryAmount.toString(),
                                              style: TextStyle(
                                                backgroundColor: AllCoustomTheme
                                                        .getThemeData()
                                                    .primaryColor,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              LinearPercentIndicator(
                                lineHeight: 6,
                                percent: 0.5,
                                linearStrokeCap: LinearStrokeCap.roundAll,
                                backgroundColor: AllCoustomTheme.getThemeData()
                                    .scaffoldBackgroundColor,
                                progressColor:
                                    AllCoustomTheme.getThemeData().primaryColor,
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
                                        fontWeight: FontWeight.w500,
                                        color: Colors.orange[400],
                                        fontStyle: FontStyle.italic,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Divider(
                                color:
                                    AllCoustomTheme.getThemeData().primaryColor,
                              ),
                              //  listContest(context.bloc<ContestDataBloc>().state., contest.contestCategory)
                            ],
                          ),
                        ),
                      );
                      ;
                    },
                    itemCount: snapShot.data.data['contest'].length,
                  );
          },
        )
//        )
//              BlocBuilder<ContestDataBloc, ContestDataBlocState>(
//                  builder: (_, contestState) {
//            print('matchId');
//            print(widget._matchDataForApp.matchUniqueId);
//            print(contestState.selectedMatchContestCategories);
//
//            return ListView.builder(
//              physics: BouncingScrollPhysics(),
//              itemCount: contestState.selectedMatchContestCategories == null
//                  ? 0
//                  : contestState
//                      .selectedMatchContestCategories[
//                          widget._matchDataForApp.matchUniqueId]
//                      .length,
//              itemBuilder: (context, index) {
////                print(contestState.selectedMatchContestCategories[widget._matchDataForApp.matchUniqueId].length);
//                return StickyHeader(
//                  header: new Container(
//                    color:
//                        AllCoustomTheme.getThemeData().scaffoldBackgroundColor,
//                    alignment: Alignment.centerLeft,
//                    child: Padding(
//                      padding:
//                          const EdgeInsets.only(top: 4, bottom: 6, left: 8),
//                      child: Column(
//                        crossAxisAlignment: CrossAxisAlignment.start,
//                        children: <Widget>[
//                          new Text(
//                            'Contest Number ${index + 1}',
//                            style: TextStyle(
//                              fontWeight: FontWeight.w500,
//                            ),
//                          ),
//                          Text(
//                            contestState.selectedMatchContestCategories[
//                                widget._matchDataForApp.matchUniqueId][index],
////                            'The Ultimate Face Off',
//                            style: TextStyle(
//                              color:
//                                  // Colors.red,
//                                  AllCoustomTheme.getThemeData().primaryColor,
//                              fontSize: ConstanceData.SIZE_TITLE12,
//                            ),
//                          ),
//                        ],
//                      ),
//                    ),
//                  ),
//                  content: Padding(
//                    padding: const EdgeInsets.only(left: 8, right: 8, top: 6),
//                    child: Column(
//                      children: <Widget>[
//                        listContest(
//                            contestState.selectedMatchContest[
//                                widget._matchDataForApp.matchUniqueId],
//                            contestState.selectedMatchContestCategories[
//                                widget._matchDataForApp.matchUniqueId][index])
//                      ],
//                    ),
//                  ),
//                );
//              },
//            );
//          }),
            )
      ],
    );
  }

  Widget listContest(HashMap<int, Contest> contestMap, String category) {
    List<Contest> contestList = List<Contest>();

    contestMap.values.forEach((contest) {
      if (contest.contestCategory == category) {
        contestList.add(contest);
      }
    });
    return Column(
      children: contestList
          .map(
            (contest) => Column(
              children: [
                InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          InsideContest(widget._matchDataForApp, contest),
                      fullscreenDialog: false,
                    ),
                  ),
                  child: Row(
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
                            ContestDataBloc().getPrizePool(contest),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
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
                                .getPrizeWinners(contest)
                                .toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color:
                                  AllCoustomTheme.getThemeData().primaryColor,
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
                            width: 84,
                            child: RaisedButton(
                              onPressed: () {
                                //setshowDialog(contest);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CreateTeamScreen(
                                        matchDataForApp:
                                            widget._matchDataForApp,
                                        selectedContest: contest),
                                  ),
                                );
                              },
                              child: Text(
                                contest.entryAmount.toString(),
//                                '₹575',
                                style: TextStyle(
                                  backgroundColor:
                                      AllCoustomTheme.getThemeData()
                                          .primaryColor,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
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
                          fontWeight: FontWeight.w500,
                          color: Colors.orange[400],
                          fontStyle: FontStyle.italic,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                Divider(
                  color: AllCoustomTheme.getThemeData().primaryColor,
                )
              ],
            ),
          )
          .toList(),
    );
  }

  void setshowDialog(Contest contest) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext buildContext) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            child: Center(
              child: Container(
                padding: EdgeInsets.all(54),
                child: Container(
                  decoration: BoxDecoration(
                    color: AllCoustomTheme.getThemeData().backgroundColor,
                    borderRadius: new BorderRadius.circular(4.0),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          offset: Offset(0, 1),
                          blurRadius: 5.0),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      'CONFIRMATION',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: AllCoustomTheme.getThemeData()
                                            .primaryColor,
                                        fontSize: ConstanceData.SIZE_TITLE18,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Container(
                                    child: Text(
                                      '----------',
//                                      'Unutilized Balance + Winning = ₹1000',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: AllCoustomTheme
                                            .getTextThemeColors(),
                                        fontSize: ConstanceData.SIZE_TITLE12,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: EdgeInsets.all(0),
                                child: Icon(Icons.close),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16, bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Text(
                                'Entry',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontSize: ConstanceData.SIZE_TITLE14,
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                contest.entryAmount.toString(),
//                                '₹575',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AllCoustomTheme.getThemeData()
                                      .primaryColor,
                                  fontSize: ConstanceData.SIZE_TITLE14,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16, bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Text(
                                'Usable Cash Bonus',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontSize: ConstanceData.SIZE_TITLE14,
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                '-₹' +
                                    context
                                        .bloc<AuthBloc>()
                                        .getCurrentUser()
                                        .balance,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AllCoustomTheme.getThemeData()
                                      .primaryColor,
                                  fontSize: ConstanceData.SIZE_TITLE14,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Divider(
                        height: 1,
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                            top: 8, left: 16.0, right: 16, bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Text(
                                'To Pay',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                  fontSize: ConstanceData.SIZE_TITLE14,
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                '₹575',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                  fontSize: ConstanceData.SIZE_TITLE14,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Container(
                        height: 40,
                        padding:
                            EdgeInsets.only(left: 50, right: 50, bottom: 8),
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              child: Container(
                                decoration: new BoxDecoration(
                                  color: AllCoustomTheme.getThemeData()
                                      .primaryColor,
                                  borderRadius: new BorderRadius.circular(4.0),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.5),
                                        offset: Offset(0, 1),
                                        blurRadius: 5.0),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius:
                                        new BorderRadius.circular(4.0),
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CreateTeamScreen(
                                                  matchDataForApp:
                                                      widget._matchDataForApp,
                                                  selectedContest: contest),
                                        ),
                                      );

//                                      await Navigator.push(
//                                        context,
//                                        MaterialPageRoute(
//                                          builder: (context) => CreateTeamScreen(matchDataForApp : widget._matchDataForApp),
//                                          fullscreenDialog: true,
//                                        ),
//                                      );

                                      //Navigator.pop(context);
                                    },
                                    child: Center(
                                      child: Text(
                                        'JOIN CONTEST',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: ConstanceData.SIZE_TITLE12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.only(left: 16.0, right: 16, bottom: 20),
                        child: Text(
                          "By joining this contest, you accept Frolics Sport's T&C.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AllCoustomTheme.getTextThemeColors()
                                .withOpacity(0.5),
                            fontSize: ConstanceData.SIZE_TITLE12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void setSoCloseContestFilled(String price, String leagueId) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => soCloseFilledPopup(price, leagueId),
    );
  }

  Widget soCloseFilledPopup(String price, String leagueId) {
    ContestsLeagueListData leageData;
    categoryList.contestsCategoryLeagueListData.forEach((category) {
      category.contestsCategoryLeagueListData.forEach((list) {
        if (int.tryParse('${list.remainingTeam}') != 0) {
          if (int.tryParse('${list.entryFees}') == int.tryParse('$price') &&
              list.leagueId != leagueId) {
            leageData = list;
            return;
          }
        }
      });
    });
    if (leageData == null) {
      categoryList.contestsCategoryLeagueListData.forEach((category) {
        category.contestsCategoryLeagueListData.forEach((list) {
          if (int.tryParse('${list.remainingTeam}') != 0) {
            if (int.tryParse('${list.entryFees}') <= int.tryParse('$price') &&
                list.leagueId != leagueId) {
              leageData = list;
              return;
            }
          }
        });
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 16, top: 8, bottom: 8, right: 16),
          color: Colors.white,
          child: Text(
            'So close! That contest filled up',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: ConstanceData.SIZE_TITLE20,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 16, bottom: 8, right: 16),
          color: Colors.white,
          child: Text(
            "No worries, join this contest instead! It's exactly the same type",
            style: TextStyle(
              color: AllCoustomTheme.getBlackAndWhiteThemeColors()
                  .withOpacity(0.6),
              fontWeight: FontWeight.bold,
              fontSize: ConstanceData.SIZE_TITLE14,
            ),
          ),
        ),
        Divider(
          height: 1,
        ),
        Container(
          padding: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 8),
                      color: Colors.white,
                      child: Text(
                        'Prize Pool'.toUpperCase(),
                        // "${leageData.leagueName}".toUpperCase(),
                        style: TextStyle(
                          color: AllCoustomTheme.getTextThemeColors(),
                          fontSize: ConstanceData.SIZE_TITLE12,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8, top: 4),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 12,
                            height: 12,
                            padding: EdgeInsets.only(top: 1.5),
                            child: Image.asset(ConstanceData.ruppeIcon),
                          ),
                          Text(
                            "${leageData.totalWiningAmount}".toUpperCase(),
                            style: TextStyle(
                              color:
                                  AllCoustomTheme.getBlackAndWhiteThemeColors(),
                              fontWeight: FontWeight.bold,
                              fontSize: ConstanceData.SIZE_TITLE14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 8),
                      color: Colors.white,
                      child: Text(
                        "Winners".toUpperCase(),
                        style: TextStyle(
                          color: AllCoustomTheme.getTextThemeColors(),
                          fontSize: ConstanceData.SIZE_TITLE12,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        "${leageData.totalWiner}".toUpperCase(),
                        style: TextStyle(
                          color: AllCoustomTheme.getBlackAndWhiteThemeColors(),
                          fontWeight: FontWeight.bold,
                          fontSize: ConstanceData.SIZE_TITLE14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 8),
                      color: Colors.white,
                      child: Text(
                        "Teams".toUpperCase(),
                        style: TextStyle(
                          color: AllCoustomTheme.getTextThemeColors(),
                          fontSize: ConstanceData.SIZE_TITLE12,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        "${leageData.totalTeam}".toUpperCase(),
                        style: TextStyle(
                          color: AllCoustomTheme.getBlackAndWhiteThemeColors(),
                          fontWeight: FontWeight.bold,
                          fontSize: ConstanceData.SIZE_TITLE14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(right: 8),
                      color: Colors.white,
                      child: Text(
                        "Entry".toUpperCase(),
                        style: TextStyle(
                          color: AllCoustomTheme.getTextThemeColors(),
                          fontSize: ConstanceData.SIZE_TITLE12,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 8, top: 4),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 12,
                            height: 12,
                            padding: EdgeInsets.only(top: 1.5),
                            child: Image.asset(ConstanceData.ruppeIcon),
                          ),
                          Text(
                            "${leageData.entryFees}".toUpperCase(),
                            style: TextStyle(
                              color:
                                  AllCoustomTheme.getBlackAndWhiteThemeColors(),
                              fontWeight: FontWeight.bold,
                              fontSize: ConstanceData.SIZE_TITLE14,
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
        Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            height: 40,
            child: Container(
              decoration: new BoxDecoration(
                color: AllCoustomTheme.getThemeData().primaryColor,
                borderRadius: new BorderRadius.circular(4.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      offset: Offset(0, 1),
                      blurRadius: 5.0),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: new BorderRadius.circular(4.0),
                  onTap: () async {
                    Navigator.pop(context);
                  },
                  child: Center(
                    child: Text(
                      'JOIN CONTEST',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: ConstanceData.SIZE_TITLE12,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 16, bottom: 8, right: 16),
          color: Colors.white,
          child: Text(
            "You can check other competitors after joining the contest",
            style: TextStyle(
              color: AllCoustomTheme.getTextThemeColors(),
              fontWeight: FontWeight.bold,
              fontSize: ConstanceData.SIZE_TITLE14,
            ),
          ),
        ),
      ],
    );
  }

  Widget uderGroundDrawer(ContestsLeagueListData data) {
    return Column(
      children: <Widget>[
        Container(
          height: 40,
          padding: EdgeInsets.only(top: 4),
          color: Colors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'WINNING BREAKUP',
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
          height: 60,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Prize Pool',
                    style: TextStyle(
                      color: AllCoustomTheme.getBlackAndWhiteThemeColors(),
                      fontSize: ConstanceData.SIZE_TITLE16,
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    '₹' + data.totalWiningAmount,
                    style: TextStyle(
                      color: AllCoustomTheme.getTextThemeColors(),
                      fontWeight: FontWeight.bold,
                      fontSize: ConstanceData.SIZE_TITLE20,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: data.leagueWiner.length,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(right: 10, left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Text(
                            'Rank: ' + data.leagueWiner[index].postion,
                            style: TextStyle(
                              fontSize: ConstanceData.SIZE_TITLE14,
                            ),
                          ),
                        ),
                        Text(
                          '₹ ' + data.leagueWiner[index].price,
                          style: TextStyle(
                            color: AllCoustomTheme.getTextThemeColors(),
                            fontSize: ConstanceData.SIZE_TITLE14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider()
                ],
              );
            },
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

  Widget listItems(String name, String description) {
    return Column(
      children: <Widget>[
        InkWell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding:
                    EdgeInsets.only(left: 16, right: 16, bottom: 4, top: 8),
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: ConstanceData.SIZE_TITLE18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
                child: Text(
                  description,
                  style: TextStyle(
                      fontSize: ConstanceData.SIZE_TITLE14,
                      color: AllCoustomTheme.getTextThemeColors()),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class MatchHadder extends StatelessWidget {
//  final TabType tabtype;

//  const MatchHadder({Key key, this.tabtype = TabType.Upcoming})
//      : super(key: key);
  final MatchDataForApp matchDataForApp;

  const MatchHadder({Key key, this.matchDataForApp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AllCoustomTheme.getThemeData().backgroundColor,
      child: Column(
        children: <Widget>[
          Container(
            height: 36,
            padding: EdgeInsets.only(left: 8, right: 8, bottom: 4, top: 4),
            child: Row(
              children: <Widget>[
                Container(
                  width: 24,
                  height: 24,
                  child: Image.asset('assets/19.png'),
                ),
                Container(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: Text(
//                    'SA',
                    matchDataForApp.firstTeamShortName,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AllCoustomTheme.getThemeData().primaryColor,
                      fontSize: ConstanceData.SIZE_TITLE12,
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    'vs',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: ConstanceData.SIZE_TITLE12,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: Text(
//                    'IND',
                    matchDataForApp.secondTeamShortName,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AllCoustomTheme.getThemeData().primaryColor,
                      fontSize: ConstanceData.SIZE_TITLE12,
                    ),
                  ),
                ),
                Container(
                  width: 24,
                  height: 24,
                  child: Image.asset('assets/25.png'),
                ),
                Expanded(
                  child: SizedBox(),
                ),
                Container(
                  child: CountdownTimer(
                    endTime: matchDataForApp.deadlineTime,
                    onEnd: () {
                      print(
                          'onEnd-------------------------------------------------1');
//                      try {
//                        context
//                            .bloc<SportsDataBloc>()
//                            .deleteMatchfromList(matchDataForApp);
//                        print(
//                            'onEnd-------------------------------------------------2');
//                      } catch (e) {
//                        print(e.toString());
//                        print(e.code);
//                        print(e.message);
//                        print(e.details);
//                      }
                      Fluttertoast.showToast(
                          msg: "Time Over",
                          toastLength: Toast.LENGTH_LONG,
                          backgroundColor: Colors.black,
                          textColor: Colors.white);
                      print(
                          'onEnd-------------------------------------------------3');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NewHomeScreen()));
                    },
                    textStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
//                      Text(
////                    'Mon, 9 Sep',
//                    matchDataForApp.startDate,
//                    style: TextStyle(
//                      color: HexColor(
//                        '#AAAFBC',
//                      ),
//                      fontWeight: FontWeight.w600,
//                      fontSize: 14,
//                    ),
//                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
          )
        ],
      ),
    );
  }
}
