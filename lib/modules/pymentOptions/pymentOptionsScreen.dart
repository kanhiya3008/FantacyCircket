import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:frolicsports/api/apiProvider.dart';
import 'package:frolicsports/constance/constance.dart';
import 'package:frolicsports/constance/themes.dart';
import 'package:frolicsports/models/scheduleResponseData.dart';
import 'package:frolicsports/models/userData.dart';
import 'package:frolicsports/modules/contests/contestsScreen.dart';

class PymentScreen extends StatefulWidget {
  final String paymetMoney;
  final entryFees;
  final ShedualData shedualData;
  final bool isOnlyAddMoney;
  final VoidCallback isTruePayment;

  const PymentScreen(
      {Key key,
      this.paymetMoney,
      this.shedualData,
      this.isOnlyAddMoney = false,
      this.entryFees,
      this.isTruePayment})
      : super(key: key);
  @override
  _PymentScreenState createState() => _PymentScreenState();
}

class _PymentScreenState extends State<PymentScreen> {
  var paymet = '';
  var isProsses = false;
  var paymentController = new TextEditingController();
  UserData userData;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var cashBonus = '';

  @override
  void initState() {
    if (widget.paymetMoney != null) {
      paymet = '${double.tryParse(widget.paymetMoney).toInt()}';
    }
    paymentController.text = paymet;
    getUserData();
    super.initState();
  }

  @override
  void dispose() {
    paymentController.dispose();
    super.dispose();
  }

