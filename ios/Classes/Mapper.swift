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
  let error: Error?
  let isCancelled: Bool
  
  func toMap() -> [String: Any?] {
    return [
      "permissions": permissions.mapValues { $0.toMap() },
      "error": error?.localizedDescription,
      "is_cancelled": isCancelled,
    ]
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
      "id": qonversionID,
      "store_id": storeID,
      "type": type.rawValue,
      "duration": duration.rawValue,
      "sk_product": skProduct?.toMap(),
      "pretty_price": prettyPrice
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
