class ApiConstants {
  static const String PROXY_URL = "PROXY 103.206.138.230:8888";

  static const String baseURL =
      "http://video-chat-dev-1463852847.ap-south-1.elb.amazonaws.com";
  static const String imageBaseURL =
      "http://video-chat-dev-1463852847.ap-south-1.elb.amazonaws.com";
  static const String documentUpload = apiUrl + "media/upload";

  static const String apiUrl = baseURL + "/dev/";

  static const String inAppVerfiySandBoxURL =
      "https://sandbox.itunes.apple.com/verifyReceipt";
  static const String inAppVerfiyURL =
      "https://buy.itunes.apple.com/verifyReceipt";

  static const String appleAppSpecificPassword = "ddbf-lijs-mjtx-ixam";

  //Authentication API
  static const String login = "auth/social-login";
  static const String guestLogin = "auth/guest-login";
  static const String onboarding = "app-home-screen/get-by-language";
  static const String allLanguage = "language/get-active";
  static const String matchProfile = "profile/get-profiles-conversation";
  static const String myProfile = "profile/me";
  static const String reportReason = "report/get-reasons";
  static const String feedbacks = "feedback/get-categories";
  static const String fetchTags = "feedback/get-all";
  static const String setFeedback = "feedback/set";
  static const String reportBlock = "report/block";
  static const String selectGender = "profile/set-prefered-gender";
  static const String updateProfile = "profile/update";
  static const String getFollowing = "follow/get-following";
  static const String paymentHistory = "transaction/app-transaction-history";
  static const String unFollowUser = "follow/remove";
  static const String followUser = "follow/set";
  static const String getFollowes = "follow/get-follower";
  static const String startVideoCall = "call-history/video-call-start";
  static const String receiveVideoCall = "call-history/video-call-received";
  static const String getRTMToken = "call-history/rtm-token";
  static const String buyPackage = "transaction/buy-coin-package";
  static const String coinBalance = "call-history/balance-status";
  static const String blockUser = "profile/block-unblock-profile";
  static const String createChat = "chat-history";
  static const String getProfile = "profile/";
  static const String chatList = "chat-history";
}
