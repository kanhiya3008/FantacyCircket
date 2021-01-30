import 'dart:collection';
import 'dart:core';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frolicsports/models/sportsData.dart';
import 'package:frolicsports/models/sportsDataForApp.dart';
import 'package:frolicsports/models/teamModel.dart';
import 'package:frolicsports/utils/config.dart';
import 'package:frolicsports/constance/global.dart' as globals;
import 'package:uuid/uuid.dart';

class TeamDataBloc extends Bloc<TeamDataBlocEvent, TeamDataBlocState> {
  TeamDataBloc() : super(TeamDataBlocState());

  final _firestore = Firestore.instance;

  TeamDetailsMap _teamDetailsMap = TeamDetailsMap();
  UserMatchRecord _userMatchRecord = UserMatchRecord();


  @override
  Stream<TeamDataBlocState> mapEventToState(TeamDataBlocEvent event) async* {
    switch (event) {
      case TeamDataBlocEvent.setUpdate:
        yield state.copyWith(teamDetailsMap: _teamDetailsMap);
        break;
    }
  }

  TeamDetailsMap getTeamDetailsMap() {
    return _teamDetailsMap;
  }

  Future<void> getTeamDetailsfromFirestore(String uid,
      String sportsName,
      String tournamentName,
      int matchId,
      int contestId) async {
    var documentReference = _firestore
        .collection(SPORTS_DATA)
        .document(sportsName)
        .collection(TOURNAMENTS_DATA)
        .document(tournamentName)
        .collection(MATCH_DATA)
        .document(matchId.toString())
        .collection(CONTEST_DATA)
        .document(contestId.toString());
    DocumentSnapshot documentSnapshot;
    try {
      List<TeamDetails> teamDetailMap = List<TeamDetails>();
      var teamListRef = await documentReference
          .collection(TEAM_DATA)
          .document(uid)
          .get(source: Source.serverAndCache);

      if (teamListRef.exists) {
        TeamDetails teamDetails;
        teamListRef.data['teamDetails'].forEach((team) async {

          List<TeamPlayer> teamPlayerMap = List<TeamPlayer>();

          team['teamPlayers'].forEach((team) {
            teamPlayerMap.add(TeamPlayer.fromJson(team));
          });



          teamDetails = TeamDetails(
            teamName: team['team_name'],
            teamPlayers: teamPlayerMap,
            userId: team['userId'],
            createdTime: team['createdTime'],
            cId: team['cId'],
            cName: team['cName'],
            cImage: team['cImage'],
            vcId: team['vcId'],
            vcName: team['vcName'],
            vcImage: team['vcImage'],
            teamAName: team['teamAName'],
            teamACount: team['teamACount'],
            teamBName: team['teamBName'],
            teamBCount: team['teamBCount'],
          );
          teamDetailMap.add(teamDetails);
        });
//        print(teamDetails.toJson());
        //teamDetailList.add(teamDetails.toJson());
        _teamDetailsMap.teamDetails = teamDetailMap;
      }
      print('fromfirestore');
      print(teamDetailMap.length);



//      teamDetailList.forEach((element) {
//        print('data');
//        print(element.toString());
//      });

      add(TeamDataBlocEvent.setUpdate);
    } catch (e) {
      print(e);
    }
  }


  Future<void> getUserTeamsfromFirestore(String uid) async {
    var documentReference = _firestore
        .collection(USERS)
        .document(uid)
        .collection(PARTICIPATION)
        .document("1");
    DocumentSnapshot documentSnapshot;
    try {
      List<UserMatch> userMatchRecord = List<UserMatch>();
      var userTeamListRef = await documentReference
          .get(source: Source.serverAndCache);

      if (userTeamListRef.exists) {

        userTeamListRef.data['match'].forEach((team) {
          List<UserContest> userContestList = List<UserContest>();

          team['contest'].forEach((contest) {
            userContestList.add(UserContest.fromJson(contest));
          });

          UserMatch userMatch = UserMatch(
            matchId: team['id'],
            contestList: userContestList
          );
          userMatchRecord.add(userMatch);

        });
        _userMatchRecord.matchList = userMatchRecord;

      }
      print('user Firestore');
      print(userMatchRecord.length);


      add(TeamDataBlocEvent.setUpdate);
    } catch (e) {
      print(e);
    }
  }


