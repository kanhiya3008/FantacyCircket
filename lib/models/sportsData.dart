import 'dart:collection';

import 'package:frolicsports/models/sportsDataForApp.dart';

//
//class SportsData{
//  String sportsName;
//  String type;
//  List<MatchData> matchData;
//  List<PlayerDetails> playerDetails;
//  List<Rule> rule;
//  List<Skill> skill;
//  List<SpecialRule> specialRule;
//  List<Team> team;
//
//
//  SportsData({this.sportsName = '', this.type ='', this.matchData = null, this.playerDetails = null,
//      this.rule = null, this.skill = null, this.specialRule = null, this.team = null});
//
//  SportsData.fromJson(Map<String, dynamic> json) {
//    sportsName = json['sportsName'] ?? '';
//    type = json['type'] ?? '';
//    matchData = json['matchData'] ?? '';
//    playerDetails = json['playerDetails'] ?? '';
//    rule = json['rule'] ?? '';
//    skill = json['skill'] ?? '';
//    specialRule = json['specialRule'] ?? '';
//    team = json['team'] ?? '';
//
//  }
//
//}
//
//
//class MatchData{
//  var deadlineDate;
//  var deadlineTime;
//  String description;
//  var firstTeam;
//  var matchUniqueId;
//  var maxPlayers;
//  var maxPoints;
//  var secondTeam;
//  var startDate;
//  var startTime;
//  String tournamentCountry;
//  var tournamentId;
//  var tournamentName;
//  String venue;
//
//
//  MatchData({
//      this.deadlineDate='',
//      this.deadlineTime='',
//      this.description='',
//      this.firstTeam='',
//      this.matchUniqueId='',
//      this.maxPlayers='',
//      this.maxPoints='',
//      this.secondTeam='',
//      this.startDate='',
//      this.startTime='',
//      this.tournamentCountry='',
//      this.tournamentId='',
//      this.tournamentName='',
//      this.venue=''});
//
//  MatchData.fromJson(Map<String, dynamic> json) {
//    deadlineDate = json['deadlineDate'] ?? '';
//    deadlineTime = json['deadlineTime'] ?? '';
//    description = json['description'] ?? '';
//    firstTeam = json['firstTeam'] ?? '';
//    matchUniqueId = json['matchUniqueId'] ?? '';
//    maxPlayers = json['maxPlayers'] ?? '';
//    maxPoints = json['maxPoints'] ?? '';
//    secondTeam = json['secondTeam'] ?? '';
//    startDate = json['startDate'] ?? '';
//    startTime = json['startTime'] ?? '';
//    tournamentCountry = json['tournamentCountry'] ?? '';
//    tournamentId = json['tournamentId'] ?? '';
//    tournamentName = json['tournamentName'] ?? '';
//    venue = json['venue'] ?? '';
//  }
//}
//
//class PlayerDetails{
//  String country;
//  var credits;
//  String name;
//  String pictures;
//  var playerId;
//  var points;
//  String shortName;
//  var skillsId;
//  var status;
//  var teamId;
//
//
//  PlayerDetails({
//      this.country='',
//      this.credits='',
//      this.name='',
//      this.pictures='',
//      this.playerId='',
//      this.points='',
//      this.shortName='',
//      this.skillsId='',
//      this.status='',
//      this.teamId=''});
//
//  PlayerDetails.fromJson(Map<String, dynamic> json) {
//    country = json['country'] ?? '';
//    credits = json['credits'] ?? '';
//    name = json['name'] ?? '';
//    pictures = json['pictures'] ?? '';
//    playerId = json['playerId'] ?? '';
//    points = json['points'] ?? '';
//    shortName = json['shortName'] ?? '';
//    skillsId = json['skillsId'] ?? '';
//    status = json['status'] ?? '';
//    teamId = json['teamId'] ?? '';
//
//  }
//}
//
//class Rule{
//
//  var points;
//  var ruleId;
//  String ruleName;
//  String shortName;
//  var tournamentId;
//
//
//  Rule({this.points='', this.ruleId='', this.ruleName='', this.shortName='',
//      this.tournamentId=''});
//
//  Rule.fromJson(Map<String, dynamic> json) {
//    points = json['points'] ?? '';
//    ruleId = json['ruleId'] ?? '';
//    ruleName = json['ruleName'] ?? '';
//    shortName = json['shortName'] ?? '';
//    tournamentId = json['tournamentId'] ?? '';
//  }
//}
//
//class Skill{
//  var max;
//  var min;
//  String shortName;
//  var skillId;
//  String skillName;
//  var tournamentId;
//
//
//  Skill({this.max='', this.min='', this.shortName='', this.skillId='', this.skillName='',
//      this.tournamentId=''});
//
//  Skill.fromJson(Map<String, dynamic> json) {
//    max = json['max'] ?? '';
//    min = json['min'] ?? '';
//    shortName = json['shortName'] ?? '';
//    skillId = json['skillId'] ?? '';
//    skillName = json['skillName'] ?? '';
//    tournamentId = json['tournamentId'] ?? '';
//
//  }
//
//}
//
//class SpecialRule{
//  var points;
//  String shortName;
//  var specialRuleId;
//  String specialRuleName;
//  var tournamentId;
//
//
//  SpecialRule({this.points='', this.shortName='', this.specialRuleId='',
//      this.specialRuleName='', this.tournamentId=''});
//
//  SpecialRule.fromJson(Map<String, dynamic> json) {
//    points = json['points'] ?? '';
//    shortName = json['shortName'] ?? '';
//    specialRuleId = json['specialRuleId'] ?? '';
//    specialRuleName = json['specialRuleName'] ?? '';
//    tournamentId = json['tournamentId'] ?? '';
//
//
//  }
//}
//
//class Team{
//  String logo;
//  String name;
//  String shortName;
//  var teamId;
//  var tournamentId;
//
//
//  Team({this.logo='', this.name='', this.shortName='', this.teamId='', this.tournamentId=''});
//
//  Team.fromJson(Map<String, dynamic> json) {
//    logo = json['logo'] ?? '';
//    name = json['name'] ?? '';
//    shortName = json['shortName'] ?? '';
//    teamId = json['teamId'] ?? '';
//    tournamentId = json['tournamentId'] ?? '';
//
//  }
//
//}
//
//class Contest {
//  var contestId;
//  String contestName;
//  var entryAmount;
//  var matchId;
//  var maxEntries;
//  var maxEntriesPerUser;
//  var status;
//
//
//  Contest(
//      {this.contestId = '', this.contestName = '', this.entryAmount = '', this.matchId = '',
//        this.maxEntries = '', this.maxEntriesPerUser = '', this.status = ''});
//
//  Contest.fromJson(Map<String, dynamic> json) {
//    contestId = json['contestId'] ?? '';
//    contestName = json['contestName'] ?? '';
//    entryAmount = json['entryAmount'] ?? '';
//    matchId = json['matchId'] ?? '';
//    maxEntries = json['maxEntries'] ?? '';
//    maxEntriesPerUser = json['maxEntriesPerUser'] ?? '';
//    status = json['status'] ?? '';
//  }
//}

