import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frolicsports/app/sign_in/sign_in_page.dart';
import 'package:frolicsports/bloc/authBloc.dart';
import 'package:frolicsports/bloc/sportsDataBloc.dart';
import 'package:frolicsports/constance/themes.dart';
import 'package:frolicsports/modules/home/tabScreen.dart';
import 'package:frolicsports/utils/config.dart';

class SplashScreen extends StatefulWidget {
  @override
  State createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    _loadNextScreen();

    animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 15000));
    animationController.forward();
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    await context.bloc<AuthBloc>().currentUser();
  }

  Future<void> _getSportsData() async {
    await context.bloc<SportsDataBloc>().getSportsDataFromFirestore();
  }



  void _loadNextScreen() async {
    await Future.delayed(const Duration(milliseconds: 10000));

    //Navigator.pushReplacementNamed(context, Routes.LOGIN);
  }

  @override
  Widget build(BuildContext context) {


    return BlocBuilder<AuthBloc, AuthBlocState>(builder: (_, authState) {
      if(authState.authUser==false)
        {
          print('auth is in progress');
          return splashWindow();
        }
      else{
        if (authState.userData.userId != "")
      {

        print('user exists!');
        _getSportsData();
        return BlocBuilder<SportsDataBloc, SportsDataBlocState>(builder: (_, sportsState) {

          if(sportsState.sportsDataFetched==false)
            {
              print('data fetching in progress');
              return splashWindow();
            }
          else{
            print('data fetched');
            return TabScreen();
          }
        });
      }
      else
        {
          print('user dont exists');
          return SignInPage();
        }

      }

    });


  }

//  return !isDataFetched ? splashWindow()
//      :
//
//  if (authState.authUser == false) {
//  return TabScreen();
//  }
//  else
//  {
//  if (authState.userData.userId != "") {
//  print("user exists");
//  print(authState.userData.userId);
//  return TabScreen();
//  } else {
//  print("user dont exists");
//  print(authState.userData.userId);
//  return SignInPage();
//  }
//  }

  Widget splashWindow()
  {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: AllCoustomTheme.getThemeData().primaryColor,
            ),
            constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
                minWidth: MediaQuery.of(context).size.width),
            child: Center(
              child:

                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Text(
                        appName,
                        style: new TextStyle(
                          fontSize: 48.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      new SizeTransition(
                        sizeFactor: new CurvedAnimation(
                            parent: animationController,
                            curve: Curves.fastOutSlowIn),
                        axis: Axis.vertical,
                        child: Container(
                          height: 150.0,
                        ),
                      ),
                      CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                   ]




              ),
            ),
          ),
        ],
      ),
    );
  }
}
