package com.qonversion.flutter.sdk.qonversion_flutter_sdk

import android.app.Activity
import android.app.Application
import androidx.annotation.NonNull
import androidx.preference.PreferenceManager
import com.google.gson.Gson
import com.qonversion.android.sdk.*
import com.qonversion.android.sdk.dto.QLaunchResult
import com.qonversion.android.sdk.dto.QPermission
import com.qonversion.android.sdk.dto.eligibility.QEligibility
import com.qonversion.android.sdk.dto.offerings.QOfferings
import com.qonversion.android.sdk.dto.products.QProduct
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

/** QonversionFlutterSdkPlugin */
class QonversionFlutterSdkPlugin : MethodCallHandler, FlutterPlugin, ActivityAware {
    private var activity: Activity? = null
    private var application: Application? = null
    private var channel: MethodChannel? = null
    private var deferredPurchasesStreamHandler: BaseEventStreamHandler? = null

    companion object {
        const val METHOD_CHANNEL = "qonversion_flutter_sdk"
        const val EVENT_CHANNEL_PROMO_PURCHASES = "promo_purchases"
        const val EVENT_CHANNEL_DEFERRED_PURCHASES = "updated_purchases"

        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val instance = QonversionFlutterSdkPlugin()
            instance.setup(registrar.messenger(), registrar.activity().application)
            instance.activity = registrar.activity()
        }
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        setup(binding.binaryMessenger, binding.applicationContext as Application)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        tearDown()
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {

        // Methods without args

        when (call.method) {
            "products" -> {
                return products(result)
            }
            "syncPurchases" -> {
                return syncPurchases(result)
            }
            "checkPermissions" -> {
                return checkPermissions(result)
            }
            "restore" -> {
                return restore(result)
            }
            "setDebugMode" -> {
                Qonversion.setDebugMode()
                return result.success(null)
            }
            "offerings" -> {
                return offerings(result)
            }
            "logout" -> {
                Qonversion.logout()
                return result.success(null)
            }
            "resetUser" -> {
                Qonversion.resetUser()
                return result.success(null)
            }
        }

        // Methods with args

        val args = call.arguments() as? Map<String, Any> ?: return result.noArgsError()

        when (call.method) {
            "launch" -> launch(args, result)
            "purchase" -> purchase(args["productId"] as? String, result)
            "updatePurchase" -> updatePurchase(args, result)
            "setUserId" -> setUserId(args["userId"] as? String, result)
            "setProperty" -> setProperty(args, result)
            "setUserProperty" -> setUserProperty(args, result)
            "addAttributionData" -> addAttributionData(args, result)
            "checkTrialIntroEligibility" -> checkTrialIntroEligibility(args, result)
            "storeSdkInfo" -> storeSdkInfo(args, result)
            "identify" -> identify(args["userId"] as? String, result)
            else -> result.notImplemented()
        }
    }

    private fun launch(args: Map<String, Any>, result: Result) {
        application?.let { application ->
            val apiKey = args["key"] as? String ?: return result.noApiKeyError()
            val isObserveMode = args["isObserveMode"] as? Boolean ?: return result.noArgsError()
            Qonversion.launch(
                    application,
                    apiKey,
                    isObserveMode,
                    callback = object : QonversionLaunchCallback {
                        override fun onSuccess(launchResult: QLaunchResult) {
                            result.success(launchResult.toMap())
                        }

                        override fun onError(error: QonversionError) {
                            result.qonversionError(error.description, error.additionalMessage)
                        }
                    }
            )
            startListeningPendingPurchasesEvents()
        } ?: result.error(QonversionErrorCode.UnknownError.name, "Couldn't launch Qonversion. There is no Application context", null)
    }

    private fun identify(userId: String?, result: Result) {
        if (userId == null) {
            result.noUserIdError()
            return
        }

        Qonversion.identify(userId)
        result.success(null)
    }

    private fun startListeningPendingPurchasesEvents() {
        Qonversion.setUpdatedPurchasesListener(object : UpdatedPurchasesListener {
            override fun onPermissionsUpdate(permissions: Map<String, QPermission>) {
                val payload = Gson().toJson(permissions.mapValues { it.value.toMap() })

                deferredPurchasesStreamHandler?.eventSink?.success(payload)
            }
        })
    }

    private fun purchase(productId: String?, result: Result) {
        if (productId == null) {
            result.noProductIdError()
            return
        }

        activity?.let { activity ->
            Qonversion.purchase(activity, productId, callback = object : QonversionPermissionsCallback {
                override fun onSuccess(permissions: Map<String, QPermission>) {
                    result.success(PurchaseResult(permissions).toMap())
                }

                override fun onError(error: QonversionError) {
                    result.success(PurchaseResult(error = error).toMap())
                }
            })
        } ?: result.error(QonversionErrorCode.PurchaseInvalid.name, "Couldn't make purchase. There is no Activity context", null)
    }

    private fun updatePurchase(args: Map<String, Any>, result: Result) {
        val newProductId = args["newProductId"] as? String ?: return result.noNewProductIdError()
        val oldProductId = args["oldProductId"] as? String ?: return result.noOldProductIdError()
        val prorationMode = args["proration_mode"] as? Int

        activity?.let { activity ->
            Qonversion.updatePurchase(activity, newProductId, oldProductId, prorationMode, callback = object : QonversionPermissionsCallback {
                override fun onSuccess(permissions: Map<String, QPermission>) {
                    result.success(permissions.mapValues { it.value.toMap() })
                }

                override fun onError(error: QonversionError) {
                    result.qonversionError(error.description, error.additionalMessage)
                }
            })
        } ?: result.error(QonversionErrorCode.PurchaseInvalid.name, "Couldn't update purchase. There is no Activity context", null)
    }

