package com.qonversion.flutter.sdk.qonversion_flutter_sdk

import android.app.Activity
import android.app.Application
import androidx.annotation.NonNull
import com.android.billingclient.api.Purchase
import com.android.billingclient.api.SkuDetails
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

import com.qonversion.android.sdk.Qonversion
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
        val args = call.arguments() as? Map<String, Any> ?: return result.noArgsError()

        if (args.isEmpty()) {
            return result.noArgsError()
        }

        val internalUserId = args["userID"] as? String ?: ""
        val autoTrackPurchases = args["autoTrackPurchases"] as? Boolean ?: true

        when (call.method) {
            "launch" -> launch(args, result)
            "trackPurchase" -> trackPurchase(args, result)

            // TODO remove when old methods get removed on Dart side
            "launchWithKeyCompletion",
            "launchWithKeyUserId",
            "launchWithKeyAutoTrackPurchasesCompletion" -> launchWith(args["key"] as String, internalUserId, autoTrackPurchases, result)
            "addAttributionData" -> result.notImplemented() // since there is no such method in Android SDK
            else -> result.notImplemented()
        }
    }

    private fun launch(args: Map<String, Any>, result: Result) {
        val apiKey = args["key"] as? String ?: return result.noApiKeyError()

        val userId = args["userID"] as? String ?: ""

        val callback = object: QonversionCallback {
            override fun onSuccess(uid: String) {
                result.success(uid)
            }

            override fun onError(t: Throwable) {
                result.qonversionError(t.localizedMessage, t.cause.toString())
            }
        }

        Qonversion.initialize(
                application,
                apiKey,
                userId,
                callback
        )
    }

    // TODO remove when old methods get removed on Dart side
    private fun launchWith(key: String?,
                           internalUserId: String = "",
                           autoTrackPurchases: Boolean = true,
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
                result.qonversionError(t.localizedMessage, t.cause.toString())
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

    private fun trackPurchase(args: Map<String, Any>, result: Result) {
        @Suppress("UNCHECKED_CAST")
        val detailsMap = args["details"] as Map<String, Any>
        @Suppress("UNCHECKED_CAST")
        val purchaseMap = args["purchase"] as Map<String, Any>

        val details = createSkuDetails(detailsMap)
        val purchase = createPurchase(purchaseMap)

        val callback = object: QonversionCallback {
            override fun onSuccess(uid: String) {
                result.success(uid)
            }

            override fun onError(t: Throwable) {
                result.qonversionError(t.localizedMessage, t.cause.toString())
            }
        }

        Qonversion.instance!!.purchase(details, purchase, callback)
    }

    private fun createSkuDetails(map: Map<String, Any>): SkuDetails {
        val json = map.toString()
        return SkuDetails(json)
    }

    private fun createPurchase(map: Map<String, Any>): Purchase {
        val json = map.toString()
        val signature = map["signature"] as String
        return Purchase(json, signature)
    }
}
