part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class SignupLoading extends AuthenticationState {}

class VerifyPhoneNumberLoading extends AuthenticationState {}

class SignupLoaded extends AuthenticationState {
  final DocumentReference<User>? reference;

  const SignupLoaded({
    required this.reference,
  });
}

class GenericError extends AuthenticationState {
  final String errorMessage;
  const GenericError({required this.errorMessage});
}

class HomePageGet extends AuthenticationState {
  const HomePageGet();
}

class SignupComplete extends AuthenticationState {
  const SignupComplete();
}

class CodeSent extends AuthenticationState {
  final String verifyId;
  final int? token;
  const CodeSent({required this.verifyId, required this.token});
}

class CodeCompleted extends AuthenticationState {
  final auth.PhoneAuthCredential authCredential;
  const CodeCompleted({required this.authCredential});
}

class VerifyOTPLoading extends AuthenticationState {}

class VerifyOTPLoaded extends AuthenticationState {
  final auth.User user;
  const VerifyOTPLoaded({required this.user});
}

class VerifyOTPFailed extends AuthenticationState {
  final String errorMessage;
  const VerifyOTPFailed({required this.errorMessage});
}

class GetCacheDataLoaded extends AuthenticationState {
  final User user;

  const GetCacheDataLoaded({required this.user});

}

class GetCacheDataError extends AuthenticationState {
  final String errorMessage;
  const GetCacheDataError({required this.errorMessage});
}
