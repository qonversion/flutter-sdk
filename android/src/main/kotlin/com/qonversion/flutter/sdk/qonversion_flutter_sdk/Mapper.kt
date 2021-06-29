package com.qonversion.flutter.sdk.qonversion_flutter_sdk

import com.android.billingclient.api.SkuDetails
import com.google.gson.Gson
import com.google.gson.JsonSyntaxException
import com.google.gson.annotations.SerializedName
import com.qonversion.android.sdk.QonversionError
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
import com.qonversion.flutter.sdk.qonversion_flutter_sdk.ProductFields.DURATION
import com.qonversion.flutter.sdk.qonversion_flutter_sdk.ProductFields.ID
import com.qonversion.flutter.sdk.qonversion_flutter_sdk.ProductFields.OFFERING_ID
import com.qonversion.flutter.sdk.qonversion_flutter_sdk.ProductFields.PRETTY_PRICE
import com.qonversion.flutter.sdk.qonversion_flutter_sdk.ProductFields.SKU_DETAILS
import com.qonversion.flutter.sdk.qonversion_flutter_sdk.ProductFields.STORE_ID
import com.qonversion.flutter.sdk.qonversion_flutter_sdk.ProductFields.TRIAL_DURATION
import com.qonversion.flutter.sdk.qonversion_flutter_sdk.ProductFields.TYPE

data class InnerQProduct(
        @SerializedName(ID) val qonversionID: String,
        @SerializedName(STORE_ID) val storeID: String?,
        @SerializedName(TYPE) val type: Int,
        @SerializedName(DURATION) val duration: Int?,
        @SerializedName(OFFERING_ID) val offeringID: String?,
        @SerializedName(PRETTY_PRICE) val prettyPrice: String?,
        @SerializedName(TRIAL_DURATION) val trialDuration: Int?,
        @SerializedName(SKU_DETAILS) val skuDetails: Map<String, Any?>?
)

data class PurchaseResult(val permissions: Map<String, QPermission>? = null, val error: QonversionError? = null) {
    fun toMap(): Map<String, Any?> {
        return mapOf(
                "permissions" to permissions?.mapValues { it.value.toMap() },
                "error" to (error?.description ?: error?.additionalMessage)
        )
    }
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
            ID to qonversionID,
            STORE_ID to storeID,
            TYPE to type.type,
            DURATION to duration?.type,
            SKU_DETAILS to skuDetail?.toMap(),
            PRETTY_PRICE to prettyPrice,
            TRIAL_DURATION to trialDuration?.type,
            OFFERING_ID to offeringID
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

@Throws(JsonSyntaxException::class, IllegalArgumentException::class)
fun mapQProduct(jsonProduct: String): QProduct {
    val innerProduct = Gson().fromJson(jsonProduct, InnerQProduct::class.java)
    val skuDetailsJson = innerProduct.skuDetails?.get(SkuDetailsFields.ORIGINAL_JSON) as? String
    val skuDetails = skuDetailsJson?.let { SkuDetails(it) }
    val productDuration = innerProduct.duration?.let { QProductDuration.fromType(it) }
    val productType = QProductType.fromType(innerProduct.type)
    val trialDuration = innerProduct.trialDuration?.let { QTrialDuration.fromType(it) }

    return QProduct(innerProduct.qonversionID, innerProduct.storeID, productType, productDuration).also {
        it.skuDetail = skuDetails
        it.offeringID = innerProduct.offeringID
        it.prettyPrice = innerProduct.prettyPrice
        it.trialDuration = trialDuration
    }
}
