package jp.co.felicapocketmk.karadalive_flutter_plugin

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.util.Log
import com.google.android.gms.auth.api.signin.GoogleSignIn
import com.google.android.gms.fitness.FitnessOptions
import com.google.android.gms.fitness.data.DataType
import dev.flutter.pigeon.Pigeon
import io.flutter.embedding.android.FlutterActivity
import jp.co.felicapocketmk.karadalive_flutter_plugin.define.GoogleFit
import jp.co.felicapocketmk.karadalive_flutter_plugin.define.RequestCode.REQUEST_OAUTH
import jp.co.felicapocketmk.karadalive_flutter_plugin.util.Logger

class HostAndroidFitnessApi(private val context: Context, private val activity: Activity) :
    Pigeon.AndroidFitnessApi, KaradaliveFlutterPlugin.GoogleSignInDelegate {
    private var checkFitnessPermissionStatusResult: Pigeon.Result<Pigeon.FitnessRequestPermissionResultObject>? =
        null

    override fun requestFitnessPermissionStatus(result: Pigeon.Result<Pigeon.FitnessRequestPermissionResultObject>?) {
        checkFitnessPermissionStatusResult = result
        requestFitness()
    }

    override fun googleSignInHasPermissions(result: Pigeon.Result<Boolean>?) {
        val hasPermissions = googleSignInHasPermissions()
        result?.success(hasPermissions)
    }

    private fun postResult(value: Pigeon.FitnessRequestPermissionResult) {
        val requestPermissionResult =
            Pigeon.FitnessRequestPermissionResultObject.Builder().setValue(value).build()
        try {
            checkFitnessPermissionStatusResult?.success(requestPermissionResult)
        } catch (t: Throwable) {
            // おそらくpigeonのbug 下記リンクのissue参考
            // https://github.com/flutter/flutter/issues/72240
            Logger.e(Log.getStackTraceString(t))
            Logger.w("おそらくPigeonのbug ライブラリのバージョン上げたら直るかも")
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        Logger.d(this.javaClass.name, "===== onActivityResult =====")
        Logger.d(this.javaClass.name, "requestCode:$requestCode")
        Logger.d(
            this.javaClass.name,
            "resultCode:$resultCode"
        ) // Google APIsでクライアントの認証情報が作成されていないと0になるので注意
        Logger.d(this.javaClass.name, "============================")

        // GoogleFitインストールチェック
        val googleFitIntent =
            context.packageManager.getLaunchIntentForPackage(GoogleFit.PACKAGE_NAME.value)
        googleFitIntent ?: run {
            postResult(Pigeon.FitnessRequestPermissionResult.fitnessNotInstalled)
            return
        }

        if (requestCode == REQUEST_OAUTH) {
            if (resultCode == FlutterActivity.RESULT_OK) {
                postResult(Pigeon.FitnessRequestPermissionResult.granted)
                return
            } else {
                // Fitnessパーミッションが許可されていない
                postResult(Pigeon.FitnessRequestPermissionResult.fitnessNotGranted)
                return
            }
        } else {
            postResult(Pigeon.FitnessRequestPermissionResult.noGoogleAccountConfirmed)
            return
        }
    }

    private fun googleSignInHasPermissions(): Boolean {
        return GoogleSignIn.hasPermissions(GoogleSignIn.getLastSignedInAccount(context))
    }

    private fun requestFitness() {
        // GoogleSignIn.requestPermissions を発行すると
        // Fitnessで使用するGoogleアカウント選択ダイアログが表示され
        // その後 onActivityResult が呼ばれる。
        GoogleSignIn.requestPermissions(
            activity,
            REQUEST_OAUTH, GoogleSignIn.getLastSignedInAccount(context),
            FitnessOptions
                .builder()
                .addDataType(DataType.TYPE_STEP_COUNT_CUMULATIVE)
                .addDataType(DataType.TYPE_STEP_COUNT_DELTA)
                .addDataType(DataType.TYPE_DISTANCE_DELTA)
                .build()
        )
    }
}