class ApiConstants {
  static const String PROXY_URL = "PROXY 192.168.29.91:8888";

  static const String baseURL = "https://video-chat-prod.exdevcloud.com";
  static const String imageBaseURL = "https://video-chat-prod.exdevcloud.com";

  static const String socketUrl = "https://vc-socket.exdevcloud.com";
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
  static const String setUserStatus = 'profile/user-online-offline';
  static const String getUserStatus = 'user/is-online-offline';
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
  static const String resetNotification = "profile/reset-notification";
  static const String createChat = "chat-history";
  static const String dailyEarningReport = "profile/get-daily-influencer-earning-v2";
  static const String salaryDetails = "profile/get-salary-details";
  static const String rechargeNotification = "notification/get-all";
  static const String resetRechargeNotification = "notification/reset-notification";
  static const String weeklyEarningReport = "profile/get-weekly-influencer-earning-v2";
  static const String weeklyDetailEarningReport = "profile/host-salary/?";
  static const String dailyEarningDetailReport = "profile/get-detailed-influencer-earning-v2?";
  static const String getProfile = "profile/";
  static const String getAllAlbums = 'album/getAllAlbums';
  static const String createAlbum = 'album';
  static const String buyAlbum = 'album/buyAlbum';
  static const String chatList = "chat-history";
  static const String friendList = "chat/friendList";
  static const String blockList = "report/app/block-list";
  static const String unBlockUser = "report/remove-block";
  static const String visitorList = "profile/visitor-list";
  static const String videoChatHistory = 'call-history/get-call-logs';
  static const String getAllByInfluencer = 'profile/getAllByInfulencer';
  static const String favouriteList = "favourite/get";
  static const String updateCallStatus = "call-history/video-call-end";
  static const String userFeedBack = "feedback/user-feedback";
  static const String fetchGift = "gift/all";
  static const String buyGift = "gift/buy";
  static const String receivedGift = "gift/received";
  static const String startApp = "auth/app-open";
  static const String getById = "chat/getbyid";
  static const String logout = "auth/logout";
  static const String updateFCMToken = "profile/update-fcm";
  static const String withDrawRequest = "transaction/withdrawal-request";
  static const String paymentMethod = "payment-method/get-all";
  static const String withDrawRequestList =
      "transaction/app-withdrawal-requests";
  static const String verifyFace = "profile/face-verification";

  static const String invitationVerification = "profile/verify-invitation";

  static const String influeencerLeaderboard =
      "dashboard/get-top-weekly-infulencer";
  static const String influeencerEarningReport =
      "dashboard/get-earning-report-infulencer";
}
