import 'package:motqin/core/network/api_client.dart';
import 'package:motqin/core/network/api_endpoints.dart';
import 'package:motqin/core/storage/secure_storage.dart';
import 'package:motqin/features/auth/models/auth_models.dart';

class AuthService {
  final ApiClient _client;

  const AuthService(this._client);

  /// Register a new user. Returns true on success.
  Future<void> register(RegisterDto dto) async {
    await _client.post(ApiEndpoints.register, data: dto.toJson());
  }

  /// Verify email with the code sent to the user.
  Future<void> verifyEmail({required String email, required String code}) async {
    await _client.post(
      ApiEndpoints.verifyEmail,
      queryParams: {'email': email, 'code': code},
    );
  }

  /// Login and persist token. Returns the token response.
  Future<TokenResponse> login(LoginDto dto) async {
    final response = await _client.post(
      ApiEndpoints.login,
      data: dto.toJson(),
    );

    final tokenResponse = TokenResponse.fromJson(
      response.data as Map<String, dynamic>,
    );

    // Persist tokens and user info securely
    await SecureStorage.saveToken(tokenResponse.token);
    await SecureStorage.saveRefreshToken(tokenResponse.refreshToken);
    if (tokenResponse.userId != null) {
      await SecureStorage.saveUserId(tokenResponse.userId!);
    }
    if (tokenResponse.email != null) {
      await SecureStorage.saveUserEmail(tokenResponse.email!);
    }

    return tokenResponse;
  }

  /// Google login/register.
  Future<TokenResponse> googleLogin(String idToken) async {
    final response = await _client.post(
      ApiEndpoints.googleLogin,
      data: {'idToken': idToken},
    );

    final tokenResponse = TokenResponse.fromJson(
      response.data as Map<String, dynamic>,
    );

    await SecureStorage.saveToken(tokenResponse.token);
    await SecureStorage.saveRefreshToken(tokenResponse.refreshToken);
    if (tokenResponse.userId != null) {
      await SecureStorage.saveUserId(tokenResponse.userId!);
    }

    return tokenResponse;
  }

  /// Logout — clears all stored tokens.
  Future<void> logout() async {
    await SecureStorage.clearAll();
  }

  /// Check if a token exists (user is logged in).
  Future<bool> isLoggedIn() async {
    final token = await SecureStorage.getToken();
    return token != null && token.isNotEmpty;
  }
}
