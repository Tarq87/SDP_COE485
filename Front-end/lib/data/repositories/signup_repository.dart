import 'dart:convert';
import '../data_providers/signup_api.dart';
import '../models/signup.dart';

class SignupRepository {
  SignupRepository();
  final SignupAPI api = SignupAPI();

  Future<Signup> sendSignupDetail(
      String username, String email, String password) async {
    String rawSignup = await api.requestLogin(username, email, password);
    Signup signup = Signup.fromJson(jsonDecode(rawSignup));
    return signup;
  }
}
