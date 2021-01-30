import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frolicsports/bloc/sportsDataBloc.dart';
import 'package:frolicsports/models/sportsData.dart';
import 'package:frolicsports/models/sportsDataForApp.dart';
import 'package:frolicsports/models/teamModel.dart';
import 'package:frolicsports/modules/home/newHomeScreen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:frolicsports/api/apiProvider.dart';
import 'package:frolicsports/bloc/teamSelectionBloc.dart';
import 'package:frolicsports/bloc/teamTapBloc.dart';
import 'package:frolicsports/constance/constance.dart';
import 'package:frolicsports/constance/themes.dart';
import 'package:frolicsports/models/scheduleResponseData.dart';
import 'package:frolicsports/models/squadsResponseData.dart';
import 'package:frolicsports/modules/createTeam/chooseCVCScreen.dart';
import 'package:frolicsports/modules/createTeam/createTeamProgressbar.dart';
import 'package:frolicsports/modules/createTeam/playerProfile.dart';
import 'package:frolicsports/modules/createTeam/teamPreview.dart';
import 'package:frolicsports/utils/avatarImage.dart';
import 'package:frolicsports/models/teamResponseData.dart' as team;
import 'package:frolicsports/constance/global.dart' as globals;

enum CreateTeamType { createTeam, editTeam, copyTeam }

//TeamSelectionBloc teamSelectionBloc = TeamSelectionBloc();
//TeamTapBloc teamTapBloc = TeamTapBloc();

class CreateTeamScreen extends StatefulWidget {
  //final ShedualData shedualData;
  final MatchDataForApp matchDataForApp;
  final CreateTeamType createTeamtype;
  final TeamDetails createdTeamData;
  final Contest selectedContest;

//
//  CreateTeamScreen(
//      this.matchDataForApp, this.createTeamtype , this.createdTeamData);
//

  const CreateTeamScreen(
      {Key key,
      this.matchDataForApp,
      this.createTeamtype = CreateTeamType.createTeam,
      this.createdTeamData,
      this.selectedContest})
      : super(key: key);

  @override
  _CreateTeamScreenState createState() => _CreateTeamScreenState();
}

