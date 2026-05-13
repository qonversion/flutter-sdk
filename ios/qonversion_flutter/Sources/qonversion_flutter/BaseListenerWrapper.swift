//
//  BaseListenerWrapper.swift
//  qonversion_flutter
//
//  Created by Ilya Virnik on 2/7/21.
//

#if canImport(FlutterMacOS)
import FlutterMacOS
#else
import Flutter
#endif

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
    
    let messenger: FlutterBinaryMessenger
    #if canImport(FlutterMacOS)
      messenger = binding.messenger
    #else
      messenger = binding.messenger()
    #endif
    
    eventStreamHandler = T()
    
    let channelName = "qonversion_flutter_\(eventChannelPostfix)"
    
    if let codec = codec {
      eventChannel = FlutterEventChannel(name: channelName,
                                         binaryMessenger: messenger,
                                         codec: codec)
    } else {
      eventChannel = FlutterEventChannel(name: channelName,
                                         binaryMessenger: messenger)
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
