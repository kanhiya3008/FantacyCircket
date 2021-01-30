import 'dart:collection';
import 'dart:core';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frolicsports/models/sportsData.dart';
import 'package:frolicsports/models/sportsDataForApp.dart';
import 'package:frolicsports/utils/config.dart';
import 'package:frolicsports/constance/global.dart' as globals;
import 'package:intl/intl.dart';

class SportsDataBloc extends Bloc<SportsDataBlocEvent, SportsDataBlocState> {
  SportsDataBloc() : super(SportsDataBlocState.initial());


  final _firestore = Firestore.instance;

  HashMap<String, List<MatchDataForApp>> _sportsMap =
      HashMap<String, List<MatchDataForApp>>();
  var _tournamentDataMap = HashMap<String, TournamentData>();
  var _sportsDataFetched=false;

  void deleteMatchfromList(MatchDataForApp matchDataForApp) {
//    List<MatchDataForApp> _matchDataForApp = _sportsMap[matchDataForApp.sportsName];
//
//    int index = _matchDataForApp.indexOf(matchDataForApp);
//    _matchDataForApp.removeAt(index);
//
//    _sportsMap[matchDataForApp.sportsName] = _matchDataForApp;
//    add(SportsDataBlocEvent.setUpdate);

    int index = _sportsMap[matchDataForApp.sportsName].indexOf(matchDataForApp);
    _sportsMap[matchDataForApp.sportsName].removeAt(index);
    add(SportsDataBlocEvent.setUpdate);
  }

  int getSportsList() {
    //  print('datatatata');
    //  print(_sportsMap.keys.length);
    return _sportsMap.keys.length;
  }

  TournamentData getTournamentData(String tournamentName) {
    return _tournamentDataMap[tournamentName];
  }

  @override
  Stream<SportsDataBlocState> mapEventToState(
      SportsDataBlocEvent event) async* {
    switch (event) {
      case SportsDataBlocEvent.setUpdate:
        yield state.copyWith(
            sportsMap: _sportsMap, tournamentDataMap: _tournamentDataMap, sportsDataFetched: _sportsDataFetched);
        break;
    }
  }

  HashMap<String, Skill> getTournamentSkills(sportsName, tournamentName) {
//    print('###########');
//    print(tournamentName);
//    print(state.tournamentDataMap[tournamentName].name);
//    print(state.tournamentDataMap[tournamentName].skillMap.length);
    return state.tournamentDataMap[tournamentName].skillMap;
  }

//  Future<void> getSportsContestFromFirestore(String contestCategory) async {
//    var path = SPORTS_DATA;
//    var documentReference =
//        _firestore.collection(path).document(contestCategory);
//    DocumentSnapshot documentSnapshot;
//    try {
//      documentSnapshot = await documentReference.get(source: Source.cache);
//
//      if (!documentSnapshot.exists) {
//        documentSnapshot = await documentReference.get(source: Source.server);
//        if (!documentSnapshot.exists) {
//          _sportsData = null;
//          return;
//        }
//      }
//      //print("here");
//    } catch (e) {
//      documentSnapshot = await documentReference.get(source: Source.server);
//
//      if (!documentSnapshot.exists) {
//        _sportsData = null;
//        return;
//      }
//    } finally {
//      print(documentSnapshot.data.toString());
//      //Skills
//
//      List<Skill> skillList = List<Skill>();
//      documentSnapshot.data['skills'].forEach((skill) {
//        skillList.add(Skill.fromJson(skill));
//      });
//
//      //Rule
//      List<Rule> ruleList = List<Rule>();
//      documentSnapshot.data['rules'].forEach((rule) {
//        ruleList.add(Rule.fromJson(rule));
//      });
//
//      //SpecialRule
//      List<SpecialRule> specialRuleList = List<SpecialRule>();
//      documentSnapshot.data['specialRules'].forEach((specialRule) {
//        specialRuleList.add(SpecialRule.fromJson(specialRule));
//      });
//
//      //Team
//      List<Team> teamList = List<Team>();
//      documentSnapshot.data['teams'].forEach((team) {
//        teamList.add(Team.fromJson(team));
//      });
//
//      //Match
//      List<MatchData> matchList = List<MatchData>();
//      documentSnapshot.data['matches'].forEach((match) {
//        matchList.add(MatchData.fromJson(match));
//      });
//
//      //players
//      List<PlayerDetails> playerList = List<PlayerDetails>();
//      documentSnapshot.data['players'].forEach((player) {
//        playerList.add(PlayerDetails.fromJson(player));
//      });
//
//      SportsData sportsData = SportsData(
//        sportsName: documentSnapshot.data['sportsName'],
//        type: documentSnapshot.data['sportsName'],
//        matchData: matchList,
//        playerDetails: playerList,
//        rule: ruleList,
//        skill: skillList,
//        specialRule: specialRuleList,
//        team: teamList,
//      );
//
//      print(sportsData.sportsName);
//      _sportsData = sportsData;
//      print(_sportsData.sportsName);
//      globals.sportsData = _sportsData;
//
//      globals.matchDataForAppList
//          .addAll(_convertMatchToApp(matchList, teamList));
//
//      add(SportsDataBlocEvent.setUpdate);
//    }
//  }