class _CreateTeamScreenState extends State<CreateTeamScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TabController tabController;
  var selectedIndex = 0;
  var allPlayerList = List<Players>();
  bool isLoginProsses = false;

  @override
  void initState() {
//    print('sportName');
//    print(widget.matchDataForApp.sportsName);
    context.bloc<TeamSelectionBloc>().cleanList();
    context.bloc<TeamTapBloc>().cleanList();
    //teamSelectionBloc.cleanList();
    //teamTapBloc.cleanList();
    tabController = TabController(
        length: context
            .bloc<SportsDataBloc>()
            .getTournamentData(widget.matchDataForApp.tournamentName)
            .skillMap
            .keys
            .length,
        vsync: this,
        initialIndex: 0);
    tabController.addListener(() {
      setState(() {});
//      print(tabController.index);
      selectedIndex = tabController.index;
//      print(tabController.indexIsChanging);
    });
    getSquadTeamData();
    super.initState();
  }

  Future<List<Players>> _getMatchPlayers() async {
//    print('data');
    List<Players> playerList = List<Players>();

//    BlocBuilder<SportsDataBloc, SportsDataBlocState>(
//        builder: (_, sportsState) {

//          print('players');
    HashMap<int, Team> teamMap = context
        .bloc<SportsDataBloc>()
        .getTournamentData(widget.matchDataForApp.tournamentName)
        .teamMap;
//          print(teamMap[widget.matchDataForApp.firstTeamId].playerMap);
    for (PlayerDetails playerDetails
        in teamMap[widget.matchDataForApp.firstTeamId].playerMap.values) {
      Players players = Players();
      players.country = playerDetails.country;
      players.point =
          num.tryParse(playerDetails.credits.toString())?.toDouble();
      players.firstName = playerDetails.name;
      players.shortName = playerDetails.shortName;
      players.picture = playerDetails.pictures;
      players.pid = num.tryParse(playerDetails.playerId.toString())?.toInt();
      players.fantasyPlayerRating =
          num.tryParse(playerDetails.points.toString())?.toInt();
      players.playingRole = playerDetails.skills;
      players.teamId = teamMap[widget.matchDataForApp.firstTeamId].teamId;
      players.teamName = teamMap[widget.matchDataForApp.firstTeamId].shortName;
      players.playing11 = playerDetails.isPlaying.toString();
      players.battingStyle = 'RHB';
      players.bowlingStyle = 'RHB';
      players.nationality = playerDetails.country;

      playerList.add(players);
    }

    for (PlayerDetails playerDetails
        in teamMap[widget.matchDataForApp.secondTeamId].playerMap.values) {
      Players players = Players();
      players.country = playerDetails.country;
      players.point =
          num.tryParse(playerDetails.credits.toString())?.toDouble();
      players.firstName = playerDetails.name;
      players.shortName = playerDetails.shortName;
      players.picture = playerDetails.pictures;
      players.pid = num.tryParse(playerDetails.playerId.toString())?.toInt();
      players.fantasyPlayerRating =
          num.tryParse(playerDetails.points.toString())?.toInt();
      players.playingRole = playerDetails.skills;
      players.teamId = teamMap[widget.matchDataForApp.secondTeamId].teamId;
      players.teamName = teamMap[widget.matchDataForApp.secondTeamId].shortName;
      players.playing11 = playerDetails.isPlaying.toString();
      players.battingStyle = 'RHB';
      players.bowlingStyle = 'RHB';
      players.nationality = playerDetails.country;

      playerList.add(players);
    }

//        });
    return playerList;
  }

  Future<void> getSquadTeamData() async {
    setState(() {
      isLoginProsses = false;
    });
//    final data = await ApiProvider().getTeamData();

//    print("hello111");
    allPlayerList.clear();
    allPlayerList = await _getMatchPlayers();
//    print('playerList');
//   print(allPlayerList.length);

    if (allPlayerList.length > 0) {
      if (widget.createTeamtype == CreateTeamType.createTeam) {
//        print('create Team#############');
        context.bloc<TeamSelectionBloc>().onListChanges(
            allPlayerList,
            context.bloc<SportsDataBloc>().getTournamentSkills(
                widget.matchDataForApp.sportsName,
                widget.matchDataForApp.tournamentName));
      } else if (widget.createTeamtype == CreateTeamType.editTeam &&
          widget.createdTeamData != null) {
//        print(allPlayerList.length);
        allPlayerList.forEach((p) {
          if (p.shortName.toUpperCase() ==
              widget.createdTeamData.cName.toUpperCase()) {
            p.isSelcted = true;
            p.isC = true;
          }
          if (p.shortName.toUpperCase() ==
              widget.createdTeamData.vcName.toUpperCase()) {
            p.isVC = true;
            p.isSelcted = true;
          }
          if (isMach(p.pid)) {
            p.isSelcted = true;
          }
        });
        context.bloc<TeamSelectionBloc>().onListChanges(
            allPlayerList,
            context.bloc<SportsDataBloc>().getTournamentSkills(
                widget.matchDataForApp.sportsName,
                widget.matchDataForApp.tournamentName));
      } else if (widget.createTeamtype == CreateTeamType.copyTeam &&
          widget.createdTeamData != null) {
        allPlayerList.forEach((p) {
          if (p.shortName.toUpperCase() ==
              widget.createdTeamData.cName.toUpperCase()) {
            p.isSelcted = true;
            p.isC = true;
          }
          if (p.shortName.toUpperCase() ==
              widget.createdTeamData.vcName.toUpperCase()) {
            p.isVC = true;
            p.isSelcted = true;
          }
          if (isMach(p.pid)) {
            p.isSelcted = true;
          }
        });

        context.bloc<TeamSelectionBloc>().onListChanges(
            allPlayerList,
            context.bloc<SportsDataBloc>().getTournamentSkills(
                widget.matchDataForApp.sportsName,
                widget.matchDataForApp.tournamentName));
      }
    }
    setState(() {
      isLoginProsses = false;
    });
  }

  bool isMach(int id) {
    bool isMach = false;
//    var allplayername = List<String>();
//
//    allplayername.addAll(widget.createdTeamData.bastman.split(','));
//    allplayername.addAll(widget.createdTeamData.allRounder.split(','));
//    allplayername.addAll(widget.createdTeamData.bowler.split(','));
//    allplayername.add(widget.createdTeamData.wicketKeeper);

    widget.createdTeamData.teamPlayers.forEach((p) {
      if (p.playerId == id) {
        isMach = true;
        return;
      }
    });

    return isMach;
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
                                      child: CountdownTimer(
                                        endTime:
                                            widget.matchDataForApp.deadlineTime,
                                        onEnd: () {
                                          print('onEnd');
//                                          context
//                                              .bloc<SportsDataBloc>()
//                                              .deleteMatchfromList(
//                                                  widget.matchDataForApp);
                                          Fluttertoast.showToast(
                                              msg: "Time Over",
                                              toastLength: Toast.LENGTH_LONG,
                                              backgroundColor: Colors.black,
                                              textColor: Colors.white);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      NewHomeScreen()));
                                        },
                                        textStyle: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
