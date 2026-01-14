package com.qonversion.flutter.sdk.qonversion_flutter_sdk

import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel.Result
import io.qonversion.sandwich.BridgeData
import io.qonversion.sandwich.NoCodesEventListener
import io.qonversion.sandwich.NoCodesPurchaseDelegateBridge
import io.qonversion.sandwich.NoCodesSandwich
import com.google.gson.Gson

class NoCodesPlugin(private val messenger: BinaryMessenger, private val context: Context) : NoCodesEventListener, NoCodesPurchaseDelegateBridge {
    private var noCodesSandwich: NoCodesSandwich? = null
    private val gson = Gson()
    
    // Separate event stream handlers for each event type
    private var screenShownEventStreamHandler: BaseEventStreamHandler? = null
    private var finishedEventStreamHandler: BaseEventStreamHandler? = null
    private var actionStartedEventStreamHandler: BaseEventStreamHandler? = null
    private var actionFailedEventStreamHandler: BaseEventStreamHandler? = null
    private var actionFinishedEventStreamHandler: BaseEventStreamHandler? = null
    private var screenFailedToLoadEventStreamHandler: BaseEventStreamHandler? = null
    
    // Purchase delegate event stream handlers
    private var purchaseEventStreamHandler: BaseEventStreamHandler? = null
    private var restoreEventStreamHandler: BaseEventStreamHandler? = null

    companion object {
        private const val SCREEN_SHOWN_EVENT_CHANNEL = "nocodes_screen_shown"
        private const val FINISHED_EVENT_CHANNEL = "nocodes_finished"
        private const val ACTION_STARTED_EVENT_CHANNEL = "nocodes_action_started"
        private const val ACTION_FAILED_EVENT_CHANNEL = "nocodes_action_failed"
        private const val ACTION_FINISHED_EVENT_CHANNEL = "nocodes_action_finished"
        private const val SCREEN_FAILED_TO_LOAD_EVENT_CHANNEL = "nocodes_screen_failed_to_load"
        private const val PURCHASE_EVENT_CHANNEL = "nocodes_purchase"
        private const val RESTORE_EVENT_CHANNEL = "nocodes_restore"
    }

    init {
        setup()
    }

    private fun setup() {
        // Register separate event channels for each event type
        val screenShownListener = BaseListenerWrapper(messenger, SCREEN_SHOWN_EVENT_CHANNEL)
        screenShownListener.register()
        this.screenShownEventStreamHandler = screenShownListener.eventStreamHandler
        
        val finishedListener = BaseListenerWrapper(messenger, FINISHED_EVENT_CHANNEL)
        finishedListener.register()
        this.finishedEventStreamHandler = finishedListener.eventStreamHandler
        
        val actionStartedListener = BaseListenerWrapper(messenger, ACTION_STARTED_EVENT_CHANNEL)
        actionStartedListener.register()
        this.actionStartedEventStreamHandler = actionStartedListener.eventStreamHandler
        
        val actionFailedListener = BaseListenerWrapper(messenger, ACTION_FAILED_EVENT_CHANNEL)
        actionFailedListener.register()
        this.actionFailedEventStreamHandler = actionFailedListener.eventStreamHandler
        
        val actionFinishedListener = BaseListenerWrapper(messenger, ACTION_FINISHED_EVENT_CHANNEL)
        actionFinishedListener.register()
        this.actionFinishedEventStreamHandler = actionFinishedListener.eventStreamHandler
        
        val screenFailedToLoadListener = BaseListenerWrapper(messenger, SCREEN_FAILED_TO_LOAD_EVENT_CHANNEL)
        screenFailedToLoadListener.register()
        this.screenFailedToLoadEventStreamHandler = screenFailedToLoadListener.eventStreamHandler
        
        // Register purchase delegate event channels
        val purchaseListener = BaseListenerWrapper(messenger, PURCHASE_EVENT_CHANNEL)
        purchaseListener.register()
        this.purchaseEventStreamHandler = purchaseListener.eventStreamHandler
        
        val restoreListener = BaseListenerWrapper(messenger, RESTORE_EVENT_CHANNEL)
        restoreListener.register()
        this.restoreEventStreamHandler = restoreListener.eventStreamHandler
    }

