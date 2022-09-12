//
//  Extensions.swift
//  qonversion_flutter
//
//  Created by Kamo Spertsyan on 05.09.2022.
//

import Foundation

extension Dictionary {
  func toJson() -> String? {
    guard let jsonData = try? JSONSerialization.data(withJSONObject: self,
                                                     options: []) else {
      return nil
    }

    return String(data: jsonData, encoding: .utf8)
  }
}
