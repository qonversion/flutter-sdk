//
//  SKProduct+toMap.swift
//  qonversion_flutter
//
//  Created by Ilya Virnik on 12/2/20.
//

import StoreKit

extension SKProduct {
  func toMap() -> [String: Any?] {
    var map: [String: Any?] = [
      "localizedDescription": localizedDescription,
      "localizedTitle": localizedTitle,
      "productIdentifier": productIdentifier,
      "price": price.description,
      "priceLocale": priceLocale.toMap()
    ]
    
    if #available(iOS 11.2, macOS 10.13.2, *) {
      map["subscriptionPeriod"] = subscriptionPeriod?.toMap()
      map["introductoryPrice"] = introductoryPrice?.toMap()
    }

    if #available(iOS 12.0, macOS 10.14, *) {
      map["subscriptionGroupIdentifier"] = subscriptionGroupIdentifier
    }
    
    return map
  }
}

extension Locale {
  func toMap() -> [String: Any?] {
    return [
      "currencySymbol": currencySymbol,
      "currencyCode": currencyCode
    ]
  }
}

@available(iOS 11.2, macOS 10.13.2, *)
extension SKProductSubscriptionPeriod {
  func toMap() -> [String: Any] {
    return [
      "numberOfUnits": numberOfUnits,
      "unit": unit.rawValue
    ]
  }
}

@available(iOS 11.2, macOS 10.13.2, *)
extension SKProductDiscount {
  func toMap() -> [String: Any] {
    return [
      "price": price.description,
      "numberOfPeriods": numberOfPeriods,
      "subscriptionPeriod": subscriptionPeriod.toMap(),
      "paymentMode": paymentMode.rawValue,
      "priceLocale": priceLocale.toMap()
    ]
  }
}

