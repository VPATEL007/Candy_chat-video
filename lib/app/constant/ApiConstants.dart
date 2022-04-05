class ApiConstants {
  static const String PROXY_URL = "PROXY 192.168.29.91:8888";

  static const String baseURL =
      "http://video-chat-dev-1463852847.ap-south-1.elb.amazonaws.com";
  static const String imageBaseURL = "https://video-chat-prod.exdevcloud.com";

  static const String socketUrl =
      "https://videochat-socket-dev-163916015.ap-south-1.elb.amazonaws.com";
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
  static const String fetchTags = "feedback/tags";
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
  static const String blockList = "report/app/block-list";
  static const String unBlockUser = "report/remove-block";
  static const String visitorList = "profile/visitor-list";
  static const String favouriteList = "favourite/get";
  static const String updateCallStatus = "call-history/video-call-end";
  static const String userFeedBack = "feedback/user-feedback";
  static const String fetchGift = "gift/all";
  static const String buyGift = "gift/buy";
  static const String receivedGift = "gift/received";
  static const String startApp = "auth/app-open";
  static const String logout = "auth/logout";
  static const String updateFCMToken = "profile/update-fcm";
  static const String withDrawRequest = "transaction/withdrawal-request";
  static const String paymentMethod = "payment-method/get-all";
  static const String withDrawRequestList =
      "transaction/app-withdrawal-requests";
       static const String verifyFace =
      "profile/face-verification";

  static const String invitationVerification = "profile/verify-invitation";

  static const String influeencerLeaderboard =
      "dashboard/get-top-weekly-infulencer";
  static const String influeencerEarningReport =
      "dashboard/get-earning-report-infulencer";
}
