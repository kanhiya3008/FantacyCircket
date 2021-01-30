import 'package:flutter/material.dart';
import 'package:frolicsports/constance/constance.dart';
import 'package:frolicsports/constance/themes.dart';
import 'package:frolicsports/modules/contests/contestsScreen.dart';
import 'package:frolicsports/modules/result/resultContest.dart';
import 'package:frolicsports/validator/validator.dart';

import 'joinContestPlayerpoint.dart';

class StandingResult extends StatefulWidget {
  @override
  _StandingResultState createState() => _StandingResultState();
}

class _StandingResultState extends State<StandingResult> {
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
      child: Scaffold(
        backgroundColor: AllCoustomTheme.getThemeData().backgroundColor,
        appBar: AppBar(
          title: Text(
            "Joined Contests",
            style: TextStyle(
              color: AllCoustomTheme.getReBlackAndWhiteThemeColors(),
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            MatchHadder(),
            Padding(
              padding: EdgeInsets.only(left: 8, right: 8, top: 4),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        "SCORECARD",
                        style: TextStyle(
                          color: HexColor(
                            '#AAAFBC',
                          ),
                          fontSize: 14,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        "SA   213-10",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "  (49.5)",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: HexColor(
                            '#AAAFBC',
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('|'),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "IND   224-8",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "  (50)",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: HexColor(
                            '#AAAFBC',
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        'India won by 11 runs',
                        style: TextStyle(
                          fontSize: 14,
                          color: HexColor(
                            '#AAAFBC',
                          ),
                        ),
                      )
                    ],
                  ),
                  Divider(
                    color: HexColor(
                      '#AAAFBC',
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JoinContestPlayerPoint(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'View Player Status',
                          style: TextStyle(
                            fontSize: 14,
                            color: AllCoustomTheme.getThemeData().primaryColor,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                        )
                      ],
                    ),
                  ),
                  Divider(
                    color: AllCoustomTheme.getBlackAndWhiteThemeColors(),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResultContestScreen(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text(
                              'Prize Pool',
                              style: TextStyle(
                                color: HexColor(
                                  '#AAAFBC',
                                ),
                                fontSize: ConstanceData.SIZE_TITLE14,
                              ),
                            ),
                            Text(
                              '₹25',
                              style: TextStyle(
                                fontSize: ConstanceData.SIZE_TITLE20,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              'Spots',
                              style: TextStyle(
                                color: HexColor(
                                  '#AAAFBC',
                                ),
                                fontSize: ConstanceData.SIZE_TITLE14,
                              ),
                            ),
                            Text(
                              '2',
                              style: TextStyle(
                                color: HexColor(
                                  '#AAAFBC',
                                ),
                                fontSize: ConstanceData.SIZE_TITLE14,
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              'Entry',
                              style: TextStyle(
                                color: HexColor(
                                  '#AAAFBC',
                                ),
                                fontSize: ConstanceData.SIZE_TITLE14,
                              ),
                            ),
                            Text(
                              '₹15',
                              style: TextStyle(),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Container(
                    height: 24,
                    color: Color(0xFFf5f5f5),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10, left: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Oliver Smith(T1)',
                            style: TextStyle(
                              fontSize: ConstanceData.SIZE_TITLE12,
                            ),
                          ),
                          Text(
                            '132.0',
                            style: TextStyle(
                              fontSize: ConstanceData.SIZE_TITLE12,
                              color: HexColor(
                                '#AAAFBC',
                              ),
                            ),
                          ),
                          Text(
                            '#2',
                            style: TextStyle(
                              fontSize: ConstanceData.SIZE_TITLE12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
