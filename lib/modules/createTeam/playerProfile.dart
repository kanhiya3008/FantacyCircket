import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frolicsports/bloc/sportsDataBloc.dart';
import 'package:frolicsports/bloc/teamSelectionBloc.dart';
import 'package:frolicsports/bloc/teamTapBloc.dart';
import 'package:frolicsports/models/sportsData.dart';
import 'package:frolicsports/models/sportsDataForApp.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:frolicsports/constance/constance.dart';
import 'package:frolicsports/constance/themes.dart';
import 'package:frolicsports/models/playerMachPointResponse.dart';
import 'package:frolicsports/models/scheduleResponseData.dart';
import 'package:frolicsports/models/squadsResponseData.dart';
import 'package:frolicsports/utils/avatarImage.dart';

import 'createTeamScreen.dart';

class PlayerProfileScreen extends StatefulWidget {
  final Players player;
  final bool isChoose;
  //final ShedualData shedualData;
  final MatchDataForApp matchDataForApp;

  const PlayerProfileScreen(
      {Key key, this.player, this.isChoose = false, this.matchDataForApp})
      : super(key: key);
  @override
  _PlayerProfileScreenState createState() => _PlayerProfileScreenState();
}

class _PlayerProfileScreenState extends State<PlayerProfileScreen> {
  var isProsses = false;
  List<PlayerData> playerMachImfoList;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    getPlayerMachImfoList();
    super.initState();
  }

  void getPlayerMachImfoList() async {
    setState(() {
      isProsses = true;
    });

    setState(() {
      isProsses = false;
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
              body: Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: <Widget>[
                  Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
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
                                            Icons.close,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: Container(
                                          child: Text(
                                            widget.player.firstName
//                                                +
//                                                ' '
//                                                +
//                                                widget.player.lastName
                                            ,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  ConstanceData.SIZE_TITLE18,
                                            ),
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
                              Container(
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      // color: Colors.white,
                                      padding: EdgeInsets.only(left: 24),
                                      child: Container(
                                        width: 100,
                                        height: 100,
                                        child: AvatarImage(
                                          isCircle: true,
                                          isAssets: true,
                                          imageUrl:
//                                              'assets/cname/${widget.player.pid}.png',
                                          'assets/cname/119.png',
                                          radius: 100,
                                          sizeValue: 100,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 40),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width >=
                                                    360
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
                                                'Credits',
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                  color: Colors.white54,
                                                  fontSize: ConstanceData
                                                      .SIZE_TITLE14,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(top: 8),
                                              child: Text(
                                                '${widget.player.fantasyPlayerRating}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: AllCoustomTheme
                                                      .getReBlackAndWhiteThemeColors(),
                                                  fontSize: ConstanceData
                                                      .SIZE_TITLE22,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width >=
                                                    360
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
                                                'Total points',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: Colors.white54,
                                                  fontSize: ConstanceData
                                                      .SIZE_TITLE14,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(top: 8),
                                              child: Text(
                                                '${widget.player.point}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: AllCoustomTheme
                                                      .getReBlackAndWhiteThemeColors(),
                                                  fontSize: ConstanceData
                                                      .SIZE_TITLE22,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(16.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: new Border.all(
                                      width: 1.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        height: 50,
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Container(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: 8),
                                                      child: Text(
                                                        'Bats',
                                                        textAlign:
                                                            TextAlign.end,
                                                        style: TextStyle(
                                                          color: Colors.white54,
                                                          fontSize:
                                                              ConstanceData
                                                                  .SIZE_TITLE12,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: 8),
                                                      child: Text(
                                                        '${widget.player.battingStyle}',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: AllCoustomTheme
                                                              .getReBlackAndWhiteThemeColors(),
                                                          fontSize:
                                                              ConstanceData
                                                                  .SIZE_TITLE14,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 1,
                                              color: Colors.white,
                                            ),
                                            Expanded(
                                              child: Container(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: 8),
                                                      child: Text(
                                                        'Bowls',
                                                        textAlign:
                                                            TextAlign.end,
                                                        style: TextStyle(
                                                          color: Colors.white54,
                                                          fontSize:
                                                              ConstanceData
                                                                  .SIZE_TITLE12,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: 8),
                                                      child: Text(
                                                        '${widget.player.bowlingStyle}',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: AllCoustomTheme
                                                              .getReBlackAndWhiteThemeColors(),
                                                          fontSize:
                                                              ConstanceData
                                                                  .SIZE_TITLE14,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 1,
                                        color: Colors.white,
                                      ),
                                      Container(
                                        height: 50,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                              child: Container(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: 8),
                                                      child: Text(
                                                        'Nationality',
                                                        textAlign:
                                                            TextAlign.end,
                                                        style: TextStyle(
                                                          color: Colors.white54,
                                                          fontSize:
                                                              ConstanceData
                                                                  .SIZE_TITLE12,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: 8),
                                                      child: Text(
                                                        '${widget.player.nationality}',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: AllCoustomTheme
                                                              .getReBlackAndWhiteThemeColors(),
                                                          fontSize:
                                                              ConstanceData
                                                                  .SIZE_TITLE14,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 1,
                                              color: Colors.white,
                                            ),
                                            Expanded(
                                              child: Container(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: 8),
                                                      child: Text(
                                                        'Birthday',
                                                        textAlign:
                                                            TextAlign.end,
                                                        style: TextStyle(
                                                          color: Colors.white54,
                                                          fontSize:
                                                              ConstanceData
                                                                  .SIZE_TITLE12,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: 8),
                                                      child: Text(
                                                        widget.player.birthdate == null ? '-' : '${widget.player.birthdate}',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: AllCoustomTheme
                                                              .getReBlackAndWhiteThemeColors(),
                                                          fontSize:
                                                              ConstanceData
                                                                  .SIZE_TITLE14,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              'MATCHWISE FANTASY STATS',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AllCoustomTheme
                                    .getBlackAndWhiteThemeColors(),
                                fontSize: ConstanceData.SIZE_TITLE14,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 20,
                          color: AllCoustomTheme.getTextThemeColors()
                              .withOpacity(0.3),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(left: 16),
                                  child: Text(
                                    'MATCH',
                                    style: TextStyle(
                                      fontSize: ConstanceData.SIZE_TITLE10,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 16),
                                child: Text(
                                  'POINTS',
                                  style: TextStyle(
                                    fontSize: ConstanceData.SIZE_TITLE10,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: ModalProgressHUD(
                            inAsyncCall: isProsses,
                            color: Colors.transparent,
                            progressIndicator: CircularProgressIndicator(
                              strokeWidth: 2.0,
                            ),
                            child: playerMachImfoList == null
                                ? Container(
                                    height: 1,
                                    child: LinearProgressIndicator(),
                                  )
                                : playerMachImfoList.length > 0
                                    ? ListView.builder(
                                        padding: EdgeInsets.only(bottom: 80),
                                        physics: BouncingScrollPhysics(),
                                        itemCount: playerMachImfoList.length,
                                        itemBuilder: (context, index) =>
                                            PlayerslistUI(
                                          playerMachImfoList:
                                              playerMachImfoList[index],
                                        ),
                                      )
                                    : Container(
                                        padding: EdgeInsets.only(top: 50),
                                        child: Text(
                                          'No match infomation are available!',
                                          style: TextStyle(
                                              fontSize:
                                                  ConstanceData.SIZE_TITLE12,
                                              color: AllCoustomTheme
                                                  .getTextThemeColors()),
                                        ),
                                      ),
                          ),
                        )
                      ],
                    ),
                  ),
                  widget.isChoose ? addToTeam() : SizedBox()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(
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

  Widget addToTeam() {
    var isDisabled = false;
    final validCredites = context.bloc<TeamSelectionBloc>().getTotalSelctedPlayerRating();
    final is7Player = context.bloc<TeamSelectionBloc>().getMax7PlayesCount(widget.player);
    final isValid = context.bloc<TeamSelectionBloc>().isDisabled(widget.player.pid,
        context.bloc<SportsDataBloc>().getTournamentSkills(widget.matchDataForApp.sportsName, widget.matchDataForApp.tournamentName)
    );
    final is11Player = context.bloc<TeamSelectionBloc>().getSelectedPlayerCount(null);
    final isValidMini = context.bloc<TeamSelectionBloc>().validMinErrorRequirement(
        context.bloc<SportsDataBloc>().getTournamentData(widget.matchDataForApp.tournamentName).playersCount,
        context.bloc<SportsDataBloc>().getTournamentSkills(widget.matchDataForApp.sportsName, widget.matchDataForApp.tournamentName)
    );

    if ((100.0 - validCredites) < widget.player.fantasyPlayerRating &&
        !widget.player.isSelcted) {
      isDisabled = true;
    }
    if (is7Player == 7 && !widget.player.isSelcted) {
      isDisabled = true;
    }
    if (is11Player == 11 && !widget.player.isSelcted) {
      isDisabled = true;
    }
    if (isValid && !widget.player.isSelcted) {
      isDisabled = true;
    }
    if (isValidMini != null && !widget.player.isSelcted) {
      if (isValidMini !=
          widget.player.playingRole.toUpperCase()) {
        if (!isValidMiniMach(
            widget.player.playingRole.toUpperCase(),
            context.bloc<TeamSelectionBloc>().validMinErrorRequirementList(
                context.bloc<SportsDataBloc>().getTournamentData(widget.matchDataForApp.tournamentName).playersCount,
              context.bloc<SportsDataBloc>().getTournamentSkills(widget.matchDataForApp.sportsName, widget.matchDataForApp.tournamentName)
            ))) {
          isDisabled = true;
        }
      }
    }
    return Container(
      height: 60,
      padding: EdgeInsets.only(left: 50, right: 50, bottom: 20),
      child: Row(
        children: <Widget>[
          Flexible(
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
                    if (widget.player.isSelcted) {
                    } else {}
                    if (!isDisabled) {
                      context.bloc<TeamSelectionBloc>().setPlaySelect(widget.player.pid, context,
                          context.bloc<SportsDataBloc>().getTournamentData(widget.matchDataForApp.tournamentName).maxPlayerFromSingleTeam
                      );
                      Navigator.pop(context);
                    } else {
                      bool isatlest = false;
                      bool isMinimum = false;
                      if (isValidMini != null && !widget.player.isSelcted) {
                        if (isValidMini !=
                            context.bloc<TeamSelectionBloc>()
                                .getTypeTextEnum(widget.player.playingRole)) {
                          if (!isValidMiniMach(
                              context.bloc<TeamSelectionBloc>()
                                  .getTypeTextEnum(widget.player.playingRole),
                              context.bloc<TeamSelectionBloc>()
                                  .validMinErrorRequirementList(
                                  context.bloc<SportsDataBloc>().getTournamentData(widget.matchDataForApp.tournamentName).playersCount,
                                  context.bloc<SportsDataBloc>().getTournamentSkills(widget.matchDataForApp.sportsName, widget.matchDataForApp.tournamentName)
                              ))) {
                            isatlest = true;
                          }
                        }
                      }
                      if (isValid && !widget.player.isSelcted) {
                        isMinimum = true;
                      }
                      if (isatlest && isMinimum) {
                        context.bloc<TeamTapBloc>().setType(AnimationType.atLeast);
                      } else {
                        if (isValidMini != null && !widget.player.isSelcted) {
                          context.bloc<TeamTapBloc>().setType(AnimationType.atLeast);
                        }
                        if (isValid && !widget.player.isSelcted) {
                          context.bloc<TeamTapBloc>().setType(AnimationType.isMinimum);
                        }
                      }
                      if (is7Player == 7 && !widget.player.isSelcted) {
                        context.bloc<TeamTapBloc>().setType(AnimationType.isSeven);
                      }
                      if ((100.0 - validCredites) <
                              widget.player.fantasyPlayerRating &&
                          !widget.player.isSelcted) {
                        context.bloc<TeamTapBloc>().setType(AnimationType.isCredits);
                      }
                      if (is11Player == 11 && !widget.player.isSelcted) {
                        context.bloc<TeamTapBloc>().setType(AnimationType.isFull);
                      }
                      final text = getValideTxt(
                          widget.player.playingRole);
                      showInSnackBar(text);
                    }
                  },
                  child: Center(
                    child: Text(
                      widget.player.isSelcted
                          ? 'REMOVE FROME MY TEAM'
                          : 'ADD TO MY TEAM',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AllCoustomTheme.getThemeData().primaryColor,
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
    );
  }

//  TabTextType getTypeTextEnum(String tabText) {
//    return tabText.toLowerCase() == "WK".toLowerCase()
//        ? TabTextType.wk
//        : tabText.toLowerCase() == "BAT".toLowerCase()
//            ? TabTextType.bat
//            : tabText.toLowerCase() == "ALL".toLowerCase()
//                ? TabTextType.ar
//                : tabText.toLowerCase() == "BOWL".toLowerCase()
//                    ? TabTextType.bowl
//                    : null;
//  }

  String getValideTxt(String type) {
    var animationType = context.bloc<TeamTapBloc>().animationType;
    var txt = '';
    HashMap<String, Skill> skillMap = context.bloc<SportsDataBloc>().getTournamentSkills(widget.matchDataForApp.sportsName, widget.matchDataForApp.tournamentName);
    if (animationType == AnimationType.isRegular) {
//      skillMap.keys.map((e) {
        if(skillMap[type].min==skillMap[type].max)
          {
            txt = 'Pick ${skillMap[type].min.toString()} ${skillMap[type].skillName}';
          }
        else
          {
            txt = 'Pick ${skillMap[type].min.toString()} - ${skillMap[type].max.toString()} ${skillMap[type].skillName}';
          }

//      });
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
      txt = 'You can pick only ${skillMap[type].max.toString()} ${skillMap[type].skillName}.';

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

      txt = '${context.bloc<SportsDataBloc>().getTournamentData(widget.matchDataForApp.tournamentName).playersCount.toString()} players selected, tap continue.';
//      txt = '11 players selected, tap continue.';
    } else if (animationType == AnimationType.isSeven) {
      txt = 'You can pick only ${context.bloc<SportsDataBloc>().getTournamentData(widget.matchDataForApp.tournamentName).maxPlayerFromSingleTeam.toString()} from each team.';
//      txt = 'You can pick only 7 from each team.';
    } else if (animationType == AnimationType.isCredits) {
      txt = 'Not enough creadits to pick this player.';
    } else if (animationType == AnimationType.atLeast) {
      final isValidMini = context.bloc<TeamSelectionBloc>().validMinErrorRequirement(
          context.bloc<SportsDataBloc>().getTournamentData(widget.matchDataForApp.tournamentName).playersCount,
          skillMap);
      if (isValidMini != null) {
        txt = 'You must pick at least ${skillMap[type].min.toString()} ${skillMap[type].skillName}.';

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
  final PlayerData playerMachImfoList;

  const PlayerslistUI({Key key, this.playerMachImfoList}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: AllCoustomTheme.getThemeData().backgroundColor,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: Row(
                            children: <Widget>[
                              Container(
                                height: 22,
                                width: 22,
                                child: CachedNetworkImage(
                                  imageUrl:
                                      '${playerMachImfoList.teamLogo.a.logoUrl}',
                                  placeholder: (context, url) => Center(
                                    child: Container(
                                      padding: EdgeInsets.all(12),
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.0,
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      new Icon(Icons.error),
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Text(
                                '  ${playerMachImfoList.teamLogo.a.name}  vs ${playerMachImfoList.teamLogo.b.name}  ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AllCoustomTheme
                                      .getBlackAndWhiteThemeColors(),
                                  fontSize: ConstanceData.SIZE_TITLE12,
                                ),
                              ),
                              Container(
                                height: 22,
                                width: 22,
                                child: CachedNetworkImage(
                                  imageUrl:
                                      '${playerMachImfoList.teamLogo.b.logoUrl}',
                                  placeholder: (context, url) => Center(
                                    child: Container(
                                      padding: EdgeInsets.all(12),
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.0,
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      new Icon(Icons.error),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(
                            '${playerMachImfoList.playedDate}',
                            style: TextStyle(
                              color: AllCoustomTheme.getTextThemeColors(),
                              fontSize: ConstanceData.SIZE_TITLE10,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 16),
                  child: Center(
                    child: Text(
                      '${playerMachImfoList.playerPoint}',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: AllCoustomTheme.getTextThemeColors(),
                        fontSize: ConstanceData.SIZE_TITLE12,
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
    );
  }
}
