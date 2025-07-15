abstract class SignupEvent {}

class SignupSubmitted extends SignupEvent {
  final String email;
  final String password;

  SignupSubmitted(this.email, this.password);
}
