//
//  Mapper.swift
//  qonversion_flutter
//
//  Created by Ilya Virnik on 11/22/20.
//

import Qonversion

struct PurchaseResult {
  let permissions: [String : Qonversion.Permission]
  let error: Error?
  let isCancelled: Bool
  
  func toMap() -> Dictionary<String, Any?> {
    return [
      "permissions": permissions.mapValues { $0.toMap() },
      "error": error?.localizedDescription,
      "is_cancelled": isCancelled,
    ]
  }
}

extension Qonversion.LaunchResult {
  func toMap() -> Dictionary<String, Any> {
    return [
      "uid": uid,
      "timestamp": timestamp,
      "products": products.mapValues { $0.toMap() },
      "permissions": permissions.mapValues { $0.toMap() },
      "user_products": userPoducts.mapValues { $0.toMap() },
    ]
  }
}

extension Qonversion.Product {
  func toMap() -> Dictionary<String, Any> {
    return [
      "id": qonversionID,
      "store_id": storeID,
      "type": type.rawValue,
      "duration": duration.rawValue,
    ]
  }
}

extension Qonversion.Permission {
  func toMap() -> Dictionary<String, Any?> {
    return [
      "id": permissionID,
      "associated_product": productID,
      "renew_state": renewState.rawValue,
      "started_timestamp": startedDate,
      "expiration_timestamp": expirationDate,
      "active": isActive,
    ]
  }
}