  void getUserData() async {
    setState(() {
      isProsses = true;
    });
    var responseData = await ApiProvider().drawerInfoList();
    if (responseData != null) {
      userData = responseData.data;
    }
    if (!widget.isOnlyAddMoney) {
      if ((double.tryParse(widget.entryFees) * 0.20) <
          double.tryParse(userData.cashBonus)) {
        cashBonus = '${double.tryParse(widget.entryFees) * 0.20}';
      } else {
        cashBonus = '${double.tryParse(userData.cashBonus)}';
      }
    }
    setState(() {
      isProsses = false;
    });
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
              body: ModalProgressHUD(
                inAsyncCall: isProsses,
                color: Colors.transparent,
                progressIndicator: CircularProgressIndicator(
                  strokeWidth: 2.0,
                ),
                child: Stack(
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
                                            Icons.arrow_back,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          widget.isOnlyAddMoney
                                              ? 'Add Cash'
                                              : 'Payment',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w500,
                                            color:
                                                AllCoustomTheme.getThemeData()
                                                    .backgroundColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: AppBar().preferredSize.height,
                                    ),
                                  ],
                                ),
                              ),
                              widget.shedualData != null
                                  ? MatchHadder()
                                  : SizedBox(),
                            ],
                          ),
                        ),
                        Expanded(
                          child: userData != null
                              ? SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 16.0,
                                                right: 16,
                                                bottom: 16,
                                                top: 16),
                                            child: Row(
                                              children: <Widget>[
                                                Text(
                                                  'Current Balance',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: SizedBox(),
                                                ),
                                                userData != null
                                                    ? Text(
                                                        '₹1000',
                                                        style: TextStyle(
                                                          color: AllCoustomTheme
                                                                  .getThemeData()
                                                              .primaryColor,
                                                          fontSize:
                                                              ConstanceData
                                                                  .SIZE_TITLE18,
                                                        ),
                                                      )
                                                    : Container(
                                                        width: 12,
                                                        height: 12,
                                                        child:
                                                            CircularProgressIndicator(
                                                          strokeWidth: 2.0,
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                  Color>(
                                                            AllCoustomTheme
                                                                .getBlackAndWhiteThemeColors(),
                                                          ),
                                                        ),
                                                      ),
                                              ],
                                            ),
                                          ),
                                          Divider(
                                            height: 1,
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                          top: 10,
                                          left: 16.0,
                                          right: 16,
                                          bottom: 6,
                                        ),
                                      ),
                                      Container(
                                        child: Center(
                                          child: Text(
                                            "Add cash to your account",
                                            style: TextStyle(
                                              fontSize:
                                                  ConstanceData.SIZE_TITLE14,
                                              color:
                                                  Colors.grey.withOpacity(0.6),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding:
                                            EdgeInsets.only(top: 16, left: 16),
                                        child: Text(
                                          'Please Add amount',
                                          style: TextStyle(
                                            fontSize:
                                                ConstanceData.SIZE_TITLE14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 16,
                                            right: 16,
                                            top: 8,
                                            bottom: 8),
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              left: 8, right: 8),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                new BorderRadius.circular(4.0),
                                            border: Border.all(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              width: 1.2,
                                            ),
                                          ),
                                          child: TextFormField(
                                            controller: paymentController,
                                            style: TextStyle(
                                              fontSize:
                                                  ConstanceData.SIZE_TITLE16,
                                              color: AllCoustomTheme
                                                  .getBlackAndWhiteThemeColors(),
                                            ),
                                            autofocus: true,
                                            keyboardType: TextInputType.number,
                                            decoration: new InputDecoration(
                                              prefix: Text(
                                                '₹',
                                                style: TextStyle(
                                                  fontSize: ConstanceData
                                                      .SIZE_TITLE16,
                                                ),
                                              ),
                                              border: InputBorder.none,
                                              labelStyle: TextStyle(
                                                fontSize:
                                                    ConstanceData.SIZE_TITLE16,
                                              ),
                                            ),
                                            inputFormatters: [
                                              WhitelistingTextInputFormatter
                                                  .digitsOnly,
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding:
                                            EdgeInsets.only(left: 8, right: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      paymentController.text =
                                                          '50';
                                                    });
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        top: 8, bottom: 8),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          new BorderRadius
                                                              .circular(4.0),
                                                      border: Border.all(
                                                        color: Colors.grey,
                                                        width: 1.2,
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Container(
                                                          child: Text(
                                                            '₹50',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize:
                                                                  ConstanceData
                                                                      .SIZE_TITLE18,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      paymentController.text =
                                                          '100';
                                                    });
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        top: 8, bottom: 8),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          new BorderRadius
                                                              .circular(4.0),
                                                      border: Border.all(
                                                        color: Colors.grey,
                                                        width: 1.2,
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Container(
                                                          child: Text(
                                                            '₹100',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize:
                                                                  ConstanceData
                                                                      .SIZE_TITLE18,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      paymentController.text =
                                                          '200';
                                                    });
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        top: 8, bottom: 8),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          new BorderRadius
                                                              .circular(4.0),
                                                      border: Border.all(
                                                        color: Colors.grey,
                                                        width: 1.2,
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Container(
                                                          child: Text(
                                                            '₹200',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize:
                                                                  ConstanceData
                                                                      .SIZE_TITLE18,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      Container(
                                        height: 60,
                                        padding: EdgeInsets.only(
                                            left: 50, right: 50, bottom: 20),
                                        child: Row(
                                          children: <Widget>[
                                            Flexible(
                                              child: Container(
                                                decoration: new BoxDecoration(
                                                  color: AllCoustomTheme
                                                          .getThemeData()
                                                      .primaryColor,
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          4.0),
                                                  boxShadow: <BoxShadow>[
                                                    BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.5),
                                                        offset: Offset(0, 1),
                                                        blurRadius: 5.0),
                                                  ],
                                                ),
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(4.0),
                                                    onTap: () async {
                                                      clickPayment();
                                                    },
                                                    child: Center(
                                                      child: Text(
                                                        'Add cash'
                                                            .toUpperCase(),
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                          fontSize:
                                                              ConstanceData
                                                                  .SIZE_TITLE12,
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
                                    ],
                                  ),
                                )
                              : SizedBox(),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void clickPayment() async {
    var payMoney = int.tryParse(paymentController.text);
    if (payMoney == null || payMoney == 0) {
      showInSnackBar('Please, Enter your valid Amount.');
    } else if (payMoney > 0) {
      setState(() {
        isProsses = true;
      });

      showInSnackBars(
        'you Select ₹$payMoney',
      );

      setState(() {
        isProsses = false;
      });
    } else {
      showInSnackBar('Please, Enter your valid Amount.');
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(
      new SnackBar(
        content: new Text(
          value,
          style: TextStyle(
            fontSize: ConstanceData.SIZE_TITLE14,
            color: AllCoustomTheme.getReBlackAndWhiteThemeColors(),
          ),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  void showInSnackBars(String value) {
    _scaffoldKey.currentState.showSnackBar(
      new SnackBar(
        content: new Text(
          value,
          style: TextStyle(
            fontSize: ConstanceData.SIZE_TITLE14,
            color: AllCoustomTheme.getReBlackAndWhiteThemeColors(),
          ),
        ),
        backgroundColor: Colors.green,
      ),
    );
  }
}
