import 'dart:io';

import '../app.export.dart';

class ApiConstants {
  static const String PROXY_URL = "PROXY 172.20.10.6:8888"; // Brijesh

  static const String baseURL = "http://194.195.118.99";
  static const String imageBaseURL = "http://194.195.118.99";
  static const String documentUpload = apiUrl + "media/upload";

  static const String apiUrl = baseURL + "/api/";

  //Sync Master API
  static const String syncMaster = "v1/sync-masters";

  //Authentication API
  static const String login = "auth/login";
  static const String forgotPassword = "auth/forgot-password";
  static const String resendOTP = "auth/resend-otp";
  static const String resetPassword = "auth/reset-password";
  static const String forgotOTPVerification = "auth/verify-otp";
  static const String loginOTP = "auth/user/login-via-otp";
  static const String changePassword = "auth/user/1/change-password";
  static const String logout = "auth/user/logout";
  static const String updateProfile = "auth/user/profile/update/";
  static const String addEmployee = "v1/admin/employees";

  //Dashboard Api's
  static const String getWorkspace = "v1/admin/workspaces";
  static const String createWorkspace = "v1/admin/workspaces";
  static const String updateWorkspace = "v1/admin/workspaces/";
  static const String partiallyUpdateWorkspace =
      "v1/admin/workspaces/partiallyUpdate/";
  static const String deleteWorkspace = "v1/admin/workspaces/";

  //Leave Api's
  static const String addLeaveConfiguration = "v1/leave-settings";
  static const String getLeaveConfiguration = "v1/leave-settings/list";
  static const String updateLeaveConfiguration = "v1/leave-settings/";
  static const String deleteLeaveConfiguration = "v1/leave-settings/";
}
