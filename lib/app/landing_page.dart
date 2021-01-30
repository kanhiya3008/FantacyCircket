import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frolicsports/bloc/authBloc.dart';
import 'package:frolicsports/modules/home/tabScreen.dart';
import 'package:frolicsports/modules/login/loginScreen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  var isWorking = false;

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  Future<void> getCurrentUser() async {
    setState(() {
      isWorking = true;
    });
    context.bloc<AuthBloc>().currentUser();
    setState(() {
      isWorking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ModalProgressHUD(
          inAsyncCall: isWorking,
          color: Colors.transparent,
          progressIndicator: CircularProgressIndicator(
            strokeWidth: 2.0,
          ),
          child: BlocBuilder<AuthBloc, AuthBlocState>(
            builder: (_, authState) {
              print(authState.authUser);
              if (authState.authUser == false) {
                print('User Dont Exists');

                return Scaffold(
                    body: Center(
                  child: CircularProgressIndicator(),
                ));
              } else {
                if (authState.userData.userId != "") {
                  //print("user exists");
                  print(authState.userData.userId);
                  return TabScreen();
                } else {
                  //print("user exists");
                  print(authState.userData.userId);
                  return LoginScreen();
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
