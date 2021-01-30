

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frolicsports/bloc/authBloc.dart';
import 'package:frolicsports/bloc/connectivityBloc.dart';
import 'package:frolicsports/bloc/contestDataBloc.dart';
import 'package:frolicsports/bloc/phoneEnteryBloc.dart';
import 'package:frolicsports/bloc/phoneVerificationBloc.dart';
import 'package:frolicsports/bloc/sportsDataBloc.dart';
import 'package:frolicsports/bloc/standingsTabBloc.dart';
import 'package:frolicsports/bloc/teamDataBloc.dart';
import 'package:frolicsports/bloc/teamSelectionBloc.dart';
import 'package:frolicsports/bloc/teamTapBloc.dart';
import 'package:frolicsports/constance/global.dart';

class MainBloc{
  static List<BlocProvider> allBlocs(){
    return [
      BlocProvider<ConnectivityBloc>(
        create:(_) => ConnectivityBloc(),
      ),
      BlocProvider<PhoneEntryBloc>(
        create:(_) => PhoneEntryBloc(),
      ),
      BlocProvider<PhoneVerificationBloc>(
        create:(_) => PhoneVerificationBloc(),
      ),
      BlocProvider<StandingsTabBloc>(
        create:(_) => StandingsTabBloc(),
      ),
      BlocProvider<TeamSelectionBloc>(
        create:(_) => TeamSelectionBloc(),
      ),
      BlocProvider<TeamTapBloc>(
        create:(_) => TeamTapBloc(),
      ),
      BlocProvider<AuthBloc>(
        create:(_) => AuthBloc(),
      ),
      BlocProvider<SportsDataBloc>(
        create:(_) => SportsDataBloc(),
      ),
      BlocProvider<ContestDataBloc>(
        create:(_) => ContestDataBloc(),
      ),
      BlocProvider<TeamDataBloc>(
        create:(_) => TeamDataBloc(),
      )
    ];
  }
}