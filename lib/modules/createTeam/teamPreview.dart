import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frolicsports/bloc/sportsDataBloc.dart';
import 'package:frolicsports/models/sportsData.dart';
import 'package:frolicsports/models/sportsDataForApp.dart';
import 'package:frolicsports/models/teamModel.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:frolicsports/api/apiProvider.dart';
import 'package:frolicsports/bloc/teamSelectionBloc.dart';
import 'package:frolicsports/bloc/teamTapBloc.dart';
import 'package:frolicsports/constance/constance.dart';
import 'package:frolicsports/constance/themes.dart';
import 'package:frolicsports/models/scheduleResponseData.dart';
import 'package:frolicsports/models/squadsResponseData.dart';
import 'package:frolicsports/modules/createTeam/playerProfile.dart';
import 'package:frolicsports/utils/avatarImage.dart';
import 'package:frolicsports/validator/validator.dart';
import 'package:frolicsports/models/teamResponseData.dart' as team;

import 'createTeamScreen.dart';

enum CreateTeamPreviewType { regular, created }

class TeamPreviewScreen extends StatefulWidget {
  final CreateTeamPreviewType createTeamPreviewType;
  final VoidCallback editCallback;
  final VoidCallback shreCallback;
  final TeamDetails createdTeamData;
  //final ShedualData shedualData;
  final MatchDataForApp matchDataForApp;
  const TeamPreviewScreen(
      {Key key,
      this.createTeamPreviewType = CreateTeamPreviewType.regular,
      this.createdTeamData,
      this.editCallback,
      this.shreCallback,
      this.matchDataForApp})
      : super(key: key);
  @override
  _TeamPreviewScreenState createState() => _TeamPreviewScreenState();
}

class _TeamPreviewScreenState extends State<TeamPreviewScreen> {
  var isProsses = false;
  @override
  void initState() {
//    getSquadTeamData();

    super.initState();
  }

//  void getSquadTeamData() async {
//    if (widget.createTeamPreviewType == CreateTeamPreviewType.created &&
//        widget.createdTeamData != null) {
////      teamSelectionBloc = TeamSelectionBloc();
////      teamTapBloc = TeamTapBloc();
//      setState(() {
//        isProsses = true;
//      });
//      final data = await ApiProvider().getTeamData();
//
//      if (data != null && data.success == 1 && data.playerList.length > 0) {
//        var allPlayerList = data.playerList;
//
//        allPlayerList.forEach((p) {
//          if (p.title.toUpperCase() ==
//              widget.createdTeamData.cName.toUpperCase()) {
//            p.isSelcted = true;
//            p.isC = true;
//          }
//          if (p.title.toUpperCase() ==
//              widget.createdTeamData.vcName.toUpperCase()) {
//            p.isVC = true;
//            p.isSelcted = true;
//          }
//          if (isMach(p.pid)) {
//            p.isSelcted = true;
//          }
//        });
////        print('hahahahaha');
////        print(context.bloc<SportsDataBloc>().getTournamentData(widget.matchDataForApp.tournamentName).skillMap.length);
//        context.bloc<TeamSelectionBloc>().onListChanges(allPlayerList,
//            context.bloc<SportsDataBloc>().getTournamentData(widget.matchDataForApp.tournamentName).skillMap
//        );
//      }
//      setState(() {
//        isProsses = false;
//      });
//    }
//  }

