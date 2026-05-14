abstract class AuthEvent {}
class LoginEvent extends AuthEvent{
  String email;
  String password;

  LoginEvent(this.email, this.password);
}
class RegisterEvent extends AuthEvent{
  String email;
  String password;

  RegisterEvent(this.email, this.password);
}

class LogoutEvent extends AuthEvent{}

class ForgotPasswordEvent extends AuthEvent {
  final String email;

  ForgotPasswordEvent(this.email);
}

class ResetAuthStateEvent extends AuthEvent {}