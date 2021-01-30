class ScorecardResponce {
  List<Teams> teams;
  String statusNote;
  int success;
  String message;

  ScorecardResponce({this.teams, this.statusNote, this.success, this.message});

  ScorecardResponce.fromJson(Map<String, dynamic> json) {
    if (json['teams'] != null) {
      teams = new List<Teams>();
      json['teams'].forEach((v) {
        teams.add(new Teams.fromJson(v));
      });
    }
    statusNote = json['status_note'];
    success = json['success'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.teams != null) {
      data['teams'] = this.teams.map((v) => v.toJson()).toList();
    }
    data['status_note'] = this.statusNote;
    data['success'] = this.success;
    data['message'] = this.message;
    return data;
  }
}

class Teams {
  String teamId;
  String name;
  String shortName;
  String scoresFull;
  String scores;
  String overs;

  Teams(
      {this.teamId,
      this.name,
      this.shortName,
      this.scoresFull,
      this.scores,
      this.overs});

  Teams.fromJson(Map<String, dynamic> json) {
    teamId = json['team_id'] ?? '';
    name = json['name'] ?? '';
    shortName = json['short_name'] ?? '';
    scoresFull = json['scores_full'] ?? '';
    scores = json['scores'] ?? '';
    overs = json['overs'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['team_id'] = this.teamId;
    data['name'] = this.name;
    data['short_name'] = this.shortName;
    data['scores_full'] = this.scoresFull;
    data['scores'] = this.scores;
    data['overs'] = this.overs;
    return data;
  }
}
//   String status;
//   Response response;
//   String etag;
//   String modified;
//   String datetime;
//   String apiVersion;

//   ScorecardResponce(
//       {this.status,
//       this.response,
//       this.etag,
//       this.modified,
//       this.datetime,
//       this.apiVersion});

//   ScorecardResponce.fromJson(Map<String, dynamic> json) {
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
//   int matchId;
//   String title;
//   String subtitle;
//   int format;
//   String formatStr;
//   int status;
//   String statusStr;
//   String statusNote;
//   String verified;
//   String preSquad;
//   String oddsAvailable;
//   int gameState;
//   String gameStateStr;
//   Competition competition;
//   Teama teama;
//   Teamb teamb;
//   String dateStart;
//   String dateEnd;
//   int timestampStart;
//   int timestampEnd;
//   Venue venue;
//   String umpires;
//   String referee;
//   String equation;
//   String live;
//   String result;

//   Response({
//     this.matchId,
//     this.title,
//     this.subtitle,
//     this.format,
//     this.formatStr,
//     this.status,
//     this.statusStr,
//     this.statusNote,
//     this.verified,
//     this.preSquad,
//     this.oddsAvailable,
//     this.gameState,
//     this.gameStateStr,
//     this.competition,
//     this.teama,
//     this.teamb,
//     this.dateStart,
//     this.dateEnd,
//     this.timestampStart,
//     this.timestampEnd,
//     this.venue,
//     this.umpires,
//     this.referee,
//     this.equation,
//     this.live,
//     this.result,
//   });

//   Response.fromJson(Map<String, dynamic> json) {
//     matchId = json['match_id'];
//     title = json['title'];
//     subtitle = json['subtitle'];
//     format = json['format'];
//     formatStr = json['format_str'];
//     status = json['status'];
//     statusStr = json['status_str'];
//     statusNote = json['status_note'];
//     verified = json['verified'];
//     preSquad = json['pre_squad'];
//     oddsAvailable = json['odds_available'];
//     gameState = json['game_state'];
//     gameStateStr = json['game_state_str'];
//     competition = json['competition'] != null
//         ? new Competition.fromJson(json['competition'])
//         : null;
//     teama = json['teama'] != null ? new Teama.fromJson(json['teama']) : null;
//     teamb = json['teamb'] != null ? new Teamb.fromJson(json['teamb']) : null;
//     dateStart = json['date_start'];
//     dateEnd = json['date_end'];
//     timestampStart = json['timestamp_start'];
//     timestampEnd = json['timestamp_end'];
//     venue = json['venue'] != null ? new Venue.fromJson(json['venue']) : null;
//     umpires = json['umpires'];
//     referee = json['referee'];
//     equation = json['equation'];
//     live = json['live'];
//     result = json['result'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['match_id'] = this.matchId;
//     data['title'] = this.title;
//     data['subtitle'] = this.subtitle;
//     data['format'] = this.format;
//     data['format_str'] = this.formatStr;
//     data['status'] = this.status;
//     data['status_str'] = this.statusStr;
//     data['status_note'] = this.statusNote;
//     data['verified'] = this.verified;
//     data['pre_squad'] = this.preSquad;
//     data['odds_available'] = this.oddsAvailable;
//     data['game_state'] = this.gameState;
//     data['game_state_str'] = this.gameStateStr;
//     if (this.competition != null) {
//       data['competition'] = this.competition.toJson();
//     }
//     if (this.teama != null) {
//       data['teama'] = this.teama.toJson();
//     }
//     if (this.teamb != null) {
//       data['teamb'] = this.teamb.toJson();
//     }
//     data['date_start'] = this.dateStart;
//     data['date_end'] = this.dateEnd;
//     data['timestamp_start'] = this.timestampStart;
//     data['timestamp_end'] = this.timestampEnd;
//     if (this.venue != null) {
//       data['venue'] = this.venue.toJson();
//     }
//     data['umpires'] = this.umpires;
//     data['referee'] = this.referee;
//     data['equation'] = this.equation;
//     data['live'] = this.live;
//     data['result'] = this.result;

//     return data;
//   }
// }

// class Competition {
//   int cid;
//   String title;
//   String abbr;
//   String type;
//   String category;
//   String matchFormat;
//   String status;
//   String season;
//   String datestart;
//   String dateend;
//   String totalMatches;
//   String totalRounds;
//   String totalTeams;
//   String country;

//   Competition(
//       {this.cid,
//       this.title,
//       this.abbr,
//       this.type,
//       this.category,
//       this.matchFormat,
//       this.status,
//       this.season,
//       this.datestart,
//       this.dateend,
//       this.totalMatches,
//       this.totalRounds,
//       this.totalTeams,
//       this.country});

//   Competition.fromJson(Map<String, dynamic> json) {
//     cid = json['cid'];
//     title = json['title'];
//     abbr = json['abbr'];
//     type = json['type'];
//     category = json['category'];
//     matchFormat = json['match_format'];
//     status = json['status'];
//     season = json['season'];
//     datestart = json['datestart'];
//     dateend = json['dateend'];
//     totalMatches = json['total_matches'];
//     totalRounds = json['total_rounds'];
//     totalTeams = json['total_teams'];
//     country = json['country'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['cid'] = this.cid;
//     data['title'] = this.title;
//     data['abbr'] = this.abbr;
//     data['type'] = this.type;
//     data['category'] = this.category;
//     data['match_format'] = this.matchFormat;
//     data['status'] = this.status;
//     data['season'] = this.season;
//     data['datestart'] = this.datestart;
//     data['dateend'] = this.dateend;
//     data['total_matches'] = this.totalMatches;
//     data['total_rounds'] = this.totalRounds;
//     data['total_teams'] = this.totalTeams;
//     data['country'] = this.country;
//     return data;
//   }
// }

// class Teama {
//   int teamId;
//   String name;
//   String shortName;
//   String logoUrl;
//   String scoresFull;
//   String scores;
//   String overs;

//   Teama(
//       {this.teamId,
//       this.name,
//       this.shortName,
//       this.logoUrl,
//       this.scoresFull,
//       this.scores,
//       this.overs});

//   Teama.fromJson(Map<String, dynamic> json) {
//     teamId = json['team_id'];
//     name = json['name'];
//     shortName = json['short_name'];
//     logoUrl = json['logo_url'];
//     scoresFull = json['scores_full'];
//     scores = json['scores'] ?? '';
//     overs = json['overs'] ?? '';
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['team_id'] = this.teamId;
//     data['name'] = this.name;
//     data['short_name'] = this.shortName;
//     data['logo_url'] = this.logoUrl;
//     data['scores_full'] = this.scoresFull;
//     data['scores'] = this.scores;
//     data['overs'] = this.overs;
//     return data;
//   }
// }

// class Teamb {
//   int teamId;
//   String name;
//   String shortName;
//   String logoUrl;
//   String scoresFull;
//   String scores;
//   String overs;

//   Teamb(
//       {this.teamId,
//       this.name,
//       this.shortName,
//       this.logoUrl,
//       this.scoresFull,
//       this.scores,
//       this.overs});

//   Teamb.fromJson(Map<String, dynamic> json) {
//     teamId = json['team_id'];
//     name = json['name'];
//     shortName = json['short_name'];
//     logoUrl = json['logo_url'];
//     scoresFull = json['scores_full'];
//     scores = json['scores'] ?? '';
//     overs = json['overs'] ?? '';
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['team_id'] = this.teamId;
//     data['name'] = this.name;
//     data['short_name'] = this.shortName;
//     data['logo_url'] = this.logoUrl;
//     data['scores_full'] = this.scoresFull;
//     data['scores'] = this.scores;
//     data['overs'] = this.overs;
//     return data;
//   }
// }

// class Venue {
//   String name;
//   String location;
//   String timezone;

//   Venue({this.name, this.location, this.timezone});

//   Venue.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     location = json['location'];
//     timezone = json['timezone'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['name'] = this.name;
//     data['location'] = this.location;
//     data['timezone'] = this.timezone;
//     return data;
//   }
// }

// class Toss {
//   String text;
//   int winner;
//   int decision;

//   Toss({this.text, this.winner, this.decision});

//   Toss.fromJson(Map<String, dynamic> json) {
//     text = json['text'];
//     winner = json['winner'];
//     decision = json['decision'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['text'] = this.text;
//     data['winner'] = this.winner;
//     data['decision'] = this.decision;
//     return data;
//   }
// }

// class ManOfTheMatch {
//   int pid;
//   String name;
//   String thumbUrl;

//   ManOfTheMatch({this.pid, this.name, this.thumbUrl});

//   ManOfTheMatch.fromJson(Map<String, dynamic> json) {
//     pid = json['pid'];
//     name = json['name'];
//     thumbUrl = json['thumb_url'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['pid'] = this.pid;
//     data['name'] = this.name;
//     data['thumb_url'] = this.thumbUrl;
//     return data;
//   }
// }
