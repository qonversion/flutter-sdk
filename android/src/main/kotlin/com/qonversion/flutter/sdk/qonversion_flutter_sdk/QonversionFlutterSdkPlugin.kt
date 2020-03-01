package com.qonversion.flutter.sdk.qonversion_flutter_sdk

import android.app.Application
import androidx.annotation.NonNull;
import com.android.billingclient.api.BillingClient
import com.android.billingclient.api.BillingResult
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

import com.qonversion.android.sdk.Qonversion;
import com.qonversion.android.sdk.QonversionBillingBuilder
import com.qonversion.android.sdk.QonversionCallback
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

/** QonversionFlutterSdkPlugin */
class QonversionFlutterSdkPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  private lateinit var channel : MethodChannel
  private var application: Application? = null


  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "qonversion_flutter_sdk")
    channel.setMethodCallHandler(this);
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    this.application = binding.activity.application
  }

  override fun onDetachedFromActivityForConfigChanges() {
    this.application = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    this.application = binding.activity.application
  }

  override fun onDetachedFromActivity() {
    this.application = null
  }

  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "qonversion_flutter_sdk")
      channel.setMethodCallHandler(QonversionFlutterSdkPlugin())
    }
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    val args = call.arguments as? Map<String, Any> ?: return result.error("1",
            "Please provide arguments",
            "There was no arguments in method call")

    val key = args["key"] as? String
    val internalUserId = args["userID"] as? String

    when (call.method) {
      "launchWithKeyCompletion" -> launchWith(key, internalUserId, result)
      "launchWithKeyUserId" -> launchWith(key, internalUserId, result)
      "launchWithKeyAutoTrackPurchasesCompletion" -> launchWith(key, internalUserId, result)
      "addAttributionData" -> result.notImplemented() // since there is no such method in Android SDK
      else -> result.notImplemented()
    }
  }

  private fun launchWith(key: String?, internalUserId: String?, result: Result) {
    if (key == null) {
      return result.error("1", "Could not find API key", "Please provide valid API key")
    }

    val billingBuilder = buildBilling()

    val callback = object: QonversionCallback {
      override fun onSuccess(uid: String) {
        result.success(uid)
      }

      override fun onError(t: Throwable) {
        result.error("1", t.localizedMessage, t.cause)
      }
    }

    val app = application ?: return

    Qonversion.initialize(
            app,
            key,
            internalUserId ?: "",
            billingBuilder,
            true,
            callback
    )
  }

  private fun buildBilling(): QonversionBillingBuilder {
    return QonversionBillingBuilder()
            .enablePendingPurchases()
            .setChildDirected(BillingClient.ChildDirected.CHILD_DIRECTED)
            .setUnderAgeOfConsent(BillingClient.UnderAgeOfConsent.UNSPECIFIED)
            .setListener { billingResult, purchases ->
              // your purchases update logic
            }
  }
}
