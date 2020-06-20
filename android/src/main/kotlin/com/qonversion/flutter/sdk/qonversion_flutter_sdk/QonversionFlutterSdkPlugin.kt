package com.qonversion.flutter.sdk.qonversion_flutter_sdk

import android.app.Activity
import android.app.Application
import androidx.annotation.NonNull;
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

import com.qonversion.android.sdk.Qonversion;
import com.qonversion.android.sdk.QonversionBillingBuilder
import com.qonversion.android.sdk.QonversionCallback

/** QonversionFlutterSdkPlugin */
class QonversionFlutterSdkPlugin internal constructor(registrar: Registrar): MethodCallHandler {
    private val activity: Activity = registrar.activity()
    private val application: Application = activity.application

    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "qonversion_flutter_sdk")
            channel.setMethodCallHandler(QonversionFlutterSdkPlugin(registrar))
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        val args = call.arguments as? Map<String, Any> ?: return result.error("1",
                "Please provide arguments",
                "There was no arguments in method call")

        val key = args["key"] as? String
        val internalUserId = args["userID"] as? String
        val autoTrackPurchases = args["autoTrackPurchases"] as? Boolean ?: true

        when (call.method) {
            "launchWithKeyCompletion" -> launchWith(key, internalUserId, autoTrackPurchases, result)
            "launchWithKeyUserId" -> launchWith(key, internalUserId, autoTrackPurchases, result)
            "launchWithKeyAutoTrackPurchasesCompletion" -> launchWith(key, internalUserId, autoTrackPurchases, result)
            "addAttributionData" -> result.notImplemented() // since there is no such method in Android SDK
            else -> result.notImplemented()
        }
    }

    private fun launchWith(key: String?,
                           internalUserId: String?,
                           autoTrackPurchases: Boolean,
                           result: Result) {
        if (key == null) {
          return result.error("1", "Could not find API key", "Please provide valid API key")
        }

        val billingBuilder = QonversionBillingBuilder()
                .enablePendingPurchases()
                .setListener { _, _ ->  }

        val callback = object: QonversionCallback {
            override fun onSuccess(uid: String) {
                result.success(uid)
            }

            override fun onError(t: Throwable) {
                result.error("1", t.localizedMessage, t.cause.toString())
            }
        }

        Qonversion.initialize(
                application,
                key,
                internalUserId,
                billingBuilder,
                autoTrackPurchases,
                callback
        )
    }
}
