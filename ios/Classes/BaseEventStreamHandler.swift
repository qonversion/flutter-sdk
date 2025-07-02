//
//  BaseEventStreamHandler.swift
//  qonversion_flutter
//
//  Created by Ilya Virnik on 2/7/21.
//

#if canImport(FlutterMacOS)
import FlutterMacOS
#else
import Flutter
#endif

protocol EventStreamHandler: NSObject, FlutterStreamHandler {}

class BaseEventStreamHandler: NSObject, EventStreamHandler {
  var eventSink: FlutterEventSink?
  
  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    print("BaseEventStreamHandler: onListen called for \(type(of: self))")
    eventSink = events
    print("BaseEventStreamHandler: eventSink set - \(eventSink != nil ? "not nil" : "nil")")
    return nil
  }
  
  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    print("BaseEventStreamHandler: onCancel called for \(type(of: self))")
    eventSink = nil
    return nil
  }
}
