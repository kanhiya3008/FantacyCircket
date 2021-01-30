import 'dart:collection';
import 'dart:core';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:frolicsports/bloc/teamTapBloc.dart';
import 'package:frolicsports/models/sportsData.dart';
import 'package:frolicsports/models/squadsResponseData.dart';
import 'package:frolicsports/modules/createTeam/createTeamScreen.dart';
import 'package:flutter/material.dart';

class TeamSelectionBloc
    extends Bloc<TeamSelectionBlocEvent, TeamSelectionBlocState> {
  TeamSelectionBloc() : super(TeamSelectionBlocState());
  var allPlayerList = List<Players>();
  double allCredits = 100.0;
  bool assending = true;
  String competitionId = '';

  void cleanList() {
    competitionId = '';
    allPlayerList.clear();
    add(TeamSelectionBlocEvent.setUpdate);
  }


  Map<int, Players> getMatchPlayers()
  {
    Map<int, Players> playersMap = Map<int, Players>();
    allPlayerList.forEach((player) {
      playersMap[player.pid] = player;
    });
    return playersMap;
  }

  List<Players> getSelectedPlayers()
  {
    List<Players> selectedPlayers = List<Players>();
    allPlayerList.forEach((player) {
      if(player.isSelcted)
        {
          selectedPlayers.add(player);
        }
    });
    return selectedPlayers;
  }

  void onListChanges(List<Players> allPlayerListData, HashMap<String, Skill> skillMap) {
    //print(allPlayerListData);
    allPlayerList = allPlayerListData;
//    print(allPlayerListData.length);
    allCredits = 100.0;
    assending = false;

    allPlayerList = setAssendingList(assending, skillMap);
    //print('inside onListChange');
//    print(allPlayerList.length);
    add(TeamSelectionBlocEvent.setUpdate);
  }

  void setAssendingAndDesandingList(HashMap<String, Skill> skillMap) {
    assending = !assending;
//    print('playerss########');
//    print(allPlayerList.length);
    allPlayerList = setAssendingList(assending, skillMap);
    add(TeamSelectionBlocEvent.setUpdate);
  }

  List<Players> setAssendingList(bool isAssanding, HashMap<String, Skill> skillMap) {

    HashMap<String, List<Players>> playersWithSkill = HashMap<String, List<Players>>();
    skillMap.keys.forEach((e) {
      print('type');
      print(e.toUpperCase());
      playersWithSkill[e.toUpperCase()] = List<Players>();
    });

//    var wkList = List<Players>();
//    var batList = List<Players>();
//    var arList = List<Players>();
//    var bowlList = List<Players>();
//    print(assending);
    var allPlayesList = List<Players>();
    allPlayerList.forEach((player) {
//      print('players######');
//      print(player.playingRole.toUpperCase());
//      print(player.shortName);
     // playersWithSkill[player.playingRole.toUpperCase()].add(player);
      if(playersWithSkill[player.playingRole.toUpperCase()]==null)
        {
//          print('come here');
//          print(player.playingRole.toUpperCase());
          List<Players> temp = List<Players>();
          temp.add(player);
          playersWithSkill[player.playingRole.toUpperCase()] = temp;
        }
      else
        {

//          print('come here next time');
//          print(player.playingRole.toUpperCase());
          playersWithSkill[player.playingRole.toUpperCase()].add(player);
        }
//      List<Players> temp = playersWithSkill[player.playingRole.toUpperCase()];
//      print(temp);
//      temp.add(player);
//      playersWithSkill[player.playingRole.toUpperCase()] = temp;

//      if (player.playingRole.toLowerCase() ==
//          getTypeText(TabTextType.wk).toLowerCase()) {
//        wkList.add(player);
//      }
//      if (player.playingRole.toLowerCase() ==
//          getTypeText(TabTextType.bat).toLowerCase()) {
//        batList.add(player);
//      }
//      if (player.playingRole.toLowerCase() ==
//          getTypeText(TabTextType.ar).toLowerCase()) {
//        arList.add(player);
//      }
//      if (player.playingRole.toLowerCase() ==
//          getTypeText(TabTextType.bowl).toLowerCase()) {
//        bowlList.add(player);
//      }
    });
//    print('###############################');
//    print(playersWithSkill.length);
//    print(playersWithSkill.keys.length);
//    playersWithSkill.keys.forEach((e) {
//      print(e.toUpperCase());
//      print(playersWithSkill[e.toUpperCase()].length);
//
//    });
    if (isAssanding) {
      playersWithSkill.keys.forEach((e) {
        playersWithSkill[e.toUpperCase()].sort(
                (a, b) => a.fantasyPlayerRating.compareTo(b.fantasyPlayerRating)
        );
      });
//      wkList.sort(
//          (a, b) => a.fantasyPlayerRating.compareTo(b.fantasyPlayerRating));
//      batList.sort(
//          (a, b) => a.fantasyPlayerRating.compareTo(b.fantasyPlayerRating));
//      arList.sort(
//          (a, b) => a.fantasyPlayerRating.compareTo(b.fantasyPlayerRating));
//      bowlList.sort(
//          (a, b) => a.fantasyPlayerRating.compareTo(b.fantasyPlayerRating));
    } else {
      playersWithSkill.keys.forEach((e) {

        playersWithSkill[e.toUpperCase()].sort(
              (a, b) => b.fantasyPlayerRating.compareTo(a.fantasyPlayerRating)
        );
      });
//      wkList.sort(
//          (a, b) => b.fantasyPlayerRating.compareTo(a.fantasyPlayerRating));
//      batList.sort(
//          (a, b) => b.fantasyPlayerRating.compareTo(a.fantasyPlayerRating));
//      arList.sort(
//          (a, b) => b.fantasyPlayerRating.compareTo(a.fantasyPlayerRating));
//      bowlList.sort(
//          (a, b) => b.fantasyPlayerRating.compareTo(a.fantasyPlayerRating));
    }

    playersWithSkill.keys.forEach((e) {
//      print(e.toUpperCase());
//      print(playersWithSkill[e.toUpperCase()].length);
      allPlayesList.addAll(playersWithSkill[e.toUpperCase()]);
    });
//    allPlayesList.addAll(wkList);
//    allPlayesList.addAll(batList);
//    allPlayesList.addAll(arList);
//    allPlayesList.addAll(bowlList);
//    print(allPlayesList.length);
    return allPlayesList;
  }

  List<Players> getTypeList(String tabTextType) {
    var playerList = List<Players>();
//    print('players');
//    print(allPlayerList.length);
    allPlayerList.forEach((player) {
      if (player.playingRole.toUpperCase() ==
          tabTextType.toUpperCase()) {
        playerList.add(player);
      }
    });
    return playerList;
  }

  void setPlaySelect(int pid, BuildContext context, int maxPlayerFromSingleTeam) {
    allPlayerList.forEach((player) {
      if (player.pid == pid) {
        if (!player.isSelcted && (getMax7PlayesCount(player) >= maxPlayerFromSingleTeam)) {
          return;
        } else {
          player.isSelcted = !player.isSelcted;
          context.bloc<TeamTapBloc>().setType(AnimationType.isRegular);
        }
      }
    });
    add(TeamSelectionBlocEvent.setUpdate);
  }

  int getMax7PlayesCount(Players player) {
    var totalCount = 0;
    allPlayerList.forEach((playerData) {
      if (player.teamName.toUpperCase() == playerData.teamName.toUpperCase() &&
          playerData.isSelcted) {
        totalCount += 1;
      }
    });
    return totalCount;
  }

  String getTypeText(String tabTextType) {
    return tabTextType.toUpperCase();
  }

  String getTypeTextEnum(String tabText) {
    return tabText;
  }

  String getFullNameType(String tabText, HashMap<String, Skill> skillMap) {
    return skillMap[tabText].skillName;

//    return tabText.toLowerCase() == "WK".toLowerCase()
//        ? 'Wicket-Keeper'
//        : tabText.toLowerCase() == "BAT".toLowerCase()
//            ? 'Batsmen'
//            : tabText.toLowerCase() == "AR".toLowerCase()
//                ? 'All-Rounders'
//                : tabText.toLowerCase() == "BOWL".toLowerCase()
//                    ? 'Bowlers'
//                    : '';
  }

  List<int> getMinMaxSelectionCount(String tabTextType, HashMap<String, Skill> skillMap) {
    var minMaxSelectionCountList = List<int>();
//    minMaxSelectionCountList = [0, 0];
    minMaxSelectionCountList = [skillMap[tabTextType].min, skillMap[tabTextType].max];

//    if (tabTextType == TabTextType.wk) {
//      minMaxSelectionCountList = [1, 1];
//    } else if (tabTextType == TabTextType.bat) {
//      minMaxSelectionCountList = [3, 5];
//    } else if (tabTextType == TabTextType.ar) {
//      minMaxSelectionCountList = [1, 3];
//    } else if (tabTextType == TabTextType.bowl) {
//      minMaxSelectionCountList = [3, 5];
//    } else {
//      minMaxSelectionCountList = [0, 0];
//    }
    return minMaxSelectionCountList;
  }

  double getTotalSelctedPlayerRating() {
    var totalpoint = 0.0;
    allPlayerList.forEach((player) {
      if (player.isSelcted == true) {
        totalpoint += player.fantasyPlayerRating;
      }
    });
    return totalpoint;
  }

  void setCaptain(int pid) {
    allPlayerList.forEach((player) {
      player.isC = false;
    });
    allPlayerList.forEach((player) {
      if (pid == player.pid) {
        player.isVC = false;
        player.isC = true;
      }
    });
    add(TeamSelectionBlocEvent.setUpdate);
  }

  void setViceCaptain(int pid) {
    allPlayerList.forEach((player) {
      player.isVC = false;
    });
    allPlayerList.forEach((player) {
      if (pid == player.pid) {
        player.isC = false;
        player.isVC = true;
      }
    });
    add(TeamSelectionBlocEvent.setUpdate);
  }

  int getSelectedPlayerCount(String tabTextType) {
    var totalpoint = 0;
    allPlayerList.forEach((player) {
      if (tabTextType == null) {
        if (player.isSelcted == true) {
          totalpoint += 1;
        }
      } else {
        if (player.isSelcted == true &&
            (player.playingRole.toUpperCase() ==
                tabTextType.toUpperCase())) {
          totalpoint += 1;
        }
      }
    });
//    print('totalpoint');
//    print(totalpoint);
    return totalpoint;
  }

  void refreshCAndVC() {
    allPlayerList.forEach((player) {
      if (!player.isSelcted) {
        player.isVC = false;
        player.isC = false;
      }
    });
  }

  int getSelectedTeamPlayerCount(String sortTeamName) {
    var totalpoint = 0;
    allPlayerList.forEach((player) {
      if (player.teamName.toUpperCase() == sortTeamName.toUpperCase()) {
        if (player.isSelcted == true) {
          totalpoint += 1;
        }
      }
    });
    return totalpoint;
  }

  bool isDisabled(int pid, HashMap<String, Skill> skillMap) {
//    print('isdiabled');
    Players playes;
    var selectedPlayes = 0;
    allPlayerList.forEach((player) {
      if (pid == player.pid) {
        playes = player;
      }
    });

    var allTypePlayerList = List<Players>();
    allPlayerList.forEach((player) {
      if (playes.playingRole.toUpperCase() ==
          player.playingRole.toUpperCase()) {
        allTypePlayerList.add(player);
        if (player.isSelcted) {
          selectedPlayes += 1;
        }
      }
    });
    if (getMinMaxSelectionCount(playes.playingRole.toUpperCase(), skillMap)[1] <=
        selectedPlayes) {
      return true;
    } else {
      return false;
    }
  }

  bool validSaveTeamRequirement() {
    bool isC = false;
    bool isVC = false;
    allPlayerList.forEach((player) {
      if (player.isC) {
        isC = true;
      }
      if (player.isVC) {
        isVC = true;
      }
    });
    if (isC && isVC) {
      return true;
    } else {
      return false;
    }
  }

  bool validMinRequirement(HashMap<String, Skill> skillMap) {
//    var wkList = 0;
//    var batList = 0;
//    var arList = 0;
//    var bowlList = 0;

  bool result=true;
    HashMap<String, int> skillCount = HashMap<String, int>();
    skillMap.keys.forEach((e) {
      skillCount[e.toUpperCase()] = 0;
    });

    allPlayerList.forEach((player) {
      if (player.isSelcted) {
        skillCount[player.playingRole.toUpperCase()] += 1;
//        if (player.playingRole.toLowerCase() ==
//            getTypeText(TabTextType.wk).toLowerCase()) {
//          wkList += 1;
//        }
//        if (player.playingRole.toLowerCase() ==
//            getTypeText(TabTextType.bat).toLowerCase()) {
//          batList += 1;
//        }
//        if (player.playingRole.toLowerCase() ==
//            getTypeText(TabTextType.ar).toLowerCase()) {
//          arList += 1;
//        }
//        if (player.playingRole.toLowerCase() ==
//            getTypeText(TabTextType.bowl).toLowerCase()) {
//          bowlList += 1;
//        }
      }
    });

//    skillMap.keys.map((e) {
//      if(getMinMaxSelectionCount(e.toUpperCase(), skillMap)[0] <= skillCount[e.toUpperCase()])
//      {
//
//      }
//    });

    skillMap.keys.forEach((e) {
      if(getMinMaxSelectionCount(e.toUpperCase(), skillMap)[0] > skillCount[e.toUpperCase()])
        {
          result=false;
        }
      });


//    if ((getMinMaxSelectionCount(TabTextType.wk, skillMap)[0] <= wkList) &&
//        (getMinMaxSelectionCount(TabTextType.bat,skillMap)[0] <= batList) &&
//        (getMinMaxSelectionCount(TabTextType.ar,skillMap)[0] <= arList) &&
//        (getMinMaxSelectionCount(TabTextType.bowl,skillMap)[0] <= bowlList)) {
//      return true;
//    } else {
//      return false;
//    }
  return result;
  }

  List<String> validMinErrorRequirementList(int playerCountAllowed , HashMap<String,Skill> skillMap) {
    var typeList = List<String>();
//    var wkList = 0;
//    var batList = 0;
//    var arList = 0;
//    var bowlList = 0;

    HashMap<String, int> skillPLayersMapCount = HashMap<String, int>();
    HashMap<String, int> skillPLayersMapMin = HashMap<String, int>();
    skillMap.keys.forEach((e) {
      skillPLayersMapCount[e.toUpperCase()] = 0;
      skillPLayersMapMin[e.toUpperCase()] = 0;
    });
    allPlayerList.forEach((player) {
      if (player.isSelcted) {
        skillPLayersMapCount[player.playingRole.toUpperCase()] += 1;
//        if (player.playingRole.toLowerCase() ==
//            getTypeText(TabTextType.wk).toLowerCase()) {
//          wkList += 1;
//        }
//        if (player.playingRole.toLowerCase() ==
//            getTypeText(TabTextType.bat).toLowerCase()) {
//          batList += 1;
//        }
//        if (player.playingRole.toLowerCase() ==
//            getTypeText(TabTextType.ar).toLowerCase()) {
//          arList += 1;
//        }
//        if (player.playingRole.toLowerCase() ==
//            getTypeText(TabTextType.bowl).toLowerCase()) {
//          bowlList += 1;
//        }
      }
    });
    if (playerCountAllowed - getSelectedPlayerCount(null) != 0) {
//      var minWk = 0;
//      var minAr = 0;
//      var minBat = 0;
//      var minbowl = 0;

      var totalMin = 0;
      skillMap.keys.map((e) {
        if (getMinMaxSelectionCount(e.toUpperCase(), skillMap)[0] > skillPLayersMapCount[e.toUpperCase()]) {
          skillPLayersMapMin[e.toUpperCase()] += getMinMaxSelectionCount(e.toUpperCase(), skillMap)[0] - skillPLayersMapCount[e.toUpperCase()];
          totalMin += getMinMaxSelectionCount(e.toUpperCase(), skillMap)[0] - skillPLayersMapCount[e.toUpperCase()];
        }
      });

//      if (getMinMaxSelectionCount(TabTextType.ar)[0] > arList) {
//        minAr = getMinMaxSelectionCount(TabTextType.ar)[0] - arList;
//      }
//      if (getMinMaxSelectionCount(TabTextType.bat)[0] > batList) {
//        minBat = getMinMaxSelectionCount(TabTextType.bat)[0] - batList;
//      }
//      if (getMinMaxSelectionCount(TabTextType.bowl)[0] > bowlList) {
//        minbowl = getMinMaxSelectionCount(TabTextType.bowl)[0] - bowlList;
//      }
//      var totalMin = minWk + minAr + minBat + minbowl;
//      print(getSelectedPlayerCount(null));
//      print(totalMin);
//      print((11 - getSelectedPlayerCount(null)));
      if (totalMin > (playerCountAllowed - (getSelectedPlayerCount(null) + 1))) {

//        print('hererere');
        skillMap.keys.map((e) {
          if (skillPLayersMapMin[e.toUpperCase()] !=0)
            {
              typeList.add(e.toUpperCase());
            }
        });
//        if (minWk != 0) {
//          typeList.add(TabTextType.wk);
//        }
//        if (minBat != 0) {
//          typeList.add(TabTextType.bat);
//        }
//        if (minAr != 0) {
//          typeList.add(TabTextType.ar);
//        }
//        if (minbowl != 0) {
//          typeList.add(TabTextType.bowl);
//        }
      } else {
        skillMap.keys.map((e) {
          if (getMinMaxSelectionCount(e.toUpperCase(),skillMap)[0] > skillPLayersMapCount[e.toUpperCase()] &&
              getMinMaxSelectionCount(e.toUpperCase(),skillMap)[0] ==
                  playerCountAllowed - getSelectedPlayerCount(null)) {
            typeList.add(e.toUpperCase());
          }
        });

//        if (getMinMaxSelectionCount(TabTextType.wk)[0] > wkList &&
//            getMinMaxSelectionCount(TabTextType.wk)[0] ==
//                11 - getSelectedPlayerCount(null)) {
//          typeList.add(TabTextType.wk);
//        }
//        if (getMinMaxSelectionCount(TabTextType.ar)[0] > arList &&
//            getMinMaxSelectionCount(TabTextType.ar)[0] ==
//                11 - getSelectedPlayerCount(null)) {
//          typeList.add(TabTextType.ar);
//        }
//        if (getMinMaxSelectionCount(TabTextType.bat)[0] > batList &&
//            getMinMaxSelectionCount(TabTextType.bat)[0] ==
//                11 - getSelectedPlayerCount(null)) {
//          typeList.add(TabTextType.bat);
//        }
//        if (getMinMaxSelectionCount(TabTextType.bowl)[0] > bowlList &&
//            getMinMaxSelectionCount(TabTextType.bowl)[0] ==
//                11 - getSelectedPlayerCount(null)) {
//          typeList.add(TabTextType.bowl);
//        }
      }
    }
    return typeList;
  }

  String validMinErrorRequirement(int playerCountAllowed, HashMap<String, Skill> skillMap) {
//    var wkList = 0;
//    var batList = 0;
//    var arList = 0;
//    var bowlList = 0;
//print('valid min');
    HashMap<String, int> skillMapCount = HashMap<String, int>();
    HashMap<String, int> skillMapMin = HashMap<String, int>();
    skillMap.keys.forEach((e) {
      skillMapCount[e.toUpperCase()] = 0;
      skillMapMin[e.toUpperCase()] = 0;
    });
//print(skillMapCount.length);
    allPlayerList.forEach((player) {
      if (player.isSelcted) {
        skillMapCount[player.playingRole] += 1;
//        if (player.playingRole.toLowerCase() ==
//            getTypeText(TabTextType.wk).toLowerCase()) {
//          wkList += 1;
//        }
//        if (player.playingRole.toLowerCase() ==
//            getTypeText(TabTextType.bat).toLowerCase()) {
//          batList += 1;
//        }
//        if (player.playingRole.toLowerCase() ==
//            getTypeText(TabTextType.ar).toLowerCase()) {
//          arList += 1;
//        }
//        if (player.playingRole.toLowerCase() ==
//            getTypeText(TabTextType.bowl).toLowerCase()) {
//          bowlList += 1;
//        }
      }
    });
//
//skillMapCount.keys.forEach((e) {
//  print(e.toUpperCase());
//  print(skillMapCount[e.toUpperCase()]);
//});
    if (playerCountAllowed - getSelectedPlayerCount(null) != 0) {
//      var minWk = 0;
//      var minAr = 0;
//      var minBat = 0;
//      var minbowl = 0;

//    print('here comes');
    var totalMin = 0;
      skillMap.keys.forEach((e) {
        if (getMinMaxSelectionCount(e.toUpperCase(), skillMap)[0] > skillMapCount[e.toUpperCase()]) {
          skillMapMin[e.toUpperCase()] = getMinMaxSelectionCount(e.toUpperCase(),skillMap)[0] - skillMapCount[e.toUpperCase()];
          totalMin += getMinMaxSelectionCount(e.toUpperCase(),skillMap)[0] - skillMapCount[e.toUpperCase()];
        }
      });




//      if (getMinMaxSelectionCount(TabTextType.wk)[0] > wkList) {
//        minWk = getMinMaxSelectionCount(TabTextType.wk)[0] - wkList;
//      }
//      if (getMinMaxSelectionCount(TabTextType.ar)[0] > arList) {
//        minAr = getMinMaxSelectionCount(TabTextType.ar)[0] - arList;
//      }
//      if (getMinMaxSelectionCount(TabTextType.bat)[0] > batList) {
//        minBat = getMinMaxSelectionCount(TabTextType.bat)[0] - batList;
//      }
//      if (getMinMaxSelectionCount(TabTextType.bowl)[0] > bowlList) {
//        minbowl = getMinMaxSelectionCount(TabTextType.bowl)[0] - bowlList;
//      }
//      var totalMin = minWk + minAr + minBat + minbowl;
//      print(totalMin);
//      print(getSelectedPlayerCount(null));
//      print((11 - getSelectedPlayerCount(null)));
//      print(totalMin);
      if (totalMin > (playerCountAllowed - (getSelectedPlayerCount(null) + 1))) {

//       print('*****************************');
        var response = null;
        skillMap.keys.forEach((e) {
          if(skillMapMin[e.toUpperCase()] != 0)
            {
//              print(e.toUpperCase());
//              print('hehehehe');
              if(response ==null) {
                response = e.toUpperCase();
//                print(response);
              }
            }
        });
//        print('wwwwww');
//        print(response);
        return response;

//        if (minWk != 0) {
//          return TabTextType.wk;
//        } else if (minBat != 0) {
//          return TabTextType.bat;
//        } else if (minAr != 0) {
//          return TabTextType.ar;
//        } else if (minbowl != 0) {
//          return TabTextType.bowl;
//        } else {
//          return null;
//        }
      } else {
//        print('@@@@@@@@@@@@@@@@@@@@@');
        String response = null;
        skillMap.keys.map((e) {
          if(response==null) {
            if (getMinMaxSelectionCount(e.toUpperCase(), skillMap)[0] >
                skillMapCount[e.toUpperCase()] &&
                getMinMaxSelectionCount(e.toUpperCase(), skillMap)[0] ==
                    playerCountAllowed - getSelectedPlayerCount(null)) {
              response = e.toUpperCase();
            }
          }

        });
        return response;


//        if (getMinMaxSelectionCount(TabTextType.wk)[0] > wkList &&
//            getMinMaxSelectionCount(TabTextType.wk)[0] ==
//                11 - getSelectedPlayerCount(null)) {
//          return TabTextType.wk;
//        } else if (getMinMaxSelectionCount(TabTextType.ar)[0] > arList &&
//            getMinMaxSelectionCount(TabTextType.ar)[0] ==
//                11 - getSelectedPlayerCount(null)) {
//          return TabTextType.ar;
//        } else if (getMinMaxSelectionCount(TabTextType.bat)[0] > batList &&
//            getMinMaxSelectionCount(TabTextType.bat)[0] ==
//                11 - getSelectedPlayerCount(null)) {
//          return TabTextType.bat;
//        } else if (getMinMaxSelectionCount(TabTextType.bowl)[0] > bowlList &&
//            getMinMaxSelectionCount(TabTextType.bowl)[0] ==
//                11 - getSelectedPlayerCount(null)) {
//          return TabTextType.bowl;
//        } else {
//          return null;
//        }
      }
    } else {
      return null;
    }
  }

  @override
  TeamSelectionBlocState get initialState => TeamSelectionBlocState.initial();

  @override
  Stream<TeamSelectionBlocState> mapEventToState(
      TeamSelectionBlocEvent event) async* {
    if (event == TeamSelectionBlocEvent.setUpdate) {
      //print("events");
//      print(allPlayerList.length);
      yield state.copyWith(
        allPlayerList: allPlayerList,
        assending: assending,
      );
    }
  }
}

enum TeamSelectionBlocEvent { setUpdate }



class TeamSelectionBlocState {
  var allPlayerList = List<Players>();
  bool assending = false;
  TeamSelectionBlocState({
    this.allPlayerList,
    this.assending,
  });

  factory TeamSelectionBlocState.initial() {
    return TeamSelectionBlocState(
      allPlayerList: List<Players>(),
      assending: false,
    );
  }

  TeamSelectionBlocState copyWith({
    List<Players> allPlayerList,
    bool assending,
  }) {
    return TeamSelectionBlocState(
      allPlayerList: allPlayerList ?? this.allPlayerList,
      assending: assending ?? this.assending,
    );
  }
}
