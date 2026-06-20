import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motqin/core/storage/secure_storage.dart';
import 'package:motqin/features/auth/models/auth_models.dart';
import 'package:motqin/features/auth/services/auth_service.dart';
import 'package:motqin/core/network/api_exception.dart';

// ════════════════════════════════════════════════════════════════════════════
// EVENTS
// ════════════════════════════════════════════════════════════════════════════

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;
  const AuthLoginRequested({required this.email, required this.password});
  @override
  List<Object?> get props => [email, password];
}

class AuthRegisterRequested extends AuthEvent {
  final String userName;
  final String email;
  final String password;
  final String role;
  const AuthRegisterRequested({
    required this.userName,
    required this.email,
    required this.password,
    required this.role,
  });
  @override
  List<Object?> get props => [userName, email, password, role];
}

class AuthVerifyEmailRequested extends AuthEvent {
  final String email;
  final String code;
  const AuthVerifyEmailRequested({required this.email, required this.code});
  @override
  List<Object?> get props => [email, code];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

class AuthCheckStatusRequested extends AuthEvent {
  const AuthCheckStatusRequested();
}

// ════════════════════════════════════════════════════════════════════════════
// STATES
// ════════════════════════════════════════════════════════════════════════════

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

/// App just launched, checking stored token
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Waiting for API response
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// User is authenticated
class AuthAuthenticated extends AuthState {
  final String userId;
  final String email;
  const AuthAuthenticated({required this.userId, required this.email});
  @override
  List<Object?> get props => [userId, email];
}

/// User is NOT authenticated
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Registration succeeded — user needs to verify email
class AuthRegistrationSuccess extends AuthState {
  final String email; // to pass to the verify screen
  const AuthRegistrationSuccess({required this.email});
  @override
  List<Object?> get props => [email];
}

/// Email verified successfully
class AuthEmailVerified extends AuthState {
  const AuthEmailVerified();
}

/// Any auth error
class AuthError extends AuthState {
  final String message;
  const AuthError({required this.message});
  @override
  List<Object?> get props => [message];
}

// ════════════════════════════════════════════════════════════════════════════
// BLOC
// ════════════════════════════════════════════════════════════════════════════

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;

  AuthBloc({required AuthService authService})
      : _authService = authService,
        super(const AuthInitial()) {
    on<AuthCheckStatusRequested>(_onCheckStatus);
    on<AuthLoginRequested>(_onLogin);
    on<AuthRegisterRequested>(_onRegister);
    on<AuthVerifyEmailRequested>(_onVerifyEmail);
    on<AuthLogoutRequested>(_onLogout);
  }

  // ── Check if already logged in (call on app start) ──────────────────────
  Future<void> _onCheckStatus(
    AuthCheckStatusRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final loggedIn = await _authService.isLoggedIn();
      if (loggedIn) {
        // Load saved user info
        
        final userId = await SecureStorage.getUserId() ?? '';
        final email = await SecureStorage.getUserEmail() ?? '';
        emit(AuthAuthenticated(userId: userId, email: email));
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (_) {
      emit(const AuthUnauthenticated());
    }
  }

  // ── Login ────────────────────────────────────────────────────────────────
  Future<void> _onLogin(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final response = await _authService.login(
        LoginDto(emailAddress: event.email, password: event.password),
      );
      emit(AuthAuthenticated(
        userId: response.userId ?? '',
        email: response.email ?? event.email,
      ));
    } on ApiException catch (e) {
      emit(AuthError(message: e.arabicMessage));
    } catch (e) {
      emit(AuthError(message: 'حدث خطأ غير متوقع'));
    }
  }

  // ── Register ─────────────────────────────────────────────────────────────
  Future<void> _onRegister(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await _authService.register(RegisterDto(
        userName: event.userName,
        emailAddress: event.email,
        password: event.password,
        role: event.role,
      ));
      emit(AuthRegistrationSuccess(email: event.email));
    } on ApiException catch (e) {
      emit(AuthError(message: e.arabicMessage));
    } catch (e) {
      emit(AuthError(message: 'حدث خطأ غير متوقع'));
    }
  }

  // ── Verify Email ─────────────────────────────────────────────────────────
  Future<void> _onVerifyEmail(
    AuthVerifyEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await _authService.verifyEmail(email: event.email, code: event.code);
      emit(const AuthEmailVerified());
    } on ApiException catch (e) {
      emit(AuthError(message: e.arabicMessage));
    } catch (e) {
      emit(AuthError(message: 'حدث خطأ غير متوقع'));
    }
  }

  // ── Logout ───────────────────────────────────────────────────────────────
  Future<void> _onLogout(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authService.logout();
    emit(const AuthUnauthenticated());
  }
}
