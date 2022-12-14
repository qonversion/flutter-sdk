package com.qonversion.flutter.sdk.qonversion_flutter_sdk

import io.flutter.plugin.common.MethodChannel
import io.qonversion.sandwich.SandwichError

fun MethodChannel.Result.noNecessaryDataError() {
    return error(
        "NoNecessaryDataError",
        "Could not find necessary arguments",
        "Make sure you pass correct call arguments"
    )
}

fun MethodChannel.Result.sandwichError(error: SandwichError) {
    return error(error.code, error.description, error.additionalMessage)
}

fun MethodChannel.Result.purchaseError(error: SandwichError, isCancelled: Boolean) {
    val errorCode = if (isCancelled) "PurchaseCancelledByUser" else error.code
    return error(errorCode, error.description, error.additionalMessage)
}
