//
//  BaseListenerWrapper.swift
//  qonversion_flutter
//
//  Created by Ilya Virnik on 2/7/21.
//

import Flutter

typealias MethodCodec = NSObject & FlutterMethodCodec

class FlutterListenerWrapper<T>: NSObject where T: EventStreamHandler {
  let binding: FlutterPluginRegistrar
  let eventChannelPostfix: String
  
  var eventChannel: FlutterEventChannel?
  var eventStreamHandler: T?
  
  init(_ binding: FlutterPluginRegistrar, postfix: String) {
    self.binding = binding
    self.eventChannelPostfix = postfix
  }
  
  func register(_ codec: MethodCodec? = nil, completion: ((T?) -> Void)? = nil) {
    guard eventStreamHandler == nil else {
      return
    }
    eventStreamHandler = T()
    if let codec = codec {
      eventChannel = FlutterEventChannel(name: "qonversion_flutter_\(eventChannelPostfix)",
                                         binaryMessenger: binding.messenger(),
                                         codec: codec)
    } else {
      eventChannel = FlutterEventChannel(name: "qonversion_flutter_\(eventChannelPostfix)",
                                         binaryMessenger: binding.messenger())
    }
    
    eventChannel?.setStreamHandler(eventStreamHandler)
    
    completion?(eventStreamHandler)
  }
  
  func unregister() {
    eventChannel?.setStreamHandler(nil)
    eventStreamHandler = nil
    eventChannel = nil
  }
}
