//
//  FlutterError+Custom.swift
//  Pods-Runner
//
//  Created by Ilya Virnik on 6/21/20.
//

#if canImport(FlutterMacOS)
import FlutterMacOS
#else
import Flutter
#endif

extension FlutterError {
  static private let passValidValue = "Please make sure you pass a valid value"
  
  static let noArgs = FlutterError(code: "0",
                                   message: "Could not find call arguments",
                                   details: "Make sure you pass Map as call arguments")
  
  static let noApiKey = FlutterError(code: "1",
                                     message: "Could not find API key",
                                     details: passValidValue)
  
  static let noUserId = FlutterError(code: "2",
                                     message: "Could not find userID",
                                     details: passValidValue)
  
  static let noAutoTrackPurchases = FlutterError(code: "3",
                                                 message: "Could not find autoTrackPurchases boolean value",
                                                 details: passValidValue)
  
  static let noData = FlutterError(code: "4",
                                   message: "Could not find data",
                                   details: passValidValue)
  
  static let noProvider = FlutterError(code: "5",
                                       message: "Could not find provider",
                                       details: passValidValue)
  
  static func failedToGetProducts(_ description: String) -> FlutterError {
    return FlutterError(code: "7",
                        message: "Failed to get products",
                        details: description)
  }
  
  static let noProductId = FlutterError(code: "8",
                                        message: "Could not find productId value",
                                        details: "Please provide valid productId")
  
  static func qonversionError(_ description: String) -> FlutterError {
    return FlutterError(code: "9",
                        message: "Qonversion Error",
                        details: description)
  }
  
  static func parsingError(_ description: String) -> FlutterError {
    return FlutterError(code: "12",
                        message: "Arguments Parsing Error",
                        details: description)
  }
  
  static let noProperty = FlutterError(code: "13",
                                       message: "Could not find property",
                                       details: passValidValue)
  
  static let noPropertyValue = FlutterError(code: "14",
                                            message: "Could not find property value",
                                            details: passValidValue)
  
  static func offeringsError(_ description: String) -> FlutterError {
    return FlutterError(code: "OFFERINGS",
                        message: "Could not get offerings",
                        details: description)
  }
  
  static let noSdkInfo = FlutterError(code: "15",
                                      message: "Could not find sdk info",
                                      details: passValidValue)

  static let noLifetime = FlutterError(code: "16",
                                       message: "Could not find lifetime",
                                       details: passValidValue)

}
