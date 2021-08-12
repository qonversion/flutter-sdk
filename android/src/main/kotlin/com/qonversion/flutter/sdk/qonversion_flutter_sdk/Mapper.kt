package com.qonversion.flutter.sdk.qonversion_flutter_sdk

import com.android.billingclient.api.SkuDetails
import com.google.gson.Gson
import com.google.gson.JsonSyntaxException
import com.google.gson.reflect.TypeToken
import com.qonversion.android.sdk.QonversionError
import com.qonversion.android.sdk.QonversionErrorCode
import com.qonversion.android.sdk.dto.QLaunchResult
import com.qonversion.android.sdk.dto.QPermission
import com.qonversion.android.sdk.dto.eligibility.QEligibility
import com.qonversion.android.sdk.dto.eligibility.QIntroEligibilityStatus
import com.qonversion.android.sdk.dto.offerings.QOffering
import com.qonversion.android.sdk.dto.offerings.QOfferings
import com.qonversion.android.sdk.dto.products.QProduct
import com.qonversion.android.sdk.dto.products.QProductDuration
import com.qonversion.android.sdk.dto.products.QProductType
import com.qonversion.android.sdk.dto.products.QTrialDuration

data class PurchaseResult(val permissions: Map<String, QPermission>? = null, val error: QonversionError? = null) {
    fun toMap(): Map<String, Any?> {
        val isUserCancelled = error?.code == QonversionErrorCode.CanceledPurchase
        return mapOf(
                "permissions" to permissions?.mapValues { it.value.toMap() },
                "error" to error.toMap(),
                "is_cancelled" to isUserCancelled
        )
    }
}

fun QonversionError?.toMap(): Map<String, String>? {
    if (this == null) return null

    return mapOf("code" to code.toString(),
            "description" to description,
            "additionalMessage" to additionalMessage)
}

fun QLaunchResult.toMap(): Map<String, Any> {
    return mapOf(
            "uid" to uid,
            "timestamp" to date.time.toDouble(),
            "products" to products.mapValues { it.value.toMap() },
            "permissions" to permissions.mapValues { it.value.toMap() },
            "user_products" to userProducts.mapValues { it.value.toMap() }
    )
}

fun QProduct.toMap(): Map<String, Any?> {
    return mapOf(
            ProductFields.ID to qonversionID,
            ProductFields.STORE_ID to storeID,
            ProductFields.TYPE to type.type,
            ProductFields.DURATION to duration?.type,
            ProductFields.SKU_DETAILS to skuDetail?.toMap(),
            ProductFields.PRETTY_PRICE to prettyPrice,
            ProductFields.TRIAL_DURATION to trialDuration?.type,
            ProductFields.OFFERING_ID to offeringID
    )
}

fun QPermission.toMap(): Map<String, Any?> {
    return mapOf(
            "id" to permissionID,
            "associated_product" to productID,
            "renew_state" to renewState.type,
            "started_timestamp" to startedDate.time.toDouble(),
            "expiration_timestamp" to expirationDate?.time?.toDouble(),
            "active" to isActive()
    )
}

fun QOfferings.toMap(): Map<String, Any?> {
    return mapOf(
            "main" to main?.toMap(),
            "available_offerings" to availableOfferings.map { it.toMap() }
    )
}

fun QOffering.toMap(): Map<String, Any?> {
    return mapOf(
            "id" to offeringID,
            "tag" to tag.tag,
            "products" to products.map { it.toMap() }
    )
}

fun QEligibility.toMap(): Map<String, Any?> {
    return mapOf("status" to status.toInt())
}

fun QIntroEligibilityStatus.toInt(): Int {
    return when (this) {
        QIntroEligibilityStatus.Unknown -> 0
        QIntroEligibilityStatus.NonIntroProduct -> 1
        QIntroEligibilityStatus.Ineligible -> 2
        QIntroEligibilityStatus.Eligible -> 3
    }
}

fun SkuDetails.toMap(): Map<String, Any?> {
    return mapOf(
            "title" to title,
            "description" to description,
            "freeTrialPeriod" to freeTrialPeriod,
            "introductoryPrice" to introductoryPrice,
            "introductoryPriceAmountMicros" to introductoryPriceAmountMicros,
            "introductoryPriceCycles" to introductoryPriceCycles,
            "introductoryPricePeriod" to introductoryPricePeriod,
            "price" to price,
            "priceAmountMicros" to priceAmountMicros,
            "priceCurrencyCode" to priceCurrencyCode,
            "sku" to sku,
            "type" to type,
            "subscriptionPeriod" to subscriptionPeriod,
            "originalPrice" to originalPrice,
            "originalPriceAmountMicros" to originalPriceAmountMicros,
            SkuDetailsFields.ORIGINAL_JSON to originalJson
    )
}

@Throws(JsonSyntaxException::class, IllegalArgumentException::class, ClassCastException::class)
fun mapQProduct(jsonProduct: String): QProduct? {
    val mapType = object : TypeToken<Map<String, Any?>>() {}.type
    val mappedProduct: Map<String, Any?> = Gson().fromJson(jsonProduct, mapType)

    val qonversionId = mappedProduct[ProductFields.ID] as? String ?: return null

    val storeId = mappedProduct[ProductFields.STORE_ID] as? String

    val type = mappedProduct[ProductFields.TYPE] as Double
    val productType = QProductType.fromType(type.toInt())

    val duration = mappedProduct[ProductFields.DURATION] as? Double
    val productDuration = duration?.toInt()?.let { QProductDuration.fromType(it) }

    val prettyPrice = mappedProduct[ProductFields.PRETTY_PRICE] as? String

    val trialDuration = mappedProduct[ProductFields.TRIAL_DURATION] as? Double
    val productTrialDuration = trialDuration?.toInt()?.let { QTrialDuration.fromType(it) }

    val offeringId = mappedProduct[ProductFields.OFFERING_ID] as? String

    val originalSkuDetails = mappedProduct[SkuDetailsFields.ORIGINAL_JSON] as? String
    val skuDetails = originalSkuDetails?.let { SkuDetails(it) }

    return QProduct(qonversionId, storeId, productType, productDuration).also {
        it.skuDetail = skuDetails
        it.offeringID = offeringId
        it.prettyPrice = prettyPrice
        it.trialDuration = productTrialDuration
    }
}
