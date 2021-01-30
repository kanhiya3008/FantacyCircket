import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:frolicsports/bloc/authBloc.dart';
import 'package:frolicsports/bloc/teamDataBloc.dart';
import 'package:frolicsports/models/sportsData.dart';
import 'package:frolicsports/models/sportsDataForApp.dart';
import 'package:frolicsports/models/teamModel.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:frolicsports/api/apiProvider.dart';
import 'package:frolicsports/constance/constance.dart';
import 'package:frolicsports/constance/themes.dart';
import 'package:frolicsports/models/scheduleResponseData.dart';
import 'package:frolicsports/models/squadsResponseData.dart';
import 'package:frolicsports/models/teamResponseData.dart' as teamData;
import 'package:frolicsports/models/teamResponseData.dart';
import 'package:frolicsports/modules/contests/contestsScreen.dart';
import 'package:frolicsports/modules/createTeam/createTeamScreen.dart';
import 'package:frolicsports/modules/createTeam/teamPreview.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:frolicsports/utils/avatarImage.dart';

class MyTeamsScreen extends StatefulWidget {
  final MatchDataForApp matchDataForApp;

  const MyTeamsScreen(
      {Key key,
        this.matchDataForApp
      })
      : super(key: key);

  @override
  _MyTeamsScreenState createState() => _MyTeamsScreenState();
}

class _MyTeamsScreenState extends State<MyTeamsScreen> {
//  List<teamData.TeamData> teamList = List<teamData.TeamData>();
  TeamDetailsMap teamDetailsMap = TeamDetailsMap();
  bool isProsses = false;

  @override
  void initState() {

    getTeamList();
    super.initState();
  }

