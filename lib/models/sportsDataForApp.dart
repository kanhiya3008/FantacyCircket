

class MatchDataForApp{
  String sportsName;
  var firstTeamId;
  String firstTeamShortName;
  String firstTeamLogo;
  var matchUniqueId;
  var secondTeamId;
  String secondTeamShortName;
  String secondTeamLogo;
  var startDate;
  var startTime;
  var tournamentId;
  var tournamentName;
  var deadlineTime;


  MatchDataForApp({this.sportsName='', this.firstTeamId='', this.firstTeamShortName='',
      this.firstTeamLogo='', this.matchUniqueId='',
      this.secondTeamId='', this.secondTeamShortName='',
      this.secondTeamLogo='', this.startDate='', this.startTime='', this.tournamentId='', this.tournamentName='', this.deadlineTime=''});

}