    private fun checkPermissions(result: Result) {
        Qonversion.checkPermissions(object: QonversionPermissionsCallback {
            override fun onSuccess(permissions: Map<String, QPermission>) {
                result.success(permissions.mapValues { it.value.toMap() })
            }

            override fun onError(error: QonversionError) {
                result.qonversionError(error.description, error.additionalMessage)
            }
        })
    }

    private fun restore(result: Result) {
        Qonversion.restore(object: QonversionPermissionsCallback {
            override fun onSuccess(permissions: Map<String, QPermission>) {
                result.success(permissions.mapValues { it.value.toMap() })
            }

            override fun onError(error: QonversionError) {
                result.qonversionError(error.description, error.additionalMessage)
            }
        })
    }

    private fun offerings(result: Result) {
        Qonversion.offerings(callback = object: QonversionOfferingsCallback {
            override fun onSuccess(offerings: QOfferings) {
                val jsonOfferings = Gson().toJson(offerings.toMap())
                result.success(jsonOfferings)
            }

            override fun onError(error: QonversionError) {
                result.offeringsError(error.description, error.additionalMessage)
            }
        })
    }

    private fun products(result: Result) {
        Qonversion.products(callback = object: QonversionProductsCallback {
            override fun onSuccess(products: Map<String, QProduct>) {
                result.success(products.mapValues { it.value.toMap() })
            }

            override fun onError(error: QonversionError) {
                result.qonversionError(error.description, error.additionalMessage)
            }
        })
    }

    private fun setUserId(userId: String?, result: Result) {
        if (userId == null) {
            result.noUserIdError()
            return
        }

        Qonversion.setUserID(userId)
        result.success(null)
    }

    private fun setProperty(args: Map<String, Any>, result: Result) {
        val rawProperty = args["property"] as? String ?: return result.noProperty()

        val value = args["value"] as? String ?: return result.noPropertyValue()

        try {
            Qonversion.setProperty(QUserProperties.valueOf(rawProperty), value)
            result.success(null)
        } catch (e: IllegalArgumentException) {
            result.parsingError(e.localizedMessage)
        }
    }

    private fun setUserProperty(args: Map<String, Any>, result: Result) {
        val property = args["property"] as? String ?: return result.noProperty()

        val value = args["value"] as? String ?: return result.noPropertyValue()

        Qonversion.setUserProperty(property, value)
        result.success(null)
    }

    private fun syncPurchases(result: Result) {
        Qonversion.syncPurchases()
        result.success(null)
    }

    private fun addAttributionData(args: Map<String, Any>, result: Result) {
        val data = args["data"] as? Map<String, Any> ?: return result.noDataError()

        if (data.isEmpty()) {
            return result.noDataError()
        }

        val provider = args["provider"] as? String ?: return result.noProviderError()

        val castedProvider = when (provider) {
            "appsFlyer" -> AttributionSource.AppsFlyer
            else -> null
        }
                ?: return result.success(null)

        Qonversion.attribution(data, castedProvider)

        result.success(null)
    }

    private fun checkTrialIntroEligibility(args: Map<String, Any>, result: Result) {
        val ids = args["ids"] as? List<String> ?: return result.noDataError()

        Qonversion.checkTrialIntroEligibilityForProductIds(ids, callback = object: QonversionEligibilityCallback {
            override fun onSuccess(eligibilities: Map<String, QEligibility>) {
                val jsonEligibilities = Gson().toJson(eligibilities.mapValues { it.value.toMap() })
                result.success(jsonEligibilities)
            }

            override fun onError(error: QonversionError) {
                result.qonversionError(error.additionalMessage, error.description)
            }
        })
    }

    private fun storeSdkInfo(args: Map<String, Any>, result: Result) {
        val version = args["version"] as? String ?: return result.noSdkInfo()
        val versionKey = args["versionKey"] as? String ?: return result.noSdkInfo()
        val source = args["source"] as? String ?: return result.noSdkInfo()
        val sourceKey = args["sourceKey"] as? String ?: return result.noSdkInfo()

        val editor = PreferenceManager.getDefaultSharedPreferences(application).edit()
        editor.putString(sourceKey, source)
        editor.putString(versionKey, version)
        editor.apply()

        result.success(null)
    }

    private fun setup(messenger: BinaryMessenger, application: Application) {
        this.application = application
        channel = MethodChannel(messenger, METHOD_CHANNEL)
        channel?.setMethodCallHandler(this)

        // Register deferred purchases events
        val purchasesListener = BaseListenerWrapper(messenger, EVENT_CHANNEL_DEFERRED_PURCHASES)
        purchasesListener.register()
        this.deferredPurchasesStreamHandler = purchasesListener.eventStreamHandler

        // Register promo purchases events. Android SDK does not generate any promo purchases yet
        val promoPurchasesListener = BaseListenerWrapper(messenger, EVENT_CHANNEL_PROMO_PURCHASES)
        promoPurchasesListener.register()
    }

    private fun tearDown() {
        channel?.setMethodCallHandler(null)
        channel = null
        this.deferredPurchasesStreamHandler = null
        this.application = null
    }
}