  Future getTeamList() async {
    setState(() {
      teamDetailsMap=null;
      isProsses = true;
    });
//    var team = GetTeamResponseData.fromJson(jsonDecode(
//        '{"team_data":[{"team_id":"293","team_name":"Oliver Smith(T1)","captun":"Andile Phehlukwayo","wise_captun":"Faf du Plessis","wicket_keeper":"Quinton de Kock","bowler":"Imran Tahir,Jasprit Bumrah,Tabraiz Shamsi","bastman":"Faf du Plessis,Rohit Sharma,Virat Kohli,Hashim Amla","all_rounder":"Hardik Pandya,Jean-Paul Duminy,Andile Phehlukwayo","user_id":"5","created_time":"2019-08-02 01:17:00","updated_time":"0000-00-00 00:00:00","is_delete":"0","match_key":"38529","competition_id":"111320"},{"team_id":"293","team_name":"Oliver Smith(T1)","captun":"Andile Phehlukwayo","wise_captun":"Faf du Plessis","wicket_keeper":"Quinton de Kock","bowler":"Imran Tahir,Jasprit Bumrah,Tabraiz Shamsi","bastman":"Faf du Plessis,Rohit Sharma,Virat Kohli,Hashim Amla","all_rounder":"Hardik Pandya,Jean-Paul Duminy,Andile Phehlukwayo","user_id":"5","created_time":"2019-08-02 01:17:00","updated_time":"0000-00-00 00:00:00","is_delete":"0","match_key":"38529","competition_id":"111320"}],"success":1,"message":"Team data get successfully"}'));
//    teamList = team.teamData;

    setState(() {
      teamDetailsMap = context.bloc<TeamDataBloc>().state.teamDetailsMap;
      isProsses = false;
    });
//    print(context.bloc<TeamDataBloc>().getTeamDetailsMap().teamDetails.length);
//    print(context.bloc<TeamDataBloc>().getTeamDetailsMap().teamDetails.length);
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
              body: ModalProgressHUD(
                inAsyncCall: isProsses,
                color: Colors.transparent,
                progressIndicator: CircularProgressIndicator(
                  strokeWidth: 2.0,
                ),
                child: Stack(
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
                                          'My Teams',
                                          style: TextStyle(
                                            fontSize:
                                                ConstanceData.SIZE_TITLE22,
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
                              MatchHadder(matchDataForApp: widget.matchDataForApp)
                            ],
                          ),
                        ),
                        Flexible(
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: contestsListData(context),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
//                    Container(
//                      height: 60,
//                      padding: EdgeInsets.only(left: 50, right: 50, bottom: 20),
//                      child: Opacity(
//                        opacity: teamDetailsMap == null ? 0.2 : 1.0,
//                        child: Container(
//                          decoration: new BoxDecoration(
//                            color: AllCoustomTheme.getThemeData().primaryColor,
//                            borderRadius: new BorderRadius.circular(4.0),
//                            boxShadow: <BoxShadow>[
//                              BoxShadow(
//                                  color: Colors.black.withOpacity(0.5),
//                                  offset: Offset(0, 1),
//                                  blurRadius: 5.0),
//                            ],
//                          ),
//                          child: Material(
//                            color: Colors.transparent,
//                            child: InkWell(
//                              borderRadius: new BorderRadius.circular(4.0),
//                              onTap: () async {
//                                await Navigator.push(
//                                  context,
//                                  MaterialPageRoute(
//                                    builder: (context) => CreateTeamScreen(
//                                        matchDataForApp: widget.matchDataForApp,
//                                        //shedualData: widget.shedualData,
//                                        ),
//                                    fullscreenDialog: true,
//                                  ),
//                                );
//                                setState(() {
//                                  getTeamList();
//                                });
//                              },
//                              child: Center(
//                                child: Text(
//                                  'CREATE TEAM',
//                                  style: TextStyle(
//                                    fontWeight: FontWeight.bold,
//                                    color: Colors.white,
//                                    fontSize: ConstanceData.SIZE_TITLE12,
//                                  ),
//                                ),
//                              ),
//                            ),
//                          ),
//                        ),
//                      ),
//                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget contestsListData(BuildContext context) {
//    print(teamList.length);

//  List<TeamDetails> teamDetailsList = List<TeamDetails>();
//    teamDetailsMap.teamDetails.values.forEach((v) => teamDetailsList.add(v));


    return ListView.builder(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.only(bottom: 80),
      itemCount: teamDetailsMap.teamDetails.length,
      itemBuilder: (context, index) {


//        TeamDetails teamDetails = TeamDetails(
//          vcId: teamDetailsMap.teamDetails[index]['vcId'],
//          vcName: teamDetailsMap.teamDetails[index]['vcName'],
//          vcImage : teamDetailsMap.teamDetails[index]['vcImage'],
//          cId: teamDetailsMap.teamDetails[index]['cId'],
//          cName: teamDetailsMap.teamDetails[index]['cName'],
//          cImage: teamDetailsMap.teamDetails[index]['cImage'],
//          createdTime: teamDetailsMap.teamDetails[index]['createdTime'],
//          userId: teamDetailsMap.teamDetails[index]['userId'],
//          teamPlayers: teamDetailsMap.teamDetails[index]['teamPlayers'],
//          teamAName: teamDetailsMap.teamDetails[index]['teamAName'],
//          teamACount: teamDetailsMap.teamDetails[index]['teamACount'],
//          teamBName: teamDetailsMap.teamDetails[index]['teamBName'],
//          teamBCount: teamDetailsMap.teamDetails[index]['teamBCount'],
//          teamName: teamDetailsMap.teamDetails[index]['team_name']
//        );
        return CreatedTeamListView(
            index: index,
            team: teamDetailsMap.teamDetails[index],
            copyCallBack: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateTeamScreen(
                    createdTeamData: teamDetailsMap.teamDetails[index],
                    createTeamtype: CreateTeamType.copyTeam,
                    matchDataForApp: widget.matchDataForApp,
                  ),
                  fullscreenDialog: true,
                ),
              );
              setState(() {
                getTeamList();
              });
            },
            editCallBack: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateTeamScreen(
                    createdTeamData: teamDetailsMap.teamDetails[index],
                    createTeamtype: CreateTeamType.editTeam,
                    matchDataForApp: widget.matchDataForApp,
                  ),
                  fullscreenDialog: true,
                ),
              );
              setState(() {
                getTeamList();
              });
            },
            shareCallBack: () {},
            allViewClick: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TeamPreviewScreen(
                    createdTeamData: teamDetailsMap.teamDetails[index],
                    createTeamPreviewType: CreateTeamPreviewType.created,
                    matchDataForApp: widget.matchDataForApp,
                    editCallback: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateTeamScreen(
                            createdTeamData: teamDetailsMap.teamDetails[index],
                            createTeamtype: CreateTeamType.editTeam,
                            matchDataForApp: widget.matchDataForApp,
                          ),
                          fullscreenDialog: true,
                        ),
                      );
                      setState(() {
                        getTeamList();
                      });
                    },
                    shreCallback: () {},
                  ),
                  fullscreenDialog: true,
                ),
              );
            });
      },
    );
  }
}

