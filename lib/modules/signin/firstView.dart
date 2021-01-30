import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:frolicsports/constance/constance.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:frolicsports/constance/themes.dart';

import 'package:image_picker/image_picker.dart';
import 'package:frolicsports/models/cityResponseData.dart';
import 'package:frolicsports/models/countryResponseData.dart';
import 'package:frolicsports/models/stateResponseData.dart';
import 'package:frolicsports/modules/home/tabScreen.dart';
import 'package:frolicsports/modules/login/continuebutton.dart';
import 'package:frolicsports/modules/login/loginScreen.dart';
import 'package:frolicsports/validator/validator.dart';

const double _kPickerSheetHeight = 216.0;

class FirstView extends StatefulWidget {
  final void Function() callBack;

  const FirstView({Key key, this.callBack}) : super(key: key);

  @override
  _FirstViewState createState() => _FirstViewState();
}

class _FirstViewState extends State<FirstView> {
  var countryList = List<CountryList>();
  var stateList = List<StateList>();
  var cityList = List<CityList>();

  var imageUrl = '';
  var userNameController = new TextEditingController();
  var emailController = new TextEditingController();
  var referCodeController = new TextEditingController();
  var phoneController = new TextEditingController();

  var userNameFocusNode = FocusNode();
  var emailFocusNode = FocusNode();
  var dobFocusNode = FocusNode();
  var stateFocusNode = FocusNode();
  var cityFocusNode = FocusNode();
  var referFocusNode = FocusNode();
  var date = DateTime.now();
  var isLoginProsses = false;
  CountryList selectedCountry;
  StateList slectedState;
  var _selectedStateIndex = 0;

  CityList slectedCity;
  var _selectedCityIndex = 0;

  String countryCode;
  File _image;

  final _formKey = GlobalKey<FormState>();

