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
import io.qonversion.sandwich.ActivityProvider
import io.qonversion.sandwich.BridgeData
import io.qonversion.sandwich.QonversionEventsListener
import io.qonversion.sandwich.QonversionSandwich

class QonversionPlugin : MethodCallHandler, FlutterPlugin, ActivityAware {
    private var application: Application? = null
    private var activity: Activity? = null
    private var channel: MethodChannel? = null
    private var updatedEntitlementsStreamHandler: BaseEventStreamHandler? = null
    private var noCodesPlugin: NoCodesPlugin? = null

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
        override fun onEntitlementsUpdated(entitlements: BridgeData) {
            val payload = Gson().toJson(entitlements)
            updatedEntitlementsStreamHandler?.eventSink?.success(payload)
        }
    }

    companion object {
        private const val METHOD_CHANNEL = "qonversion_plugin"
        private const val EVENT_CHANNEL_PROMO_PURCHASES = "promo_purchases"
        private const val EVENT_CHANNEL_UPDATED_ENTITLEMENTS = "updated_entitlements"
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
            "userProperties" -> {
                return userProperties(result)
            }
            "logout" -> {
                qonversionSandwich.logout()
                return result.success(null)
            }
            "userInfo" -> {
                return userInfo(result)
            }
            "isFallbackFileAccessible" -> {
                return isFallbackFileAccessible(result)
            }
            "remoteConfigList" -> {
                return remoteConfigList(result)
            }
            "closeNoCodes" -> {
                noCodesPlugin?.closeNoCodes(result)
                return
            }
            // NoCodes Purchase Delegate methods without args
            "setNoCodesPurchaseDelegate" -> {
                noCodesPlugin?.setPurchaseDelegate(result)
                return
            }
            "delegatedPurchaseCompleted" -> {
                noCodesPlugin?.delegatedPurchaseCompleted(result)
                return
            }
            "delegatedRestoreCompleted" -> {
                noCodesPlugin?.delegatedRestoreCompleted(result)
                return
            }
        }

        // Methods with args
        val args = call.arguments() as? Map<String, Any> ?: return result.noNecessaryDataError()
        when (call.method) {
            "initialize" -> initialize(args, result)
            "purchase" -> purchase(args, result)
            "purchaseWithResult" -> purchaseWithResult(args, result)
            "updatePurchase" -> updatePurchase(args, result)
            "remoteConfig" -> remoteConfig(args["contextKey"] as? String, result)
            "remoteConfigListForContextKeys" -> remoteConfigList(args, result)
            "setDefinedUserProperty" -> setDefinedUserProperty(args, result)
            "setCustomUserProperty" -> setCustomUserProperty(args, result)
            "addAttributionData" -> addAttributionData(args, result)
            "checkTrialIntroEligibility" -> checkTrialIntroEligibility(args, result)
            "attachUserToExperiment" -> attachUserToExperiment(args, result)
            "detachUserFromExperiment" -> detachUserFromExperiment(args, result)
            "attachUserToRemoteConfiguration" -> attachUserToRemoteConfiguration(args, result)
            "detachUserFromRemoteConfiguration" -> detachUserFromRemoteConfiguration(args, result)
            "storeSdkInfo" -> storeSdkInfo(args, result)
            "identify" -> identify(args["userId"] as? String, result)
            // NoCodes methods
            "initializeNoCodes" -> noCodesPlugin?.initializeNoCodes(args, result)
            "setScreenPresentationConfig" -> noCodesPlugin?.setScreenPresentationConfig(args["config"] as? Map<String, Any>, args["contextKey"] as? String, result)
            "showNoCodesScreen" -> noCodesPlugin?.showNoCodesScreen(args["contextKey"] as? String, result)
            "setNoCodesLocale" -> noCodesPlugin?.setLocale(args["locale"] as? String, result)
            // NoCodes Purchase Delegate methods
            "delegatedPurchaseFailed" -> noCodesPlugin?.delegatedPurchaseFailed(args["errorMessage"] as? String, result)
            "delegatedRestoreFailed" -> noCodesPlugin?.delegatedRestoreFailed(args["errorMessage"] as? String, result)
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

        qonversionSandwich.identify(userId, result.toResultListener())
    }

    private fun purchase(args: Map<String, Any>, result: Result) {
        val productId = args["productId"] as? String ?: return result.noNecessaryDataError()
        val oldProductId = args["oldProductId"] as? String
        val offerId = args["offerId"] as? String
        val applyOffer = args["applyOffer"] as? Boolean
        val updatePolicyKey = args["updatePolicyKey"] as? String

        @Suppress("UNCHECKED_CAST")
        val contextKeys = args["contextKeys"] as? List<String>

        qonversionSandwich.purchase(
            productId,
            offerId,
            applyOffer,
            oldProductId,
            updatePolicyKey,
            contextKeys,
            result.toJsonResultListener()
        )
    }

    private fun purchaseWithResult(args: Map<String, Any>, result: Result) {
        val productId = args["productId"] as? String ?: return result.noNecessaryDataError()
        val oldProductId = args["oldProductId"] as? String
        val offerId = args["offerId"] as? String
        val applyOffer = args["applyOffer"] as? Boolean
        val updatePolicyKey = args["updatePolicyKey"] as? String

        @Suppress("UNCHECKED_CAST")
        val contextKeys = args["contextKeys"] as? List<String>

        qonversionSandwich.purchaseWithResult(
            productId,
            offerId,
            applyOffer,
            oldProductId,
            updatePolicyKey,
            contextKeys,
            result.toJsonResultListener()
        )
    }

    private fun updatePurchase(args: Map<String, Any>, result: Result) {
        purchase(args, result)
    }

    private fun checkEntitlements(result: Result) {
        qonversionSandwich.checkEntitlements(result.toJsonResultListener())
    }

    private fun restore(result: Result) {
        qonversionSandwich.restore(result.toJsonResultListener())
    }

    private fun offerings(result: Result) {
        qonversionSandwich.offerings(result.toJsonResultListener())
    }

    private fun userProperties(result: Result) {
        qonversionSandwich.userProperties(result.toJsonResultListener())
    }

    private fun isFallbackFileAccessible(result: Result) {
        qonversionSandwich.isFallbackFileAccessible(result.toJsonResultListener())
    }
    private fun remoteConfig(contextKey: String?, result: Result) {
        qonversionSandwich.remoteConfig(contextKey, result.toJsonResultListener())
    }

    private fun remoteConfigList(result: Result) {
        qonversionSandwich.remoteConfigList(result.toJsonResultListener())
    }

    private fun remoteConfigList(args: Map<String, Any>, result: Result) {
        @Suppress("UNCHECKED_CAST")
        val contextKeys = args["contextKeys"] as? List<String> ?: return result.noNecessaryDataError()
        val includeEmptyContextKey = args["includeEmptyContextKey"] as? Boolean ?: return result.noNecessaryDataError()

        qonversionSandwich.remoteConfigList(contextKeys, includeEmptyContextKey, result.toJsonResultListener())
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
        val experimentId = args["experimentId"] as? String ?: return result.noNecessaryDataError()
        val groupId = args["groupId"] as? String ?: return result.noNecessaryDataError()

        qonversionSandwich.attachUserToExperiment(experimentId, groupId, result.toJsonResultListener())
    }

    private fun detachUserFromExperiment(args: Map<String, Any>, result: Result) {
        val experimentId = args["experimentId"] as? String ?: return result.noNecessaryDataError()

        qonversionSandwich.detachUserFromExperiment(experimentId, result.toJsonResultListener())
    }

    private fun attachUserToRemoteConfiguration(args: Map<String, Any>, result: Result) {
        val remoteConfigurationId = args["remoteConfigurationId"] as? String ?: return result.noNecessaryDataError()

        qonversionSandwich.attachUserToRemoteConfiguration(remoteConfigurationId, result.toJsonResultListener())
    }

    private fun detachUserFromRemoteConfiguration(args: Map<String, Any>, result: Result) {
        val remoteConfigurationId = args["remoteConfigurationId"] as? String ?: return result.noNecessaryDataError()

        qonversionSandwich.detachUserFromRemoteConfiguration(remoteConfigurationId, result.toJsonResultListener())
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

        // Register NoCodes plugin
        try {
            noCodesPlugin = NoCodesPlugin(messenger, application)
        } catch (e: Exception) {
            println("Failed to initialize NoCodesPlugin: ${e.message}")
        }

        // Register entitlements update events
        val updatedEntitlementsListener = BaseListenerWrapper(messenger, EVENT_CHANNEL_UPDATED_ENTITLEMENTS)
        updatedEntitlementsListener.register()
        this.updatedEntitlementsStreamHandler = updatedEntitlementsListener.eventStreamHandler

        // Register promo purchases events. Android SDK does not generate any promo purchases yet
        val promoPurchasesListener = BaseListenerWrapper(messenger, EVENT_CHANNEL_PROMO_PURCHASES)
        promoPurchasesListener.register()
    }

    private fun tearDown() {
        channel?.setMethodCallHandler(null)
        channel = null
        this.updatedEntitlementsStreamHandler = null
        this.noCodesPlugin = null
        this.application = null
    }
}
