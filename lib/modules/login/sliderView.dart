import 'package:flutter/material.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:frolicsports/constance/constance.dart';
import 'package:frolicsports/constance/themes.dart';

class SliderView extends StatefulWidget {
  @override
  _SliderViewState createState() => _SliderViewState();
}

class _SliderViewState extends State<SliderView> {
  var pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Flexible(
            child: Container(
              child: PageView(
                controller: pageController,
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  ImageListView(
                    imageAsset: 'assets/cricketImage1.png',
                    txt: 'Select A Match',
                    subTxt:
                        'Select any of the upcoming matches from any of the current or\nupcoming cricket series',
                  ),
                  ImageListView(
                    imageAsset: 'assets/cricketImage2.png',
                    txt: 'Join A Contest',
                    subTxt:
                        'join any free or cash contest to win cash and the ultimate\nbragging rights to showoff your improvement in the free/Skill\ncontests on Fixturers!',
                  ),
                  ImageListView(
                    imageAsset: 'assets/cricketImage3.png',
                    txt: 'Create Your Team',
                    subTxt:
                        'Use your sports knowledge and showcase your skills to create\nyour team within a budget of 100 credits',
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 30,
            child: Center(
              child: PageIndicator(
                layout: PageIndicatorLayout.WARM,
                size: 10.0,
                controller: pageController,
                space: 5.0,
                count: 3,
                color: AllCoustomTheme.getThemeData()
                    .backgroundColor
                    .withOpacity(0.5),
                activeColor: AllCoustomTheme.getThemeData().backgroundColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ImageListView extends StatelessWidget {
  final String imageAsset;
  final String txt;
  final String subTxt;

  const ImageListView(
      {Key key, this.imageAsset, this.txt = '', this.subTxt = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width - 60,
              child: Image.asset(imageAsset),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              txt,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width >= 340
                    ? ConstanceData.SIZE_TITLE18
                    : ConstanceData.SIZE_TITLE14,
                fontWeight: FontWeight.bold,
                color: AllCoustomTheme.getThemeData().backgroundColor,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 4),
            child: Text(
              subTxt,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width >= 340
                    ? ConstanceData.SIZE_TITLE12
                    : ConstanceData.SIZE_TITLE10,
                color: AllCoustomTheme.getThemeData()
                    .backgroundColor
                    .withOpacity(0.8),
              ),
            ),
          )
        ],
      ),
    );
  }
}
