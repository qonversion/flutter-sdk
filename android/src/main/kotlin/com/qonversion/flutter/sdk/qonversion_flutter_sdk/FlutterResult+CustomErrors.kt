package com.qonversion.flutter.sdk.qonversion_flutter_sdk

import io.flutter.plugin.common.MethodChannel

fun MethodChannel.Result.noArgsError() {
    return this.error("0", "Could not find call arguments", "Make sure you pass Map as call arguments")
}

fun MethodChannel.Result.noApiKeyError() {
    return this.error("1", "Could not find API key", "Make sure you pass Map as call arguments")
}

fun MethodChannel.Result.noUserIdError() {
    return this.error("2", "Could not find userID", "Make sure you pass Map as call arguments")
}

fun MethodChannel.Result.noAutoTrackPurchasesError() {
    return this.error("3", "Could not find autoTrackPurchases boolean value", "Make sure you pass Map as call arguments")
}

fun MethodChannel.Result.noDataError() {
    return this.error("4", "Could not find data", "Please make sure you pass a valid value")
}

fun MethodChannel.Result.noProviderError() {
    return this.error("5", "Could not find provider", "Please make sure you pass a valid value")
}

fun MethodChannel.Result.qonversionError(message: String, cause: String) {
    return this.error("9", message, cause)
}