//                                      Text(
////                                        'Mon, 9 Sep',
//                                        widget.matchDataForApp.startDate.toString(),
//                                        style: TextStyle(
//                                          fontSize: 24,
//                                          fontStyle: FontStyle.italic,
//                                          fontWeight: FontWeight.w500,
//                                          color: AllCoustomTheme.getThemeData()
//                                              .backgroundColor,
//                                        ),
//                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: AppBar().preferredSize.height,
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(4),
                              color:
                                  AllCoustomTheme.getThemeData().primaryColor,
                              child: Center(
                                child: Text(
                                  'Max ${context.bloc<SportsDataBloc>().getTournamentData(widget.matchDataForApp.tournamentName).maxPlayerFromSingleTeam.toString()} players from a team',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: ConstanceData.SIZE_TITLE14),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  top: 4, bottom: 4, left: 8, right: 8),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width >= 360
                                            ? 75
                                            : 65,
                                    padding: EdgeInsets.all(4),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                            'Players',
                                            style: TextStyle(
                                              color: Colors.white54,
                                              fontSize: MediaQuery.of(context)
                                                          .size
                                                          .width >=
                                                      360
                                                  ? ConstanceData.SIZE_TITLE12
                                                  : ConstanceData.SIZE_TITLE10,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: <Widget>[
                                              Container(
                                                child: BlocBuilder<
                                                    TeamSelectionBloc,
                                                    TeamSelectionBlocState>(
//                                                  bloc: teamSelectionBloc,
                                                  builder: (context, state) {
                                                    return Text(
                                                      '${context.bloc<TeamSelectionBloc>().getSelectedPlayerCount(null)}',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: AllCoustomTheme
                                                            .getReBlackAndWhiteThemeColors(),
                                                        fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width >=
                                                                360
                                                            ? ConstanceData
                                                                .SIZE_TITLE20
                                                            : ConstanceData
                                                                .SIZE_TITLE18,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    EdgeInsets.only(bottom: 4),
                                                child: Text(
                                                  ' / ${context.bloc<SportsDataBloc>().getTournamentData(widget.matchDataForApp.tournamentName).playersCount.toString()}',
                                                  style: TextStyle(
                                                    color: Colors.white54,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .width >=
                                                                360
                                                            ? ConstanceData
                                                                .SIZE_TITLE12
                                                            : ConstanceData
                                                                .SIZE_TITLE10,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Center(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Expanded(
                                              child: Container(
                                                padding:
                                                    EdgeInsets.only(right: 4),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Container(
                                                      child: BlocBuilder<
                                                              TeamSelectionBloc,
                                                              TeamSelectionBlocState>(
                                                          builder:
                                                              (context, state) {
                                                        int cnt = 0;
                                                        state.allPlayerList
                                                            .forEach((player) {
                                                          if (player
                                                                  .isSelcted &&
                                                              player.teamName ==
                                                                  widget
                                                                      .matchDataForApp
                                                                      .firstTeamShortName) {
                                                            cnt += 1;
                                                          }
                                                        });

                                                        return Text(
//                                                        'SA',
//                                                        widget.matchDataForApp
//                                                            .firstTeamShortName,
                                                          cnt.toString(),

                                                          style: TextStyle(
                                                            color:
                                                                Colors.white54,
                                                            fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width >=
                                                                    360
                                                                ? ConstanceData
                                                                    .SIZE_TITLE12
                                                                : ConstanceData
                                                                    .SIZE_TITLE10,
                                                          ),
                                                        );
                                                      }),
                                                    ),
                                                    Container(
                                                      child: BlocBuilder<
                                                          TeamSelectionBloc,
                                                          TeamSelectionBlocState>(
//                                                        bloc: teamSelectionBloc,
                                                        builder: (context,
                                                            TeamSelectionBlocState
                                                                state) {
                                                          return Text(
//                                                            'SA',
                                                            widget
                                                                .matchDataForApp
                                                                .firstTeamShortName,
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: AllCoustomTheme
                                                                  .getReBlackAndWhiteThemeColors(),
                                                              fontSize: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width >=
                                                                      360
                                                                  ? ConstanceData
                                                                      .SIZE_TITLE18
                                                                  : ConstanceData
                                                                      .SIZE_TITLE16,
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 50,
                                              height: 50,
                                              child:
                                                  Image.asset('assets/19.png'),
                                            ),
                                            Container(
                                              width: 16,
                                            ),
                                            Container(
                                              width: 50,
                                              height: 50,
                                              child:
                                                  Image.asset('assets/25.png'),
                                            ),
                                            Expanded(
                                              child: Container(
                                                padding:
                                                    EdgeInsets.only(left: 4),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Container(
                                                      child: BlocBuilder<
                                                              TeamSelectionBloc,
                                                              TeamSelectionBlocState>(
                                                          builder:
                                                              (context, state) {
                                                        int cnt = 0;
                                                        state.allPlayerList
                                                            .forEach((player) {
                                                          if (player
                                                                  .isSelcted &&
                                                              player.teamName ==
                                                                  widget
                                                                      .matchDataForApp
                                                                      .secondTeamShortName) {
                                                            cnt += 1;
                                                          }
                                                        });

                                                        return Text(
//                                                        'SA',
//                                                        widget.matchDataForApp
//                                                            .firstTeamShortName,
                                                          cnt.toString(),

                                                          style: TextStyle(
                                                            color:
                                                                Colors.white54,
                                                            fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width >=
                                                                    360
                                                                ? ConstanceData
                                                                    .SIZE_TITLE12
                                                                : ConstanceData
                                                                    .SIZE_TITLE10,
                                                          ),
                                                        );
                                                      }),

//                                                      Text(
////                                                        'IND',
//                                                        widget.matchDataForApp
//                                                            .secondTeamShortName,
//                                                        style: TextStyle(
//                                                          color: Colors.white54,
//                                                          fontSize: MediaQuery.of(
//                                                                          context)
//                                                                      .size
//                                                                      .width >=
//                                                                  360
//                                                              ? ConstanceData
//                                                                  .SIZE_TITLE12
//                                                              : ConstanceData
//                                                                  .SIZE_TITLE10,
//                                                        ),
//                                                      ),
                                                    ),
                                                    Container(
                                                      child: BlocBuilder<
                                                          TeamSelectionBloc,
                                                          TeamSelectionBlocState>(
//                                                        bloc: teamSelectionBloc,
                                                        builder: (context,
                                                            TeamSelectionBlocState
                                                                state) {
                                                          return Text(
//                                                            'IND',
                                                            widget
                                                                .matchDataForApp
                                                                .secondTeamShortName,
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: AllCoustomTheme
                                                                  .getReBlackAndWhiteThemeColors(),
                                                              fontSize: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width >=
                                                                      360
                                                                  ? ConstanceData
                                                                      .SIZE_TITLE18
                                                                  : ConstanceData
                                                                      .SIZE_TITLE16,
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width >= 360
                                            ? 75
                                            : 65,
                                    padding: EdgeInsets.all(4),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                            'Credits Left',
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                              color: Colors.white54,
                                              fontSize: MediaQuery.of(context)
                                                          .size
                                                          .width >=
                                                      360
                                                  ? ConstanceData.SIZE_TITLE12
                                                  : ConstanceData.SIZE_TITLE10,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: Container(
                                            child: BlocBuilder<
                                                TeamSelectionBloc,
                                                TeamSelectionBlocState>(
//                                              bloc: teamSelectionBloc,
                                              builder: (context,
                                                  TeamSelectionBlocState
                                                      state) {
                                                return Text(
                                                  '${context.bloc<SportsDataBloc>().getTournamentData(widget.matchDataForApp.tournamentName).totalPoints
//                                                      100.0
                                                      - context.bloc<TeamSelectionBloc>().getTotalSelctedPlayerRating()}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: AllCoustomTheme
                                                        .getReBlackAndWhiteThemeColors(),
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .width >=
                                                                360
                                                            ? ConstanceData
                                                                .SIZE_TITLE20
                                                            : ConstanceData
                                                                .SIZE_TITLE18,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 40,
                              width: double.infinity,
                              padding: EdgeInsets.all(8),
                              child: BlocBuilder<TeamSelectionBloc,
                                  TeamSelectionBlocState>(
//                                bloc: teamSelectionBloc,
                                builder:
                                    (context, TeamSelectionBlocState state) {
                                  final playesCount = context
                                      .bloc<TeamSelectionBloc>()
                                      .getSelectedPlayerCount(null);
                                  return CreateTeamProgressbarView(
                                    teamCount: playesCount,
                                    allowed: context
                                        .bloc<SportsDataBloc>()
                                        .getTournamentData(widget
                                            .matchDataForApp.tournamentName)
                                        .playersCount,
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 40,
                        child: BlocBuilder<TeamSelectionBloc,
                            TeamSelectionBlocState>(
//                          bloc: teamSelectionBloc,
                          builder: (context, TeamSelectionBlocState state) {
                            return TabBar(
                              isScrollable: true,
                              indicatorWeight: 3,
                              controller: tabController,
                              unselectedLabelColor:
                                  AllCoustomTheme.getTextThemeColors(),
                              indicatorColor:
                                  AllCoustomTheme.getThemeData().primaryColor,
                              labelColor:
                                  AllCoustomTheme.getBlackAndWhiteThemeColors(),
                              tabs: context
                                  .bloc<SportsDataBloc>()
                                  .getTournamentSkills(
                                      widget.matchDataForApp.sportsName,
                                      widget.matchDataForApp.tournamentName)
                                  .keys
                                  .map((e) {
                                return TabTextView(
                                  tabTextType: e.toUpperCase()
//                                  TabTextType.wk
                                  ,
                                  count: context
                                      .bloc<TeamSelectionBloc>()
                                      .getSelectedPlayerCount(e.toUpperCase()
//                                      TabTextType.wk
                                          ),
                                  isSelected: selectedIndex == 0 ? true : false,
                                );
                              }).toList(),
//                              <Widget>[
//                                TabTextView(
//                                  tabTextType: TabTextType.wk,
//                                  count: context.bloc<TeamSelectionBloc>()
//                                      .getSelectedPlayerCount(TabTextType.wk),
//                                  isSelected: selectedIndex == 0 ? true : false,
//                                ),
//                                TabTextView(
//                                  tabTextType: TabTextType.bat,
//                                  count: context.bloc<TeamSelectionBloc>()
//                                      .getSelectedPlayerCount(TabTextType.bat),
//                                  isSelected: selectedIndex == 1 ? true : false,
//                                ),
//                                TabTextView(
//                                  tabTextType: TabTextType.ar,
//                                  count: context.bloc<TeamSelectionBloc>()
//                                      .getSelectedPlayerCount(TabTextType.ar),
//                                  isSelected: selectedIndex == 2 ? true : false,
//                                ),
//                                TabTextView(
//                                  tabTextType: TabTextType.bowl,
//                                  count: context.bloc<TeamSelectionBloc>()
//                                      .getSelectedPlayerCount(TabTextType.bowl),
//                                  isSelected: selectedIndex == 3 ? true : false,
//                                ),
//                              ],
                            );
                          },
                        ),
                      ),
                      Flexible(
                        child: ModalProgressHUD(
                          inAsyncCall: isLoginProsses,
                          color: Colors.transparent,
                          progressIndicator: CircularProgressIndicator(
                            strokeWidth: 2.0,
                          ),
                          child: BlocBuilder<TeamSelectionBloc,
                              TeamSelectionBlocState>(
//                            bloc: teamSelectionBloc,
                            builder: (context, state) {
                              return TabBarView(
                                physics: BouncingScrollPhysics(
                                  parent: PageScrollPhysics(),
                                ),
                                controller: tabController,
                                children: context
                                    .bloc<SportsDataBloc>()
                                    .getTournamentSkills(
                                        widget.matchDataForApp.sportsName,
                                        widget.matchDataForApp.tournamentName)
                                    .keys
                                    .map((e) {
//                                      print('skillsssssssss');
//                                      print(e);
                                  return TeamSelectionList(
                                    players: context
                                        .bloc<TeamSelectionBloc>()
                                        .getTypeList(e.toUpperCase()),
                                    tabType: e.toUpperCase(),
                                    matchDataForApp: widget.matchDataForApp,
                                  );
                                }).toList(),
//                                <Widget>[
//                                  TeamSelectionList(
//                                      players: context
//                                          .bloc<TeamSelectionBloc>()
//                                          .getTypeList(TabTextType.wk),
//                                      tabType: TabTextType.wk),
//                                  TeamSelectionList(
//                                      players: context
//                                          .bloc<TeamSelectionBloc>()
//                                          .getTypeList(TabTextType.bat),
//                                      tabType: TabTextType.bat),
//                                  TeamSelectionList(
//                                      players: context
//                                          .bloc<TeamSelectionBloc>()
//                                          .getTypeList(TabTextType.ar),
//                                      tabType: TabTextType.ar),
//                                  TeamSelectionList(
//                                      players: context
//                                          .bloc<TeamSelectionBloc>()
//                                          .getTypeList(TabTextType.bowl),
//                                      tabType: TabTextType.bowl),
//                                ],
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                    height: 60,
                    padding: EdgeInsets.only(left: 50, right: 50, bottom: 20),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            decoration: new BoxDecoration(
                              color: Colors.white,
                              borderRadius: new BorderRadius.circular(4.0),
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
                                borderRadius: new BorderRadius.circular(4.0),
                                onTap: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TeamPreviewScreen(
                                        matchDataForApp: widget.matchDataForApp,
                                      ),
                                      fullscreenDialog: true,
                                    ),
                                  );
                                },
                                child: Center(
                                  child: Text(
                                    'TEAM PREVIEW',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AllCoustomTheme.getThemeData()
                                          .primaryColor,
                                      fontSize: ConstanceData.SIZE_TITLE12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: BlocBuilder<TeamSelectionBloc,
                              TeamSelectionBlocState>(
//                            bloc: teamSelectionBloc,
                            builder: (context, TeamSelectionBlocState state) {
                              final playesCount = context
                                  .bloc<TeamSelectionBloc>()
                                  .getSelectedPlayerCount(null);
                              final isValid = context
                                  .bloc<TeamSelectionBloc>()
                                  .validMinRequirement(context
                                      .bloc<SportsDataBloc>()
                                      .getTournamentSkills(
                                          widget.matchDataForApp.sportsName,
                                          widget
                                              .matchDataForApp.tournamentName));
                              var isDisabled = true;
                              if (playesCount ==
                                      context
                                          .bloc<SportsDataBloc>()
                                          .getTournamentData(widget
                                              .matchDataForApp.tournamentName)
                                          .playersCount &&
                                  isValid) {
                                isDisabled = false;
                              }
                              return Opacity(
                                opacity: isDisabled ? 0.2 : 1.0,
                                child: Container(
                                  decoration: new BoxDecoration(
                                    color: AllCoustomTheme.getThemeData()
                                        .primaryColor,
                                    borderRadius:
                                        new BorderRadius.circular(4.0),
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
                                      onTap: () async {
                                        if (!isDisabled) {
                                          context
                                              .bloc<TeamSelectionBloc>()
                                              .refreshCAndVC();
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ChooseCVCScreen(
                                                      matchDataForApp: widget
                                                          .matchDataForApp,
                                                      selectedContest: widget
                                                          .selectedContest),
                                            ),
                                          );
                                        }
                                      },
                                      child: Center(
                                        child: Text(
                                          'CONTINUE',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize:
                                                ConstanceData.SIZE_TITLE12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TabTextView extends StatelessWidget {
  final String tabTextType;
  final bool isSelected;
  final int count;

  const TabTextView({
    Key key,
    this.tabTextType,
    this.count = 0,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              child: Text(
                tabTextType.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? AllCoustomTheme.getBlackAndWhiteThemeColors()
                      : AllCoustomTheme.getTextThemeColors(),
                  fontSize: ConstanceData.SIZE_TITLE14,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 2),
              child: Text(
                ' ($count)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? AllCoustomTheme.getBlackAndWhiteThemeColors()
                      : AllCoustomTheme.getTextThemeColors(),
                  fontSize: ConstanceData.SIZE_TITLE10,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

//enum TabTextType { wk, bat, ar, bowl }
enum AnimationType { isRegular, isMinimum, isFull, isSeven, isCredits, atLeast }

class TeamSelectionList extends StatefulWidget {
  final List<Players> players;
  final String tabType;

//  final ShedualData shedualData;

  final MatchDataForApp matchDataForApp;

  const TeamSelectionList(
      {Key key, this.players, this.tabType, this.matchDataForApp})
      : super(key: key);

  @override
  _TeamSelectionListState createState() => _TeamSelectionListState();
}

class _TeamSelectionListState extends State<TeamSelectionList> {
  var messageList = List<String>();
  var animationType = AnimationType.isRegular;

  @override
  void initState() {
//    print('%%%%%%%%%%%%%%');
//    print(widget.players.length);
//    print(widget.tabType);
    context.bloc<TeamTapBloc>().setType(AnimationType.isRegular);

    super.initState();
//    print('hello');
//    print(widget.players.length);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          new Container(
            height: 40,
            child: Container(
              height: 40,
              width: double.infinity,
              color: AllCoustomTheme.getThemeData().scaffoldBackgroundColor,
              child: Container(
                child: Center(
                  child: BlocBuilder<TeamTapBloc, TeamTapBlocState>(
//                    bloc: teamTapBloc,
                    builder: (context, TeamTapBlocState teamTapBlocstate) {
                      animationType = teamTapBlocstate.animationType;
                      return BlocBuilder<TeamSelectionBloc,
                          TeamSelectionBlocState>(
//                        bloc: teamSelectionBloc,
                        builder: (context, TeamSelectionBlocState state) {
                          return Text(
                            getValideTxt(widget.tabType),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                                  AllCoustomTheme.getBlackAndWhiteThemeColors(),
                              fontSize: ConstanceData.SIZE_TITLE14,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 36,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 74),
                        child: Center(
                          child: Text(
                            'PLAYERS',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AllCoustomTheme.getTextThemeColors(),
                              fontSize: ConstanceData.SIZE_TITLE12,
                            ),
                          ),
                        ),
                      ),
                      Expanded(child: Container()),
                      Container(
                        width: 80,
                        child: Center(
                          child: Text(
                            'POINTS',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AllCoustomTheme.getTextThemeColors(),
                              fontSize: ConstanceData.SIZE_TITLE12,
                            ),
                          ),
                        ),
                      ),
                      BlocBuilder<TeamSelectionBloc, TeamSelectionBlocState>(
//                        bloc: teamSelectionBloc,
                        builder: (context, state) {
                          return InkWell(
                            onTap: () {
                              context
                                  .bloc<TeamSelectionBloc>()
                                  .setAssendingAndDesandingList(context
                                      .bloc<SportsDataBloc>()
                                      .getTournamentSkills(
                                          widget.matchDataForApp.sportsName,
                                          widget
                                              .matchDataForApp.tournamentName));
                            },
                            child: Container(
                              width: 70,
                              child: Center(
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'CREDITS',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AllCoustomTheme
                                            .getBlackAndWhiteThemeColors(),
                                        fontSize: ConstanceData.SIZE_TITLE12,
                                      ),
                                    ),
                                    Icon(
                                      state.assending == null
                                          ? Icons.arrow_upward
                                          : state.assending
                                              ? Icons.arrow_upward
                                              : Icons.arrow_downward,
                                      size: 20,
                                      color: AllCoustomTheme.getThemeData()
                                          .primaryColor,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      Container(
                        width: 30,
                      )
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.only(bottom: 80),
                physics: BouncingScrollPhysics(),
                itemCount: widget.players.length,
                itemBuilder: (context, index) {
//                  widget.players.forEach((f) {
////                    print(f.pid);
//                  });

                  return PlayerslistUI(
                    matchDataForApp: widget.matchDataForApp,
                    player: widget.players[index],
                  );
                }),
          )
        ],
      ),
    );
  }

  String getValideTxt(String type) {
    var txt = '';
    HashMap<String, Skill> skills = context
        .bloc<SportsDataBloc>()
        .getTournamentSkills(widget.matchDataForApp.sportsName,
            widget.matchDataForApp.tournamentName);

    if (animationType == AnimationType.isRegular) {
      if (skills[type].min == skills[type].max) {
//          txt = 'Pick ' + skills[type].min.toString() + ' Wicket-Keeper';
        txt = 'Pick ${skills[type].min.toString()} ${skills[type].skillName}';
      } else {
        txt =
            'Pick ${skills[type].min.toString()} - ${skills[type].max.toString()} ${skills[type].skillName}';
      }
//      if (TabTextType.wk == type) {
//        txt = 'Pick 1 Wicket-Keeper';
//      } else if (TabTextType.bat == type) {
//        txt = 'Pick 3 - 5 Batsmen';
//      } else if (TabTextType.ar == type) {
//        txt = 'Pick 1 - 3 All-Rounders';
//      } else if (TabTextType.bowl == type) {
//        txt = 'Pick 3 - 5 Bowlers';
//      }
    } else if (animationType == AnimationType.isMinimum) {
      txt =
          'You can pick only ${skills[type].max.toString()} ${skills[type].skillName}.';
//      if (TabTextType.wk == type) {
//        txt = 'You can pick only 1 Wicket-Keeper.';
//      } else if (TabTextType.bat == type) {
//        txt = 'You can pick only 5 Batsmen.';
//      } else if (TabTextType.ar == type) {
//        txt = 'You can pick only 3 All-Rounders.';
//      } else if (TabTextType.bowl == type) {
//        txt = 'You can pick only 5 Bowlers.';
//      }
    } else if (animationType == AnimationType.isFull) {
      txt =
          '${context.bloc<SportsDataBloc>().getTournamentData(widget.matchDataForApp.tournamentName).playersCount.toString()} players selected, tap continue.';
//      txt = '11 players selected, tap continue.';
    } else if (animationType == AnimationType.isSeven) {
      txt =
          'You can pick only ${context.bloc<SportsDataBloc>().getTournamentData(widget.matchDataForApp.tournamentName).maxPlayerFromSingleTeam.toString()} from each team.';
//      txt = 'You can pick only 7 from each team.';
    } else if (animationType == AnimationType.isCredits) {
      txt = 'Not enough credits to pick this player.';
    } else if (animationType == AnimationType.atLeast) {
      final isValidMini = context
          .bloc<TeamSelectionBloc>()
          .validMinErrorRequirement(
              context
                  .bloc<SportsDataBloc>()
                  .getTournamentData(widget.matchDataForApp.tournamentName)
                  .playersCount,
              context.bloc<SportsDataBloc>().getTournamentSkills(
                  widget.matchDataForApp.sportsName,
                  widget.matchDataForApp.tournamentName));
      if (isValidMini != null) {
        txt =
            'You must pick at least ${skills[type].min.toString()} ${skills[type].skillName}.';
//        if (TabTextType.wk == isValidMini) {
//          txt = 'You must pick at least 1 Wicket-Keeper.';
//        } else if (TabTextType.bat == isValidMini) {
//          txt = 'You must pick at least 3 Batsmen.';
//        } else if (TabTextType.ar == isValidMini) {
//          txt = 'You must pick at least 1 All-Rounders.';
//        } else if (TabTextType.bowl == isValidMini) {
//          txt = 'You must pick at least 3 Bowlers.';
//        }
      }
    }
    return txt;
  }
}

class PlayerslistUI extends StatelessWidget {
  final Players player;

  //final ShedualData shedualData;
  final MatchDataForApp matchDataForApp;

  const PlayerslistUI({Key key, this.player, this.matchDataForApp})
      : super(key: key);

  bool isValidMiniMach(String t, List<String> tlist) {
    bool isMach = false;
    tlist.forEach((type) {
      if (t == type) {
        isMach = true;
        return;
      }
    });
    return isMach;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamSelectionBloc, TeamSelectionBlocState>(
//      bloc: teamSelectionBloc,
      builder: (context, TeamSelectionBlocState state) {
        var isDisabled = false;
        final validCredites =
            context.bloc<TeamSelectionBloc>().getTotalSelctedPlayerRating();
        final is7Player =
            context.bloc<TeamSelectionBloc>().getMax7PlayesCount(player);
        final isValid = context.bloc<TeamSelectionBloc>().isDisabled(
            player.pid,
            context.bloc<SportsDataBloc>().getTournamentSkills(
                matchDataForApp.sportsName, matchDataForApp.tournamentName));
//        print(player.shortName);
//        print(isValid);
        final is11Player =
            context.bloc<TeamSelectionBloc>().getSelectedPlayerCount(null);
//        print('hellllllllll');
//        print(player.isSelcted);
//        print(is11Player);
        final isValidMini = context
            .bloc<TeamSelectionBloc>()
            .validMinErrorRequirement(
                context
                    .bloc<SportsDataBloc>()
                    .getTournamentData(matchDataForApp.tournamentName)
                    .playersCount,
                context.bloc<SportsDataBloc>().getTournamentSkills(
                    matchDataForApp.sportsName,
                    matchDataForApp.tournamentName));
//        print('hellllllllll1111');
//        print(isValidMini);
        if ((100.0 - validCredites) < player.fantasyPlayerRating &&
            !player.isSelcted) {
//          print('hehehe');
          isDisabled = true;
        }
        if (is7Player ==
                context
                    .bloc<SportsDataBloc>()
                    .getTournamentData(matchDataForApp.tournamentName)
                    .maxPlayerFromSingleTeam &&
            !player.isSelcted) {
//           print('hhhhh2222');
          isDisabled = true;
        }
        if (is11Player ==
                context
                    .bloc<SportsDataBloc>()
                    .getTournamentData(matchDataForApp.tournamentName)
                    .playersCount &&
            !player.isSelcted) {
//          print('hjhjhd222');
          isDisabled = true;
        }
        if (isValid && !player.isSelcted) {
//          print('98989898');
          isDisabled = true;
        }
//        print('hellllllllll22222');
        if (isValidMini != null && !player.isSelcted) {
//          print('here');
          if (isValidMini != player.playingRole.toUpperCase()) {
//            print('here234243243');
            if (!isValidMiniMach(
                player.playingRole.toUpperCase(),
                context.bloc<TeamSelectionBloc>().validMinErrorRequirementList(
                    context
                        .bloc<SportsDataBloc>()
                        .getTournamentData(matchDataForApp.tournamentName)
                        .playersCount,
                    context.bloc<SportsDataBloc>().getTournamentSkills(
                        matchDataForApp.sportsName,
                        matchDataForApp.tournamentName)))) {
//              print('here8888');
              isDisabled = true;
            }
          }
        }
//        print('hellllllllll4455666');
        return Opacity(
          opacity: isDisabled ? 0.5 : 1.0,
          child: Container(
            height: 60,
            color: player.isSelcted
                ? AllCoustomTheme.getThemeData().primaryColor.withOpacity(0.4)
                : AllCoustomTheme.getThemeData().backgroundColor,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: new BorderRadius.circular(0.0),
                onTap: () async {
                  if (!isDisabled) {
//                    print(player.shortName);
                    context.bloc<TeamSelectionBloc>().setPlaySelect(
                        player.pid,
                        context,
                        context
                            .bloc<SportsDataBloc>()
                            .getTournamentData(matchDataForApp.tournamentName)
                            .maxPlayerFromSingleTeam);
                  } else {
                    bool isatlest = false;
                    bool isMinimum = false;
                    if (isValidMini != null && !player.isSelcted) {
                      if (isValidMini != player.playingRole.toUpperCase()) {
//                        print('helle');
                        if (!isValidMiniMach(
                            player.playingRole.toUpperCase(),
                            context
                                .bloc<TeamSelectionBloc>()
                                .validMinErrorRequirementList(
                                    context
                                        .bloc<SportsDataBloc>()
                                        .getTournamentData(
                                            matchDataForApp.tournamentName)
                                        .playersCount,
                                    context
                                        .bloc<SportsDataBloc>()
                                        .getTournamentSkills(
                                            matchDataForApp.sportsName,
                                            matchDataForApp.tournamentName)))) {
//                          print('helle1111');
                          isatlest = true;
                        }
                      }
                    }
                    if (isValid && !player.isSelcted) {
                      isMinimum = true;
                    }
                    if (isatlest && isMinimum) {
                      context
                          .bloc<TeamTapBloc>()
                          .setType(AnimationType.atLeast);
                    } else {
                      if (isValidMini != null && !player.isSelcted) {
                        context
                            .bloc<TeamTapBloc>()
                            .setType(AnimationType.atLeast);
                      }
                      if (isValid && !player.isSelcted) {
                        context
                            .bloc<TeamTapBloc>()
                            .setType(AnimationType.isMinimum);
                      }
                    }
                    if (is7Player ==
                            context
                                .bloc<SportsDataBloc>()
                                .getTournamentData(
                                    matchDataForApp.tournamentName)
                                .maxPlayerFromSingleTeam &&
                        !player.isSelcted) {
                      context
                          .bloc<TeamTapBloc>()
                          .setType(AnimationType.isSeven);
                    }
                    if ((100.0 - validCredites) < player.fantasyPlayerRating &&
                        !player.isSelcted) {
                      context
                          .bloc<TeamTapBloc>()
                          .setType(AnimationType.isCredits);
                    }

                    if (is11Player ==
                            context
                                .bloc<SportsDataBloc>()
                                .getTournamentData(
                                    matchDataForApp.tournamentName)
                                .playersCount &&
                        !player.isSelcted) {
                      context.bloc<TeamTapBloc>().setType(AnimationType.isFull);
                    }
                  }
                },
                onLongPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlayerProfileScreen(
                        matchDataForApp: matchDataForApp,
                        player: player,
                        isChoose: true,
                      ),
                      fullscreenDialog: true,
                    ),
                  );
                },
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 16),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PlayerProfileScreen(
                                      matchDataForApp: matchDataForApp,
                                      player: player,
                                      isChoose: true,
                                    ),
                                    fullscreenDialog: true,
                                  ),
                                );
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                child: AvatarImage(
                                  isProgressPrimaryColor: true,
                                  isCircle: true,
                                  isAssets: true,
                                  imageUrl:
//                                      'assets/cname/${player.pid}.png',
                                      'assets/cname/119.png',
                                  radius: 50,
                                  sizeValue: 50,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      '${player.shortName}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AllCoustomTheme
                                            .getBlackAndWhiteThemeColors(),
                                        fontSize: ConstanceData.SIZE_TITLE12,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 4),
                                    child: Text(
                                      '${player.teamName} - ${player.playingRole.toUpperCase()}',
                                      style: TextStyle(
                                        color: AllCoustomTheme
                                            .getTextThemeColors(),
                                        fontSize: ConstanceData.SIZE_TITLE10,
                                      ),
                                    ),
                                  ),
                                  player.playing11 != ''
                                      ? Container(
                                          padding: EdgeInsets.only(top: 4),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                width: 6,
                                                height: 6,
                                                decoration: BoxDecoration(
                                                    color: player.playing11 ==
                                                            'true'
                                                        ? Colors.green
                                                        : player.playing11 ==
                                                                'false'
                                                            ? Colors.red
                                                            : AllCoustomTheme
                                                                .getTextThemeColors(),
                                                    shape: BoxShape.circle),
                                              ),
                                              Container(
                                                padding:
                                                    EdgeInsets.only(left: 4),
                                                child: Text(
                                                  player.playing11 == 'true'
                                                      ? 'Playing'
                                                      : player.playing11 ==
                                                              'false'
                                                          ? 'Not Playing'
                                                          : "",
                                                  style: TextStyle(
                                                      color: player.playing11 ==
                                                              'true'
                                                          ? Colors.green
                                                          : player.playing11 ==
                                                                  'false'
                                                              ? Colors.red
                                                              : AllCoustomTheme
                                                                  .getTextThemeColors(),
                                                      fontSize: ConstanceData
                                                          .SIZE_TITLE10,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : SizedBox()
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 100,
                            child: Center(
                              child: Text(
                                '${player.point}',
                                style: TextStyle(
                                  color: AllCoustomTheme.getTextThemeColors(),
                                  fontSize: ConstanceData.SIZE_TITLE12,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 40,
                            child: Text(
                              '${player.fantasyPlayerRating}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AllCoustomTheme
                                    .getBlackAndWhiteThemeColors(),
                                fontSize: ConstanceData.SIZE_TITLE12,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 8, bottom: 8),
                            width: 0.4,
                            child: Container(
                              color: AllCoustomTheme.getTextThemeColors()
                                  .withOpacity(0.5),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 8),
                            child: Center(
                              child: Container(
                                width: 40,
                                child: Icon(
                                  player.isSelcted ? Icons.close : Icons.add,
                                  color: player.isSelcted
                                      ? Colors.red
                                      : Colors.black,
                                ),
                              ),
                            ),
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
            ),
          ),
        );
      },
    );
  }
}
