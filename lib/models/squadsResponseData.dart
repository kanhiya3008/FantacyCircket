class SquadsResponseData {
  int success = 0;
  String message = '';
  List<Players> playerList;

  SquadsResponseData({this.success, this.message, this.playerList});

  SquadsResponseData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['player_list'] != null) {
      playerList = new List<Players>();
      json['player_list'].forEach((v) {
        playerList.add(new Players.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.playerList != null) {
      data['player_list'] = this.playerList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Players {
  int pid;
  String title;
  String shortName;
  String firstName;
  String lastName;
  String middleName;
  String birthdate;
  String birthplace;
  String country;
  String playingRole;
  String battingStyle;
  String bowlingStyle;
  String fieldingPosition;
  String teamName;
  int fantasyPlayerRating;
  String nationality;
  int teamId;
  String playing11;
  double point;
  bool isSelcted;
  bool isVC;
  bool isC;
  String picture;

  Players({
    this.pid,
    this.title,
    this.shortName,
    this.firstName,
    this.lastName,
    this.middleName,
    this.birthdate,
    this.birthplace,
    this.country,
    this.playingRole,
    this.battingStyle,
    this.bowlingStyle,
    this.fieldingPosition,
    this.teamName,
    this.fantasyPlayerRating,
    this.nationality,
    this.teamId,
    this.point = 0.0,
    this.isSelcted = false,
    this.isVC = false,
    this.isC = false,
    this.playing11,
    this.picture,

  });

  Players.fromJson(Map<String, dynamic> json) {
    pid = json['pid'];
    title = json['title'];
    shortName = json['short_name'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    middleName = json['middle_name'];
    birthdate = json['birthdate'] ?? '';
    birthplace = json['birthplace'];
    country = json['country'];
    playingRole = json['playing_role'];
    battingStyle = json['batting_style'] ?? '';
    bowlingStyle = json['bowling_style'] ?? '';
    fieldingPosition = json['fielding_position'];
    teamName = json['team_name'];
    fantasyPlayerRating = json['fantasy_player_rating'];
    nationality = json['nationality'] ?? '';
    teamId = json['team_id'];
    isSelcted = false;
    isVC = false;
    point = 0.0;
    isC = false;
    playing11 = json['playing11'];
    picture = json['picture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pid'] = this.pid;
    data['title'] = this.title;
    data['short_name'] = this.shortName;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['middle_name'] = this.middleName;
    data['birthdate'] = this.birthdate;
    data['birthplace'] = this.birthplace;
    data['country'] = this.country;
    data['playing_role'] = this.playingRole;
    data['batting_style'] = this.battingStyle;
    data['bowling_style'] = this.bowlingStyle;
    data['fielding_position'] = this.fieldingPosition;
    data['team_name'] = this.teamName;
    data['fantasy_player_rating'] = this.fantasyPlayerRating;
    data['nationality'] = this.nationality;
    data['team_id'] = this.teamId;
    data['playing11'] = this.playing11;
    data['isSelcted'] = this.isSelcted;
    data['picture'] = this.picture;
    return data;
  }
}
//   String status;
//   Response response;
//   String etag;
//   String modified;
//   String datetime;
//   String apiVersion;

//   SquadsResponseData(
//       {this.status,
//       this.response,
//       this.etag,
//       this.modified,
//       this.datetime,
//       this.apiVersion});

//   SquadsResponseData.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     response = json['response'] != null
//         ? new Response.fromJson(json['response'])
//         : null;
//     etag = json['etag'];
//     modified = json['modified'];
//     datetime = json['datetime'];
//     apiVersion = json['api_version'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     if (this.response != null) {
//       data['response'] = this.response.toJson();
//     }
//     data['etag'] = this.etag;
//     data['modified'] = this.modified;
//     data['datetime'] = this.datetime;
//     data['api_version'] = this.apiVersion;
//     return data;
//   }
// }

// class Response {
//   String squadType;
//   List<Squads> squads;

//   Response({this.squadType, this.squads});

//   Response.fromJson(Map<String, dynamic> json) {
//     squadType = json['squad_type'];
//     if (json['squads'] != null) {
//       squads = new List<Squads>();
//       json['squads'].forEach((v) {
//         squads.add(new Squads.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['squad_type'] = this.squadType;
//     if (this.squads != null) {
//       data['squads'] = this.squads.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class Squads {
//   String teamId;
//   String title;
//   Team team;
//   List<Players> players;

//   Squads({this.teamId, this.title, this.team, this.players});

//   Squads.fromJson(Map<String, dynamic> json) {
//     teamId = json['team_id'];
//     title = json['title'];
//     team = json['team'] != null ? new Team.fromJson(json['team']) : null;
//     if (json['players'] != null) {
//       players = new List<Players>();
//       json['players'].forEach((v) {
//         players.add(new Players.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['team_id'] = this.teamId;
//     data['title'] = this.title;
//     if (this.team != null) {
//       data['team'] = this.team.toJson();
//     }
//     if (this.players != null) {
//       data['players'] = this.players.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class Team {
//   int tid;
//   String title;
//   String abbr;
//   String thumbUrl;
//   String type;
//   String logoUrl;
//   String country;
//   String sex;
//   String altName;

//   Team(
//       {this.tid,
//       this.title,
//       this.abbr,
//       this.thumbUrl,
//       this.type,
//       this.logoUrl,
//       this.country,
//       this.sex,
//       this.altName});

//   Team.fromJson(Map<String, dynamic> json) {
//     tid = json['tid'];
//     title = json['title'];
//     abbr = json['abbr'];
//     thumbUrl = json['thumb_url'];
//     type = json['type'];
//     logoUrl = json['logo_url'];
//     country = json['country'];
//     sex = json['sex'];
//     altName = json['alt_name'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['tid'] = this.tid;
//     data['title'] = this.title;
//     data['abbr'] = this.abbr;
//     data['thumb_url'] = this.thumbUrl;
//     data['type'] = this.type;
//     data['logo_url'] = this.logoUrl;
//     data['country'] = this.country;
//     data['sex'] = this.sex;
//     data['alt_name'] = this.altName;
//     return data;
//   }
// }

// class Players {
//   int pid;
//   String title;
//   String shortTeamName;
//   bool isSelcted;
//   bool isC;
//   bool isVC;
//   String shortName;
//   String firstName;
//   String lastName;
//   String middleName;
//   String birthdate;
//   String birthplace;
//   String country;
//   // List<Null> primaryTeam;
//   String thumbUrl;
//   String logoUrl;
//   String playingRole;
//   String battingStyle;
//   String bowlingStyle;
//   String fieldingPosition;
//   int recentMatch;
//   int recentAppearance;
//   double fantasyPlayerRating;
//   double point;
//   String nationality;

//   Players(
//       {this.pid,
//       this.shortTeamName,
//       this.title,
//       this.shortName,
//       this.firstName,
//       this.lastName,
//       this.middleName,
//       this.birthdate,
//       this.birthplace,
//       this.country,
//       this.isSelcted = false,
//       this.isC = false,
//       this.isVC = false,
//       // this.primaryTeam,
//       this.thumbUrl,
//       this.logoUrl,
//       this.playingRole,
//       this.battingStyle,
//       this.bowlingStyle,
//       this.fieldingPosition,
//       this.recentMatch,
//       this.recentAppearance,
//       this.fantasyPlayerRating,
//       this.point,
//       this.nationality});

//   Players.fromJson(Map<String, dynamic> json) {
//     pid = json['pid'];
//     isC = false;
//     isVC = false;
//     shortTeamName = '';
//     isSelcted = false;
//     title = json['title'];
//     shortName = json['short_name'];
//     firstName = json['first_name'];
//     lastName = json['last_name'];
//     middleName = json['middle_name'];
//     birthdate = json['birthdate'] == '' ? '- -' : json['birthdate'];
//     birthplace = json['birthplace'];
//     country = json['country'];
//     point = 0.0;
//     // if (json['primary_team'] != null) {
//     //   primaryTeam = new List<Null>();
//     //   json['primary_team'].forEach((v) {
//     //     primaryTeam.add(new Null.fromJson(v));
//     //   });
//     // }
//     thumbUrl = json['thumb_url'];
//     logoUrl = json['logo_url'];
//     playingRole = json['playing_role'];
//     battingStyle = json['batting_style'] == '' ? '- -' : json['batting_style'];
//     bowlingStyle = json['bowling_style'] == '' ? '- -' : json['bowling_style'];
//     fieldingPosition = json['fielding_position'];
//     recentMatch = json['recent_match'] ?? 0;
//     recentAppearance = json['recent_appearance'] ?? 0;
//     fantasyPlayerRating = double.parse('${json['fantasy_player_rating']}');
//     nationality = json['nationality'] == '' ? '- -' : json['nationality'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['pid'] = this.pid;
//     data['title'] = this.title;
//     data['short_name'] = this.shortName;
//     data['first_name'] = this.firstName;
//     data['last_name'] = this.lastName;
//     data['middle_name'] = this.middleName;
//     data['birthdate'] = this.birthdate;
//     data['birthplace'] = this.birthplace;
//     data['country'] = this.country;
//     data['shortTeamName'] = this.shortTeamName;
//     data['point'] = this.point;
//     // if (this.primaryTeam != null) {
//     //   data['primary_team'] = this.primaryTeam.map((v) => v.toJson()).toList();
//     // }
//     data['thumb_url'] = this.thumbUrl;
//     data['logo_url'] = this.logoUrl;
//     data['playing_role'] = this.playingRole;
//     data['batting_style'] = this.battingStyle;
//     data['bowling_style'] = this.bowlingStyle;
//     data['fielding_position'] = this.fieldingPosition;
//     data['recent_match'] = this.recentMatch;
//     data['recent_appearance'] = this.recentAppearance;
//     data['fantasy_player_rating'] = this.fantasyPlayerRating;
//     data['nationality'] = this.nationality;
//     data['isSelcted'] = this.isSelcted;
//     data['isC'] = this.isC;
//     data['isVC'] = this.isVC;
//     return data;
//   }
// }
