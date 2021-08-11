class ApiConstants {
  static const String PROXY_URL = "PROXY 103.206.138.230:8888"; // Brijesh

  static const String baseURL =
      "http://video-chat-dev-1463852847.ap-south-1.elb.amazonaws.com";
  static const String imageBaseURL =
      "http://video-chat-dev-1463852847.ap-south-1.elb.amazonaws.com";
  static const String documentUpload = apiUrl + "media/upload";

  static const String apiUrl = baseURL + "/dev/";

  //Authentication API
  static const String login = "auth/social-login";
  static const String onboarding = "app-home-screen/get-all";
  static const String allLanguage = "language/get-all";
}