  Future<void> getSportsDataFromFirestore() async {
    var path = SPORTS_DATA;
    var sportsRef;
    try {
      sportsRef =
          await _firestore.collection(path).getDocuments(source: Source.server);
      if (sportsRef.documents.length == 0) {
        sportsRef = await _firestore
            .collection(path)
            .getDocuments(source: Source.server);
      }
    } catch (e) {
      sportsRef =
          await _firestore.collection(path).getDocuments(source: Source.server);
    } finally {
      if (sportsRef == null) {
        return;
      }

      if (sportsRef.documents.length > 0) {
        sportsRef.documents.forEach((element) async {
          var tournamentRef;
          try {
            tournamentRef = await _firestore
                .collection(path)
                .document(element.documentID.toString())
                .collection(TOURNAMENTS_DATA)
                .getDocuments(source: Source.server);

            if (tournamentRef.documents.length == 0) {
              tournamentRef = await _firestore
                  .collection(path)
                  .document(element.documentID.toString())
                  .collection(TOURNAMENTS_DATA)
                  .getDocuments(source: Source.server);
            }
          } catch (e) {
            tournamentRef = await _firestore
                .collection(path)
                .document(element.documentID.toString())
                .collection(TOURNAMENTS_DATA)
                .getDocuments(source: Source.server);
          } finally {
            if (tournamentRef.documents.length == 0) {
              return;
            }

            List<MatchDataForApp> matchDataForApp = List<MatchDataForApp>();
            if (tournamentRef.documents.length > 0) {
              tournamentRef.documents.forEach((tournamentElement) async {
                HashMap<String, Skill> skillMap = HashMap<String, Skill>();
                tournamentElement.data['skills'].forEach((skill) {
                  skillMap[skill['short']] = Skill.fromJson(skill);
                });
//                print('skillllll');
//                print(skillMap.length);

                //Rule
                HashMap<int, Rule> ruleMap = HashMap<int, Rule>();
                tournamentElement.data['rules'].forEach((rule) {
                  ruleMap[rule['id']] = Rule.fromJson(rule);
                });

                //SpecialRule
                HashMap<String, SpecialRule> specialRuleMap =
                    HashMap<String, SpecialRule>();
                tournamentElement.data['specialrules'].forEach((specialRule) {
                  specialRuleMap[specialRule['short']] =
                      SpecialRule.fromJson(specialRule);
                });

                //Team
                HashMap<int, Team> teamMap = HashMap<int, Team>();
                tournamentElement.data['teams'].forEach((team) {
                  HashMap<int, PlayerDetails> playersDetailsMap =
                      HashMap<int, PlayerDetails>();
                  if (team["plrs"] != null) {
                    //TODO remove when we have data
                    if (team["plrs"].length > 0) {
                      //TODO
//                      print(team["plrs"].toString());
//                      print(team["plrs"].length);
                      for (var i = 0; i < team["plrs"].length; i++) {
//                          print(team["plrs"][i]['pShort'].toString());
                        PlayerDetails player = PlayerDetails(
                            playerId: team["plrs"][i]["id"],
                            shortName: team["plrs"][i]["pShort"],
                            name: team["plrs"][i]["name"],
                            country: team["plrs"][i]["cnty"],
                            credits: team["plrs"][i]["cr"],
                            isPlaying: team["plrs"][i]["isP"],
                            points: team["plrs"][i]["pt"],
                            skills: team["plrs"][i]["pSkill"],
                            pictures: team["plrs"][i]['img'],
                            teamShortName: team["short"]);

                        playersDetailsMap[team["plrs"][i]['id']] = player;
                      }
//                      team["plrs"].forEach((player) {
//                        print('hello########');
//
//
//                        //playersDetailsMap[player["id"]] =
//                            //PlayerDetails.fromJson(player);
//
//                      });
                    }
                  }
                  Team tm = Team(
                      logo: team["logo"],
                      name: team["name"],
                      shortName: team["short"],
                      teamId: team["id"],
                      playerMap: playersDetailsMap);
                  teamMap[team['id']] = tm;
                });

                //Match

                HashMap<int, MatchData> matchMap = HashMap<int, MatchData>();
                tournamentElement.data['matches'].forEach((match) {
                  MatchData matchData = MatchData(
                      firstTeamId: match['tId1'],
                      secondTeamId: match['tId2'],
                      matchUniqueId: match['id'],
                      startTime: match['tm'],
                      startDate: match['dt'].toDate().toString());

                  matchMap[match['id']] = matchData;
                });
//                print('###############');
                matchMap.values.forEach((element) {
                  print(element.startDate);
                });

//                print('SruleMap');
//                print(specialRuleMap.length);
//                specialRuleMap.keys.forEach((element) {
//                  print(element);
//                });
                TournamentData tournamentData = TournamentData(
                  playersCount: tournamentElement.data['plr'],
                  totalPoints: tournamentElement.data['pts'],
                  playerImageFolder: tournamentElement.data['playerFolder'],
                  teamImageFolder: tournamentElement.data['teamImageFolder'],
                  id: tournamentElement.data['id'],
                  deadlineSeconds: tournamentElement.data['deadlineSeconds'],
                  maxPlayerFromSingleTeam: tournamentElement.data['maxPlr'],
                  name: tournamentElement.data['name'],
                  matchDataMap: matchMap,
                  ruleMap: ruleMap,
                  skillMap: skillMap,
                  specialRuleMap: specialRuleMap,
                  teamMap: teamMap,
                );

//                print('tournament1111');
//                print(tournamentElement.data['name']);
//                print(tournamentData.toString());
//                print(tournamentData.skillMap.length);
                _tournamentDataMap[tournamentElement.data['name']] =
                    tournamentData;

//                print('sportssss');
//                print(element.documentID);
                matchDataForApp.addAll(
                    _convertMatchToApp(tournamentData, element.documentID));
              });
            }

//            print(matchDataForApp.length);

            _sportsMap[element.documentID] = matchDataForApp;

//            print(_sportsMap.length);
            _sportsDataFetched = true;
            add(SportsDataBlocEvent.setUpdate);
          }
        });
      } else {
        //TODO
        //as no data available for sports
        print('no data found');
        return;
      }
    }
  }

//  Future<void> getSportsDataFromFirestore1(String sportsName) async {
//    var path = SPORTS_DATA;
//    var documentReference = _firestore.collection(path).document(sportsName);
//    DocumentSnapshot documentSnapshot;
//    try {
//      documentSnapshot = await documentReference.get(source: Source.cache);
//
//      if (!documentSnapshot.exists) {
//        documentSnapshot = await documentReference.get(source: Source.server);
//        if (!documentSnapshot.exists) {
//          _sportsData = null;
//          return;
//        }
//      }
//      //print("here");
//    } catch (e) {
//      documentSnapshot = await documentReference.get(source: Source.server);
//
//      if (!documentSnapshot.exists) {
//        _sportsData = null;
//        return;
//      }
//    } finally {
//      //print('here finally');
//      //Skills
//      List<Skill> skillList = List<Skill>();
//      documentSnapshot.data['skills'].forEach((skill) {
//        skillList.add(Skill.fromJson(skill));
//      });
//
//      //Rule
//      List<Rule> ruleList = List<Rule>();
//      documentSnapshot.data['rules'].forEach((rule) {
//        ruleList.add(Rule.fromJson(rule));
//      });
//
//      //SpecialRule
//      List<SpecialRule> specialRuleList = List<SpecialRule>();
//      documentSnapshot.data['specialRules'].forEach((specialRule) {
//        specialRuleList.add(SpecialRule.fromJson(specialRule));
//      });
//
//      //Team
//      List<Team> teamList = List<Team>();
//      documentSnapshot.data['teams'].forEach((team) {
//        teamList.add(Team.fromJson(team));
//      });
//
//      //Match
//      List<MatchData> matchList = List<MatchData>();
//      documentSnapshot.data['matches'].forEach((match) {
//        matchList.add(MatchData.fromJson(match));
//      });
//
//      //players
//      List<PlayerDetails> playerList = List<PlayerDetails>();
//      documentSnapshot.data['players'].forEach((player) {
//        playerList.add(PlayerDetails.fromJson(player));
//      });
//
//      SportsData sportsData = SportsData(
//        sportsName: documentSnapshot.data['sportsName'],
//        type: documentSnapshot.data['sportsName'],
//        matchData: matchList,
//        playerDetails: playerList,
//        rule: ruleList,
//        skill: skillList,
//        specialRule: specialRuleList,
//        team: teamList,
//      );
//
//      print(sportsData.sportsName);
//      _sportsData = sportsData;
//      print(_sportsData.sportsName);
//      globals.sportsData = _sportsData;
//
//      globals.matchDataForAppList
//          .addAll(_convertMatchToApp(matchList, teamList));
//
//      add(SportsDataBlocEvent.setUpdate);
//    }
//  }

