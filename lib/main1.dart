import 'package:flutter/material.dart';
import 'package:frolicsports/old_utils/Config.dart';
import 'package:frolicsports/old_utils/Route1.dart';


void main() {
  runApp(MyApp());
}
class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver{

//  static User currentUser;

  final materialApp = MaterialApp(
      title: appName,
//      theme: ThemeData(
//          brightness: Brightness.light,
//          accentColor: Colors.indigoAccent,
//          primaryColor: Colors.indigoAccent,
//          primarySwatch: Colors.indigo,
//          fontFamily: quickFont),
//      debugShowCheckedModeBanner: false,
//      showPerformanceOverlay: false,
//      initialRoute: '/',
//      onGenerateRoute: Router.generateRoute
  );

  @override
  Widget build(BuildContext context) {
    return materialApp;
  }

//  @override
//  void didChangeAppLifecycleState(AppLifecycleState state) {
//    print("came here");
//    if (FirebaseAuth.instance.currentUser() != null && currentUser != null) {
//      print("current user is not null");
//      if (state == AppLifecycleState.paused) {
//        //user offline
//        zmp = Timestamp.now();
//        FireStoreUtils.currentUserDocRef.updateData(currentUser.toJson());
//      } else if (state == AppLifecycleState.resumed) {
//        //user online
//        currentUser.active = true;
//        FireStoreUtils.currentUserDocRef.updateData(currentUser.toJson());
//      }
//    }
//  }
}