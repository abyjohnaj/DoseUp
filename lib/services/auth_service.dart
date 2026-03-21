import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    // Step 1: Create the auth user
    final res = await supabase.auth.signUp(
      email: email,
      password: password,
    );

    final user = res.user;

    // FIX: Guard against null user (can happen if email confirmation is ON
    // and Supabase returns a session-less response)
    if (user == null) {
      throw Exception(
        "Registration failed or email confirmation required. "
        "Please check your inbox and confirm your email before logging in.",
      );
    }

    // Step 2: Insert profile into public.users
    // FIX: Use upsert so re-registering the same email doesn't double-insert
    await supabase.from('users').upsert({
      'id': user.id,       // must match auth.users(id) — the FK target
      'name': name,
      'email': email,
      'role': role,
    });
  }

  Future<void> signIn(String email, String password) async {
    await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }
}