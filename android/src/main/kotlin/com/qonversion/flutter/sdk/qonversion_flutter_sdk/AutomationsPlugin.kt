package com.qonversion.flutter.sdk.qonversion_flutter_sdk

import com.google.gson.Gson
import com.qonversion.android.sdk.automations.Automations
import com.qonversion.android.sdk.automations.AutomationsDelegate
import com.qonversion.android.sdk.automations.QActionResult
import io.flutter.plugin.common.BinaryMessenger

class AutomationsPlugin {
    private var shownScreensStreamHandler: BaseEventStreamHandler? = null
    private var startedActionsStreamHandler: BaseEventStreamHandler? = null
    private var failedActionsStreamHandler: BaseEventStreamHandler? = null
    private var finishedActionsStreamHandler: BaseEventStreamHandler? = null
    private var finishedAutomationsStreamHandler: BaseEventStreamHandler? = null
    private val automationsDelegate = getAutomationsDelegate()

    companion object {
        private const val EVENT_CHANNEL_SHOWN_SCREENS = "shown_screens"
        private const val EVENT_CHANNEL_STARTED_ACTIONS = "started_actions"
        private const val EVENT_CHANNEL_FAILED_ACTIONS = "failed_actions"
        private const val EVENT_CHANNEL_FINISHED_ACTIONS = "finished_actions"
        private const val EVENT_CHANNEL_FINISHED_AUTOMATIONS = "finished_automations"
    }

    fun register(messenger: BinaryMessenger) {
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

    fun setAutomationsDelegate() {
        Automations.setDelegate(automationsDelegate)
    }

    private fun getAutomationsDelegate() = object : AutomationsDelegate {
        override fun automationsDidShowScreen(screenId: String) {
            shownScreensStreamHandler?.eventSink?.success(screenId)
        }

        override fun automationsDidStartExecuting(actionResult: QActionResult) {
            val payload = Gson().toJson(actionResult.toMap())
            startedActionsStreamHandler?.eventSink?.success(payload)
        }

        override fun automationsDidFailExecuting(actionResult: QActionResult) {
            val payload = Gson().toJson(actionResult.toMap())
            failedActionsStreamHandler?.eventSink?.success(payload)
        }

        override fun automationsDidFinishExecuting(actionResult: QActionResult) {
            val payload = Gson().toJson(actionResult.toMap())
            finishedActionsStreamHandler?.eventSink?.success(payload)
        }

        override fun automationsFinished() {
            finishedAutomationsStreamHandler?.eventSink?.success(null)
        }
    }
}