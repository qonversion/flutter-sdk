package com.qonversion.flutter.sdk.qonversion_flutter_sdk

import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel

class BaseListenerWrapper internal constructor(
        private val binaryMessenger: BinaryMessenger,
        private val eventChannelPostfix: String
) {

    private var eventChannel: EventChannel? = null
    var eventStreamHandler: BaseEventStreamHandler? = null

    fun register() {
        eventStreamHandler =
                BaseEventStreamHandler()
        eventChannel = EventChannel(
                binaryMessenger,
                "qonversion_flutter_${eventChannelPostfix}"
        ).apply { setStreamHandler(eventStreamHandler) }
    }

    fun unregister() {
        eventChannel?.setStreamHandler(null)
        eventStreamHandler = null
        eventChannel = null
    }
}