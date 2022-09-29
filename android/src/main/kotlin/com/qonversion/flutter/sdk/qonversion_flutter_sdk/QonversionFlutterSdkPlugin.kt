package com.qonversion.flutter.sdk.qonversion_flutter_sdk

import android.app.Activity
import android.app.Application
import androidx.annotation.NonNull
import com.google.gson.Gson
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import io.qonversion.sandwich.*

/** QonversionFlutterSdkPlugin */
class QonversionFlutterSdkPlugin : MethodCallHandler, FlutterPlugin, ActivityAware {
    private var activity: Activity? = null
    private var application: Application? = null
    private var channel: MethodChannel? = null
    private var deferredPurchasesStreamHandler: BaseEventStreamHandler? = null
    private var automationsPlugin: AutomationsPlugin? = null

    private val qonversionSandwich by lazy {
        application?.let {
            QonversionSandwich(
                it,
                object : ActivityProvider {
                    override val currentActivity: Activity?
                        get() = activity
                },
                qonversionEventsListener
            )
        } ?: throw IllegalStateException("Failed to initialize Qonversion Sandwich. Application is null.")
    }

    private val qonversionEventsListener: QonversionEventsListener = object : QonversionEventsListener {
        override fun onPermissionsUpdate(permissions: BridgeData) {
            val payload = Gson().toJson(permissions)
            deferredPurchasesStreamHandler?.eventSink?.success(payload)
        }
    }

