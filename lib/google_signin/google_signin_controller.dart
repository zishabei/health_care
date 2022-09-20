import 'package:health_care/pigeons/steps.dart';
import 'package:state_notifier/state_notifier.dart';
import 'google_signin_state.dart';

class GoogleSigninController extends StateNotifier<GoogleSigninState>
    with LocatorMixin {
  GoogleSigninController(GoogleSigninState state) : super(state);

  Future<bool?> googleSignInHasPermissionsAndroid() async {
    try {
      state = const GoogleSigninState.loading();
      var result = await AndroidFitnessApi().googleSignInHasPermissions();

      if (result) {
        state = const GoogleSigninState.success();
      } else {
        state = const GoogleSigninState.error("notAuthorized");
      }
      return result;
    } catch (e) {
      state = const GoogleSigninState.error("notAuthorized");
    }
    return null;
  }

  Future<FitnessRequestPermissionResultObject?>
      requestFitnessPermissionAndroid() async {
    try {
      state = const GoogleSigninState.loading();
      var result = await AndroidFitnessApi().requestFitnessPermissionStatus();
      if (result.value == FitnessRequestPermissionResult.granted) {
        state = const GoogleSigninState.success();
      } else {
        state = const GoogleSigninState.error('notAuthorized');
      }
      return result;
    } catch (e) {
      state = const GoogleSigninState.error("notAuthorized");
    }
    return null;
  }
}
