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

import QonversionSandwich

extension FlutterError {
  static private let passValidValue = "Please make sure you pass a valid value"
  
  static let noNecessaryData = FlutterError(code: "NoNecessaryDataError",
                                            message: "Could not find necessary arguments",
                                            details: "Make sure you pass correct call arguments")

  static func sandwichError(_ error: SandwichError) -> FlutterError {
    return mapSandwichError(error, errorCode: error.code)
  }

  static let serializationError = FlutterError(code: "SerializationError",
                                               message: "Failed to serialize response from native bridge",
                                               details: "")
  
  private static func mapSandwichError(_ error: SandwichError, errorCode: String, errorMessage: String? = nil) -> FlutterError {
    var details = "Qonversion Error Code: \(error.code)"
    
    if let additionalMessage = error.additionalMessage {
      details = "\(details). Additional Message: \(additionalMessage)"
    }
    
    return FlutterError(code: errorCode,
                        message: error.details,
                        details: details)
  }
}
