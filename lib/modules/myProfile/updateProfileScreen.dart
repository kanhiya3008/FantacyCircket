import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:frolicsports/constance/constance.dart';
import 'package:frolicsports/constance/themes.dart';
import 'package:frolicsports/models/cityResponseData.dart';
import 'package:frolicsports/models/countryResponseData.dart';
import 'package:frolicsports/models/stateResponseData.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:intl/intl.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frolicsports/models/userData.dart';
import 'package:frolicsports/validator/validator.dart';

class UpdateProfileScreen extends StatefulWidget {
  final UserData loginUserData;

  const UpdateProfileScreen({Key key, this.loginUserData}) : super(key: key);
  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  UserData loginUserData;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isProsses = false;
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

  var genderList = ['male', 'female', 'other'];
  var selectedGender = 'male';
  var genderListIndex = 0;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    loginUserData = widget.loginUserData;
    userNameController.text = loginUserData.name;
    emailController.text = loginUserData.email;
    referCodeController.text = loginUserData.referral;
    phoneController.text = loginUserData.mobileNumber;
    imageUrl = loginUserData.image;

    if (loginUserData.gender == 'male') {
      selectedGender = loginUserData.gender;
      genderListIndex = 0;
    }
    if (loginUserData.gender == 'female') {
      selectedGender = loginUserData.gender;
      genderListIndex = 1;
    }

    date = DateFormat.yMd().parse(loginUserData.dob);
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
                inAsyncCall: isLoginProsses,
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
                                            Icons.close,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          'Update Profile',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w500,
                                            color: AllCoustomTheme.getThemeData().backgroundColor,
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
                          child: SingleChildScrollView(
                            padding: EdgeInsets.only(top: 16, bottom: 60),
                            physics: BouncingScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Stack(
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
                                                      ? loginUserData.image == '' || loginUserData.image == '' || loginUserData.image == null
                                                          ? Container(
                                                              padding: EdgeInsets.all(0.0),
                                                              child: Image.asset(
                                                                ConstanceData.playerImage,
                                                                fit: BoxFit.cover,
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
                                                  backgroundColor: Colors.transparent,
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
                                        height: 24,
                                        width: 24,
                                        child: GestureDetector(
                                          child: new CircleAvatar(
                                            backgroundColor: AllCoustomTheme.getThemeData().backgroundColor,
                                            child: Icon(
                                              Icons.edit,
                                              size: 18,
                                              color: AllCoustomTheme.getThemeData().primaryColor,
                                            ),
                                          ),
                                          onTap: () {
                                            getImage();
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      children: <Widget>[
                                        new Container(
                                          padding: EdgeInsets.only(right: 16),
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
                                                    ),
                                                  ),
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
                                                  enabled: false,
                                                  decoration: new InputDecoration(
                                                    labelText: 'Email',
                                                    icon: Padding(
                                                      padding: const EdgeInsets.only(top: 14),
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
                                              // SizedBox(
                                              //   height: 8,
                                              // ),
                                              // _buildStatePickerDemo(context),
                                              // SizedBox(
                                              //   height: 16,
                                              // ),
                                              // _buildCityPickerDemo(context),
                                              // SizedBox(
                                              //   height: 8,
                                              // ),
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
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 60,
                      padding: EdgeInsets.only(left: 50, right: 50, bottom: 20),
                      child: Container(
                        decoration: new BoxDecoration(
                          color: AllCoustomTheme.getThemeData().primaryColor,
                          borderRadius: new BorderRadius.circular(4.0),
                          boxShadow: <BoxShadow>[
                            BoxShadow(color: Colors.black.withOpacity(0.5), offset: Offset(0, 1), blurRadius: 5.0),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: new BorderRadius.circular(4.0),
                            onTap: () async {
                              FocusScope.of(context).requestFocus(new FocusNode());
                              _submit();
                            },
                            child: Center(
                              child: Text(
                                'Update Profile',
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
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

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
      height: 216.0,
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

  void _submit() async {
    FocusScope.of(context).requestFocus(FocusNode());

    if (_formKey.currentState.validate() == false) {
      return;
    }
    if (DateTime.now().difference(date).inDays < 6570) {
      showInSnackBar("Please!, Enter your valid birth date.");
      return;
    }

    _formKey.currentState.save();
    loginUserData.name = userNameController.text;
    loginUserData.dob = DateFormat('dd/MM/yyyy').format(date);
    loginUserData.gender = genderList[genderListIndex];
    loginUserData.email = emailController.text;
    loginUserData.state = stateList[_selectedStateIndex].name;
    loginUserData.city = cityList[_selectedCityIndex].name;
    loginUserData.referral = referCodeController.text;

    setState(() {
      isLoginProsses = true;
    });

    Fluttertoast.showToast(msg: 'Succsessfull Update Profile', timeInSecForIos: 3);
    Navigator.pop(context);

    setState(() {
      isLoginProsses = false;
    });
  }
}
