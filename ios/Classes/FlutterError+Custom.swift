//
//  FlutterError+Custom.swift
//  Pods-Runner
//
//  Created by Ilya Virnik on 6/21/20.
//

import Flutter

extension FlutterError {
  static let noArgs = FlutterError(code: "0",
                                   message: "Could not find call arguments",
                                   details: "Make sure you pass Map as call arguments")
  
  static let noApiKey = FlutterError(code: "1",
                                     message: "Could not find API key",
                                     details: "Please make sure you pass a valid value")
  
  static let noUserId = FlutterError(code: "2",
                                     message: "Could not find userID",
                                     details: "Please make sure you pass a valid value")
  
  static let noAutoTrackPurchases = FlutterError(code: "3",
                                                 message: "Could not find autoTrackPurchases boolean value",
                                                 details: "Please make sure you pass a valid value")
  
  static let noData = FlutterError(code: "4",
                                   message: "Could not find data",
                                   details: "Please make sure you pass a valid value")
  
  static let noProvider = FlutterError(code: "5",
                                       message: "Could not find provider",
                                       details: "Please make sure you pass a valid value")
  
  static func failedToLaunchSdk(_ description: String) -> FlutterError {
    FlutterError(code: "6",
                 message: "Failed to launch Qonversion SDK",
                 details: description)
  }
  
  static func failedToGetProducts(_ description: String) -> FlutterError {
    FlutterError(code: "7",
                 message: "Failed to get products",
                 details: description)
  }
}
