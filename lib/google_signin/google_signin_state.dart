import 'package:freezed_annotation/freezed_annotation.dart';
part 'google_signin_state.freezed.dart';

@freezed
class GoogleSigninState with _$GoogleSigninState {
  const factory GoogleSigninState.success() = _Success;

  const factory GoogleSigninState.error(String errorText) = _Error;

  const factory GoogleSigninState.loading() = _Loading;

  const factory GoogleSigninState.initialize() = _Initialize;
}
