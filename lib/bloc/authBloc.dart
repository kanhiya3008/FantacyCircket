import 'dart:core';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:frolicsports/models/userData.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:frolicsports/utils/config.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:frolicsports/constance/global.dart' as globals;

class AuthBloc extends Bloc<AuthBlocEvent, AuthBlocState> {
  AuthBloc() : super(AuthBlocState.initial());

  final _firebaseAuth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;

  var _userData = UserData();
  var _authUser=false;

  Future<void> currentUser() async {
    final user = await _firebaseAuth.currentUser();
    _userFromFirebase(user);
    _getUserDatatoFirestore(user.uid);
    add(AuthBlocEvent.setUpdate);
  }

  UserData getCurrentUser()
  {
    return state.userData;
  }

  void _userFromFirebase(FirebaseUser user) {
    _userData = UserData();
    if (user != null) {
      _userData.userId = user.uid;
      _authUser = true;
//      globals.userdata = _userData;
    } else {
      _userData.userId = '';
      _authUser = true;
    }
  }


  Future<UserData> signInWithEmailAndPassword(String email, String password) async {
    final authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    _getUserDatatoFirestore(authResult.user.uid);
//    _saveUserDatatoFirestore(authResult);
//    _userFromFirebase(authResult.user);
    add(AuthBlocEvent.setUpdate);
  }

  Future<UserData> createUserWithEmailAndPassword(
      String email, String password) async {
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    _saveUserDatatoFirestore(authResult);
//    _userFromFirebase(authResult.user);
    add(AuthBlocEvent.setUpdate);
  }

  Future<UserData> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final authResult = await _firebaseAuth.signInWithCredential(
          GoogleAuthProvider.getCredential(
            idToken: googleAuth.idToken,
            accessToken: googleAuth.accessToken,
          ),
        );

        _saveUserDatatoFirestore(authResult);
        //_userFromFirebase(authResult.user);
        add(AuthBlocEvent.setUpdate);
      } else {
        throw PlatformException(
          code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
          message: 'Missing Google Auth Token',
        );
      }
    } else {
      throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }

  Future<UserData> signInWithFacebook() async {
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(
      ['public_profile'],
    );
    if (result.accessToken != null) {
      final authResult = await _firebaseAuth.signInWithCredential(
        FacebookAuthProvider.getCredential(
          accessToken: result.accessToken.token,
        ),
      );
//      _userFromFirebase(authResult.user);
      _saveUserDatatoFirestore(authResult);
      add(AuthBlocEvent.setUpdate);
    } else {
      throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }

  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    final facebookLogin = FacebookLogin();
    await facebookLogin.logOut();
    await _firebaseAuth.signOut();
  }

  @override
  Stream<AuthBlocState> mapEventToState(AuthBlocEvent event) async* {
    switch (event) {
      case AuthBlocEvent.setUpdate:
        yield state.copyWith(userData: _userData, authUser: _authUser);
        break;
    }
  }

  Future<void> _getUserDatatoFirestore(String uid) async
  {
    var path = USERS;
    var documentReference = _firestore.collection(path).document(uid);



    DocumentSnapshot documentSnapshot = await documentReference.get(source: Source.cache);

    if(!documentSnapshot.exists)
      {
        documentSnapshot = await documentReference.get(source: Source.server);
        if(!documentSnapshot.exists)
          {
            _userData = null;
          }
        else{

         _userData = UserData.fromJson(documentSnapshot.data);
         print(_userData.userId);
        }
      }
    else{
      print('cache');
      _userData = UserData.fromJson(documentSnapshot.data);
      print(_userData.userId);
    }

//    globals.userdata = _userData;

  }

  Future<void> _saveUserDatatoFirestore(AuthResult result) async
  {
    var path = USERS;
    var documentReference = _firestore.collection(path).document(result.user.uid);
    _userData = getGoogleAttributes(result);
//    globals.userdata = _userData;
    await documentReference.setData(_userData.toJson());

  }

  UserData getGoogleAttributes(AuthResult result)
  {
    UserData userData = UserData(
      userId : result.user.providerData[0].uid,
      email : result.user.providerData[0].email,
      mobileNumber: result.user.providerData[0].phoneNumber ?? '',
      name:result.user.providerData[0].displayName ?? '',
      image:result.user.providerData[0].photoUrl ?? '',
    );

    return userData;
  }
}



enum AuthBlocEvent { setUpdate }

class AuthBlocState {
  var userData = UserData();
  var authUser = false;

  AuthBlocState({this.userData, this.authUser});

  factory AuthBlocState.initial() {
    return AuthBlocState(userData: UserData(), authUser: false);
  }

  AuthBlocState copyWith({UserData userData, bool authUser}) {
    return AuthBlocState(
        userData: userData ?? this.userData,
        authUser: authUser ?? this.authUser);
  }
}
