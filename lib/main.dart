import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frolicsports/app/landing_page.dart';
import 'package:frolicsports/app/sign_in/sign_in_page.dart';
import 'package:frolicsports/bloc/authBloc.dart';
import 'package:frolicsports/bloc/connectivityBloc.dart';
import 'package:frolicsports/bloc/contestDataBloc.dart';
import 'package:frolicsports/bloc/mainBloc.dart';
import 'package:frolicsports/bloc/sportsDataBloc.dart';
import 'package:frolicsports/constance/firsttime.dart';
import 'package:frolicsports/constance/global.dart' as globals;
import 'package:frolicsports/constance/routes.dart';
import 'package:frolicsports/constance/themes.dart';
import 'package:frolicsports/modules/home/tabScreen.dart';
import 'package:frolicsports/modules/login/loginScreen.dart';
import 'package:frolicsports/modules/login/otpValidationScreen.dart';
import 'package:frolicsports/modules/signin/firstScreen.dart';
import 'package:frolicsports/modules/signin/firstView.dart';
import 'package:frolicsports/modules/splash/SplashScreen.dart';
import 'package:frolicsports/test.dart';
import 'package:frolicsports/utils/config.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    print('bloc: ${bloc.runtimeType}, event: $event');
    super.onEvent(bloc, event);
  }

  @override
  void onChange(Cubit cubit, Change change) {
    print('cubit: ${cubit.runtimeType}, change: $change');
    super.onChange(cubit, change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print('bloc: ${bloc.runtimeType}, transition: $transition');
    super.onTransition(bloc, transition);
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) {
    print('cubit: ${cubit.runtimeType}, error: $error');
    super.onError(cubit, error, stackTrace);
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //BlocSupervisor().delegate = SimpleBlocDelegate();
  Bloc.observer = SimpleBlocObserver();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) => runApp(
      MultiBlocProvider(providers: MainBloc.allBlocs(), child: new MyApp())));
}

class MyApp extends StatefulWidget {
  static setCustomeTheme(BuildContext context, int index) {
    final _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setCustomeTheme(index);
  }

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    globals.connectivityBloc = ConnectivityBloc();
    globals.connectivityBloc.onInitial();
    super.initState();

//    FirstTime.getValues();
  }

  void setCustomeTheme(int index) {
    setState(() {
      globals.colorsIndex = index;
      globals.primaryColorString = globals.colors[globals.colorsIndex];
      globals.secondaryColorString = globals.primaryColorString;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: globals.isLight ? Brightness.dark : Brightness.light,
    ));
    return Container(
      color: AllCoustomTheme.getThemeData().primaryColor,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: appName,
        theme: AllCoustomTheme.getThemeData(),
        routes: routes,
      ),
    );
//    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  var routes = <String, WidgetBuilder>{
    //Routes.SPLASH: (BuildContext context) => new test(), // Paytm
    Routes.SPLASH: (BuildContext context) => new SplashScreen(),
    Routes.LOGIN: (BuildContext context) => new LoginScreen(),
    Routes.TAB: (BuildContext context) => new TabScreen(),
    Routes.OTP: (BuildContext context) => new OtpValidationScreen(),
  };
}
