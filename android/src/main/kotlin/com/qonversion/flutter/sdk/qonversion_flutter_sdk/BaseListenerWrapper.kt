package com.qonversion.flutter.sdk.qonversion_flutter_sdk

import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel

abstract class BaseListenerWrapper(
        val binaryMessenger: BinaryMessenger
) {

    protected abstract val eventChannelPostfix: String

    protected var eventChannel: EventChannel? = null
    protected var eventStreamHandler: BaseEventStreamHandler? = null

    fun register() {
        eventStreamHandler =
                BaseEventStreamHandler()
        eventChannel = EventChannel(
                binaryMessenger,
                "qonversion_flutter_/${eventChannelPostfix}"
        ).apply { setStreamHandler(eventStreamHandler) }
    }

    fun unregister() {
        eventChannel?.setStreamHandler(null)
        eventStreamHandler = null
        eventChannel = null
    }
}