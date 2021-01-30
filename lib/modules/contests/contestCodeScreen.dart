import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:frolicsports/constance/constance.dart';
import 'package:frolicsports/constance/themes.dart';
import 'package:frolicsports/models/contestsResponseData.dart';

class ContestCodeScreen extends StatefulWidget {
  @override
  _ContestCodeScreenState createState() => _ContestCodeScreenState();
}

class _ContestCodeScreenState extends State<ContestCodeScreen> {
  var codeController = new TextEditingController();
  var inviteCode = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isProsses = false;

  var categoryList = ContestsLeagueResponseData();

  @override
  void initState() {
    categoryList.contestsCategoryLeagueListData =
        List<ContestsLeagueCategoryListResponseData>();
    categoryList.teamlist = [];
    categoryList.totalcontest = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AllCoustomTheme.getThemeData().primaryColor,
            AllCoustomTheme.getThemeData().primaryColor,
            Colors.white,
            Colors.white,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: <Widget>[
          SafeArea(
            child: Scaffold(
              key: _scaffoldKey,
              backgroundColor: AllCoustomTheme.getThemeData().backgroundColor,
              body: Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        color: AllCoustomTheme.getThemeData().primaryColor,
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: AppBar().preferredSize.height,
                              child: Row(
                                children: <Widget>[
                                  Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        width: AppBar().preferredSize.height,
                                        height: AppBar().preferredSize.height,
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        'Invite Code',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w500,
                                          color: AllCoustomTheme.getThemeData()
                                              .backgroundColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: AppBar().preferredSize.height,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ModalProgressHUD(
                          inAsyncCall: isProsses,
                          color: Colors.transparent,
                          progressIndicator: CircularProgressIndicator(
                            strokeWidth: 2.0,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                            },
                            child: contestsData(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    child: Container(
                      height: 60,
                      padding: EdgeInsets.only(left: 50, right: 50, bottom: 20),
                      child: Container(
                        decoration: new BoxDecoration(
                          color: AllCoustomTheme.getThemeData().primaryColor,
                          borderRadius: new BorderRadius.circular(4.0),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                offset: Offset(0, 1),
                                blurRadius: 5.0),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: new BorderRadius.circular(4.0),
                            onTap: () async {
                              if (inviteCode != '') {
                              } else {
                                showInSnackBar("Invite code can't be empty");
                              }
                            },
                            child: Center(
                              child: Text(
                                'JOIN THIS CONTEST',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: ConstanceData.SIZE_TITLE12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void showInSnackBar(String value, {bool isGreeen = false}) {
    _scaffoldKey.currentState.showSnackBar(
      new SnackBar(
        content: new Text(
          value,
          style: TextStyle(
            fontSize: ConstanceData.SIZE_TITLE14,
            color: AllCoustomTheme.getReBlackAndWhiteThemeColors(),
          ),
        ),
        backgroundColor: isGreeen ? Colors.green : Colors.red,
      ),
    );
  }

  Widget contestsData() {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 16),
            child: Text(
              'If you have a contest invite code, enter it and join.',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AllCoustomTheme.getTextThemeColors(),
                fontSize: ConstanceData.SIZE_TITLE12,
              ),
            ),
          ),
          new Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: new TextField(
              controller: codeController,
              style: TextStyle(
                fontSize: ConstanceData.SIZE_TITLE16,
                color: AllCoustomTheme.getBlackAndWhiteThemeColors(),
              ),
              autofocus: false,
              decoration: new InputDecoration(
                labelText: 'Invite code.',
                counterStyle: TextStyle(
                  fontSize: 0,
                  color: Colors.transparent,
                ),
              ),
              onChanged: (txt) {
                inviteCode = txt;
              },
            ),
          ),
        ],
      ),
    );
  }
}