class SportsData {
  HashMap<String, MatchDataForApp> sportsMatchMap;

  SportsData({this.sportsMatchMap = null});
}

class TournamentData {
  var id;
  var deadlineSeconds;
  var maxPlayerFromSingleTeam;
  String name;
  var playersCount;
  var totalPoints;
  var playerImageFolder;
  var teamImageFolder;

  HashMap<int, MatchData> matchDataMap;
  HashMap<int, Rule> ruleMap;
  HashMap<String, Skill> skillMap;
  HashMap<String, SpecialRule> specialRuleMap;
  HashMap<int, Team> teamMap;

  TournamentData(
      {this.id = '',
      this.deadlineSeconds = '',
      this.maxPlayerFromSingleTeam = '',
      this.name = '',
      this.playersCount = '',
      this.totalPoints = '',
      this.playerImageFolder = '',
      this.teamImageFolder = '',
      this.matchDataMap = null,
      this.ruleMap = null,
      this.skillMap = null,
      this.specialRuleMap = null,
      this.teamMap = null});

  TournamentData.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    deadlineSeconds = json['deadlineSeconds'] ?? '';
    maxPlayerFromSingleTeam = json['maxPlr'] ?? '';
    name = json['name'] ?? '';
    playersCount = json['plr'] ?? '';
    totalPoints = json['pts'] ?? '';
    playerImageFolder = json['playerFolder'] ?? '';
    teamImageFolder = json['teamFolder'] ?? '';
    matchDataMap = json['matchData'] ?? '';
    ruleMap = json['rule'] ?? '';
    skillMap = json['skill'] ?? '';
    specialRuleMap = json['specialRule'] ?? '';
    teamMap = json['team'] ?? '';
  }
}

class MatchData {
  var firstTeamId;
  var matchUniqueId;
  var secondTeamId;
  var startDate;
  var startTime;

  MatchData(
      {this.firstTeamId = '',
      this.matchUniqueId = '',
      this.secondTeamId = '',
      this.startDate = '',
      this.startTime = ''});

