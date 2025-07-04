//
//  NoCodesPlugin.swift
//  qonversion_flutter
//
//  Created by Assistant on 08.05.2025.
//  Copyright © 2025 Qonversion Inc. All rights reserved.
//

import Foundation
import Flutter
import QonversionSandwich

public class NoCodesPlugin: NSObject {
    // Event type constants
    private let eventScreenShown = "nocodes_screen_shown"
    private let eventFinished = "nocodes_finished"
    private let eventActionStarted = "nocodes_action_started"
    private let eventActionFailed = "nocodes_action_failed"
    private let eventActionFinished = "nocodes_action_finished"
    private let eventScreenFailedToLoad = "nocodes_screen_failed_to_load"
    private var screenShownEventStreamHandler: BaseEventStreamHandler?
    private var finishedEventStreamHandler: BaseEventStreamHandler?
    private var actionStartedEventStreamHandler: BaseEventStreamHandler?
    private var actionFailedEventStreamHandler: BaseEventStreamHandler?
    private var actionFinishedEventStreamHandler: BaseEventStreamHandler?
    private var screenFailedToLoadEventStreamHandler: BaseEventStreamHandler?
    private var noCodesSandwich: NoCodesSandwich?
    
    public func register(_ registrar: FlutterPluginRegistrar) {
        
        // Register separate event channels for each event type
        let screenShownListener = FlutterListenerWrapper<BaseEventStreamHandler>(registrar, postfix: eventScreenShown)
        screenShownListener.register() { eventStreamHandler in
            self.screenShownEventStreamHandler = eventStreamHandler
        }
        
        let finishedListener = FlutterListenerWrapper<BaseEventStreamHandler>(registrar, postfix: eventFinished)
        finishedListener.register() { eventStreamHandler in
            self.finishedEventStreamHandler = eventStreamHandler
        }
        
        let actionStartedListener = FlutterListenerWrapper<BaseEventStreamHandler>(registrar, postfix: eventActionStarted)
        actionStartedListener.register() { eventStreamHandler in
            self.actionStartedEventStreamHandler = eventStreamHandler
        }
        
        let actionFailedListener = FlutterListenerWrapper<BaseEventStreamHandler>(registrar, postfix: eventActionFailed)
        actionFailedListener.register() { eventStreamHandler in
            self.actionFailedEventStreamHandler = eventStreamHandler
        }
        
        let actionFinishedListener = FlutterListenerWrapper<BaseEventStreamHandler>(registrar, postfix: eventActionFinished)
        actionFinishedListener.register() { eventStreamHandler in
            self.actionFinishedEventStreamHandler = eventStreamHandler
        }
        
        let screenFailedToLoadListener = FlutterListenerWrapper<BaseEventStreamHandler>(registrar, postfix: eventScreenFailedToLoad)
        screenFailedToLoadListener.register() { eventStreamHandler in
            self.screenFailedToLoadEventStreamHandler = eventStreamHandler
        }
        
    }
    
    public func initialize(_ args: [String: Any]?, _ result: @escaping FlutterResult) {
        guard let args = args,
              let projectKey = args["projectKey"] as? String else {
            return result(FlutterError.noNecessaryData)
        }
        
        if noCodesSandwich == nil {
            noCodesSandwich = NoCodesSandwich(noCodesEventListener: self)
        }
        
        noCodesSandwich?.initialize(projectKey: projectKey)
        result(nil)
    }
    
    @MainActor public func setScreenPresentationConfig(_ args: [String: Any]?, _ result: @escaping FlutterResult) {
        guard let args = args,
              let configData = args["config"] as? [String: Any] else {
            return result(FlutterError.noNecessaryData)
        }
        
        let contextKey = args["contextKey"] as? String
        
        noCodesSandwich?.setScreenPresentationConfig(configData, forContextKey: contextKey)
        result(nil)
    }
    
    @MainActor public func showScreen(_ args: [String: Any]?, _ result: @escaping FlutterResult) {
        guard let args = args,
              let contextKey = args["contextKey"] as? String else {
            return result(FlutterError.noNecessaryData)
        }
        
        noCodesSandwich?.showScreen(contextKey)
        result(nil)
    }
    
    @MainActor public func close(_ result: @escaping FlutterResult) {
        noCodesSandwich?.close()
        result(nil)
    }
}

extension NoCodesPlugin: NoCodesEventListener {
    public func noCodesDidTrigger(event: String, payload: [String: Any]?) {
        
        let eventData: [String: Any] = [
            "payload": payload ?? [:]
        ]
        
        // Convert to JSON string
        guard let jsonData = try? JSONSerialization.data(withJSONObject: eventData),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            print("NoCodesPlugin: Failed to serialize event data to JSON")
            return
        }
        
        DispatchQueue.main.async {
            switch event {
            case eventScreenShown:
                self.screenShownEventStreamHandler?.eventSink?(jsonString)
                
            case eventFinished:
                self.finishedEventStreamHandler?.eventSink?(jsonString)
                
            case eventActionStarted:
                self.actionStartedEventStreamHandler?.eventSink?(jsonString)
                
            case eventActionFailed:
                self.actionFailedEventStreamHandler?.eventSink?(jsonString)
                
            case eventActionFinished:
                self.actionFinishedEventStreamHandler?.eventSink?(jsonString)
                
            case eventScreenFailedToLoad:
                self.screenFailedToLoadEventStreamHandler?.eventSink?(jsonString)
                
            default:
                print("NoCodesPlugin: unknown event type: \(event)")
            }
        }
    }
} 
