import 'dart:collection';
import 'dart:convert';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:frolicsports/modules/contests/createContest.dart';
import 'package:frolicsports/modules/home/newHomeScreen.dart';
import 'package:uuid/uuid.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frolicsports/utils/paytmConfig.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:frolicsports/bloc/authBloc.dart';
import 'package:frolicsports/bloc/sportsDataBloc.dart';
import 'package:frolicsports/bloc/teamDataBloc.dart';
import 'package:frolicsports/models/sportsData.dart';
import 'package:frolicsports/models/sportsDataForApp.dart';
import 'package:frolicsports/models/teamModel.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:frolicsports/bloc/teamSelectionBloc.dart';
import 'package:frolicsports/constance/constance.dart';
import 'package:frolicsports/constance/themes.dart';
import 'package:frolicsports/models/scheduleResponseData.dart';
import 'package:frolicsports/models/squadsResponseData.dart';
import 'package:frolicsports/modules/createTeam/playerProfile.dart';
import 'package:frolicsports/modules/createTeam/teamPreview.dart';
import 'package:frolicsports/models/teamResponseData.dart' as team;
import 'package:frolicsports/modules/myteams/myTeams.dart';
import 'package:frolicsports/utils/avatarImage.dart';
import 'package:paytm/paytm.dart';
import 'createTeamScreen.dart';
import 'package:uuid/uuid.dart';
import 'package:frolicsports/constance/global.dart' as globals;

class ChooseCVCScreen extends StatefulWidget {
  final bool isUpdateTeam;
  final CreateTeamType createTeamtype;
  final team.TeamData createdTeamData;
  final MatchDataForApp matchDataForApp;
  final Contest selectedContest;

  const ChooseCVCScreen(
      {Key key,
      this.isUpdateTeam = false,
      this.createTeamtype = CreateTeamType.createTeam,
      this.createdTeamData,
      this.matchDataForApp,
      this.selectedContest})
      : super(key: key);

  @override
  _ChooseCVCScreenState createState() => _ChooseCVCScreenState();
}

