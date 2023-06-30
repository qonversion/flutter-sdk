package com.qonversion.flutter.sdk.qonversion_flutter_sdk

import android.app.Activity
import android.app.Application
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
import io.qonversion.sandwich.ActivityProvider
import io.qonversion.sandwich.BridgeData
import io.qonversion.sandwich.QonversionEventsListener
import io.qonversion.sandwich.QonversionSandwich

class QonversionPlugin : MethodCallHandler, FlutterPlugin, ActivityAware {
    private var activity: Activity? = null
    private var application: Application? = null
    private var channel: MethodChannel? = null
    private var updatedEntitlementsStreamHandler: BaseEventStreamHandler? = null

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

    private lateinit var automationsPlugin: AutomationsPlugin

    private val qonversionEventsListener: QonversionEventsListener = object : QonversionEventsListener {
        override fun onEntitlementsUpdated(entitlements: BridgeData) {
            val payload = Gson().toJson(entitlements)
            updatedEntitlementsStreamHandler?.eventSink?.success(payload)
        }
    }

    companion object {
        private const val METHOD_CHANNEL = "qonversion_plugin"
        private const val EVENT_CHANNEL_PROMO_PURCHASES = "promo_purchases"
        private const val EVENT_CHANNEL_UPDATED_ENTITLEMENTS = "updated_entitlements"

        // Used for compatibility with the apps, which don't use Android Embedding v2.
        @Suppress("DEPRECATION", "unused")
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val instance = QonversionPlugin()
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

    override fun onMethodCall(call: MethodCall, result: Result) {
        // Methods without args
        when (call.method) {
            "syncHistoricalData" -> {
                qonversionSandwich.syncHistoricalData()
                return result.success(null)
            }
            "products" -> {
                return products(result)
            }
            "syncPurchases" -> {
                return syncPurchases(result)
            }
            "checkEntitlements" -> {
                return checkEntitlements(result)
            }
            "restore" -> {
                return restore(result)
            }
            "offerings" -> {
                return offerings(result)
            }
            "remoteConfig" -> {
                return remoteConfig(result)
            }
            "logout" -> {
                qonversionSandwich.logout()
                return result.success(null)
            }
            "userInfo" -> {
                return userInfo(result)
            }
            "automationsSubscribe" -> {
                return automationsPlugin.subscribe()
            }
        }

        // Methods with args
        val args = call.arguments() as? Map<String, Any> ?: return result.noNecessaryDataError()
        when (call.method) {
            "initialize" -> initialize(args, result)
            "purchase" -> purchase(args["productId"] as? String, result)
            "purchaseProduct" -> purchaseProduct(args, result)
            "updatePurchase" -> updatePurchase(args, result)
            "updatePurchaseWithProduct" -> updatePurchaseWithProduct(args, result)
            "setDefinedUserProperty" -> setDefinedUserProperty(args, result)
            "setCustomUserProperty" -> setCustomUserProperty(args, result)
            "addAttributionData" -> addAttributionData(args, result)
            "checkTrialIntroEligibility" -> checkTrialIntroEligibility(args, result)
            "attachUserToExperiment" -> attachUserToExperiment(args, result)
            "detachUserFromExperiment" -> detachUserFromExperiment(args, result)
            "storeSdkInfo" -> storeSdkInfo(args, result)
            "identify" -> identify(args["userId"] as? String, result)
            "automationsSetNotificationsToken" -> automationsPlugin.setNotificationsToken(args["notificationsToken"] as? String, result)
            "automationsHandleNotification" -> automationsPlugin.handleNotification(args, result)
            "automationsGetNotificationCustomPayload" -> automationsPlugin.getNotificationCustomPayload(args, result)
            "automationsShowScreen" -> automationsPlugin.showScreen(args["screenId"] as? String, result)
            "setScreenPresentationConfig" -> automationsPlugin.setScreenPresentationConfig(
                args["configData"] as? Map<String, Any>,
                args["screenId"] as? String,
                result
            )
            else -> result.notImplemented()
        }
    }

    private fun initialize(args: Map<String, Any>, result: Result) {
        val context = application ?: return result.noNecessaryDataError()
        val projectKey = args["projectKey"] as? String ?: return result.noNecessaryDataError()
        val launchModeKey = args["launchMode"] as? String ?: return result.noNecessaryDataError()
        val environmentKey = args["environment"] as? String ?: return result.noNecessaryDataError()
        val entitlementsCacheLifetimeKey = args["entitlementsCacheLifetime"] as? String ?: return result.noNecessaryDataError()
        val proxyUrl = args["proxyUrl"] as? String
        val kidsMode = args["kidsMode"] as? Boolean ?: false
        qonversionSandwich.initialize(context, projectKey, launchModeKey, environmentKey, entitlementsCacheLifetimeKey, proxyUrl, kidsMode)
        result.success(null)
    }

    private fun identify(userId: String?, result: Result) {
        if (userId == null) {
            result.noNecessaryDataError()
            return
        }

        qonversionSandwich.identify(userId)
        result.success(null)
    }

    private fun purchase(productId: String?, result: Result) {
        if (productId == null) {
            return result.noNecessaryDataError()
        }

        qonversionSandwich.purchase(productId, result.toPurchaseResultListener())
    }

    private fun purchaseProduct(args: Map<String, Any>, result: Result) {
        val productId = args["productId"] as? String ?: return result.noNecessaryDataError()
        val offeringId = args["offeringId"] as? String

        qonversionSandwich.purchaseProduct(productId, offeringId, result.toPurchaseResultListener())
    }

    private fun updatePurchase(args: Map<String, Any>, result: Result) {
        val newProductId = args["newProductId"] as? String ?: return result.noNecessaryDataError()
        val oldProductId = args["oldProductId"] as? String ?: return result.noNecessaryDataError()
        val prorationMode = args["proration_mode"] as? Int

        qonversionSandwich.updatePurchase(newProductId, oldProductId, prorationMode, result.toPurchaseResultListener())
    }

    private fun updatePurchaseWithProduct(args: Map<String, Any>, result: Result) {
        val newProductId = args["newProductId"] as? String ?: return result.noNecessaryDataError()
        val offeringId = args["offeringId"] as? String
        val oldProductId = args["oldProductId"] as? String ?: return result.noNecessaryDataError()
        val prorationMode = args["proration_mode"] as? Int

        qonversionSandwich.updatePurchaseWithProduct(
            newProductId,
            offeringId,
            oldProductId,
            prorationMode,
            result.toPurchaseResultListener()
        )
    }

    private fun checkEntitlements(result: Result) {
        qonversionSandwich.checkEntitlements(result.toResultListener())
    }

    private fun restore(result: Result) {
        qonversionSandwich.restore(result.toResultListener())
    }

    private fun offerings(result: Result) {
        qonversionSandwich.offerings(result.toJsonResultListener())
    }

    private fun remoteConfig(result: Result) {
        qonversionSandwich.remoteConfig(result.toJsonResultListener())
    }

    private fun products(result: Result) {
        qonversionSandwich.products(result.toResultListener())
    }

    private fun setDefinedUserProperty(args: Map<String, Any>, result: Result) {
        val rawProperty = args["property"] as? String ?: return result.noNecessaryDataError()
        val value = args["value"] as? String ?: return result.noNecessaryDataError()

        qonversionSandwich.setDefinedProperty(rawProperty, value)
        result.success(null)
    }

    private fun setCustomUserProperty(args: Map<String, Any>, result: Result) {
        val property = args["property"] as? String ?: return result.noNecessaryDataError()
        val value = args["value"] as? String ?: return result.noNecessaryDataError()

        qonversionSandwich.setCustomProperty(property, value)
        result.success(null)
    }

    private fun syncPurchases(result: Result) {
        qonversionSandwich.syncPurchases()
        result.success(null)
    }

    private fun addAttributionData(args: Map<String, Any>, result: Result) {
        @Suppress("UNCHECKED_CAST")
        val data = args["data"] as? Map<String, Any> ?: return result.noNecessaryDataError()

        if (data.isEmpty()) {
            return result.noNecessaryDataError()
        }

        val provider = args["provider"] as? String ?: return result.noNecessaryDataError()

        qonversionSandwich.addAttributionData(provider, data)
        result.success(null)
    }

    private fun checkTrialIntroEligibility(args: Map<String, Any>, result: Result) {
        @Suppress("UNCHECKED_CAST")
        val ids = args["ids"] as? List<String> ?: return result.noNecessaryDataError()

        qonversionSandwich.checkTrialIntroEligibility(ids, result.toJsonResultListener())
    }

    private fun attachUserToExperiment(args: Map<String, Any>, result: Result) {
        @Suppress("UNCHECKED_CAST")
        val experimentId = args["experimentId"] as? String ?: return result.noNecessaryDataError()
        val groupId = args["groupId"] as? String ?: return result.noNecessaryDataError()

        qonversionSandwich.attachUserToExperiment(experimentId, groupId, result.toJsonResultListener())
    }

    private fun detachUserFromExperiment(args: Map<String, Any>, result: Result) {
        @Suppress("UNCHECKED_CAST")
        val experimentId = args["experimentId"] as? String ?: return result.noNecessaryDataError()

        qonversionSandwich.detachUserFromExperiment(experimentId, result.toJsonResultListener())
    }

    private fun userInfo(result: Result) {
        qonversionSandwich.userInfo(result.toResultListener())
    }

    private fun storeSdkInfo(args: Map<String, Any>, result: Result) {
        val version = args["version"] as? String ?: return result.noNecessaryDataError()
        val source = args["source"] as? String ?: return result.noNecessaryDataError()

        qonversionSandwich.storeSdkInfo(source, version)
        result.success(null)
    }

    private fun setup(messenger: BinaryMessenger, application: Application) {
        this.application = application
        channel = MethodChannel(messenger, METHOD_CHANNEL)
        channel?.setMethodCallHandler(this)

        // Register entitlements update events
        val updatedEntitlementsListener = BaseListenerWrapper(messenger, EVENT_CHANNEL_UPDATED_ENTITLEMENTS)
        updatedEntitlementsListener.register()
        this.updatedEntitlementsStreamHandler = updatedEntitlementsListener.eventStreamHandler

        // Register promo purchases events. Android SDK does not generate any promo purchases yet
        val promoPurchasesListener = BaseListenerWrapper(messenger, EVENT_CHANNEL_PROMO_PURCHASES)
        promoPurchasesListener.register()

        automationsPlugin = AutomationsPlugin(messenger)
    }

    private fun tearDown() {
        channel?.setMethodCallHandler(null)
        channel = null
        this.updatedEntitlementsStreamHandler = null
        this.application = null
    }
}
