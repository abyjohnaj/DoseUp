import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  // REGISTER
  Future signUp({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final res = await supabase.auth.signUp(
      email: email,
      password: password,
    );

    final user = res.user;

    // save extra user data
    await supabase.from('users').insert({
      'id': user!.id,
      'name': name,
      'email': email,
      'role': role,
    });
  }

  // LOGIN
  Future signIn(String email, String password) async {
    await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future signOut() async {
    await supabase.auth.signOut();
  }
}