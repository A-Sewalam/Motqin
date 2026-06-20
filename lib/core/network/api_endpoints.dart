class ApiEndpoints {
  static const String baseUrl = 'https://motqin-demo-1.runasp.net';

  // Authentication
  static const String register    = '/api/Authentication/register-user';
  static const String verifyEmail = '/api/Authentication/VerifyEmailAuthority';
  static const String login       = '/api/Authentication/login-user';
  static const String refreshToken = '/api/Authentication/refresh-token';
  static const String googleLogin  = '/api/Authentication/google-regester-or-login';

  // Users
  static const String users         = '/api/Users';
  static String userById(String id) => '/api/Users/$id';

  // Subjects
  static const String subjects              = '/api/Subjects';
  static String subjectById(int id)         => '/api/Subjects/$id';
  static String startSession(int sessionId) => '/api/Subjects/Start/$sessionId';
  static String endSession(int sessionId)   => '/api/Subjects/End/$sessionId';

  // Lessons
  static const String lessons       = '/api/Lessons';
  static String lessonById(int id)  => '/api/Lessons/$id';

  // Questions
  static const String questions                 = '/api/Questions';
  static String questionById(int id)            => '/api/Questions/Question/Get/$id';
  static const String questionsByLesson         = '/api/Questions/get-by-lesson';
  static const String questionsByCategoryLesson = '/api/Questions/get-by-category-and-lesson';
  static String startQuestion(int id)           => '/api/Questions/Start/$id';
  static String endQuestion(int id)             => '/api/Questions/End/$id';
  static const String createMcq                 = '/api/Questions/mcq';
  static const String createFill                = '/api/Questions/fill';
  static String updateMcq(int id)               => '/api/Questions/mcq/$id';
  static String updateFill(int id)              => '/api/Questions/fill/$id';
  static String deleteQuestion(int id)          => '/api/Questions/$id';
}
