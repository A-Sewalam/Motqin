class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException({required this.message, this.statusCode});

  @override
  String toString() => 'ApiException($statusCode): $message';

  String get arabicMessage {
    switch (statusCode) {
      case 400: return 'بيانات غير صحيحة، يرجى التحقق من المدخلات';
      case 401: return 'غير مصرح، يرجى تسجيل الدخول مجدداً';
      case 403: return 'ليس لديك صلاحية للوصول';
      case 404: return 'العنصر المطلوب غير موجود';
      case 409: return 'البيانات موجودة مسبقاً';
      case 500: return 'خطأ في الخادم، يرجى المحاولة لاحقاً';
      default:  return 'حدث خطأ، يرجى المحاولة مرة أخرى';
    }
  }
}
