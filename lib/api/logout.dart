import 'package:flutter/material.dart';
import 'package:frolicsports/constance/global.dart' as globals;
import 'package:frolicsports/constance/routes.dart';
import 'package:frolicsports/constance/sharedPreferences.dart';
import 'package:frolicsports/models/userData.dart';
import 'package:frolicsports/modules/login/loginScreen.dart';
import 'package:frolicsports/old_utils/Helper.dart';
import 'package:frolicsports/utils/dialogs.dart';
import 'package:frolicsports/bloc/authBloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogOut {
  void logout(BuildContext context) async {
    try {
//      globals.usertoken = '';
      await MySharedPreferences().clearSharedPreferences();
      final auth = context.bloc<AuthBloc>();
      await auth.signOut();
      Navigator.of(context).pushNamedAndRemoveUntil(Routes.SPLASH, (route) => false);
//     Navigator.of(context).pushNamedAndRemoveUntil(
//          Routes.LOGIN, (Route<dynamic> route) => false);
    } on Exception {
      Dialogs.showDialogWithOneButton(
        context,
        "Error",
        "please! try again.",
      );
    }
  }

  Future backSplashScreen(BuildContext context) async {
    try {
//      globals.usertoken = '';
      loginUserData = UserData();
      await MySharedPreferences().clearSharedPreferences();
      Navigator.of(context).pushNamedAndRemoveUntil(
          Routes.LOGIN, (Route<dynamic> route) => false);
    } on Exception {
      Dialogs.showDialogWithOneButton(
        context,
        "Error",
        "please! try again.",
      );
    }
  }
}