class CreatedTeamListView extends StatefulWidget {
  final VoidCallback copyCallBack;
  final VoidCallback editCallBack;
  final VoidCallback shareCallBack;
  final VoidCallback allViewClick;

  final TeamDetails team;
  final int index;
  final ShedualData shedualData;
  const CreatedTeamListView({
    Key key,
    this.team,
    this.index,
    this.shedualData,
    this.copyCallBack,
    this.editCallBack,
    this.shareCallBack,
    this.allViewClick,
  }) : super(key: key);
  @override
  _CreatedTeamListViewState createState() => _CreatedTeamListViewState();
}

class SkillScore{
  String skillName;
  int count;
  SkillScore({this.skillName,this.count});
}

class _CreatedTeamListViewState extends State<CreatedTeamListView> {
//  var wkcount = 0;
//  var batcount = 0;
//  var allcount = 0;
//  var bowlcount = 0;
//  var teamAName ='';
//  var teamBName = '';
//  var teamACount = 0;
//  var teamBCount = 0;


  List<SkillScore> skillScore = List<SkillScore>();
  List<TeamPlayer> teamPlayerList = List<TeamPlayer>();

//  List<Players> players = List<Players>();
//  Players captun;
//  Players wcaptun;

  @override
  void initState() {

    Map<String, int> skillList = Map<String, int>();
    widget.team.teamPlayers.forEach((player) {
//    widget.team.teamPlayers.forEach((player) {
//      TeamPlayer teamPlayer = TeamPlayer(
//        playerId: player['playerId'],
//        skill: player['skill']
//      );
      if (skillList.containsKey(player.skill))
        {
          skillList[player.skill] = skillList[player.skill] + 1;
        }
      else
        {
          skillList[player.skill] = 1;
        }

      teamPlayerList.add(player);
    });

    skillList.forEach((key, value) {
      skillScore.add(SkillScore(skillName: key, count: value));
    });

//    players.forEach((p) {
//      if (p.title == widget.team.captun) {
//        captun = p;
//        captun.isC = true;
//      }
//      if (p.title == widget.team.wiseCaptun) {
//        wcaptun = p;
//        wcaptun.isVC = true;
//      }
//      if (isMach(p.title)) {
//        if ('SA'.toLowerCase() == p.teamName.toLowerCase()) {
//          teamA += 1;
//        }
//        if ('IND'.toLowerCase() == p.teamName.toLowerCase()) {
//          teamB += 1;
//        }
//      }
//    });

//    batcount = widget.team.bastman.split(',').length;
//    allcount = widget.team.allRounder.split(',').length;
//    bowlcount = widget.team.bowler.split(',').length;

    super.initState();
    getTeamDeatil();
  }

  Future getTeamDeatil() async {
//    SquadsResponseData data = await ApiProvider().getTeamData();
//    if (data.success == 1 && data.playerList.length > 0) {
//      players = data.playerList;


//    }
//    setState(() {});
  }

//  bool isMach(String name) {
//    bool isMach = false;
//    var allplayername = List<String>();
//    allplayername.addAll(widget.team.bastman.split(','));
//    allplayername.addAll(widget.team.allRounder.split(','));
//    allplayername.addAll(widget.team.bowler.split(','));
//    allplayername.add(widget.team.wicketKeeper);
//    allplayername.forEach((pName) {
//      if (pName == name) {
//        isMach = true;
//        return;
//      }
//    });
//    return isMach;
//  }