  MatchData.fromJson(Map<String, dynamic> json) {
    firstTeamId = json['tId1'] ?? '';
    matchUniqueId = json['id'] ?? '';
    secondTeamId = json['tId2'] ?? '';
    startDate = json['dt'] ?? '';
    startTime = json['tm'] ?? '';
  }
}

class PlayerDetails {
  String country;
  var credits;
  String name;
  String pictures;
  var playerId;
  var points;
  String shortName;
  var skills;
  var isPlaying;
  var teamShortName;

  PlayerDetails(
      {this.country = '',
      this.credits = '',
      this.name = '',
      this.pictures = '',
      this.playerId = '',
      this.points = '',
      this.shortName = '',
      this.skills = '',
      this.isPlaying = '',
      this.teamShortName});

  PlayerDetails.fromJson(Map<String, dynamic> json) {
    country = json['cnty'] ?? '';
    credits = json['cr'] ?? '';
    name = json['name'] ?? '';
    pictures = json['img'] ?? '';
    playerId = json['id'] ?? '';
    points = json['pt'] ?? '';
    shortName = json['pShort'] ?? '';
    skills = json['pSkill'] ?? '';
    isPlaying = json['isP'] ?? '';
    teamShortName = json['teamShortName'] ?? '';
  }
}

class Rule {
  var points;
  var ruleId;
  String ruleName;
  String shortName;

  Rule(
      {this.points = '',
      this.ruleId = '',
      this.ruleName = '',
      this.shortName = ''});

  Rule.fromJson(Map<String, dynamic> json) {
    points = json['pts'] ?? '';
    ruleId = json['id'] ?? '';
    ruleName = json['name'] ?? '';
    shortName = json['short'] ?? '';
  }
}

class Skill {
  var max;
  var min;
  String shortName;
  var skillId;
  String skillName;

  Skill(
      {this.max = '',
      this.min = '',
      this.shortName = '',
      this.skillId = '',
      this.skillName = ''});

  Skill.fromJson(Map<String, dynamic> json) {
    max = json['max'] ?? '';
    min = json['min'] ?? '';
    shortName = json['short'] ?? '';
    skillId = json['id'] ?? '';
    skillName = json['name'] ?? '';
  }
}

class SpecialRule {
  var points;
  String shortName;
  var specialRuleId;
  String specialRuleName;

  SpecialRule(
      {this.points = '',
      this.shortName = '',
      this.specialRuleId = '',
      this.specialRuleName = ''});

  SpecialRule.fromJson(Map<String, dynamic> json) {
    points = json['pts'] ?? '';
    shortName = json['short'] ?? '';
    specialRuleId = json['id'] ?? '';
    specialRuleName = json['name'] ?? '';
  }
}

class Team {
  String logo;
  String name;
  String shortName;
  var teamId;
  HashMap<int, PlayerDetails> playerMap;

  Team(
      {this.logo = '',
      this.name = '',
      this.shortName = '',
      this.teamId = '',
      this.playerMap = null});

  Team.fromJson(Map<String, dynamic> json) {
    logo = json['logo'] ?? '';
    name = json['name'] ?? '';
    shortName = json['short'] ?? '';
    teamId = json['id'] ?? '';
    playerMap = json['playerDetails'] ?? '';
  }
}

class Contest {
  var contestId;
  String contestName;
  var entryAmount;
  var maxEntries;
  var maxEntriesPerUser;
  var contestCategory;
  List<Prizes> prizeList;

  Contest(
      {this.contestId = '',
      this.contestName = '',
      this.entryAmount = '',
      this.maxEntries = '',
      this.maxEntriesPerUser = '',
      this.contestCategory = '',
      this.prizeList:null});

  Contest.fromJson(Map<String, dynamic> json) {
    contestId = json['id'] ?? '';
    contestName = json['name'] ?? '';
    entryAmount = json['amt'] ?? '';
    maxEntries = json['max'] ?? '';
    maxEntriesPerUser = json['usrLmt'] ?? '';
    contestCategory = json['cat'] ?? '';
    prizeList = json['prizeList'] ?? '';
  }
}

class Prizes {
  var prizeId;
  var status;
  var prizeAmount;
  var rankRangeStart;
  var rankRangeEnd;

  Prizes(
      {this.prizeId = '',
        this.status = '',
        this.prizeAmount = '',
        this.rankRangeStart = '',
        this.rankRangeEnd = ''});

  Prizes.fromJson(Map<String, dynamic> json) {
    prizeId = json['id'] ?? '';
    status = json['st'] ?? '';
    prizeAmount = json['amt'] ?? '';
    rankRangeStart = json['start'] ?? '';
    rankRangeEnd = json['end'] ?? '';
  }
}
