package com.qonversion.flutter.sdk.qonversion_flutter_sdk

import android.app.Activity
import android.app.Application
import androidx.annotation.NonNull
import com.google.gson.Gson
import com.qonversion.android.sdk.*
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

import com.qonversion.android.sdk.dto.QLaunchResult
import com.qonversion.android.sdk.dto.QPermission
import com.qonversion.android.sdk.dto.offerings.QOfferings
import com.qonversion.android.sdk.dto.products.QProduct

/** QonversionFlutterSdkPlugin */
class QonversionFlutterSdkPlugin internal constructor(registrar: Registrar): MethodCallHandler {
    private val activity: Activity = registrar.activity()
    private val application: Application = activity.application

    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "qonversion_flutter_sdk")
            channel.setMethodCallHandler(QonversionFlutterSdkPlugin(registrar))
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {

        // Methods without args

        when (call.method) {
            "products" -> {
                return products(result)
            }
            "syncPurchases" -> {
                return syncPurchases(result)
            }
            "checkPermissions" -> {
                return checkPermissions(result)
            }
            "restore" -> {
                return restore(result)
            }
            "setDebugMode" -> {
                Qonversion.setDebugMode()
                return result.success(null)
            }
            "offerings" -> {
                return offerings(result)
            }
        }

        // Methods with args

        val args = call.arguments() as? Map<String, Any> ?: return result.noArgsError()

        when (call.method) {
            "launch" -> launch(args, result)
            "purchase" -> purchase(args["productId"] as? String, result)
            "updatePurchase" -> updatePurchase(args, result)
            "setUserId" -> setUserId(args["userId"] as? String, result)
            "setProperty" -> setProperty(args, result)
            "setUserProperty" -> setUserProperty(args, result)
            "addAttributionData" -> addAttributionData(args, result)
            else -> result.notImplemented()
        }
    }

    private fun launch(args: Map<String, Any>, result: Result) {
        val apiKey = args["key"] as? String ?: return result.noApiKeyError()
        val isObserveMode = args["isObserveMode"] as? Boolean ?: return result.noArgsError()

        Qonversion.launch(
                application,
                apiKey,
                isObserveMode,
                callback = object: QonversionLaunchCallback {
                    override fun onSuccess(launchResult: QLaunchResult) {
                        result.success(launchResult.toMap())
                    }

                    override fun onError(error: QonversionError) {
                        result.qonversionError(error.description, error.additionalMessage)
                    }
                }
        )
    }

    private fun purchase(productId: String?, result: Result) {
        if (productId == null) {
            result.noProductIdError()
            return
        }

        Qonversion.purchase(activity, productId, callback = object: QonversionPermissionsCallback {
            override fun onSuccess(permissions: Map<String, QPermission>) {
                result.success(PurchaseResult(permissions).toMap())
            }

            override fun onError(error: QonversionError) {
                result.success(PurchaseResult(error = error).toMap())
            }
        })
    }

    private fun updatePurchase(args: Map<String, Any>, result: Result) {
        val newProductId = args["newProductId"] as? String ?: return result.noNewProductIdError()
        val oldProductId = args["oldProductId"] as? String ?: return result.noOldProductIdError()
        val prorationMode = args["proration_mode"] as? Int
        
        Qonversion.updatePurchase(activity, newProductId, oldProductId, prorationMode, callback = object: QonversionPermissionsCallback {
            override fun onSuccess(permissions: Map<String, QPermission>) {
                result.success(permissions.mapValues { it.value.toMap() })
            }

            override fun onError(error: QonversionError) {
                result.qonversionError(error.description, error.additionalMessage)
            }
        })
    }

    private fun checkPermissions(result: Result) {
        Qonversion.checkPermissions(object: QonversionPermissionsCallback {
            override fun onSuccess(permissions: Map<String, QPermission>) {
                result.success(permissions.mapValues { it.value.toMap() })
            }

            override fun onError(error: QonversionError) {
                result.qonversionError(error.description, error.additionalMessage)
            }
        })
    }

    private fun restore(result: Result) {
        Qonversion.restore(object: QonversionPermissionsCallback {
            override fun onSuccess(permissions: Map<String, QPermission>) {
                result.success(permissions.mapValues { it.value.toMap() })
            }

            override fun onError(error: QonversionError) {
                result.qonversionError(error.description, error.additionalMessage)
            }
        })
    }

    private fun offerings(result: Result) {
        Qonversion.offerings(callback = object: QonversionOfferingsCallback {
            override fun onSuccess(offerings: QOfferings) {
                val jsonOfferings = Gson().toJson(offerings.toMap())
                result.success(jsonOfferings)
            }

            override fun onError(error: QonversionError) {
                result.offeringsError(error.description, error.additionalMessage)
            }
        })
    }

    private fun products(result: Result) {
        Qonversion.products(callback = object: QonversionProductsCallback {
            override fun onSuccess(products: Map<String, QProduct>) {
                result.success(products.mapValues { it.value.toMap() })
            }

            override fun onError(error: QonversionError) {
                result.qonversionError(error.description, error.additionalMessage)
            }
        })
    }

    private fun setUserId(userId: String?, result: Result) {
        if (userId == null) {
            result.noUserIdError()
            return
        }

        Qonversion.setUserID(userId)
        result.success(null)
    }

    private fun setProperty(args: Map<String, Any>, result: Result) {
        val rawProperty = args["property"] as? String ?: return result.noProperty()

        val value = args["value"] as? String ?: return result.noPropertyValue()

        try {
            Qonversion.setProperty(QUserProperties.valueOf(rawProperty), value)
            result.success(null)
        } catch (e: IllegalArgumentException) {
            result.parsingError(e.localizedMessage)
        }
    }

    private fun setUserProperty(args: Map<String, Any>, result: Result) {
        val property = args["property"] as? String ?: return result.noProperty()

        val value = args["value"] as? String ?: return result.noPropertyValue()

        Qonversion.setUserProperty(property, value)
        result.success(null)
    }

    private fun syncPurchases(result: Result) {
        Qonversion.syncPurchases()
        result.success(null)
    }

    private fun addAttributionData(args: Map<String, Any>, result: Result) {
        val data = args["data"] as? Map<String, Any> ?: return result.noDataError()

        if (data.isEmpty()) {
            return result.noDataError()
        }

        val provider = args["provider"] as? String ?: return result.noProviderError()

        val castedProvider = when (provider) {
            "appsFlyer" -> AttributionSource.AppsFlyer
            else -> null
        }
                ?: return result.success(null)

        Qonversion.attribution(data, castedProvider)

        result.success(null)
    }
}