    fun initializeNoCodes(args: Map<String, Any>, result: Result) {
        val projectKey = args["projectKey"] as? String ?: return result.noNecessaryDataError()
        val version = args["version"] as? String ?: return result.noNecessaryDataError()
        val source = args["source"] as? String ?: return result.noNecessaryDataError()
        val locale = args["locale"] as? String

        if (projectKey.isNotEmpty()) {
            // Initialize NoCodes Sandwich
            noCodesSandwich = NoCodesSandwich()

            noCodesSandwich?.storeSdkInfo(context, source, version)

            noCodesSandwich?.initialize(context, projectKey, null, null, null, locale)
            noCodesSandwich?.setDelegate(this)
            result.success(null)
        } else {
            result.noNecessaryDataError()
        }
    }

    fun setScreenPresentationConfig(config: Map<String, Any>?, contextKey: String?, result: Result) {
        if (config != null) {
            noCodesSandwich?.setScreenPresentationConfig(config, contextKey)
            result.success(null)
        } else {
            result.noNecessaryDataError()
        }
    }

    fun showNoCodesScreen(contextKey: String?, result: Result) {
        if (contextKey != null) {
            noCodesSandwich?.showScreen(contextKey)
            result.success(null)
        } else {
            result.noNecessaryDataError()
        }
    }

    fun closeNoCodes(result: Result) {
        noCodesSandwich?.close()
        result.success(null)
    }

    fun setLocale(locale: String?, result: Result) {
        noCodesSandwich?.setLocale(locale)
        result.success(null)
    }

    // MARK: - Purchase Delegate Methods
    
    fun setPurchaseDelegate(result: Result) {
        noCodesSandwich?.setPurchaseDelegate(this)
        result.success(null)
    }
    
    fun delegatedPurchaseCompleted(result: Result) {
        noCodesSandwich?.delegatedPurchaseCompleted()
        result.success(null)
    }
    
    fun delegatedPurchaseFailed(errorMessage: String?, result: Result) {
        noCodesSandwich?.delegatedPurchaseFailed(errorMessage ?: "Unknown error")
        result.success(null)
    }
    
    fun delegatedRestoreCompleted(result: Result) {
        noCodesSandwich?.delegatedRestoreCompleted()
        result.success(null)
    }
    
    fun delegatedRestoreFailed(errorMessage: String?, result: Result) {
        noCodesSandwich?.delegatedRestoreFailed(errorMessage ?: "Unknown error")
        result.success(null)
    }

    // NoCodesEventListener implementation
    override fun onNoCodesEvent(event: NoCodesEventListener.Event, payload: BridgeData?) {
        val eventData = mapOf("payload" to (payload ?: emptyMap<String, Any>()))
        
        // Convert to JSON string
        val jsonString = gson.toJson(eventData)
        
        when (event) {
            NoCodesEventListener.Event.ScreenShown -> {
                screenShownEventStreamHandler?.eventSink?.success(jsonString)
            }
            NoCodesEventListener.Event.Finished -> {
                finishedEventStreamHandler?.eventSink?.success(jsonString)
            }
            NoCodesEventListener.Event.ActionStarted -> {
                actionStartedEventStreamHandler?.eventSink?.success(jsonString)
            }
            NoCodesEventListener.Event.ActionFailed -> {
                actionFailedEventStreamHandler?.eventSink?.success(jsonString)
            }
            NoCodesEventListener.Event.ActionFinished -> {
                actionFinishedEventStreamHandler?.eventSink?.success(jsonString)
            }
            NoCodesEventListener.Event.ScreenFailedToLoad -> {
                screenFailedToLoadEventStreamHandler?.eventSink?.success(jsonString)
            }
        }
    }
    
    // NoCodesPurchaseDelegateBridge implementation
    override fun purchase(product: BridgeData) {
        val jsonString = gson.toJson(product)
        purchaseEventStreamHandler?.eventSink?.success(jsonString)
    }
    
    override fun restore() {
        restoreEventStreamHandler?.eventSink?.success("restore")
    }
}
