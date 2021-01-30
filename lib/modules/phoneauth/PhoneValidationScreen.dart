import 'package:country_pickers/country.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frolicsports/utils/config.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:frolicsports/bloc/phoneEnteryBloc.dart';
import 'package:frolicsports/bloc/phoneVerificationBloc.dart';
import 'package:frolicsports/constance/constance.dart';
import 'package:frolicsports/constance/themes.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:frolicsports/modules/login/continuebutton.dart';
import 'package:frolicsports/constance/global.dart' as globals;
import 'package:frolicsports/modules/login/otpValidationScreen.dart';
import 'package:url_launcher/url_launcher.dart';

var selectedCountryCode = '91';

class PhoneValidationScreen extends StatefulWidget {
  @override
  _PhoneValidationScreenState createState() => _PhoneValidationScreenState();
}

class _PhoneValidationScreenState extends State<PhoneValidationScreen>
    with TickerProviderStateMixin {
  String countryCode;
  AnimationController _animationController;
  Country _selectedCupertinoCountry =
      CountryPickerUtils.getCountryByIsoCode('in');

  var phonNumberContorller = new TextEditingController();
  var phoneFocusNode = FocusNode();
  var phonNumber = '';

  final phoneEntryBloc = PhoneEntryBloc();
  var isLoginProsses = false;
  bool ismove = false;

  @override
  void initState() {
    globals.phoneVerificationBloc = PhoneVerificationBloc();
    _animationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 400));
    super.initState();
  }

  @override
  void dispose() {
    phoneFocusNode.dispose();
    phonNumberContorller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          color: AllCoustomTheme.getThemeData().backgroundColor,
        ),
        SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: ModalProgressHUD(
              inAsyncCall: isLoginProsses,
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                child: Stack(
                  children: <Widget>[
                    Container(
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width,
                            maxHeight: MediaQuery.of(context).size.height -
                                MediaQuery.of(context).padding.top,
                          ),
                          child: Column(
                            children: <Widget>[
                              Stack(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(
                                      top: 24,
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 14,right: 4),
                                            child: Container(
                                              width: 30,
                                              child: Icon(Icons.arrow_back),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          appName,
                                          style: TextStyle(
                                            fontSize: 30,
                                            color:
                                                AllCoustomTheme.getThemeData()
                                                    .primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 14,
                                    child: _help(),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              _row1(),
                              SizedBox(
                                height: 10,
                              ),
                              _phonNumber(),
                              Flexible(
                                child: Container(
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        child: RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text:
                                                    'By continue, you are agree to our ',
                                                style: TextStyle(
                                                  fontSize: ConstanceData
                                                      .SIZE_TITLE12,
                                                  color: AllCoustomTheme
                                                      .getTextThemeColors(),
                                                ),
                                              ),
                                              TextSpan(
                                                text: 'Terms of Service',
                                                style: TextStyle(
                                                  fontSize: ConstanceData
                                                      .SIZE_TITLE12,
                                                  color: AllCoustomTheme
                                                          .getThemeData()
                                                      .primaryColor,
                                                ),
                                                recognizer:
                                                    new TapGestureRecognizer()
                                                      ..onTap = () async {
                                                        const url =
                                                            ConstanceData
                                                                .TermsofService;
                                                        if (await canLaunch(
                                                            url)) {
                                                          await launch(url);
                                                        } else {
                                                          throw 'Could not launch $url';
                                                        }
                                                      },
                                              ),
                                              TextSpan(
                                                text: '\n & ',
                                                style: TextStyle(
                                                  fontSize: ConstanceData
                                                      .SIZE_TITLE12,
                                                  color: AllCoustomTheme
                                                      .getTextThemeColors(),
                                                ),
                                              ),
                                              TextSpan(
                                                text: 'Privacy Policy',
                                                style: TextStyle(
                                                  fontSize: ConstanceData
                                                      .SIZE_TITLE12,
                                                  color: AllCoustomTheme
                                                          .getThemeData()
                                                      .primaryColor,
                                                ),
                                                recognizer:
                                                    new TapGestureRecognizer()
                                                      ..onTap = () async {
                                                        const url =
                                                            ConstanceData
                                                                .PrivacyPolicy;
                                                        if (await canLaunch(
                                                            url)) {
                                                          await launch(url);
                                                        } else {
                                                          throw 'Could not launch $url';
                                                        }
                                                      },
                                              ),
                                              TextSpan(
                                                text: '.',
                                                style: TextStyle(
                                                  fontSize: ConstanceData
                                                      .SIZE_TITLE12,
                                                  color: AllCoustomTheme
                                                      .getTextThemeColors(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Stack(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: <Widget>[
                                new SizeTransition(
                                  sizeFactor: new CurvedAnimation(
                                      parent: _animationController,
                                      curve: Curves.fastOutSlowIn),
                                  axis: Axis.horizontal,
                                  child: ContinueButton(
                                    callBack: () async {
                                      FocusScope.of(context)
                                          .requestFocus(new FocusNode());
                                      if (globals.connectivityBloc.isOffLine ==
                                          true) {
                                        Fluttertoast.showToast(
                                            msg: ConstanceData.NoInternet,
                                            timeInSecForIos: 3);
                                        return;
                                      }
                                      setState(() {
                                        isLoginProsses = true;
                                      });

                                      await Future.delayed(
                                          const Duration(seconds: 1));

                                      Fluttertoast.showToast(
                                          msg:
                                              "Your phone verification successful.",
                                          timeInSecForIos: 3);

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              OtpValidationScreen(),
                                        ),
                                      );

                                      setState(() {
                                        isLoginProsses = false;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _help() {
    return Container(
      padding: EdgeInsets.only(top: 28, right: 10),
      child: Row(
        children: <Widget>[
          Icon(
            FontAwesomeIcons.questionCircle,
            size: 14,
          ),
          SizedBox(
            width: 4,
          ),
          Text(
            'Help',
            style: TextStyle(
              fontSize: ConstanceData.SIZE_TITLE10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _row1() {
    return Row(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Please enter your 10-digit\nmobile number.',
            style: TextStyle(
              fontSize: ConstanceData.SIZE_TITLE14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _phonNumber() {
    return new Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 28),
            child: Row(
              children: <Widget>[
                InkWell(
                  child: _buildCupertinoSelectedItem(_selectedCupertinoCountry),
                  onTap: _openCupertinoCountryPicker,
                ),
              ],
            ),
          ),
          Flexible(
            child: Container(
              padding: EdgeInsets.only(left: 16),
              child: BlocBuilder<PhoneEntryBloc, PhoneEntryBlocState>(
//                bloc: phoneEntryBloc,
                builder: (BuildContext context, PhoneEntryBlocState state) =>
                    Theme(
                  data: AllCoustomTheme.buildLightTheme().copyWith(
                      backgroundColor: Colors.transparent,
                      scaffoldBackgroundColor: Colors.transparent),
                  child: TextField(
                    controller: phonNumberContorller,
                    style: TextStyle(
                      fontSize: ConstanceData.SIZE_TITLE16,
                      color: AllCoustomTheme.getBlackAndWhiteThemeColors(),
                    ),
                    autofocus: true,
                    focusNode: phoneFocusNode,
                    keyboardType: TextInputType.number,
                    decoration: new InputDecoration(
                      labelText: 'Mobile Number',
                      errorText: state.isPhoneError
                          ? 'phone length should be proper.'
                          : null,
                      prefix: Text("+${_selectedCupertinoCountry.phoneCode} "),
                    ),
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    onChanged: (txt) {
                      phoneEntryBloc.onPhoneChanges(txt);
                      if (txt.length > 4) {
                        _animationController.forward();
                      } else {
                        _animationController.reverse();
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCupertinoSelectedItem(Country country) {
    return Row(
      children: <Widget>[
        CountryPickerUtils.getDefaultFlagImage(country),
      ],
    );
  }

  void _openCupertinoCountryPicker() => showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return CountryPickerCupertino(
            backgroundColor: AllCoustomTheme.getThemeData().backgroundColor,
            itemBuilder: _buildCupertinoItem,
            pickerSheetHeight: 250.0,
            pickerItemHeight: 60,
            initialCountry: _selectedCupertinoCountry,
            onValuePicked: (Country country) {
              selectedCountryCode = _selectedCupertinoCountry.phoneCode;
              setState(() => _selectedCupertinoCountry = country);
            });
      });

  Widget _buildCupertinoItem(Country country) => Container(
        padding: EdgeInsets.only(left: 32, right: 32),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            CountryPickerUtils.getDefaultFlagImage(country),
            SizedBox(width: 8.0),
            Expanded(
              child: Text(
                country.name,
                maxLines: 3,
                style: TextStyle(
                  fontSize: ConstanceData.SIZE_TITLE16,
                ),
              ),
            ),
            Container(
              child: Text(
                "+${country.phoneCode}",
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: ConstanceData.SIZE_TITLE16,
                ),
              ),
            ),
          ],
        ),
      );
}