class _ChooseCVCScreenState extends State<ChooseCVCScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var isLoginProsses = false;
  List<team.TeamData> createdTeamList = List<team.TeamData>();

  int totalTeams = 0;
  bool isJoinPaytm = false;
  @override
  void initState() {
    // TODO: implement initState

    getTeam();
    super.initState();
  }

  Future<void> getTeam() async {
    await context.bloc<TeamDataBloc>().getTeamDetailsfromFirestore(
        context.bloc<AuthBloc>().getCurrentUser().userId,
        widget.matchDataForApp.sportsName,
        widget.matchDataForApp.tournamentName,
        widget.matchDataForApp.matchUniqueId,
        widget.selectedContest.contestId);

    await context.bloc<TeamDataBloc>().getUserTeamsfromFirestore(
        context.bloc<AuthBloc>().getCurrentUser().userId);
    setState(() {
//      totalTeams = context.bloc<TeamDataBloc>().getTeamDetailsMap().teamDetails.length;
//      print('total');
//      print(totalTeams);
    });
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
              body: isJoinPaytm
                  ? Center(child: CircularProgressIndicator())
                  : Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: <Widget>[
                        Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                color:
                                    AllCoustomTheme.getThemeData().primaryColor,
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
                                                width: AppBar()
                                                    .preferredSize
                                                    .height,
                                                height: AppBar()
                                                    .preferredSize
                                                    .height,
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
                                                endTime: widget.matchDataForApp
                                                    .deadlineTime,
                                                onEnd: () {
                                                  print('onEnd');
//                                                  context
//                                                      .bloc<SportsDataBloc>()
//                                                      .deleteMatchfromList(
//                                                          widget
//                                                              .matchDataForApp);
                                                  Fluttertoast.showToast(
                                                      msg: "Time Over",
                                                      toastLength:
                                                          Toast.LENGTH_LONG,
                                                      backgroundColor:
                                                          Colors.black,
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
//                                              Text(
////                                          'Mon, 9 Sep',
//                                                widget
//                                                    .matchDataForApp.startDate,
//                                                style: TextStyle(
//                                                  fontSize: 24,
//                                                  fontStyle: FontStyle.italic,
//                                                  fontWeight: FontWeight.w500,
//                                                  color: AllCoustomTheme
//                                                          .getThemeData()
//                                                      .backgroundColor,
//                                                ),
//                                              ),
                                            ),
                                          ),
                                          Container(
                                            width:
                                                AppBar().preferredSize.height,
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      child: Center(
                                        child: Text(
                                          'Choose your ${context.bloc<SportsDataBloc>().getTournamentData(widget.matchDataForApp.tournamentName).specialRuleMap['C'].specialRuleName} and ${context.bloc<SportsDataBloc>().getTournamentData(widget.matchDataForApp.tournamentName).specialRuleMap['VC'].specialRuleName}',
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w500,
                                            color:
                                                AllCoustomTheme.getThemeData()
                                                    .backgroundColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      child: Center(
                                          child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                  width: 30,
                                                  height: 30,
                                                  child: Center(
                                                    child: Container(
                                                      width: 24,
                                                      height: 24,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            new BorderRadius
                                                                .circular(30.0),
                                                        border: new Border.all(
                                                          width: 1.0,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 2,
                                                                top: 2),
                                                        child: Center(
                                                          child: Text(
                                                            'C',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  ConstanceData
                                                                      .SIZE_TITLE12,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      bottom: 4),
                                                  child: Center(
                                                    child: Text(
                                                      ' gets ${context.bloc<SportsDataBloc>().getTournamentData(widget.matchDataForApp.tournamentName).specialRuleMap['C'].points.toString()}x points', // TODO
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: ConstanceData
                                                            .SIZE_TITLE14,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                  width: 30,
                                                  height: 30,
                                                  child: Center(
                                                    child: Container(
                                                      width: 24,
                                                      height: 24,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            new BorderRadius
                                                                .circular(30.0),
                                                        border: new Border.all(
                                                          width: 1.0,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 4,
                                                                top: 1),
                                                        child: Center(
                                                          child: Text(
                                                            'vc',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  ConstanceData
                                                                      .SIZE_TITLE14,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      bottom: 4),
                                                  child: Center(
                                                    child: Text(
                                                      ' gets ${context.bloc<SportsDataBloc>().getTournamentData(widget.matchDataForApp.tournamentName).specialRuleMap['VC'].points.toString()}x points',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: ConstanceData
                                                            .SIZE_TITLE14,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      )),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: ModalProgressHUD(
                                  color: Colors.transparent,
                                  inAsyncCall: isLoginProsses,
                                  progressIndicator: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                  ),
                                  child: BlocBuilder<TeamSelectionBloc,
                                      TeamSelectionBlocState>(
//                              bloc: teamSelectionBloc,
                                    builder: (context, state) {
                                      var selectedPlayerList = List<Players>();
                                      state.allPlayerList.forEach((player) {
                                        if (player.isSelcted) {
                                          selectedPlayerList.add(player);
                                        }
                                      });

                                      HashMap<String, Skill> skillMap = context
                                          .bloc<SportsDataBloc>()
                                          .getTournamentSkills(
                                              widget.matchDataForApp.sportsName,
                                              widget.matchDataForApp
                                                  .tournamentName);
                                      HashMap<String, List<Players>>
                                          skillPlayerList =
                                          HashMap<String, List<Players>>();
                                      skillMap.keys.forEach((e) {
                                        skillPlayerList[e.toUpperCase()] =
                                            List<Players>();
                                      });

//                                var wkList = List<Players>();
//                                var batList = List<Players>();
//                                var arList = List<Players>();
//                                var bowlList = List<Players>();
                                      var allPlayesList = List<Players>();
                                      selectedPlayerList.forEach((player) {
                                        skillMap.keys.forEach((e) {
                                          if (player.playingRole
                                                  .toUpperCase() ==
                                              e.toUpperCase()) {
                                            skillPlayerList[e.toUpperCase()]
                                                .add(player);
                                          }
                                        });

//                                  if (player.playingRole.toLowerCase() ==
//                                      context
//                                          .bloc<TeamSelectionBloc>()
//                                          .getTypeText(TabTextType.wk)
//                                          .toLowerCase()) {
//                                    wkList.add(player);
//                                  }
//                                  if (player.playingRole.toLowerCase() ==
//                                      context
//                                          .bloc<TeamSelectionBloc>()
//                                          .getTypeText(TabTextType.bat)
//                                          .toLowerCase()) {
//                                    batList.add(player);
//                                  }
//                                  if (player.playingRole.toLowerCase() ==
//                                      context
//                                          .bloc<TeamSelectionBloc>()
//                                          .getTypeText(TabTextType.ar)
//                                          .toLowerCase()) {
//                                    arList.add(player);
//                                  }
//                                  if (player.playingRole.toLowerCase() ==
//                                      context
//                                          .bloc<TeamSelectionBloc>()
//                                          .getTypeText(TabTextType.bowl)
//                                          .toLowerCase()) {
//                                    bowlList.add(player);
//                                  }
                                      });

                                      skillMap.keys.forEach((e) {
                                        skillPlayerList[e.toUpperCase()].sort(
                                            (a, b) => b.fantasyPlayerRating
                                                .compareTo(
                                                    a.fantasyPlayerRating));
                                      });
//                                wkList.sort((a, b) => b.fantasyPlayerRating
//                                    .compareTo(a.fantasyPlayerRating));
//                                batList.sort((a, b) => b.fantasyPlayerRating
//                                    .compareTo(a.fantasyPlayerRating));
//                                arList.sort((a, b) => b.fantasyPlayerRating
//                                    .compareTo(a.fantasyPlayerRating));
//                                bowlList.sort((a, b) => b.fantasyPlayerRating
//                                    .compareTo(a.fantasyPlayerRating));

                                      skillMap.keys.forEach((e) {
                                        allPlayesList.addAll(
                                            skillPlayerList[e.toUpperCase()]);
                                      });
//                                allPlayesList.addAll(wkList);
//                                allPlayesList.addAll(batList);
//                                allPlayesList.addAll(arList);
//                                allPlayesList.addAll(bowlList);

                                      return ListView.builder(
                                        padding: EdgeInsets.only(bottom: 80),
                                        physics: BouncingScrollPhysics(),
                                        itemCount: allPlayesList.length,
                                        itemBuilder: (context, index) =>
                                            PlayerslistUI(
                                          matchDataForApp:
                                              widget.matchDataForApp,
                                          player: allPlayesList[index],
                                          isGrayBar: index != 0
                                              ? allPlayesList[index]
                                                      .playingRole !=
                                                  allPlayesList[index - 1]
                                                      .playingRole
                                              : true,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 60,
                          padding:
                              EdgeInsets.only(left: 50, right: 50, bottom: 20),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  decoration: new BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        new BorderRadius.circular(4.0),
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
                                      borderRadius:
                                          new BorderRadius.circular(4.0),
                                      onTap: () async {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                TeamPreviewScreen(
                                              matchDataForApp:
                                                  widget.matchDataForApp,
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
                                            color:
                                                AllCoustomTheme.getThemeData()
                                                    .primaryColor,
                                            fontSize:
                                                ConstanceData.SIZE_TITLE12,
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
                                  builder:
                                      (context, TeamSelectionBlocState state) {
                                    final isDisabled = context
                                        .bloc<TeamSelectionBloc>()
                                        .validSaveTeamRequirement();
                                    return Opacity(
                                      opacity: isDisabled ? 1.0 : 0.2,
                                      child: Container(
                                        decoration: new BoxDecoration(
                                          color: AllCoustomTheme.getThemeData()
                                              .primaryColor,
                                          borderRadius:
                                              new BorderRadius.circular(4.0),
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.5),
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
                                              if (isDisabled) {
                                                await setshowDialog();

                                                //saveTeam(state.allPlayerList);
                                              }
                                            },
                                            child: Center(
                                              child: Text(
                                                'SAVE TEAM',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: ConstanceData
                                                      .SIZE_TITLE12,
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

  var isLoad = false;
  Future setshowDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext buildContext) {
        return

//          isLoad ?
//              CircularProgressIndicator()
//              :
            Scaffold(
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
                                widget.selectedContest.entryAmount.toString(),
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
                                '₹${(int.parse(context.bloc<AuthBloc>().getCurrentUser().balance) - widget.selectedContest.entryAmount).toString()}',
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
                                    onTap: () async {
                                      print("pressssssssssss");
                                      setState(() {
                                        isJoinPaytm = true;
                                      });
                                      paytmFunction();
                                      Navigator.pop(context, true);
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

  Widget _dialogBox() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Try again",
            style: TextStyle(fontSize: 18),
          ),
          actions: [
            MaterialButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    //builder: (context) =>
                    //      CreateTeamScreen(),
                    builder: (context) => CreateTeamScreen(
                        matchDataForApp: widget.matchDataForApp),
                    fullscreenDialog: true,
                  ),
                );
              },
              child: Text("Try Again"),
            )
          ],
          content: Text(
            "Transaction failed, Please try again",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
        );
      },
    );
  }

  paytmFunction() async {
    print('called');
    final int amt = 10;
    try {
      final HttpsCallableResult result = await callable.call(
        <String, dynamic>{
          'orderId': orderID.toString(),
          'amt': amt.toString(),
          'custId': custId
        },
      );
      print('result');
      print("ORDERID : $orderID");
      print(result.data);
      print(result.data['checksum']);

      var body = {
        "requestType": payment,
        "mid": mid,
        "websiteName": webStaging,
        "orderId": orderID.toString(),
        "callbackUrl": callBackUrl,
        "txnAmount": {
          "value": amt.toString(),
          "currency": currency,
        },
        "userInfo": {
          "custId": custId,
        }
      };
      print(body);
      var head = {"signature": result.data['checksum']};
      print(head);

      var post_data = {"body": body, "head": head};

      print(post_data.toString());

      var pp = jsonEncode(post_data);
      var url =
          'https://securegw-stage.paytm.in/theia/api/v1/initiateTransaction?mid=lUvMfI35194252768557&orderId=' +
              orderID.toString();
      var response = await http.post(
        url,
        body: pp,
        headers: {
          'Content-Type': 'application/json',
          'Content-Length': pp.length.toString()
        },
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      bool isValidToken = false;
      String tokenString = '';
      final tokenResponse = jsonDecode(response.body);
      if (tokenResponse['body']['resultInfo']['resultStatus'] == 'S') {
        tokenString = tokenResponse['body']['txnToken'];
        isValidToken = true;
        print("token details");
        print(isValidToken);
        print(tokenString);
        var paytmResponse;
        paytmResponse = await Paytm.payWithPaytm(
            mid,
            orderID.toString(),
            tokenString,
            amt.toString(),
            callBackUrl + "?ORDER_ID=" + orderID.toString(),
            true);

        if (paytmResponse != null) {
          Navigator.pop(context);
        }
        paytmResponse.then((value) async {
          print("Paytm Response is : $value}");

          var map = Map<String, dynamic>.from(value);
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CreateTeamScreen(matchDataForApp: widget.matchDataForApp),
              fullscreenDialog: true,
            ),
          );
          await Fluttertoast.showToast(
            msg: "Transaction successful",
            //timeInSecForIos: 5,
            backgroundColor: Colors.black,
            textColor: Colors.white,
          );
        }).catchError((err) {
          print("fffffffffffffffffffffffffffffffff");
          //_dialogBox();
          Fluttertoast.showToast(
              msg: 'Transaction Failed',
              //fontSize: 18,
              //timeInSecForIos: 5,
              backgroundColor: Colors.black,
              textColor: Colors.white);
        });
      }

//                    print('Response body: ${tokenResponse['body']['resultInfo']}');

//                    print(await http.read('https://example.com/foobar.txt'));
    } on CloudFunctionsException catch (e) {
      print('caught firebase functions exception');
      print(e.code);
      print(e.message);
      print(e.details);
      print("-------------------cloundfunctionException");
      // _dialogBox();
      await Fluttertoast.showToast(
          msg: "Transaction Failed",
          //fontSize: 18,
          textColor: Colors.white,
          backgroundColor: Colors.black);
    } catch (e) {
      print('---------------------------caught generic exception');

      // _dialogBox();
      await Fluttertoast.showToast(
          msg: "Transaction Failed, Try Again",
          //fontSize: 18,
          textColor: Colors.white,
          backgroundColor: Colors.black);
      print(e);
    }
  }

  void saveTeam(List<Players> playerList) async {
    List<TeamPlayer> teamPlayerList = List<TeamPlayer>();
    Map<String, int> teamCounts = Map<String, int>();
    TeamDetails teamData = TeamDetails();
    for (Players players in playerList) {
      if (players.isSelcted) {
        TeamPlayer teamPlayer = TeamPlayer();
        teamPlayer.playerId = players.pid.toString();
        teamPlayer.skill = players.playingRole.toString();
//        print(players.playingRole.toString());
        if (players.isC == true) {
          teamData.cId = players.pid.toString();
          teamData.cName = players.shortName.toString();
          teamData.cImage = players.picture.toString();
        }
        if (players.isVC == true) {
          teamData.vcId = players.pid.toString();
          teamData.vcName = players.shortName.toString();
          teamData.vcImage = players.picture.toString();
        }

        teamCounts.containsKey(players.teamName)
            ? teamCounts[players.teamName] += 1
            : teamCounts[players.teamName] = 1;
        teamPlayerList.add(teamPlayer);
      }
    }
//    print('count');
//    print(teamCounts.length);
    bool check = false;
    teamCounts.forEach((key, value) {
      if (check == false) {
        teamData.teamAName = key;
        teamData.teamACount = value;
        check = true;
      } else {
        teamData.teamBName = key;
        teamData.teamBCount = value;
      }
    });

//    var uuid = Uuid();
    teamData.teamName =
        (context.bloc<TeamDataBloc>().getTeamDetailsMap().teamDetails.length +
                1)
            .toString(); //uuid.v1().toString().substring(0, 6);
    teamData.teamPlayers = teamPlayerList;
    teamData.userId = context
        .bloc<AuthBloc>()
        .getCurrentUser()
        .userId; //'pank';//TODO globals.userdata.userId;
    teamData.createdTime = DateTime.now().toString();

    print(teamData.toJson());
    await context.bloc<TeamDataBloc>().saveTeamDetailsToFirestore(
        teamData,
        widget.matchDataForApp.sportsName,
        widget.matchDataForApp.tournamentName,
        widget.matchDataForApp.matchUniqueId,
        widget.selectedContest.contestId);

//    Navigator.pop(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            MyTeamsScreen(matchDataForApp: widget.matchDataForApp),
      ),
    );
  }
}

class PlayerslistUI extends StatelessWidget {
  final Players player;

  //final ShedualData shedualData;
  final MatchDataForApp matchDataForApp;
  final bool isGrayBar;

  const PlayerslistUI(
      {Key key, this.player, this.isGrayBar = false, this.matchDataForApp})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AllCoustomTheme.getThemeData().backgroundColor,
      child: Column(
        children: <Widget>[
          isGrayBar
              ? Container(
                  padding: EdgeInsets.all(4),
                  color: AllCoustomTheme.getThemeData()
                      .dividerColor
                      .withOpacity(0.1),
                  child: Center(
                    child: Text(
                      context.bloc<TeamSelectionBloc>().getFullNameType(
                          player.playingRole,
                          context.bloc<SportsDataBloc>().getTournamentSkills(
                              matchDataForApp.sportsName,
                              matchDataForApp.tournamentName)),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AllCoustomTheme.getBlackAndWhiteThemeColors(),
                        fontSize: ConstanceData.SIZE_TITLE12,
                      ),
                    ),
                  ),
                )
              : SizedBox(),
          Container(
            height: 60,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: new BorderRadius.circular(0.0),
                onTap: () async {},
                onLongPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlayerProfileScreen(
                        matchDataForApp: matchDataForApp,
                        player: player,
                        isChoose: false,
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
                                      isChoose: false,
                                    ),
                                    fullscreenDialog: true,
                                  ),
                                );
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                child: AvatarImage(
                                  isCircle: true,
                                  isAssets: true,
                                  imageUrl:
//                                  'assets/cname/${player.pid}.png',
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
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 80,
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
                            padding: EdgeInsets.only(top: 8, bottom: 8),
                            width: 0.4,
                            child: Container(
                              color: AllCoustomTheme.getTextThemeColors()
                                  .withOpacity(0.5),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 8, left: 8),
                            child: Center(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: new BorderRadius.circular(32.0),
                                  onTap: () {
                                    context
                                        .bloc<TeamSelectionBloc>()
                                        .setCaptain(player.pid);
                                  },
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: player.isC
                                          ? AllCoustomTheme.getThemeData()
                                              .primaryColor
                                          : Colors.transparent,
                                      borderRadius:
                                          new BorderRadius.circular(32.0),
                                      border: new Border.all(
                                        width: 1.0,
                                        color: player.isC
                                            ? AllCoustomTheme.getThemeData()
                                                .primaryColor
                                            : AllCoustomTheme
                                                .getTextThemeColors(),
                                      ),
                                    ),
                                    child: Container(
                                      padding:
                                          EdgeInsets.only(bottom: 2, top: 2),
                                      child: Center(
                                        child: Text(
                                          'C',
                                          style: TextStyle(
                                            color: player.isC
                                                ? Colors.white
                                                : AllCoustomTheme
                                                    .getTextThemeColors(),
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                ConstanceData.SIZE_TITLE16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 16),
                            child: Center(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: new BorderRadius.circular(32.0),
                                  onTap: () {
                                    context
                                        .bloc<TeamSelectionBloc>()
                                        .setViceCaptain(player.pid);
                                  },
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: player.isVC
                                          ? AllCoustomTheme.getThemeData()
                                              .primaryColor
                                          : Colors.transparent,
                                      borderRadius:
                                          new BorderRadius.circular(32.0),
                                      border: new Border.all(
                                        width: 1.0,
                                        color: player.isVC
                                            ? AllCoustomTheme.getThemeData()
                                                .primaryColor
                                            : AllCoustomTheme
                                                .getTextThemeColors(),
                                      ),
                                    ),
                                    child: Container(
                                      padding:
                                          EdgeInsets.only(bottom: 4, top: 1),
                                      child: Center(
                                        child: Text(
                                          'vc',
                                          style: TextStyle(
                                            color: player.isVC
                                                ? Colors.white
                                                : AllCoustomTheme
                                                    .getTextThemeColors(),
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                ConstanceData.SIZE_TITLE18,
                                          ),
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
                    Divider(
                      height: 1,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
