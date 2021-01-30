import 'dart:collection';
import 'dart:core';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frolicsports/models/sportsData.dart';
import 'package:frolicsports/models/sportsDataForApp.dart';
import 'package:frolicsports/utils/config.dart';
import 'package:frolicsports/constance/global.dart' as globals;

class ContestDataBloc extends Bloc<ContestDataBlocEvent, ContestDataBlocState> {
  ContestDataBloc() : super(ContestDataBlocState());

  final _firestore = Firestore.instance;

  HashMap<int, HashMap<int, Contest>> _selectedMatchContest =
      HashMap<int, HashMap<int, Contest>>();

  HashMap<int, List<String>> _selectedMatchContestCategories =
      HashMap<int, List<String>>();

  @override
  Stream<ContestDataBlocState> mapEventToState(
      ContestDataBlocEvent event) async* {
    switch (event) {
      case ContestDataBlocEvent.setUpdate:
        yield state.copyWith(
            selectedMatchContest: _selectedMatchContest,
            selectedMatchContestCategories: _selectedMatchContestCategories);
        break;
    }
  }

  Contest convertStringToContest(var tempContestString) {
    List<Prizes> prizeList = List<Prizes>();

    for (var i = 0; i < tempContestString["prz"].length; i++) {
      prizeList.add(Prizes.fromJson(tempContestString['prz'][i]));
    }
    Contest contest = Contest(
        contestId: tempContestString['id'],
        contestCategory: tempContestString['cat'],
        contestName: tempContestString['name'],
        entryAmount: tempContestString['amt'],
        maxEntries: tempContestString['max'],
        maxEntriesPerUser: tempContestString['useLmt'],
        prizeList: prizeList);
    //print(contest.entryAmount);

    return contest;
  }

  Future<void> getContestForMatchFromFirestore(MatchDataForApp match) async {
    var contestRef;
    try {
      contestRef = await _firestore
          .collection(SPORTS_DATA)
          .document(match.sportsName)
          .collection(TOURNAMENTS_DATA)
          .document(match.tournamentName)
          .collection(MATCH_DATA)
          .document(match.matchUniqueId.toString())
          .get(source: Source.cache);

      if (!contestRef.exists) {
        contestRef = await _firestore
            .collection(SPORTS_DATA)
            .document(match.sportsName)
            .collection(TOURNAMENTS_DATA)
            .document(match.tournamentName)
            .collection(MATCH_DATA)
            .document(match.matchUniqueId.toString())
            .get(source: Source.server);
      }
    } catch (e) {
      contestRef = await _firestore
          .collection(SPORTS_DATA)
          .document(match.sportsName)
          .collection(TOURNAMENTS_DATA)
          .document(match.tournamentName)
          .collection(MATCH_DATA)
          .document(match.matchUniqueId.toString())
          .get(source: Source.server);
    } finally {
      if (!contestRef.exists) {
        return;
      }

      HashMap<int, Contest> contestMap = HashMap<int, Contest>();
      List<String> categories = List<String>();

      contestRef.data['contest'].forEach((cnn) {
        List<Prizes> prizeList = List<Prizes>();
        print('contest');
        print(cnn['name']);
        if (cnn["prz"] != null) {
          //TODO remove when we have data
          print(cnn['prz'].length);
//          if (cnn["prz"].length > 0) {
          for (var i = 0; i < cnn["prz"].length; i++) {
            prizeList.add(Prizes.fromJson(cnn['prz'][i]));
          }
//            print(cnn["prz"][0].toString());
//            cnn["prz"].map((prz){
//              print('prz');
//              print(prz['id']);
//              prizeList.add(Prizes.fromJson(prz));
//            });
//            cnn["prz"].foreach((prz) {
//              prizeList.add(Prizes.fromJson(prz));
//            });

          Contest contest = Contest(
              contestId: cnn['id'],
              contestCategory: cnn['cat'],
              contestName: cnn['name'],
              entryAmount: cnn['amt'],
              maxEntries: cnn['max'],
              maxEntriesPerUser: cnn['useLmt'],
              prizeList: prizeList);

          contestMap[cnn['id']] = contest;
          print(cnn['cat']);
          if (categories.indexOf(cnn['cat']) == -1) {
            categories.add(cnn['cat']);
          }

          print(match.matchUniqueId);
        }
      });
      _selectedMatchContest[match.matchUniqueId] = contestMap;
      print('categories');
      print(categories.length);
      _selectedMatchContestCategories[match.matchUniqueId] = categories;
      add(ContestDataBlocEvent.setUpdate);
    }
  }

