package com.qonversion.flutter.sdk.qonversion_flutter_sdk

import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel.Result
import io.qonversion.sandwich.BridgeData
import io.qonversion.sandwich.NoCodesEventListener
import io.qonversion.sandwich.NoCodesSandwich
import com.google.gson.Gson

class NoCodesPlugin(private val messenger: BinaryMessenger, private val context: Context) : NoCodesEventListener {
    private var noCodesSandwich: NoCodesSandwich? = null
    private val gson = Gson()
    
    // Separate event stream handlers for each event type
    private var screenShownEventStreamHandler: BaseEventStreamHandler? = null
    private var finishedEventStreamHandler: BaseEventStreamHandler? = null
    private var actionStartedEventStreamHandler: BaseEventStreamHandler? = null
    private var actionFailedEventStreamHandler: BaseEventStreamHandler? = null
    private var actionFinishedEventStreamHandler: BaseEventStreamHandler? = null
    private var screenFailedToLoadEventStreamHandler: BaseEventStreamHandler? = null

    companion object {
        private const val SCREEN_SHOWN_EVENT_CHANNEL = "nocodes_screen_shown"
        private const val FINISHED_EVENT_CHANNEL = "nocodes_finished"
        private const val ACTION_STARTED_EVENT_CHANNEL = "nocodes_action_started"
        private const val ACTION_FAILED_EVENT_CHANNEL = "nocodes_action_failed"
        private const val ACTION_FINISHED_EVENT_CHANNEL = "nocodes_action_finished"
        private const val SCREEN_FAILED_TO_LOAD_EVENT_CHANNEL = "nocodes_screen_failed_to_load"
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
    }

    fun initializeNoCodes(args: Map<String, Any>, result: Result) {
        val projectKey = args["projectKey"] as? String ?: return result.noNecessaryDataError()
        val version = args["version"] as? String ?: return result.noNecessaryDataError()
        val source = args["source"] as? String ?: return result.noNecessaryDataError()

        if (projectKey.isNotEmpty()) {
            // Initialize NoCodes Sandwich
            noCodesSandwich = NoCodesSandwich()

            noCodesSandwich?.storeSdkInfo(context, source, version)

            noCodesSandwich?.initialize(context, projectKey)
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
} 