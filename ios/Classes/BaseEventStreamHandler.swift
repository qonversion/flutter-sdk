//
//  BaseEventStreamHandler.swift
//  qonversion_flutter
//
//  Created by Ilya Virnik on 2/7/21.
//

import Flutter

protocol EventStreamHandler: NSObject, FlutterStreamHandler {}

class BaseEventStreamHandler: NSObject, EventStreamHandler {
  var eventSink: FlutterEventSink?
  
  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    eventSink = events
    return nil
  }
  
  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    eventSink = nil
    return nil
  }
}