  Future getImage() async {
    File image;
    image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      File cropimage = await cropImage(image);
      if (cropimage != null) {
        if (!mounted) return;
        setState(() {
          _image = cropimage;
        });
      }
    }
  }

  String _validateUserName(String value) {
    return value.isEmpty ? 'UserName can not be empty' : null;
  }

  String _validateEmail(String value) {
    return value.isEmpty ? 'Email can not be empty' : !Validators().emailValidator(value) ? 'Email is not valid' : null;
  }

  @override
  void initState() {
    slectedState = StateList(name: 'selecte your state');
    stateList.insert(0, slectedState);
    slectedCity = CityList(name: 'selecte your city');
    cityList.insert(0, slectedCity);
    super.initState();
  }

  @override
  void dispose() {
    userNameController.dispose();
    emailController.dispose();
    referCodeController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ModalProgressHUD(
          inAsyncCall: isLoginProsses,
          color: Colors.transparent,
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 0, top: 50),
                child: Container(
                  padding: EdgeInsets.only(bottom: 0),
                  decoration: new BoxDecoration(
                    color: AllCoustomTheme.getThemeData().backgroundColor,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        new Container(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            children: <Widget>[
                              new Container(
                                padding: const EdgeInsets.only(top: 16),
                                child: new TextFormField(
                                  controller: userNameController,
                                  style: TextStyle(
                                    fontSize: ConstanceData.SIZE_TITLE16,
                                    color: AllCoustomTheme.getBlackAndWhiteThemeColors(),
                                  ),
                                  autofocus: false,
                                  focusNode: userNameFocusNode,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: new InputDecoration(
                                      labelText: 'Name',
                                      icon: Padding(
                                        padding: const EdgeInsets.only(top: 16),
                                        child: Icon(Icons.person),
                                      )),
                                  onEditingComplete: () {
                                    FocusScope.of(context).requestFocus(emailFocusNode);
                                  },
                                  validator: _validateUserName,
                                  onSaved: (value) {
                                    loginUserData.name = value;
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              new Container(
                                child: new TextFormField(
                                  controller: emailController,
                                  style: TextStyle(
                                    fontSize: ConstanceData.SIZE_TITLE16,
                                    color: AllCoustomTheme.getBlackAndWhiteThemeColors(),
                                  ),
                                  autofocus: false,
                                  focusNode: emailFocusNode,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: new InputDecoration(
                                    labelText: 'Email',
                                    icon: Padding(
                                      padding: const EdgeInsets.only(top: 14),
                                      child: Icon(Icons.email),
                                    ),
                                  ),
                                  onEditingComplete: () {
                                    FocusScope.of(context).requestFocus(dobFocusNode);
                                  },
                                  validator: _validateEmail,
                                  onSaved: (value) {
                                    loginUserData.email = value;
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              _buildDatePicker(context),
                              SizedBox(
                                height: 8,
                              ),
                              _buildGenderPickerDemo(context),
                              SizedBox(
                                height: 8,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              _buildStatePickerDemo(context),
                              SizedBox(
                                height: 16,
                              ),
                              _buildCityPickerDemo(context),
                              SizedBox(
                                height: 8,
                              ),
                              new Container(
                                child: new TextFormField(
                                  controller: referCodeController,
                                  style: TextStyle(
                                    fontSize: ConstanceData.SIZE_TITLE16,
                                    color: AllCoustomTheme.getBlackAndWhiteThemeColors(),
                                  ),
                                  autofocus: false,
                                  focusNode: referFocusNode,
                                  keyboardType: TextInputType.number,
                                  decoration: new InputDecoration(
                                    labelText: 'Refer Code',
                                    icon: Padding(
                                      padding: const EdgeInsets.only(top: 14),
                                      child: Icon(Icons.receipt),
                                    ),
                                  ),
                                  onEditingComplete: () {
                                    FocusScope.of(context).requestFocus(FocusNode());
                                  },
                                  onSaved: (value) {},
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              new Container(
                                child: TextFormField(
                                  controller: phoneController,
                                  style: TextStyle(
                                    fontSize: ConstanceData.SIZE_TITLE16,
                                    color: AllCoustomTheme.getBlackAndWhiteThemeColors(),
                                  ),
                                  autofocus: false,
                                  keyboardType: TextInputType.number,
                                  decoration: new InputDecoration(
                                    labelStyle: TextStyle(
                                      fontSize: ConstanceData.SIZE_TITLE16,
                                    ),
                                    labelText: 'Mobile Number',
                                    icon: Padding(
                                      padding: const EdgeInsets.only(top: 14),
                                      child: Icon(Icons.call),
                                    ),
                                  ),
                                  enabled: false,
                                ),
                              ),
                              SizedBox(
                                height: 24,
                              ),
                            ],
                          ),
                        ),
                        ContinueButton(
                          callBack: () {
                            FocusScope.of(context).requestFocus(new FocusNode());
                            _submit();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: 96,
                      width: 96,
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: <BoxShadow>[
                          BoxShadow(color: Colors.black45, offset: Offset(1.1, 1.1), blurRadius: 3.0),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          new ClipRRect(
                            borderRadius: new BorderRadius.circular(48.0),
                            child: Container(
                              decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: Container(
                                decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: CircleAvatar(
                                  radius: 48,
                                  child: _image == null
                                      ? loginUserData.image == '' || loginUserData.image == null
                                      ? Container(
                                    padding: EdgeInsets.all(0.0),
                                    child: Text(
                                      'C.',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                      ),
                                    ),
                                  )
                                      : new CachedNetworkImage(
                                    imageUrl: imageUrl,
                                    placeholder: (context, url) => CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                    ),
                                    errorWidget: (context, url, error) => new Icon(Icons.error),
                                    fit: BoxFit.cover,
                                  )
                                      : new Image.file(
                                    _image,
                                    fit: BoxFit.cover,
                                  ),
                                  backgroundColor: AllCoustomTheme.getThemeData().primaryColor,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    new Positioned(
                      left: 70.0,
                      top: 70.0,
                      child: Container(
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                          boxShadow: <BoxShadow>[
                            BoxShadow(color: Colors.black54, offset: Offset(1.1, 1.1), blurRadius: 2.0),
                          ],
                        ),
                        height: 20,
                        width: 20,
                        child: GestureDetector(
                          child: new CircleAvatar(
                            backgroundColor: AllCoustomTheme.getThemeData().backgroundColor,
                            child: Icon(Icons.edit, size: 14, color: AllCoustomTheme.getThemeData().primaryColor),
                          ),
                          onTap: () {
                            getImage();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () {
          showCupertinoModalPopup<void>(
            context: context,
            builder: (BuildContext context) {
              return _buildBottomPicker(
                CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (DateTime newDateTime) {
                    setState(() => date = newDateTime);
                  },
                ),
              );
            },
          );
        },
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 14, left: 4),
              child: Icon(
                FontAwesomeIcons.babyCarriage,
                color: HexColor('#8C8C8C'),
                size: 20,
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        'Date of Birth',
                        style: TextStyle(
                          fontSize: DateFormat.yMd().format(date) != DateFormat.yMd().format(DateTime.now())
                              ? ConstanceData.SIZE_TITLE12
                              : ConstanceData.SIZE_TITLE16,
                          color: HexColor('#8C8C8C'),
                        ),
                      ),
                    ),
                    DateFormat.yMd().format(date) != DateFormat.yMd().format(DateTime.now())
                        ? Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        DateFormat.yMd().format(date) != DateFormat.yMd().format(DateTime.now()) ? DateFormat.yMMMMd().format(date) : '',
                        style: TextStyle(
                          fontSize: ConstanceData.SIZE_TITLE16,
                          color: DateTime.now().difference(date).inDays >= 6570 ? AllCoustomTheme.getBlackAndWhiteThemeColors() : Colors.red,
                        ),
                      ),
                    )
                        : SizedBox(
                      width: 0,
                      height: 8,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Container(
                        height: 1.2,
                        color: HexColor('#8C8C8C'),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStatePickerDemo(BuildContext context) {
    final FixedExtentScrollController scrollController = FixedExtentScrollController(initialItem: _selectedStateIndex);
    return Container(
      child: InkWell(
        onTap: () async {
          if (stateList.length < 1) {
            if (countryList.length > 1) {}
          } else {
            await showCupertinoModalPopup<void>(
              context: context,
              builder: (BuildContext context) {
                return _buildBottomPicker(
                  CupertinoPicker(
                    scrollController: scrollController,
                    itemExtent: 44,
                    backgroundColor: CupertinoColors.white,
                    onSelectedItemChanged: (int index) {
                      setState(() => _selectedStateIndex = index);
                    },
                    children: List<Widget>.generate(stateList.length, (int index) {
                      return Center(
                        child: Text(stateList[index].name),
                      );
                    }),
                  ),
                );
              },
            );
          }
        },
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Icon(
                FontAwesomeIcons.map,
                color: HexColor('#8C8C8C'),
                size: 24,
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'State',
                        style: TextStyle(
                          fontSize: ConstanceData.SIZE_TITLE12,
                          color: HexColor('#8C8C8C'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        stateList[_selectedStateIndex].name,
                        style: TextStyle(
                          fontSize: ConstanceData.SIZE_TITLE16,
                          color: AllCoustomTheme.getBlackAndWhiteThemeColors(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Container(
                        height: 1.2,
                        color: HexColor('#8C8C8C'),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCityPickerDemo(BuildContext context) {
    final FixedExtentScrollController scrollController = FixedExtentScrollController(initialItem: _selectedCityIndex);
    return Container(
      child: InkWell(
        onTap: () async {
          if (cityList.length < 1) {
          } else {
            await showCupertinoModalPopup<void>(
              context: context,
              builder: (BuildContext context) {
                return _buildBottomPicker(
                  CupertinoPicker(
                    scrollController: scrollController,
                    itemExtent: 44,
                    backgroundColor: CupertinoColors.white,
                    onSelectedItemChanged: (int index) {
                      setState(() => _selectedCityIndex = index);
                    },
                    children: List<Widget>.generate(cityList.length, (int index) {
                      return Center(
                        child: Text(cityList[index].name),
                      );
                    }),
                  ),
                );
              },
            ).then((t) {
              slectedCity = cityList[_selectedCityIndex];
            });
          }
        },
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Icon(
                Icons.location_city,
                color: HexColor('#8C8C8C'),
                size: 24,
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'City',
                        style: TextStyle(
                          fontSize: ConstanceData.SIZE_TITLE12,
                          color: HexColor('#8C8C8C'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        cityList[_selectedCityIndex].name,
                        style: TextStyle(
                          fontSize: ConstanceData.SIZE_TITLE16,
                          color: AllCoustomTheme.getBlackAndWhiteThemeColors(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Container(
                        height: 1.2,
                        color: HexColor('#8C8C8C'),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  var genderList = ['male', 'female', 'other'];
  var selectedGender = 'male';
  var genderListIndex = 0;
  Widget _buildGenderPickerDemo(BuildContext context) {
    final FixedExtentScrollController scrollController = FixedExtentScrollController(initialItem: genderListIndex);
    return Container(
      child: InkWell(
        onTap: () async {
          await showCupertinoModalPopup<void>(
            context: context,
            builder: (BuildContext context) {
              return _buildBottomPicker(
                CupertinoPicker(
                  scrollController: scrollController,
                  itemExtent: 44,
                  backgroundColor: CupertinoColors.white,
                  onSelectedItemChanged: (int index) {
                    setState(() => genderListIndex = index);
                  },
                  children: List<Widget>.generate(genderList.length, (int index) {
                    return Center(
                      child: Text(genderList[index][0].toUpperCase() + genderList[index].substring(1).toLowerCase()),
                    );
                  }),
                ),
              );
            },
          ).then((t) {
            selectedGender = genderList[genderListIndex];
          });
        },
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Icon(
                FontAwesomeIcons.male,
                color: HexColor('#8C8C8C'),
                size: 24,
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'Gender',
                        style: TextStyle(
                          fontSize: ConstanceData.SIZE_TITLE12,
                          color: HexColor('#8C8C8C'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        genderList[genderListIndex][0].toUpperCase() + genderList[genderListIndex].substring(1).toLowerCase(),
                        style: TextStyle(
                          fontSize: ConstanceData.SIZE_TITLE16,
                          color: AllCoustomTheme.getBlackAndWhiteThemeColors(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Container(
                        height: 1.2,
                        color: HexColor('#8C8C8C'),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBottomPicker(Widget picker) {
    return Container(
      height: _kPickerSheetHeight,
      padding: const EdgeInsets.only(top: 6.0),
      color: CupertinoColors.white,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: CupertinoColors.black,
          fontSize: 22.0,
        ),
        child: SafeArea(
          top: false,
          child: picker,
        ),
      ),
    );
  }

  Future<File> cropImage(File imageFile) async {
    File croppedFile = await ImageCropper.cropImage(
      androidUiSettings: AndroidUiSettings(
        toolbarColor: AllCoustomTheme.getThemeData().backgroundColor,
      ),
      aspectRatio: CropAspectRatio(
        ratioX: 1.0,
        ratioY: 1.0,
      ),
      sourcePath: imageFile.path,
      maxWidth: 512,
      maxHeight: 512,
    );
    return croppedFile;
  }

  void _submit() async {
    FocusScope.of(context).requestFocus(FocusNode());

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TabScreen(),
      ),
    );
  }
}
