package jp.co.felicapocketmk.karadalive_flutter_plugin

import android.app.Activity
import android.content.Context
import android.content.Intent
import androidx.annotation.NonNull
import dev.flutter.pigeon.Pigeon
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import jp.co.felicapocketmk.karadalive_flutter_plugin.define.RequestCode.REQUEST_OAUTH
import jp.co.felicapocketmk.karadalive_flutter_plugin.util.Logger

/** KaradaliveFlutterPlugin */
class KaradaliveFlutterPlugin: FlutterPlugin, MethodCallHandler,
  ActivityAware, PluginRegistry.ActivityResultListener {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var hostAndroidFitnessApi: HostAndroidFitnessApi
  private lateinit var nativeStepApi: FlutterCallNativeApi
  private lateinit var activityBinding : ActivityPluginBinding
  private lateinit var activity : Activity
  private lateinit var context : Context
  private lateinit var pluginBinding : FlutterPlugin.FlutterPluginBinding

  interface GoogleSignInDelegate {
    fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?)
  }

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    this.channel = MethodChannel(flutterPluginBinding.binaryMessenger, "karadalive_flutter_plugin")
    this.channel.setMethodCallHandler(this)
    this.context = flutterPluginBinding.applicationContext
    this.pluginBinding = flutterPluginBinding
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}\nworked by: KaradaliveFlutterPlugin")
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    this.channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    binding.addActivityResultListener(this)
    this.activityBinding = binding
    this.activity = binding.activity
    this.nativeStepApi = FlutterCallNativeApi(this.context)
    this.hostAndroidFitnessApi = HostAndroidFitnessApi(this.context, this.activity)
    Pigeon.AndroidFitnessApi.setup(this.pluginBinding.binaryMessenger, this.hostAndroidFitnessApi)
    Pigeon.FlutterCallNativeApi.setup(this.pluginBinding.binaryMessenger, this.nativeStepApi)
  }

  override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
    if (requestCode == REQUEST_OAUTH) {
      Logger.i("REQUEST_OAUTH called : " + this.activity?.packageName) // 呼び出し元のパッケージ名確認
      this.hostAndroidFitnessApi.onActivityResult(requestCode, resultCode, data)
      return true
    } else {
      return false
    }
  }

  override fun onDetachedFromActivityForConfigChanges() {
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
  }

  override fun onDetachedFromActivity() {
    this.activityBinding.removeActivityResultListener(this)
  }
}