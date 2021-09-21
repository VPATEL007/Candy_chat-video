import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/app/AppConfiguration/AppNavigation.dart';
import 'package:video_chat/app/app.export.dart';
import 'package:video_chat/components/Model/User/UserModel.dart';
import 'package:video_chat/components/Screens/Home/Home.dart';
import 'package:video_chat/provider/followes_provider.dart';

class EditProfileScreen extends StatefulWidget {
  static const route = "EditProfileScreen";
  final bool isFromSignUp;

  const EditProfileScreen({Key? key, this.isFromSignUp = false})
      : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _nationController = TextEditingController();
  TextEditingController _aboutController = TextEditingController();
  Gender _gender = Gender.Male;
  bool isImage = false;

  UserModel? _userInfo;

  List<Asset>? get getSelectedAssets => _userInfo?.userImages!
      .where((image) => image.id == null && image.assetPath.isNotEmpty)
      .map<Asset>((img) => Asset(img.assetPath, img.assetPath, 0, 0))
      .toList();

  @override
  void initState() {
    super.initState();
    init();
  }

  List<int> removeImage = [];

  Future<void> init() async {
    _userInfo = Provider.of<FollowesProvider>(context, listen: false)
        .userModel!
        .toCloneInfo;
    if (_userInfo == null) {
      await Provider.of<FollowesProvider>(context, listen: false)
          .fetchMyProfile(context);
      _userInfo = Provider.of<FollowesProvider>(context, listen: false)
          .userModel!
          .toCloneInfo;
      if (mounted) setState(() {});
    }
    userNameController.text = _userInfo?.userName ?? "";
    _aboutController.text = _userInfo?.about ?? "";
    contactController.text = _userInfo?.phone ?? "";

    _gender = _userInfo?.gender == describeEnum(Gender.Female).toLowerCase()
        ? Gender.Female
        : _userInfo?.gender == describeEnum(Gender.Male).toLowerCase()
            ? Gender.Male
            : Gender.Other;
    genderController.text = describeEnum(_gender);
    _dobController.text = _userInfo?.dob ?? "";
    _nationController.text = _userInfo?.region?.regionName ?? "";
    if (_userInfo?.dob != null) {
      _selectedDate = DateTime.tryParse(_userInfo?.dob ?? "")!;
    }
    List<UserImage> userImages = [
      UserImage(),
      UserImage(),
      UserImage(),
      UserImage(),
      UserImage(),
      UserImage(),
    ];

    if (_userInfo?.userImages != null)
      for (var i = 0; i < _userInfo!.userImages!.length; i++) {
        userImages[i] = _userInfo!.userImages![i];
        isImage = true;
      }
    _userInfo?.userImages = userImages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading:
            widget.isFromSignUp == false ? getBackButton(context) : SizedBox(),
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
        child: getBottomButton(context, "Save Profile", () async {
          if (isValid()) {
            _userInfo?.userName = userNameController.text;
            _userInfo?.gender = genderController.text;
            _userInfo?.dob = _dobController.text;
            _userInfo?.region?.regionName = _nationController.text;
            _userInfo?.about = _aboutController.text;
            _userInfo?.phone = contactController.text;

            if (widget.isFromSignUp) {
              NetworkClient.getInstance.showLoader(context);
              await Provider.of<FollowesProvider>(context, listen: false)
                  .saveMyProfile(context, _userInfo, removeImage);
              NetworkClient.getInstance.hideProgressDialog();
              NavigationUtilities.pushReplacementNamed(Home.route);
            } else {
              Provider.of<FollowesProvider>(context, listen: false)
                  .saveMyProfile(context, _userInfo, removeImage);
              Navigator.of(context).pop();
            }
          }
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
                  children: List.generate(_userInfo?.userImages?.length ?? 0,
                      (index) {
                    // Asset asset = images[index];
                    return (_userInfo?.userImages?[index].photoUrl.isEmpty ??
                            true)
                        ? InkWell(
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
                          )
                        : Stack(
                            fit: StackFit.expand,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: SizedBox.expand(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: (_userInfo?.userImages?[index]
                                                .assetPath.isNotEmpty ??
                                            false)
                                        ? AssetThumb(
                                            asset: Asset(
                                                _userInfo?.userImages?[index]
                                                    .assetPath,
                                                _userInfo?.userImages?[index]
                                                    .assetPath,
                                                100,
                                                100),
                                            width: 100,
                                            height: 100,
                                          )
                                        : CachedNetworkImage(
                                            imageUrl: _userInfo
                                                    ?.userImages?[index]
                                                    .photoUrl ??
                                                "",
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
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
                                          removeImage.add(_userInfo
                                                  ?.userImages?[index].id ??
                                              0);
                                          _userInfo?.userImages?[index]
                                              .photoUrl = "";
                                          _userInfo?.userImages?[index].id =
                                              null;
                                          _userInfo?.userImages?[index]
                                              .assetPath = "";
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
                  style: appTheme?.settingMenu.copyWith(
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Username",
                  style: appTheme?.black16Medium.copyWith(),
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
                  "Contact no",
                  style: appTheme?.black16Medium.copyWith(),
                ),
                SizedBox(height: 5),
                CommonTextfield(
                  textOption: TextFieldOption(
                      keyboardType: TextInputType.phone,
                      hintText: "Contact no",
                      inputController: contactController),
                  textCallback: (text) {},
                ),
                SizedBox(height: 10),
                Text(
                  "Gender",
                  style: appTheme?.black16Medium.copyWith(),
                ),
                SizedBox(height: 5),
                CommonTextfield(
                  focusNode: AlwaysDisabledFocusNode(),
                  textOption: TextFieldOption(
                      textCapitalization: TextCapitalization.words,
                      hintText: "Gender",
                      inputController: genderController),
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
                                            _gender = gender!;
                                          });
                                          Navigator.of(context)
                                              .pop(describeEnum(gender!));
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
                  style: appTheme?.black16Medium.copyWith(),
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
                  "About me",
                  style: appTheme?.black16Medium.copyWith(),
                ),
                SizedBox(height: 5),
                CommonTextfield(
                  textOption: TextFieldOption(
                      hintText: "About me",
                      maxLine: 5,
                      inputController: _aboutController),
                  textCallback: (text) {},
                ),
                // SizedBox(height: 10),
                // Text(
                //   "Nation",
                //   style: appTheme.black16Medium.copyWith(),
                // ),
                // SizedBox(height: 5),
                // CommonTextfield(
                //   focusNode: AlwaysDisabledFocusNode(),
                //   textOption: TextFieldOption(
                //     postfixWid: Icon(Icons.arrow_drop_down_outlined),
                //     hintText: "Nation",
                //     inputController: _nationController,
                //   ),
                //   tapCallback: () {
                //     showCountryPicker(
                //       context: context,
                //       showPhoneCode: false,
                //       onSelect: (Country country) {
                //         print('Select country: ${country.displayName}');
                //         _nationController.text = country.name;
                //       },
                //       countryListTheme: CountryListThemeData(
                //         borderRadius: BorderRadius.only(
                //           topLeft: Radius.circular(30.0),
                //           topRight: Radius.circular(30.0),
                //         ),
                //         inputDecoration: InputDecoration(
                //           labelText: 'Search',
                //           hintText: 'Start typing to search',
                //           prefixIcon: const Icon(Icons.search),
                //           border: OutlineInputBorder(
                //             borderSide: BorderSide(
                //               color: const Color(0xFF8C98A8).withOpacity(0.2),
                //             ),
                //           ),
                //         ),
                //       ),
                //     );
                //   },
                //   textCallback: (String text) {},
                // ),
                SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    DateTime? newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
        builder: (BuildContext? context, Widget? child) {
          return child ?? Container();
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

  // Image Picker...
  loadAssets() async {
    int? maxImageSelectLength = _userInfo?.userImages!
        .where((maxImage) => maxImage.id == null)
        .toList()
        .length;
    try {
      List<Asset> _resultList = await MultiImagePicker.pickImages(
        maxImages: maxImageSelectLength ?? 0,
        enableCamera: true,
        selectedAssets: getSelectedAssets ?? [],
        materialOptions: MaterialOptions(
          actionBarTitle: "Video chat App",
        ),
      );
      if (_resultList.isNotEmpty) {
        // Whenever assign path to originalPhotoPath When then assign path to assetPath
        _userInfo?.userImages!
            .where((images) => images.photoUrl.isNotEmpty && images.id == null)
            .forEach((img) => img.photoUrl = "");

        _userInfo?.userImages!
            .where((images) => images.assetPath.isNotEmpty && images.id == null)
            .forEach((img) => img.assetPath = "");

        final bool resultLengthGeterThanProductImage =
            _resultList.length > (_userInfo?.userImages?.length ?? 0);
        final int resultLength = _resultList.length - 1;
        final int resultLengthMultiByProductLength =
            (resultLength - (_userInfo?.userImages?.length ?? 0));

        int imageIndex = 0;
        // If images is more then _listingObj.productImage.length then get only last _listingObj.productImage.length images...
        for (int i = (resultLengthGeterThanProductImage ? resultLength : 0);
            (resultLengthGeterThanProductImage
                ? i > resultLengthMultiByProductLength
                : i < _resultList.length);
            (resultLengthGeterThanProductImage ? i-- : i++)) {
          final String filePath = _resultList[i].identifier ?? "";

          imageIndex = resultLengthGeterThanProductImage
              ? ((i - resultLengthMultiByProductLength) - 1)
              : i;
          if (mounted) {
            isImage = true;
            setState(() {
              _userInfo?.userImages!
                  .where((img) => img.id == null)
                  .toList()[imageIndex]
                  .photoUrl = filePath;
              _userInfo?.userImages!
                  .where((img) => img.id == null)
                  .toList()[imageIndex]
                  .assetPath = filePath;
            });
            imageIndex--;
          }
        }
      }
    } on PlatformException catch (error) {
      print(error);
    } catch (error) {
      print(error);
    }
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  bool isValid() {
    if (userNameController.text.isEmpty) {
      View.showMessage(context, "Please enter Username.");
      return false;
    }

    // if (contactController.text.isEmpty) {
    //   View.showMessage(context, "Please enter Contact no.");
    //   return false;
    // }

    if (genderController.text.isEmpty) {
      View.showMessage(context, "Please select Gender.");
      return false;
    }

    if (_dobController.text.isEmpty) {
      View.showMessage(context, "Please select Date of Birth.");
      return false;
    }

    // if (_aboutController.text.isEmpty) {
    //   View.showMessage(context, "Please enter About me.");
    //   return false;
    // }

    if (_userInfo?.userImages == null) {
      View.showMessage(context, "Please select atleast one Photo.");
      return false;
    }

    if (_userInfo?.userImages?.length == 0) {
      View.showMessage(context, "Please select atleast one Photo.");
      return false;
    }

    if (isImage == false) {
      View.showMessage(context, "Please select atleast one Photo.");
      return false;
    }

    return true;
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

enum Gender { Male, Female, Other }