  String getPrizePool(Contest contest) {
    var totalAmount = 0.0;
//    print(contest.prizeList.length);
    contest.prizeList.forEach((prize) {
      totalAmount +=
          (prize.rankRangeEnd - prize.rankRangeStart + 1) * prize.prizeAmount;
      print("prize Amount${prize.prizeAmount}");
      //print(totalAmount);
    });
    return totalAmount.toString();
  }

  int getPrizeWinners(Contest contest) {
    var totalNumber = 0;
//    print(contest.prizeList.length);
    contest.prizeList.forEach((prize) {
      totalNumber += prize.rankRangeEnd - prize.rankRangeStart + 1;
//      print(totalNumber);
    });

    return totalNumber;
  }

//  Future<void> getSelectedMatchContest(int matchId) {
//    List<Contest> cnn;
//    Set<String> contestType = Set<String>();
//    //print(globals.contestList.length);
//    _selectedMatchContest[matchId].values.forEach((cont) {
//      cnn.removeRange(0, cnn.length);
//      contestType.add(cont.contestCategory);
//      if (_selectedMatchContest.containsKey(contest.contestName) == true) {
//        cnn = _selectedMatchContest[contest.contestName];
//        cnn.add(contest);
//        _selectedMatchContest[contest.contestName] = cnn;
//      } else {
//        cnn.add(contest);
//        _uniqueMatchContest.add(contest.contestName);
//        _selectedMatchContest[contest.contestName] = cnn;
//      }
//    });
//    for (Contest contest in _selectedMatchContest.values) {
////      print('came here');
//      cnn = List<Contest>();
////      print(contest.matchId);
//      if (contest.matchId == matchId) {
////          print(matchId);
//        cnn.removeRange(0, cnn.length);
//        contestType.add(contest.contestName);
//        if (_selectedMatchContest.containsKey(contest.contestName) == true) {
//          cnn = _selectedMatchContest[contest.contestName];
//          cnn.add(contest);
//          _selectedMatchContest[contest.contestName] = cnn;
//        } else {
//          cnn.add(contest);
//          _uniqueMatchContest.add(contest.contestName);
//          _selectedMatchContest[contest.contestName] = cnn;
//        }
//      }
//    }
//    ;
//    print(_selectedMatchContest["Jumbo"]);
//    print(_uniqueMatchContest.toString());
//    add(ContestDataBlocEvent.selectedMatch);
//  }

//  Future<void> getSportsContestFromFirestore(String contestCategory) async {
//    var path = SPORTS_DATA;
//    var documentReference =
//        _firestore.collection(path).document(contestCategory);
//
//    DocumentSnapshot documentSnapshot;
//    try {
//      documentSnapshot = await documentReference.get(source: Source.cache);
//
//      if (!documentSnapshot.exists) {
//        documentSnapshot = await documentReference.get(source: Source.server);
//        if (!documentSnapshot.exists) {
//          _contest = null;
//          return;
//        }
//      }
//    } catch (e) {
//      documentSnapshot = await documentReference.get(source: Source.server);
//
//      if (!documentSnapshot.exists) {
//        _contest = null;
//        return;
//      }
//    } finally {
//      // Contest
//      List<Contest> contestList = List<Contest>();
//      documentSnapshot.data['Contest'].forEach((contest) {
//        contestList.add(Contest.fromJson(contest));
//      });
//
//      _contest.addAll(contestList);
//      globals.contestList.addAll(contestList);
//      add(ContestDataBlocEvent.setUpdate);
//    }
//  }

}

enum ContestDataBlocEvent { setUpdate }

class ContestDataBlocState {
  HashMap<int, HashMap<int, Contest>> selectedMatchContest =
      HashMap<int, HashMap<int, Contest>>();
  HashMap<int, List<String>> selectedMatchContestCategories =
      HashMap<int, List<String>>();

  ContestDataBlocState(
      {this.selectedMatchContest, this.selectedMatchContestCategories});

  ContestDataBlocState copyWith(
      {HashMap<int, HashMap<int, Contest>> selectedMatchContest,
      HashMap<int, List<String>> selectedMatchContestCategories}) {
    return ContestDataBlocState(
        selectedMatchContest: selectedMatchContest ?? this.selectedMatchContest,
        selectedMatchContestCategories: selectedMatchContestCategories ??
            this.selectedMatchContestCategories);
  }
}
