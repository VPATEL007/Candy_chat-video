import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const DEVICE_TYPE_ANDROID = 1; //Android
const DEVICE_TYPE_IOS = 2; //IOS
const DEFAULT_PAGE = 1;
const DEFAULT_LIMIT = 8;
const SUCCESS = 1;
const FAIL = 2;

const IMAGE_FILE_SIZE = 10.0;

const MIN_ORDER_QTY = 1;
const MAX_ORDER_QTY = 999;

const DEFAULT_RING_SIZE_KEY = "DEFAULT_RING_SIZE_KEY";

const APPNAME = "Covid App";
const STRIPE_KEY = "pk_test_ZCG3mwYMaOFEFAdpcQtkNIZ300fxNZXXOj";

const CODE_CREATED = 201;
const CODE_OK = "OK";
const E_FORBIDDEN = "E_FORBIDDEN";

const MISMATCHED_TIME_ZONE = "MISMATCHED_TIME_ZONE";
const CODE_UNAUTHORIZED = "E_UNAUTHORIZED";
const CODE_TOKEN_EXPIRE = "E_TOKEN_EXPIRE";
const CODE_ERROR = "E_ERROR";
const CODE_DEVICE_LOGOUT = "CODE_DEVICE_LOGOUT";
const CODE_KILL_SWITCH = "CODE_KILL_SWITCH";
const CODE_USER_DELETED = "CODE_USER_DELETED";
const TOKEN_EXPIRY_CODE = "TOKEN_EXPIRY_CODE";
const INTERNET_UNAWAILABLE = "INTERNET_UNAWAILABLE";
const NO_CONNECTION = "Internet unavailable.";
const MOBILE_NOT_VERIFIED = "Your mobile is not verified.";
const SOMETHING_WENT_WRONG = "Something went wrong, please try again later.";
const PARSING_WRONG = "Something went wrong, please try again later.";
const createdAt_DESC = "createdAt DESC";
const successStatusCode = 200;
const addedSuccesStatusCode = 201;
const notFoundStatusCode = 404;

const masterSyncInitial = "1970-01-01T00:00:00+00:00";

const RegexForEmoji =
    r'(?:[\u2700-\u27bf]|(?:\ud83c[\udde6-\uddff]){2}|[\ud800-\udbff][\udc00-\udfff]|[\u0023-\u0039]\ufe0f?\u20e3|\u3299|\u3297|\u303d|\u3030|\u24c2|\ud83c[\udd70-\udd71]|\ud83c[\udd7e-\udd7f]|\ud83c\udd8e|\ud83c[\udd91-\udd9a]|\ud83c[\udde6-\uddff]|\ud83c[\ude01-\ude02]|\ud83c\ude1a|\ud83c\ude2f|\ud83c[\ude32-\ude3a]|\ud83c[\ude50-\ude51]|\u203c|\u2049|[\u25aa-\u25ab]|\u25b6|\u25c0|[\u25fb-\u25fe]|\u00a9|\u00ae|\u2122|\u2139|\ud83c\udc04|[\u2600-\u26FF]|\u2b05|\u2b06|\u2b07|\u2b1b|\u2b1c|\u2b50|\u2b55|\u231a|\u231b|\u2328|\u23cf|[\u23e9-\u23f3]|[\u23f8-\u23fa]|\ud83c\udccf|\u2934|\u2935|[\u2190-\u21ff])';
// r'((\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff]))';
const RegexForTextField =
    r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff]|[ -%^&"!#])';

const RegexForStrongPasswd =
    r'(^(?=.*[A-Z].*[A-Z])(?=.*[!@#$&*])(?=.*[0-9].*[0-9])(?=.*[a-z].*[a-z].*[a-z]).{8}$)';
//check number
const numberRegExp = r'[a-z][A-Z]!@#$%^&*()_+{}:">?<,./;';
// DB Constant
const alphaNumberRegEx = r'[a-zA-Z0-9]';
const alphaRegEx = r'[a-zA-Z]';
const spaceRegEx = r'\s';

class UserRole {
  static const ADMIN = "ADMIN";
  static const SUPER_ADMIN = "SUPER_ADMIN";
  static const GYM_OWNER = "GYM_OWNER";
  static const MEMBER = "MEMBER";
  static const STAFF = "STAFF";
}

class MasterCodeConstant {
  static const DESIGNATION = "DESIGNATION";
  static const DOCUMENT = "DOCUMENT";
  static const SPECIALIZATION = "SPECIALIZATION";
  static const LANGUAGE = "LANGUAGE";
  static const EDUCATION_LEVEL = "GRADUATIONS";
  static const DEPARTMENT = "DEPARTMENT";
  static const REGIONS = "REGIONS";
  static const LEAVE_TYPES = "LEAVE_TYPES";
}

List<Color> randomColorArr = [
  Color(0xFF6F3F87),
  Color(0xFF507D8F),
  Color(0xFF3186B9),
  Color(0xFF76B3CC)
];
