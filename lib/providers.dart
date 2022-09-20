import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'google_signin/google_signin_controller.dart';
import 'google_signin/google_signin_state.dart';

final googleSigninProvider = StateNotifierProvider<GoogleSigninController, GoogleSigninState>((ref) {
  return GoogleSigninController(const GoogleSigninState.initialize());
});