  List<MatchDataForApp> _convertMatchToApp(
      TournamentData tournamentData, String sportsName) {
    List<MatchDataForApp> matchDataForAppList = List<MatchDataForApp>();

    tournamentData.matchDataMap.values.forEach((matchData) {
      MatchDataForApp matchDataForApp = MatchDataForApp();
      matchDataForApp.sportsName = sportsName;
      matchDataForApp.firstTeamId = matchData.firstTeamId;
      matchDataForApp.matchUniqueId = matchData.matchUniqueId;
      matchDataForApp.secondTeamId = matchData.secondTeamId;
      matchDataForApp.startDate = matchData.startDate;
      matchDataForApp.startTime = matchData.startTime;

      DateTime tempDate = new DateFormat("yyyy-MM-dd hh:mm:ss")
          .parse(matchData.startDate + ' ' + matchData.startTime);

      var newDate =
          tempDate.add(new Duration(days: 22)).add(new Duration(minutes: 167));

//      print(matchDataForApp.matchUniqueId.toString() +
//          " :  " +
//          newDate.toString());
//      print(matchDataForApp.matchUniqueId.toString() +
//          " :  " +
//          newDate.toString());
      matchDataForApp.deadlineTime =
          (newDate.millisecondsSinceEpoch + 1000 * 60) -
              tournamentData.deadlineSeconds;
//      print(matchDataForApp.matchUniqueId.toString() +
//          " :  " +
//          matchDataForApp.deadlineTime.toString());
      matchDataForApp.tournamentId = tournamentData.id;
      matchDataForApp.tournamentName = tournamentData.name;

      matchDataForApp.firstTeamShortName =
          tournamentData.teamMap[matchData.firstTeamId].shortName;
      matchDataForApp.firstTeamLogo =
          tournamentData.teamMap[matchData.firstTeamId].logo;

      matchDataForApp.secondTeamShortName =
          tournamentData.teamMap[matchData.secondTeamId].shortName;
      ;
      matchDataForApp.secondTeamLogo =
          tournamentData.teamMap[matchData.secondTeamId].shortName;
      ;
      matchDataForAppList.add(matchDataForApp);
    });
    return matchDataForAppList;
  }
}

enum SportsDataBlocEvent { setUpdate }

class SportsDataBlocState {
  HashMap<String, List<MatchDataForApp>> sportsMap =
      HashMap<String, List<MatchDataForApp>>();
  var tournamentDataMap = HashMap<String, TournamentData>();
  bool sportsDataFetched = false;

  SportsDataBlocState({this.sportsMap, this.tournamentDataMap, this.sportsDataFetched});

  factory SportsDataBlocState.initial() {
    return SportsDataBlocState(sportsDataFetched: false,
    sportsMap: HashMap<String, List<MatchDataForApp>>(),
    tournamentDataMap: HashMap<String, TournamentData>());
  }

  SportsDataBlocState copyWith(
      {HashMap<String, List<MatchDataForApp>> sportsMap,
      HashMap<String, TournamentData> tournamentDataMap,
      bool sportsDataFetched}) {
    return SportsDataBlocState(
        sportsMap: sportsMap ?? this.sportsMap,
        tournamentDataMap: tournamentDataMap ?? this.tournamentDataMap,
        sportsDataFetched: sportsDataFetched ?? this.sportsDataFetched);
  }
}
