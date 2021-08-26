import 'package:country_picker/country_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/components/Model/User/UserModel.dart';
import 'package:video_chat/provider/followes_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  List<Asset> images = <Asset>[];
  TextEditingController userNameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _nationController = TextEditingController();
  Gender _gender = Gender.Male;

  UserModel _userInfo;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    _userInfo = Provider.of<FollowesProvider>(context, listen: false).userModel;
    if (_userInfo == null) {
      await Provider.of<FollowesProvider>(context, listen: false)
          .fetchMyProfile(context);
      _userInfo =
          Provider.of<FollowesProvider>(context, listen: false).userModel;
      if (mounted) setState(() {});
    }
    userNameController.text = _userInfo?.providerDisplayName ?? "";
    genderController.text = _userInfo?.gender ?? "";
    _gender = _userInfo?.gender == describeEnum(Gender.Female).toLowerCase()
        ? Gender.Female
        : _userInfo?.gender == describeEnum(Gender.Male).toLowerCase()
            ? Gender.Male
            : Gender.Other;
    _dobController.text = _userInfo?.dob ?? "";
    _nationController.text = _userInfo?.region?.regionName ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: getBackButton(context),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            getColorText("Edit ", ColorConstants.black,
                fontSize: getFontSize(18)),
            getColorText("Profile", ColorConstants.red,
                fontSize: getFontSize(18)),
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: getBottomButton(context, "Save Profile", () {
          _userInfo?.providerDisplayName = userNameController.text;
          _userInfo?.gender = genderController.text;
          _userInfo?.dob = _dobController.text;
          _userInfo?.region?.regionName = _nationController.text;
          Provider.of<FollowesProvider>(context, listen: false)
              .saveMyProfile(context, _userInfo);
          Navigator.of(context).pop();
        }),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: getSize(30), right: getSize(30)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 10,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: (images?.isEmpty ?? true)
                      ? List.generate(6, (index) {
                          return InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () {
                              loadAssets();
                            },
                            child: Image.asset(
                              "assets/Profile/no_image.png",
                              width: 100,
                              height: 100,
                            ),
                          );
                        })
                      : List.generate(images.length, (index) {
                          Asset asset = images[index];
                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: SizedBox.expand(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: AssetThumb(
                                      asset: asset,
                                      width: 100,
                                      height: 100,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: InkWell(
                                    onTap: () {
                                      if (mounted) {
                                        setState(() {
                                          images.removeAt(index);
                                        });
                                      }
                                    },
                                    child: Image.asset(
                                      "assets/Profile/close.png",
                                      height: 15,
                                      width: 15,
                                    )),
                              )
                            ],
                          );
                        }),
                ),
                SizedBox(height: 30),
                Text(
                  "Personal details",
                  style: appTheme.settingMenu.copyWith(
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Username",
                  style: appTheme.black16Medium.copyWith(),
                ),
                SizedBox(height: 5),
                CommonTextfield(
                  textOption: TextFieldOption(
                      hintText: "Username",
                      inputController: userNameController),
                  textCallback: (text) {},
                ),
                SizedBox(height: 10),
                Text(
                  "Gender",
                  style: appTheme.black16Medium.copyWith(),
                ),
                SizedBox(height: 5),
                CommonTextfield(
                  focusNode: AlwaysDisabledFocusNode(),
                  textOption: TextFieldOption(
                      hintText: "Gender", inputController: genderController),
                  tapCallback: () async {
                    String gender = await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: StatefulBuilder(
                              builder: (context, setState) => Column(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(
                                    Gender.values.length,
                                    (index) => RadioListTile<Gender>(
                                        value: Gender.values[index],
                                        groupValue: _gender,
                                        title: Text(
                                            describeEnum(Gender.values[index])),
                                        onChanged: (gender) {
                                          setState(() {
                                            _gender = gender;
                                          });
                                          Navigator.of(context)
                                              .pop(describeEnum(gender));
                                        })),
                              ),
                            ),
                          );
                        });
                    if (gender != null) genderController.text = gender;
                  },
                  textCallback: (String text) {},
                ),
                SizedBox(height: 10),
                Text(
                  "Date of Birth",
                  style: appTheme.black16Medium.copyWith(),
                ),
                SizedBox(height: 5),
                CommonTextfield(
                  focusNode: AlwaysDisabledFocusNode(),
                  textOption: TextFieldOption(
                    postfixWid: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset(
                        "assets/Profile/calendar.png",
                        height: 10,
                        width: 10,
                      ),
                    ),
                    hintText: "Date of Birth",
                    inputController: _dobController,
                  ),
                  tapCallback: () {
                    _selectDate(context);
                  },
                  textCallback: (String text) {},
                ),
                SizedBox(height: 10),
                Text(
                  "Nation",
                  style: appTheme.black16Medium.copyWith(),
                ),
                SizedBox(height: 5),
                CommonTextfield(
                  focusNode: AlwaysDisabledFocusNode(),
                  textOption: TextFieldOption(
                    postfixWid: Icon(Icons.arrow_drop_down_outlined),
                    hintText: "Nation",
                    inputController: _nationController,
                  ),
                  tapCallback: () {
                    showCountryPicker(
                      context: context,
                      showPhoneCode: false,
                      onSelect: (Country country) {
                        print('Select country: ${country.displayName}');
                        _nationController.text = country.name;
                      },
                      countryListTheme: CountryListThemeData(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                        inputDecoration: InputDecoration(
                          labelText: 'Search',
                          hintText: 'Start typing to search',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: const Color(0xFF8C98A8).withOpacity(0.2),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  textCallback: (String text) {},
                ),
                SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2040),
        builder: (BuildContext context, Widget child) {
          return child;
        });

    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      _dobController
        ..text = DateFormat.yMMMd().format(_selectedDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: _dobController.text.length,
            affinity: TextAffinity.upstream));
    }
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 6,
        enableCamera: true,
        selectedAssets: images,
        materialOptions: MaterialOptions(
          actionBarTitle: "Video chat App",
        ),
      );
    } on Exception catch (e) {
      print(e);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
    });
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

enum Gender { Male, Female, Other }
