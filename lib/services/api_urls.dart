class ApiUrls {
  //static const String baseUrl = "http://217.15.170.117";
  static const String baseUrl = "https://mihad4000.merinasib.shop/api/v1";


  //static const String imageBaseUrl = "http://217.15.170.117/";
  static const String imageBaseUrl = "https://mihad4000.merinasib.shop/";


  //static const String socketUrl = "http://217.15.170.117";
  static const String socketUrl = "https://mihad4000.merinasib.shop";

  static const String register = '/users/register';
  static const String verifyOtp = '/auth/verify-otp';
  static const String uploadPhoto = '/gallery/upload';
  static const String login = '/auth/login';
  static const String forgetPassword = '/auth/forget-password';
  static  const String  resendOtp = '/auth/resend-otp';
  static  const String  resetPassword = '/auth/reset-password';
  static  const String  profiles = '/profiles';
  static  const String  interest = '/profiles/interest-values';
  static  const String  location = '/profiles/location';
  static   String  swipeProfile(limit,page,goal,age,minimumDistance) => '/profiles/v2?limit=$limit&page=$page&goal=$goal&age=$age&minimumDistance=$minimumDistance';
  static   String  matchCreate(String userId) => '/match?userID=$userId';
  static   String  profileDetails(String userId) => '/profiles/$userId';
  static   String  likeRewind(String userId) => '/match/likes/rewind?userId=$userId';
  static   String  notification(int page,int limit) => '/notification?page=$page&limit=$limit';
  static   String  allPost(int page,int limit,String? userId) => '/timeline?page=$page&limit=$limit&userId=$userId';
  static   String  socialPost(int page,int limit) => '/timeline/social?page=$page&limit=$limit';
  static   String  conversation(int page,int limit) => '/conversation?limit=$limit&page=$page';
  static   String  message(String conversationId, int page,int limit) => '/message/$conversationId?page=$page&limit=$limit';
  static   String  block(String conversationId) => '/conversation/block/$conversationId';
  static   String  conversationMedia(String conversationId,int page,int limit) => '/conversation/media/$conversationId?page=$page&limit=$limit';
  static  const String  myProfile = '/users/info/me';
  static  const String  terms = '/settings/terms-and-conditions';
  static  const String  about = '/settings/about-us';
  static  const String  privacy = '/settings/privacy-policy';
  static  const String  changePassword = '/auth/reset-password';
  static  const String  updateProfile = '/users/update-profile';
  static  const String  fileSend = '/message';
  static  const String  postCreate = '/timeline/post';
  static  const String  gifts = '/gifts';
  static  const String  balance = '/balance';
  static  const String  gallery = '/gallery';
  static  const String  sendGifts = '/balance/';
  static  const String  topUp = '/stripe/create-payment-intent';
  static  const String  withdraw = '/transections/withdraw';
  static  const String  bankInfo = '/payment/info';
  static  const String  bankInfoGet = '/payment/info/me';
  static   String  like(String postId) => '/timeline/like?postId=$postId';
  static   String  balanceVersion(String userId) => '/balance/verify/$userId';
  static   String  comment(String postId,int page,int limit) => '/timeline/post/$postId/comment?page=$page&limit=$limit';
  static   String  createComment(String postId) => '/timeline/post/$postId/comment';
  static   String  transHistory(int page,int limit) => '/transections/gifts?page=$page&limit=$limit';
  static   String  myTransHistory(int page,int limit) => '/transections/balance?page=$page&limit=$limit';
  static   String  photoDeleted(String id) => '/gallery/$id';
  static   String  postDeleted(String id) => '/timeline/post/$id';
  static   String  postEdit(String id) => '/timeline/post/$id';
  static   String  postSearch(String term,int page,int limit) => '/users/find?page=$page&limit=$limit&term=$term';







}
