import 'dart:collection';

import 'package:frolicsports/bloc/connectivityBloc.dart';
import 'package:frolicsports/bloc/phoneVerificationBloc.dart';
import 'package:frolicsports/models/sportsData.dart';
import 'package:frolicsports/models/sportsDataForApp.dart';
import 'package:frolicsports/models/userData.dart';

var isLight = true;

var primaryColorString = '#3145f5';
var secondaryColorString = '#3145f5';
//var usertoken = '';
//UserData userdata;
//SportsData sportsData;
//List<MatchDataForApp> matchDataForAppList = List<MatchDataForApp>();
//List<Contest> contestList = List<Contest>();

var defaultSports = "Cricket";

PhoneVerificationBloc phoneVerificationBloc;
ConnectivityBloc connectivityBloc;

List<String> colors = ['#3145f5', '#32a852', '#e6230e', '#760ee6', '#db0ee6', '#db164e'];
int colorsIndex = 0;
