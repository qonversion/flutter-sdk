package com.qonversion.flutter.sdk.qonversion_flutter_sdk

import com.google.gson.Gson
import io.flutter.plugin.common.MethodChannel
import io.qonversion.sandwich.PurchaseResultListener
import io.qonversion.sandwich.ResultListener
import io.qonversion.sandwich.SandwichError

internal fun MethodChannel.Result.toResultListener(): ResultListener {
    return object : ResultListener {
        override fun onError(error: SandwichError) {
            sandwichError(error)
        }

        override fun onSuccess(data: Map<String, Any?>) {
            success(data)
        }
    }
}

internal fun MethodChannel.Result.toJsonResultListener(): ResultListener {
    return object : ResultListener {
        override fun onError(error: SandwichError) {
            sandwichError(error)
        }

        override fun onSuccess(data: Map<String, Any?>) {
            success(Gson().toJson(data))
        }
    }
}

internal fun MethodChannel.Result.toPurchaseResultListener(): PurchaseResultListener {
    return object : PurchaseResultListener {
        override fun onError(error: SandwichError, isCancelled: Boolean) {
            purchaseError(error, isCancelled)
        }

        override fun onSuccess(data: Map<String, Any?>) {
            success(data)
        }
    }
}