  Future<void> saveTeamDetailsToFirestore(TeamDetails teamDetails,
      String sportsName,
      String tournamentName,
      int matchId,
      int contestId) async {
    var documentReference = _firestore
        .collection(SPORTS_DATA)
        .document(sportsName)
        .collection(TOURNAMENTS_DATA)
        .document(tournamentName)
        .collection(MATCH_DATA)
        .document(matchId.toString())
        .collection(CONTEST_DATA)
        .document(contestId.toString());
    DocumentSnapshot documentSnapshot;
    try {
      List<TeamDetails> teamDetailList = List<TeamDetails>();
      List<UserMatch> userMatchList = List<UserMatch>();
      var teamListRef = await documentReference
          .collection(TEAM_DATA)
          .document(teamDetails.userId)
          .get(source: Source.serverAndCache);


      teamDetailList.addAll(_teamDetailsMap.teamDetails);
      print(teamDetailList.length);
      print(teamDetails.toJson());
      teamDetailList.add(teamDetails);
      print(teamDetailList.length);

      _teamDetailsMap.teamDetails = teamDetailList;

//      userMatchList.addAll(_userMatchRecord.matchList);
      //check id match and contest already exists
      bool matchCheck = false;

      UserMatch userMat = UserMatch();
      _userMatchRecord.matchList.forEach((userM) {
        if(matchId == userM.matchId)
          {
            matchCheck = true;
            bool check  = false;
            userM.contestList.forEach((userC) {
              if(contestId == userC.contestId)
                {
                  check = true;
                }
            });
            if(!check)
              {
                UserContest userCont = UserContest(contestId: contestId);
                userMat.contestList.add(userCont);
              }
          }

        userMatchList.add(userM);
        
      });
      if(!matchCheck)
      {
        List<UserContest> userContList = List<UserContest>();
        UserContest userCont = UserContest(contestId: contestId);
        userContList.add(userCont);
        UserMatch userM = UserMatch(contestList: userContList, matchId: matchId);
        userMatchList.add(userM);
      }

      _userMatchRecord.matchList = userMatchList;

      ///////////////
      // fo saving into db
      ////////////

      UserMatchRecord1 userMatchRecord1 = UserMatchRecord1();
      List<Map<String,dynamic>> userMatchList1 = List<Map<String,dynamic>>();
      List<Map<String,dynamic>> contestList1 = List<Map<String,dynamic>>();
      _userMatchRecord.matchList.forEach((match) {
        match.contestList.forEach((contest) {
          contestList1.add(contest.toJson());
        });
        UserMatch1 userMatch1 = UserMatch1(
          matchId: match.matchId,
          contestList: contestList1
        );
        userMatchList1.add(userMatch1.toJson());

      });
      userMatchRecord1.matchList = userMatchList1;



      TeamDetailsMap1 teamDetailsMap = TeamDetailsMap1();
      List<Map<String,dynamic>> teamDetailsList = List<Map<String,dynamic>>();
      List<Map<String,dynamic>> teamPlayers = List<Map<String,dynamic>>();

      teamDetailList.forEach((teamDetail) {
        teamDetail.teamPlayers.forEach((teamPlayer) {
          teamPlayers.add(teamPlayer.toJson());
        });

        TeamDetails1 teamDetails1 = TeamDetails1(
            teamPlayers: teamPlayers,
          teamName: teamDetail.teamName,
          userId: teamDetail.userId,
          createdTime: teamDetail.createdTime,
          cId: teamDetail.cId,
          vcId: teamDetail.vcId,
          cImage: teamDetail.cImage,
          cName: teamDetail.cName,
          teamACount: teamDetail.teamACount,
          teamAName: teamDetail.teamAName,
          teamBCount: teamDetail.teamBCount,
          teamBName: teamDetail.teamBName,
          vcImage: teamDetail.vcImage,
          vcName: teamDetail.vcName
        );
        teamDetailsList.add(teamDetails1.toJson());

      });

      teamDetailsMap.teamDetails= teamDetailsList;

      await documentReference
          .collection(TEAM_DATA)
          .document(teamDetails.userId)
          .setData(userMatchRecord1.toJson(), merge: true);

      
      await _firestore.collection(USERS)
      .document(teamDetails.userId)
      .collection(PARTICIPATION)
      .document("1")
      .setData(teamDetailsMap.toJson(), merge: true);
      
      add(TeamDataBlocEvent.setUpdate);
    } catch (e) {
      print(e);
    }
  }
}

enum TeamDataBlocEvent { setUpdate }

class TeamDataBlocState {

  TeamDetailsMap teamDetailsMap = TeamDetailsMap();

  TeamDataBlocState({this.teamDetailsMap});

  TeamDataBlocState copyWith({TeamDetailsMap teamDetailsMap}) {
    return TeamDataBlocState(
        teamDetailsMap: teamDetailsMap ?? this.teamDetailsMap);
  }
}
