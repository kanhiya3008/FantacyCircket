class UserMatchRecord1{
  List<Map<String, dynamic>> matchList;

  UserMatchRecord1({this.matchList});
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['matchList'] = this.matchList;
    return data;
  }
}


class UserMatch1{
  int matchId;
  List<Map<String, dynamic>> contestList;

  UserMatch1({this.matchId, this.contestList});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['id'] = this.matchId;
    data['contest'] = this.contestList;
    return data;
  }

}

class UserMatchRecord{
  List<UserMatch> matchList;

  UserMatchRecord({this.matchList});
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['matchList'] = this.matchList;
    return data;
  }

}


class UserMatch{
  int matchId;
  List<UserContest> contestList;

  UserMatch({this.matchId, this.contestList});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['id'] = this.matchId;
    data['contest'] = this.contestList;
    return data;
  }

}

class UserContest{
  int contestId;
  UserContest({this.contestId});
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['id'] = this.contestId;
    return data;
  }

  UserContest.fromJson(Map<String, dynamic> json) {
    contestId = json['id'] ?? '';
  }
}



class TeamDetailsMap{
  List<TeamDetails> teamDetails;

  TeamDetailsMap({this.teamDetails});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['teamDetails'] = this.teamDetails;
    return data;
  }
}


class TeamDetails{

  String teamName;
  List<TeamPlayer> teamPlayers;
  String userId;
  String createdTime;
  String cId;
  String cName;
  String cImage;
  String vcId;
  String vcName;
  String vcImage;
  var teamAName;
  var teamACount;
  var teamBName;
  var teamBCount;


  TeamDetails({
    this.teamName='',
    this.teamPlayers = null,
    this.userId='',
    this.createdTime='',
    this.cId='',
    this.cName='',
    this.cImage='',
    this.vcId='',
    this.vcName='',
    this.vcImage='',
    this.teamAName='',
    this.teamACount='',
    this.teamBName='',
    this.teamBCount=''
});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['team_name'] = this.teamName;

    data['teamPlayers'] = this.teamPlayers;

    data['userId'] = this.userId;
    data['createdTime'] = this.createdTime;
    data['cId'] = this.cId;
    data['cName'] = this.cName;
    data['cImage'] = this.cImage;
    data['vcId'] = this.vcId;
    data['vcName'] = this.vcName;
    data['vcImage'] = this.vcImage;
    data['teamAName'] = this.teamAName;
    data['teamACount'] = this.teamACount;
    data['teamBName'] = this.teamBName;
    data['teamBCount'] = this.teamBCount;
    return data;
  }
  TeamDetails.fromJson(Map<String, dynamic> json) {
    teamName = json['teamName'] ?? '';
    teamPlayers = json['teamPlayers'] ?? '';
    userId = json['userId'] ?? '';
    createdTime = json['createdTime'] ?? '';
    cId = json['cId'] ?? '';
    cName = json['cName'] ?? '';
    cImage = json['cImage'] ?? '';
    vcId = json['vcId'] ?? '';
    vcName = json['vcName'] ?? '';
    vcImage = json['vcImage'] ?? '';
    teamAName = json['teamAName'] ?? '';
    teamACount = json['teamACount'] ?? '';
    teamBName = json['teamBName'] ?? '';
    teamBCount = json['teamBCount'] ?? '';

  }
}


class TeamPlayer{
  String playerId;
  String skill;



  TeamPlayer({this.playerId='', this.skill=''});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['playerId'] = this.playerId;
    data['skill'] = this.skill;

    return data;
  }
  TeamPlayer.fromJson(Map<String, dynamic> json) {
    playerId = json['playerId'] ?? '';
    skill = json['skill'] ?? '';
  }

}


class TeamDetailsMap1{
  List<Map<String, dynamic>> teamDetails;

  TeamDetailsMap1({this.teamDetails});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['teamDetails'] = this.teamDetails;
    return data;
  }
}


class TeamDetails1{

  String teamName;
  List<Map<String, dynamic>> teamPlayers;
  String userId;
  String createdTime;
  String cId;
  String cName;
  String cImage;
  String vcId;
  String vcName;
  String vcImage;
  var teamAName;
  var teamACount;
  var teamBName;
  var teamBCount;


  TeamDetails1({
    this.teamName='',
    this.teamPlayers = null,
    this.userId='',
    this.createdTime='',
    this.cId='',
    this.cName='',
    this.cImage='',
    this.vcId='',
    this.vcName='',
    this.vcImage='',
    this.teamAName='',
    this.teamACount='',
    this.teamBName='',
    this.teamBCount=''
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['team_name'] = this.teamName;

    data['teamPlayers'] = this.teamPlayers;

    data['userId'] = this.userId;
    data['createdTime'] = this.createdTime;
    data['cId'] = this.cId;
    data['cName'] = this.cName;
    data['cImage'] = this.cImage;
    data['vcId'] = this.vcId;
    data['vcName'] = this.vcName;
    data['vcImage'] = this.vcImage;
    data['teamAName'] = this.teamAName;
    data['teamACount'] = this.teamACount;
    data['teamBName'] = this.teamBName;
    data['teamBCount'] = this.teamBCount;
    return data;
  }
  TeamDetails1.fromJson(Map<String, dynamic> json) {
    teamName = json['teamName'] ?? '';
    teamPlayers = json['teamPlayers'] ?? '';
    userId = json['userId'] ?? '';
    createdTime = json['createdTime'] ?? '';
    cId = json['cId'] ?? '';
    cName = json['cName'] ?? '';
    cImage = json['cImage'] ?? '';
    vcId = json['vcId'] ?? '';
    vcName = json['vcName'] ?? '';
    vcImage = json['vcImage'] ?? '';
    teamAName = json['teamAName'] ?? '';
    teamACount = json['teamACount'] ?? '';
    teamBName = json['teamBName'] ?? '';
    teamBCount = json['teamBCount'] ?? '';

  }
}

