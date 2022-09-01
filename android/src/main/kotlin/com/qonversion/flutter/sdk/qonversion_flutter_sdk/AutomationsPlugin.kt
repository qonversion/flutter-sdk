package com.qonversion.flutter.sdk.qonversion_flutter_sdk

import com.google.gson.Gson
import io.flutter.plugin.common.BinaryMessenger
import io.qonversion.sandwich.AutomationsEventListener
import io.qonversion.sandwich.AutomationsSandwich
import io.qonversion.sandwich.BridgeData

class AutomationsPlugin(messenger: BinaryMessenger) : AutomationsEventListener {
    private var shownScreensStreamHandler: BaseEventStreamHandler? = null
    private var startedActionsStreamHandler: BaseEventStreamHandler? = null
    private var failedActionsStreamHandler: BaseEventStreamHandler? = null
    private var finishedActionsStreamHandler: BaseEventStreamHandler? = null
    private var finishedAutomationsStreamHandler: BaseEventStreamHandler? = null

    private val automationSandwich by lazy {
        AutomationsSandwich()
    }

    companion object {
        private const val EVENT_CHANNEL_SHOWN_SCREENS = "shown_screens"
        private const val EVENT_CHANNEL_STARTED_ACTIONS = "started_actions"
        private const val EVENT_CHANNEL_FAILED_ACTIONS = "failed_actions"
        private const val EVENT_CHANNEL_FINISHED_ACTIONS = "finished_actions"
        private const val EVENT_CHANNEL_FINISHED_AUTOMATIONS = "finished_automations"
    }

    init {
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

    fun subscribe() {
        automationSandwich.subscribe(this)
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
}