package com.qonversion.flutter.sdk.qonversion_flutter_sdk

import com.google.gson.Gson
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import io.qonversion.sandwich.AutomationsEventListener
import io.qonversion.sandwich.AutomationsSandwich
import io.qonversion.sandwich.BridgeData

class AutomationsPlugin : MethodChannel.MethodCallHandler, FlutterPlugin, AutomationsEventListener {
    private var channel: MethodChannel? = null

    private var shownScreensStreamHandler: BaseEventStreamHandler? = null
    private var startedActionsStreamHandler: BaseEventStreamHandler? = null
    private var failedActionsStreamHandler: BaseEventStreamHandler? = null
    private var finishedActionsStreamHandler: BaseEventStreamHandler? = null
    private var finishedAutomationsStreamHandler: BaseEventStreamHandler? = null

    private val automationSandwich by lazy {
        AutomationsSandwich()
    }

    companion object {
        private const val METHOD_CHANNEL = "automations_plugin"

        private const val EVENT_CHANNEL_SHOWN_SCREENS = "shown_screens"
        private const val EVENT_CHANNEL_STARTED_ACTIONS = "started_actions"
        private const val EVENT_CHANNEL_FAILED_ACTIONS = "failed_actions"
        private const val EVENT_CHANNEL_FINISHED_ACTIONS = "finished_actions"
        private const val EVENT_CHANNEL_FINISHED_AUTOMATIONS = "finished_automations"

        // Used for compatibility with the apps, which don't use Android Embedding v2.
        @Suppress("DEPRECATION", "unused")
        @JvmStatic
        fun registerWith(registrar: PluginRegistry.Registrar) {
            val instance = AutomationsPlugin()
            instance.setup(registrar.messenger())
        }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        // Methods without args
        when (call.method) {
            "initialize" -> initialize()
            "subscribe" -> subscribe()
        }

        // Methods with args
        val args = call.arguments() as? Map<String, Any> ?: return result.noArgsError()
        when (call.method) {
            "setNotificationsToken" -> setNotificationsToken(args["notificationsToken"] as? String, result)
            "handleNotification" -> handleNotification(args, result)
            "getNotificationCustomPayload" -> getNotificationCustomPayload(args, result)
            else -> result.notImplemented()
        }
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        setup(binding.binaryMessenger)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        tearDown()
    }

    override fun onAutomationEvent(event: AutomationsEventListener.Event, payload: BridgeData?) {
        val (data, stream) = when (event) {
            AutomationsEventListener.Event.ScreenShown -> Pair(Gson().toJson(payload), shownScreensStreamHandler)
            AutomationsEventListener.Event.ActionStarted -> Pair(Gson().toJson(payload), startedActionsStreamHandler)
            AutomationsEventListener.Event.ActionFinished -> Pair(Gson().toJson(payload), finishedActionsStreamHandler)
            AutomationsEventListener.Event.ActionFailed -> Pair(Gson().toJson(payload), failedActionsStreamHandler)
            AutomationsEventListener.Event.AutomationsFinished -> Pair(payload, finishedAutomationsStreamHandler)
        }

        stream?.eventSink?.success(data)
    }

    private fun initialize() {
        automationSandwich.initialize()
    }

    private fun subscribe() {
        automationSandwich.setDelegate(this)
    }

    private fun setNotificationsToken(token: String?, result: MethodChannel.Result) {
        token?.let {
            automationSandwich.setNotificationToken(it)
            result.success(null)
        } ?: result.noArgsError()
    }

    private fun handleNotification(args: Map<String, Any>, result: MethodChannel.Result) {
        @Suppress("UNCHECKED_CAST")
        val data = args["notificationData"] as? Map<String, Any> ?: return result.noDataError()

        if (data.isEmpty()) {
            return result.noDataError()
        }

        val isQonversionNotification = automationSandwich.handleNotification(data)
        result.success(isQonversionNotification)
    }

    private fun getNotificationCustomPayload(args: Map<String, Any>, result: MethodChannel.Result) {
        @Suppress("UNCHECKED_CAST")
        val data = args["notificationData"] as? Map<String, Any> ?: return result.noDataError()

        if (data.isEmpty()) {
            return result.noDataError()
        }

        val payload = automationSandwich.getNotificationCustomPayload(data)
        val payloadJson = Gson().toJson(payload)
        result.success(payloadJson)
    }

    private fun setup(messenger: BinaryMessenger) {
        channel = MethodChannel(messenger, METHOD_CHANNEL)
        channel?.setMethodCallHandler(this)

        val shownScreensListener = BaseListenerWrapper(messenger, EVENT_CHANNEL_SHOWN_SCREENS)
        shownScreensListener.register()
        shownScreensStreamHandler = shownScreensListener.eventStreamHandler

        val startedActionsListener = BaseListenerWrapper(messenger, EVENT_CHANNEL_STARTED_ACTIONS)
        startedActionsListener.register()
        startedActionsStreamHandler = startedActionsListener.eventStreamHandler

        val failedActionsListener = BaseListenerWrapper(messenger, EVENT_CHANNEL_FAILED_ACTIONS)
        failedActionsListener.register()
        failedActionsStreamHandler = failedActionsListener.eventStreamHandler

        val finishedActionsListener = BaseListenerWrapper(messenger, EVENT_CHANNEL_FINISHED_ACTIONS)
        finishedActionsListener.register()
        finishedActionsStreamHandler = finishedActionsListener.eventStreamHandler

        val finishedAutomationsListener = BaseListenerWrapper(messenger, EVENT_CHANNEL_FINISHED_AUTOMATIONS)
        finishedAutomationsListener.register()
        finishedAutomationsStreamHandler = finishedAutomationsListener.eventStreamHandler
    }

    private fun tearDown() {
        channel?.setMethodCallHandler(null)
        channel = null
    }
}