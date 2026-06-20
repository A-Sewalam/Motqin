// ── LoginDto ───────────────────────────────────────────────────────────────
class LoginDto {
  final String emailAddress;
  final String password;

  const LoginDto({required this.emailAddress, required this.password});

  Map<String, dynamic> toJson() => {
        'emailAddress': emailAddress,
        'password': password,
      };
}

// ── RegisterDto ────────────────────────────────────────────────────────────
class RegisterDto {
  final String userName;
  final String emailAddress;
  final String password;
  final String role; // 'Student' or 'Teacher'

  const RegisterDto({
    required this.userName,
    required this.emailAddress,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toJson() => {
        'userName': userName,
        'emailAddress': emailAddress,
        'password': password,
        'role': role,
      };
}

// ── TokenResponse ─────────────────────────────────────────────────────────
// The login response shape — adjust field names if your backend returns different keys
class TokenResponse {
  final String token;
  final String refreshToken;
  final String? userId;
  final String? email;

  const TokenResponse({
    required this.token,
    required this.refreshToken,
    this.userId,
    this.email,
  });

  factory TokenResponse.fromJson(Map<String, dynamic> json) => TokenResponse(
        token: json['token'] as String,
        refreshToken: json['refreshToken'] as String,
        userId: json['userId'] as String?,
        email: json['email'] as String?,
      );
}

// ── TokenRequestDto ────────────────────────────────────────────────────────
class TokenRequestDto {
  final String token;
  final String refreshToken;

  const TokenRequestDto({required this.token, required this.refreshToken});

  Map<String, dynamic> toJson() => {
        'token': token,
        'refreshToken': refreshToken,
      };
}