  bool isMach(int id) {
    bool isMach = false;
//    var allplayername = List<String>();
//    allplayername.addAll(widget.createdTeamData.bastman.split(','));
//    allplayername.addAll(widget.createdTeamData.allRounder.split(','));
//    allplayername.addAll(widget.createdTeamData.bowler.split(','));
//    allplayername.add(widget.createdTeamData.wicketKeeper);
//    allplayername.forEach((pName) {
//      if (pName == name) {
//        isMach = true;
//        return;
//      }
//    });
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
      color: HexColor('#0BA70E'),
      child: Stack(
        children: <Widget>[
          SafeArea(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: ModalProgressHUD(
                inAsyncCall: isProsses,
                color: Colors.transparent,
                progressIndicator: CircularProgressIndicator(
                  strokeWidth: 2.0,
                ),
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    Opacity(
                      opacity: 0.4,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Image.asset(
                          ConstanceData.cricketGround,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    BlocBuilder<TeamSelectionBloc, TeamSelectionBlocState>(
//                      bloc: teamSelectionBloc,
                      builder: (context, state) {

                        var selectedPlayerList = List<Players>();

                        if(widget.createTeamPreviewType == CreateTeamPreviewType.created)
                          {
                            Map<int, Players> playersMap = Map<int, Players>();
                            state.allPlayerList.forEach((player) {
                              player.isC=false;
                              player.isVC = false;

                              playersMap[player.pid] = player;
                            });

                            playersMap.keys.forEach((element) {
//                              print(element.toString());
//                                  print(playersMap[element].toJson());
//                                  print(playersMap[element]);
                            });

                            widget.createdTeamData.teamPlayers.forEach((p) {
//                            widget.createdTeamData.teamPlayers.forEach((p) {
//                              print(p['playerId']);
//
//                              print(playersMap[int.parse(p['playerId'])]);
                              if(int.parse(widget.createdTeamData.cId) == int.parse(p.playerId))
                              {
                                playersMap[int.parse(p.playerId)].isC=true;
                              }
                              if(int.parse(widget.createdTeamData.vcId) == int.parse(p.playerId))
                              {
                                playersMap[int.parse(p.playerId)].isVC=true;
                              }
                              selectedPlayerList.add(playersMap[int.parse(p.playerId)]);
                            });

//                            print(selectedPlayerList.length);
                            selectedPlayerList.forEach((element) {
                             // print(element.playingRole);
//                              print(element);
//                              print(element.toString());
                            });
                          }
                        else
                          {
                            state.allPlayerList.forEach((player) {
                              if (player.isSelcted) {
                                selectedPlayerList.add(player);
                              }
                            });
                          }


                        HashMap<String, Skill> skillMap =  context.bloc<SportsDataBloc>().getTournamentSkills(widget.matchDataForApp.sportsName, widget.matchDataForApp.tournamentName);
                        HashMap<String, List<Players>> skillPlayerList = HashMap<String, List<Players>>();
                        skillMap.keys.forEach((e){
                          skillPlayerList[e.toUpperCase()] = List<Players>();
                        });

//                        var wkList = List<Players>();
//                        var batList = List<Players>();
//                        var arList = List<Players>();
//                        var bowlList = List<Players>();

//                        print('selected length');
//                        print(selectedPlayerList.length);
                        selectedPlayerList.forEach((player) {
                        skillMap.keys.forEach((e){
                          if (player.playingRole.toUpperCase() ==
                              e.toUpperCase()) {
                            skillPlayerList[e.toUpperCase()].add(player);
//                            wkList.add(player);
                          }
                        });

//                        print('length');
//                        print(skillPlayerList.keys.length);
//                        skillPlayerList.keys.forEach((element) {
//print(element.length);
//
//                        });

//                          if (player.playingRole.toLowerCase() ==
//                              context.bloc<TeamSelectionBloc>()
//                                  .getTypeText(TabTextType.wk)
//                                  .toLowerCase()) {
//                            wkList.add(player);
//                          }
//                          if (player.playingRole.toLowerCase() ==
//                              context.bloc<TeamSelectionBloc>()
//                                  .getTypeText(TabTextType.bat)
//                                  .toLowerCase()) {
//                            batList.add(player);
//                          }
//                          if (player.playingRole.toLowerCase() ==
//                              context.bloc<TeamSelectionBloc>()
//                                  .getTypeText(TabTextType.ar)
//                                  .toLowerCase()) {
//                            arList.add(player);
//                          }
//                          if (player.playingRole.toLowerCase() ==
//                              context.bloc<TeamSelectionBloc>()
//                                  .getTypeText(TabTextType.bowl)
//                                  .toLowerCase()) {
//                            bowlList.add(player);
//                          }
                        });
                        skillMap.keys.forEach((e){
                          skillPlayerList[e.toUpperCase()].sort((a, b) => b.fantasyPlayerRating
                              .compareTo(a.fantasyPlayerRating));
                        });

//                        wkList.sort((a, b) => b.fantasyPlayerRating
//                            .compareTo(a.fantasyPlayerRating));
//                        batList.sort((a, b) => b.fantasyPlayerRating
//                            .compareTo(a.fantasyPlayerRating));
//                        arList.sort((a, b) => b.fantasyPlayerRating
//                            .compareTo(a.fantasyPlayerRating));
//                        bowlList.sort((a, b) => b.fantasyPlayerRating
//                            .compareTo(a.fantasyPlayerRating));

                        return Container(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 40, bottom: 40),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children:
//                            <Widget>[
//                              SizedBox(
//                                height: 8,
//                              ),

                            skillMap.keys.map((e) {

//                            print(e.toUpperCase());
                                  return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.only(bottom: 8, top: 8),
                                      child: Text(
                                        e.toUpperCase(),
//                                      'WICKET - KEEPER',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: ConstanceData.SIZE_TITLE12,
                                        ),
                                      ),
                                    ),
                                    getTypeList(skillPlayerList[e.toUpperCase()]),
                                  ],
                                );
                                }).toList(),

//                              Column(
//                                mainAxisSize: MainAxisSize.min,
//                                mainAxisAlignment: MainAxisAlignment.center,
//                                crossAxisAlignment: CrossAxisAlignment.center,
//                                children: <Widget>[
//                                  Container(
//                                    padding: EdgeInsets.only(bottom: 8, top: 4),
//                                    child: Text(
//                                      'WICKET - KEEPER',
//                                      style: TextStyle(
//                                        color: Colors.white,
//                                        fontSize: ConstanceData.SIZE_TITLE12,
//                                      ),
//                                    ),
//                                  ),
//                                  getTypeList(wkList),
//                                ],
//                              ),
//
//                              Column(
//                                mainAxisSize: MainAxisSize.min,
//                                mainAxisAlignment: MainAxisAlignment.center,
//                                crossAxisAlignment: CrossAxisAlignment.center,
//                                children: <Widget>[
//                                  Container(
//                                    padding: EdgeInsets.only(bottom: 8, top: 4),
//                                    child: Text(
//                                      'BATSMEN',
//                                      style: TextStyle(
//                                        color: Colors.white,
//                                        fontSize: ConstanceData.SIZE_TITLE12,
//                                      ),
//                                    ),
//                                  ),
//                                  getTypeList(batList),
//                                ],
//                              ),
//
//                              Column(
//                                mainAxisSize: MainAxisSize.min,
//                                mainAxisAlignment: MainAxisAlignment.center,
//                                crossAxisAlignment: CrossAxisAlignment.center,
//                                children: <Widget>[
//                                  Container(
//                                    padding: EdgeInsets.only(bottom: 8, top: 4),
//                                    child: Text(
//                                      'ALL-ROUNDERS',
//                                      style: TextStyle(
//                                        color: Colors.white,
//                                        fontSize: ConstanceData.SIZE_TITLE12,
//                                      ),
//                                    ),
//                                  ),
//                                  getTypeList(arList),
//                                ],
//                              ),
//
//                              Column(
//                                mainAxisSize: MainAxisSize.min,
//                                mainAxisAlignment: MainAxisAlignment.center,
//                                crossAxisAlignment: CrossAxisAlignment.center,
//                                children: <Widget>[
//                                  Container(
//                                    padding: EdgeInsets.only(bottom: 8, top: 4),
//                                    child: Text(
//                                      'BOWLERS',
//                                      style: TextStyle(
//                                        color: Colors.white,
//                                        fontSize: ConstanceData.SIZE_TITLE12,
//                                      ),
//                                    ),
//                                  ),
//                                  getTypeList(bowlList),
//                                ],
//                              ),
                              //TODO
//                              SizedBox(
//                                height: 8,
//                              ),
//                              // ),
//                            ],
                            ),
                          ),
                        );
                        // );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Container(
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
                        child: Icon(Icons.close, color: Colors.white),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  widget.createTeamPreviewType == CreateTeamPreviewType.created
                      ? Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              widget.editCallback();
                            },
                            child: Container(
                              width: AppBar().preferredSize.height - 20,
                              height: AppBar().preferredSize.height,
                              child: Icon(Icons.edit, color: Colors.white),
                            ),
                          ),
                        )
                      : SizedBox(),
                  widget.createTeamPreviewType == CreateTeamPreviewType.created
                      ? Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              widget.shreCallback();
                            },
                            child: Container(
                              width: AppBar().preferredSize.height - 20,
                              height: AppBar().preferredSize.height,
                              child: Icon(Icons.share, color: Colors.white),
                            ),
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget getTypeList(List<Players> list) {
//    print('list');
//    print(list.length);
    List<Widget> pList = List<Widget>();
    list.forEach((pdata) {
      pList.add(getPlayerView(pdata));
    });

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: pList,
    );
  }

  Widget getPlayerView(Players player) {
    final firstname = player.firstName;
    final lastName = player.lastName;
//print(player.shortName);
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              left: (MediaQuery.of(context).size.width > 360 ? 8 : 4),
              right: (MediaQuery.of(context).size.width > 360 ? 8 : 4)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlayerProfileScreen(
                        matchDataForApp: widget.matchDataForApp,
                        player: player,
                        isChoose: false,
                      ),
                      fullscreenDialog: true,
                    ),
                  );
                },
                child: Container(
                  width: (MediaQuery.of(context).size.width > 360 ? 45 : 40),
                  height: (MediaQuery.of(context).size.width > 360 ? 45 : 40),
                  child: AvatarImage(
                     isAssets : true,
                                  imageUrl:
//                                      'assets/cname/${player.pid}.png',
                    'assets/cname/119.png',
                    radius: (MediaQuery.of(context).size.width > 360 ? 45 : 40),
                    sizeValue:
                        (MediaQuery.of(context).size.width > 360 ? 45 : 40),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 6, top: 2, bottom: 2, right: 6),
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
                child: Center(
                  child: Text(
//                    (firstname.length > 1
//                            ? player.firstName[0].toUpperCase() + '. '
//                            : '') +
//                        lastName
                    player.shortName
                    ,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: (MediaQuery.of(context).size.width > 360
                          ? ConstanceData.SIZE_TITLE10
                          : 8),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(4),
                child: Center(
                  child: Text(
                    '${player.fantasyPlayerRating}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ConstanceData.SIZE_TITLE10,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: player.isC
              ? Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: new BorderRadius.circular(32.0),
                    border: new Border.all(
                      width: 1.0,
                      color: AllCoustomTheme.getThemeData().primaryColor,
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.only(bottom: 2),
                    child: Center(
                      child: Text(
                        'C',
                        style: TextStyle(
                          color: AllCoustomTheme.getThemeData().primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: ConstanceData.SIZE_TITLE10,
                        ),
                      ),
                    ),
                  ),
                )
              : player.isVC
                  ? Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: new BorderRadius.circular(32.0),
                        border: new Border.all(
                          width: 1.0,
                          color: AllCoustomTheme.getThemeData().primaryColor,
                        ),
                      ),
                      child: Container(
                        padding: EdgeInsets.only(bottom: 4),
                        child: Center(
                          child: Text(
                            'vc',
                            style: TextStyle(
                              color:
                                  AllCoustomTheme.getThemeData().primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
        )
      ],
    );
  }
}
