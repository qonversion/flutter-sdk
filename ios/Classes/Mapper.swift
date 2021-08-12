//
//  Mapper.swift
//  qonversion_flutter
//
//  Created by Ilya Virnik on 11/22/20.
//

import Qonversion

enum ParsingError: Error {
    case runtimeError(String)
}

struct PurchaseResult {
  let permissions: [String : Qonversion.Permission]
  let error: NSError?
  let isCancelled: Bool
  
  func toMap() -> [String: Any?] {
    return [
      "permissions": permissions.mapValues { $0.toMap() },
      "error": error?.toMap(),
      "is_cancelled": isCancelled,
    ]
  }
  
}

extension NSError {
  func toMap() -> [String: Any?] {
    let errorMap = [
      "code": code,
      "description": localizedDescription,
      "additionalMessage": userInfo[NSDebugDescriptionErrorKey]]
    
    return errorMap
  }
}

extension Qonversion.LaunchResult {
  func toMap() -> [String: Any] {
    return [
      "uid": uid,
      "timestamp": NSNumber(value: timestamp).intValue * 1000,
      "products": products.mapValues { $0.toMap() },
      "permissions": permissions.mapValues { $0.toMap() },
      "user_products": userPoducts.mapValues { $0.toMap() },
    ]
  }
}

extension Qonversion.Product {
  func toMap() -> [String: Any?] {
    return [
      ProductFields.id: qonversionID,
      ProductFields.storeId: storeID,
      ProductFields.type: type.rawValue,
      ProductFields.duration: duration.rawValue,
      ProductFields.skProduct: skProduct?.toMap(),
      ProductFields.prettyPrice: prettyPrice,
      ProductFields.trialDuration: trialDuration.rawValue,
      ProductFields.offeringId: offeringID
    ]
  }
}

extension Qonversion.Permission {
  func toMap() -> [String: Any?] {
    return [
      "id": permissionID,
      "associated_product": productID,
      "renew_state": renewState.rawValue,
      "started_timestamp": startedDate.timeIntervalSince1970 * 1000,
      "expiration_timestamp": expirationDate?.timeIntervalSince1970 != nil ? expirationDate!.timeIntervalSince1970 * 1000 : nil,
      "active": isActive,
    ]
  }
}

extension Qonversion.Property {
  static func fromString(_ string: String) throws -> Self {
    switch string {
    case "Email":
      return .email

    case "Name":
      return .name

    case "AppsFlyerUserId":
      return .appsFlyerUserID

    case "AdjustAdId":
      return .adjustUserID
      
    case "KochavaDeviceId":
      return .kochavaDeviceID
      
    default:
      throw ParsingError.runtimeError("Could not parse Qonversion.Property")
    }
  }
}

extension Qonversion.Offerings {
  func toMap() -> [String: Any?] {
    return [
      "main": main?.toMap(),
      "available_offerings": availableOfferings.map { $0.toMap() }
    ]
  }
}

extension Qonversion.Offering {
  func toMap() -> [String: Any?] {
    return [
      "id": identifier,
      "tag": tag.rawValue,
      "products": products.map { $0.toMap() }
    ]
  }
}

extension Qonversion.IntroEligibility {
  func toMap() -> [String: Any?] {
    return ["status": status.rawValue]
  }
}

// MARK: - JSON Encoding
extension Dictionary {
  func toJson() -> String? {
    guard let jsonData = try? JSONSerialization.data(withJSONObject: self,
                                                     options: []) else {
      return nil
    }
    
    return String(data: jsonData, encoding: .utf8)
  }
  
  func toProduct() -> Qonversion.Product? {
    guard let data = self as? [String: Any],
          let id = data[ProductFields.id] as? String
    else { return nil }
    
    let product = Qonversion.Product()
    
    product.qonversionID = id

    product.storeID = data[ProductFields.storeId] as? String ?? ""
    
    if let type = data[ProductFields.type] as? Int {
      product.type = Qonversion.ProductType(rawValue: type) ?? Qonversion.ProductType.unknown
    }
    
    if let duration = data[ProductFields.duration] as? Int {
      product.duration = Qonversion.ProductDuration(rawValue: duration) ?? Qonversion.ProductDuration.durationUnknown
    }
    
    product.prettyPrice = data[ProductFields.prettyPrice] as? String ?? ""
    
    product.offeringID = data[ProductFields.offeringId] as? String
    
    if let trialDuration = data[ProductFields.trialDuration] as? Int {
      product.trialDuration = Qonversion.TrialDuration(rawValue: trialDuration) ?? Qonversion.TrialDuration.notAvailable
    }
    
    return product
  }
}