    companion object {
        const val METHOD_CHANNEL = "qonversion_flutter_sdk"
        const val EVENT_CHANNEL_PROMO_PURCHASES = "promo_purchases"
        const val EVENT_CHANNEL_DEFERRED_PURCHASES = "updated_purchases"

        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val instance = QonversionFlutterSdkPlugin()
            instance.setup(registrar.messenger(), registrar.context().applicationContext as Application)
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
                qonversionSandwich.setDebugMode()
                return result.success(null)
            }
            "offerings" -> {
                return offerings(result)
            }
            "logout" -> {
                qonversionSandwich.logout()
                return result.success(null)
            }
        }

        // Methods with args

        val args = call.arguments() as? Map<String, Any> ?: return result.noArgsError()

        when (call.method) {
            "launch" -> launch(args, result)
            "purchase" -> purchase(args["productId"] as? String, result)
            "purchaseProduct" -> purchaseProduct(args, result)
            "updatePurchase" -> updatePurchase(args, result)
            "updatePurchaseWithProduct" -> updatePurchaseWithProduct(args, result)
            "setDefinedUserProperty" -> setDefinedUserProperty(args, result)
            "setCustomUserProperty" -> setCustomUserProperty(args, result)
            "addAttributionData" -> addAttributionData(args, result)
            "checkTrialIntroEligibility" -> checkTrialIntroEligibility(args, result)
            "storeSdkInfo" -> storeSdkInfo(args, result)
            "identify" -> identify(args["userId"] as? String, result)
            "setPermissionsCacheLifetime" -> setPermissionsCacheLifetime(args, result)
            "setNotificationsToken" -> setNotificationsToken(args["notificationsToken"] as? String, result)
            "handleNotification" -> handleNotification(args, result)
            "getNotificationCustomPayload" -> getNotificationCustomPayload(args, result)
            else -> result.notImplemented()
        }
    }

    private fun launch(args: Map<String, Any>, result: Result) {
        val projectKey = args["key"] as? String ?: return result.noApiKeyError()
        val isObserveMode = args["isObserveMode"] as? Boolean ?: return result.noArgsError()
        qonversionSandwich.launch(projectKey, isObserveMode, result.toResultListener())
    }

    private fun identify(userId: String?, result: Result) {
        if (userId == null) {
            result.noUserIdError()
            return
        }

        qonversionSandwich.identify(userId)
        result.success(null)
    }

    private fun purchase(productId: String?, result: Result) {
        if (productId == null) {
            return result.noProductIdError()
        }

        qonversionSandwich.purchase(productId, result.toPurchaseResultListener())
    }

    private fun purchaseProduct(args: Map<String, Any>, result: Result) {
        val productId = args["productId"] as? String ?: return result.noProductIdError()
        val offeringId = args["offeringId"] as? String

        qonversionSandwich.purchaseProduct(productId, offeringId, result.toPurchaseResultListener())
    }

    private fun updatePurchase(args: Map<String, Any>, result: Result) {
        val newProductId = args["newProductId"] as? String ?: return result.noNewProductIdError()
        val oldProductId = args["oldProductId"] as? String ?: return result.noOldProductIdError()
        val prorationMode = args["proration_mode"] as? Int

        qonversionSandwich.updatePurchase(newProductId, oldProductId, prorationMode, result.toPurchaseResultListener())
    }

    private fun updatePurchaseWithProduct(args: Map<String, Any>, result: Result) {
        val newProductId = args["newProductId"] as? String ?: return result.noNewProductIdError()
        val offeringId = args["offeringId"] as? String
        val oldProductId = args["oldProductId"] as? String ?: return result.noOldProductIdError()
        val prorationMode = args["proration_mode"] as? Int

        qonversionSandwich.updatePurchaseWithProduct(
            newProductId,
            offeringId,
            oldProductId,
            prorationMode,
            result.toPurchaseResultListener()
        )
    }

    private fun checkPermissions(result: Result) {
        qonversionSandwich.checkPermissions(result.toResultListener())
    }

    private fun restore(result: Result) {
        qonversionSandwich.restore(result.toResultListener())
    }

    private fun offerings(result: Result) {
        qonversionSandwich.offerings(
            object : ResultListener {
                override fun onError(error: SandwichError) {
                    result.offeringsError(error)
                }

                override fun onSuccess(data: Map<String, Any?>) {
                    result.success(Gson().toJson(data))
                }
            }
        )
    }

    private fun products(result: Result) {
        qonversionSandwich.products(result.toResultListener())
    }

    private fun setDefinedUserProperty(args: Map<String, Any>, result: Result) {
        val rawProperty = args["property"] as? String ?: return result.noProperty()
        val value = args["value"] as? String ?: return result.noPropertyValue()

        qonversionSandwich.setDefinedProperty(rawProperty, value)
        result.success(null)
    }

    private fun setCustomUserProperty(args: Map<String, Any>, result: Result) {
        val property = args["property"] as? String ?: return result.noProperty()
        val value = args["value"] as? String ?: return result.noPropertyValue()

        qonversionSandwich.setCustomProperty(property, value)
        result.success(null)
    }

    private fun syncPurchases(result: Result) {
        qonversionSandwich.syncPurchases()
        result.success(null)
    }

    private fun addAttributionData(args: Map<String, Any>, result: Result) {
        val data = args["data"] as? Map<String, Any> ?: return result.noDataError()

        if (data.isEmpty()) {
            return result.noDataError()
        }

        val provider = args["provider"] as? String ?: return result.noProviderError()

        qonversionSandwich.addAttributionData(provider, data)
        result.success(null)
    }

    private fun checkTrialIntroEligibility(args: Map<String, Any>, result: Result) {
        val ids = args["ids"] as? List<String> ?: return result.noDataError()

        qonversionSandwich.checkTrialIntroEligibility(ids, object : ResultListener {
            override fun onError(error: SandwichError) {
                result.sandwichError(error)
            }

            override fun onSuccess(data: Map<String, Any?>) {
                result.success(Gson().toJson(data))
            }
        })
    }

    private fun setPermissionsCacheLifetime(args: Map<String, Any>, result: Result) {
        val rawLifetime = args["lifetime"] as? String ?: return result.noLifetime()

        qonversionSandwich.setPermissionsCacheLifetime(rawLifetime)
        result.success(null)
    }

    private fun setNotificationsToken(token: String?, result: Result) {
        token?.let {
            qonversionSandwich.setNotificationToken(it)
            result.success(null)
        } ?: result.noArgsError()
    }

    private fun handleNotification(args: Map<String, Any>, result: Result) {
        val data = args["notificationData"] as? Map<String, Any> ?: return result.noDataError()

        if (data.isEmpty()) {
            return result.noDataError()
        }

        val isQonversionNotification = qonversionSandwich.handleNotification(data)
        result.success(isQonversionNotification)
    }

    private fun getNotificationCustomPayload(args: Map<String, Any>, result: Result) {
        val data = args["notificationData"] as? Map<String, Any> ?: return result.noDataError()

        if (data.isEmpty()) {
            return result.noDataError()
        }

        val payload = qonversionSandwich.getNotificationCustomPayload(data)
        val payloadJson = Gson().toJson(payload)
        result.success(payloadJson)
    }

    private fun storeSdkInfo(args: Map<String, Any>, result: Result) {
        val version = args["version"] as? String ?: return result.noSdkInfo()
        val source = args["source"] as? String ?: return result.noSdkInfo()

        qonversionSandwich.storeSdkInfo(source, version)
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

        automationsPlugin = AutomationsPlugin(messenger).also { it.subscribe() }
    }

    private fun tearDown() {
        channel?.setMethodCallHandler(null)
        channel = null
        this.deferredPurchasesStreamHandler = null
        this.application = null
    }

    private fun Result.toResultListener(): ResultListener {
        return object : ResultListener {
            override fun onError(error: SandwichError) {
                sandwichError(error)
            }

            override fun onSuccess(data: Map<String, Any?>) {
                success(data)
            }
        }
    }

    private fun Result.toPurchaseResultListener(): PurchaseResultListener {
        return object : PurchaseResultListener {
            override fun onError(error: SandwichError, isCancelled: Boolean) {
                purchaseError(error, isCancelled)
            }

            override fun onSuccess(data: Map<String, Any?>) {
                success(data)
            }
        }
    }
}
