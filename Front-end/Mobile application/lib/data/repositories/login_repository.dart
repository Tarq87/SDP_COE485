import 'dart:convert';
import '../data_providers/login_api.dart';
import '../models/login.dart';

class LoginRepository {
  LoginRepository();
  final LoginAPI api = LoginAPI();

  Future<Login> sendLoginDetail(String email, String password) async {
    String rawLogin = await api.requestLogin(email, password);
    Login login = Login.fromJson(jsonDecode(rawLogin));
    return login;
  }
}