  @override
  Widget build(BuildContext context) {
    return widget.index == 0 && teamPlayerList.length == 0
        ? Container(
            height: 2,
            child: LinearProgressIndicator(),
          )
        : teamPlayerList.length > 0
            ? InkWell(
                onTap: () {
                  widget.allViewClick();
                },
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 8, right: 8),
                      child: Column(
                        children: <Widget>[
                          headers1(),
                          headers2(),
                          headers3(),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Divider(
                      height: 1,
                    )
                  ],
                ),
              )
            : SizedBox();
  }

  Widget headers1() {
    return Container(
      padding: EdgeInsets.only(left: 8, top: 4),
      child: Row(
        children: <Widget>[
          Container(
            child: Text(
              context
                  .bloc<AuthBloc>()
                  .getCurrentUser()
              .name + ' (' +
                widget.team.teamName
                  + ')'
//              'Oliver Smith(T1)'

              ,
              style: TextStyle(
                fontSize: ConstanceData.SIZE_TITLE16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Container(),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              widget.editCallBack();
            },
            child: Container(
              height: 30,
              width: 30,
              child: Center(
                child: Icon(
                  Icons.edit,
                  size: ConstanceData.SIZE_TITLE16,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              widget.copyCallBack();
            },
            child: Container(
              height: 30,
              width: 30,
              child: Center(
                child: Icon(
                  Icons.content_copy,
                  size: ConstanceData.SIZE_TITLE16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget headers2() {
    return Container(
      padding: EdgeInsets.only(left: 32, right: 16, top: 10),
      child: Row(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Text(
            '${widget.team.teamAName}',
//                  'SA',
                  style: TextStyle(
                    fontSize: ConstanceData.SIZE_TITLE14,
                    color: AllCoustomTheme.getTextThemeColors(),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                    '${widget.team.teamACount}',
//                  '$teamA',
                  style: TextStyle(
                      fontSize: ConstanceData.SIZE_TITLE18,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 16),
            child: Column(
              children: <Widget>[
                Text(
            '${widget.team.teamBName}',
//                  'IND',
                  style: TextStyle(
                    fontSize: ConstanceData.SIZE_TITLE14,
                    color: AllCoustomTheme.getTextThemeColors(),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                    '${widget.team.teamBCount}',
//                  '$teamB',
                  style: TextStyle(
                      fontSize: ConstanceData.SIZE_TITLE18,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(),
          ),
          IgnorePointer(
            ignoring: true,
            child: Container(
              child: widget.team.cId != null ? getPlayerView(widget.team.cName, widget.team.cImage, true, false) : SizedBox(),
            ),
          ),
          Expanded(
            child: Container(),
          ),
          IgnorePointer(
            ignoring: true,
            child: Container(
              padding: EdgeInsets.only(right: 32),
              child: widget.team.vcId != null ? getPlayerView(widget.team.vcName, widget.team.vcImage, false, true) : SizedBox(),
            ),
          ),
        ],
      ),
    );
  }

  Widget headers3() {
    return Container(
      padding: EdgeInsets.only(left: 8, right: 8, top: 10),
      child: Row(
        children:
        <Widget>[
          listskillScore(),
        ],
      ),
    );
  }

  Widget listskillScore()
  {
//    print('skill');
//    print(skillScore.length);
    return Row(
      children:
      skillScore.map(
            (skill) =>
//                Text('hello')
//                Row(
//                  mainAxisSize: MainAxisSize.min,
//                  children: <Widget>[
                    Row(
                      children: [
                        Container(
                          child:
//                      Text('ssss'),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                  skill.skillName + '  ',
//                            'BAT  ',
                                style: TextStyle(
                                    color: AllCoustomTheme.getTextThemeColors(),
                                    fontSize: ConstanceData.SIZE_TITLE14),
                              ),
                                Text('${skill.count}          '),

//                          Text('$batcount'),
                            ],
                          ),
                        ),
//                        Container(
//                          child:
//                          Expanded(
//                            child: Container(),
//                          )
//                          ,
//                        )
                      ],
                    ),

//        Expanded(
//        child: Container(),
//    )
//                  ],
//                )
      )
          .toList(),
    );
  }

  Widget getPlayerView(String name, String img, bool isC, bool isVC) {
//    final firstname = player.firstName;
//    final lastName = player.lastName;

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
              Container(
                width: (MediaQuery.of(context).size.width > 360 ? 45 : 40),
                height: (MediaQuery.of(context).size.width > 360 ? 45 : 40),
                child: AvatarImage(
                  isAssets: true,
                  imageUrl:
//                  'assets/cname/$img',//TODO
                'assets/cname/119.png',
                  radius: (MediaQuery.of(context).size.width > 360 ? 45 : 40),
                  sizeValue:
                      (MediaQuery.of(context).size.width > 360 ? 45 : 40),
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
//                        lastName,
//                    player.shortName,
                  name,
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
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: isC
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
              : isVC
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
