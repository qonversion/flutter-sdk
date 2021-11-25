//
//  AutomationsPlugin.swift
//  qonversion_flutter
//
//  Created by Maria on 18.11.2021.
//

import Qonversion

public class AutomationsPlugin: NSObject {
  private let eventChannelShownScreens = "shown_screens"
  private let eventChannelStartedActions = "started_actions"
  private let eventChannelFailedActions = "failed_actions"
  private let eventChannelFinishedActions = "finished_actions"
  private let eventChannelFinishedAutomations = "finished_automations"
  
  private var shownScreensStreamHandler: BaseEventStreamHandler?
  private var startedActionsStreamHandler: BaseEventStreamHandler?
  private var failedActionsStreamHandler: BaseEventStreamHandler?
  private var finishedActionsStreamHandler: BaseEventStreamHandler?
  private var finishedAutomationsStreamHandler: BaseEventStreamHandler?
  
  public func register(_ registrar: FlutterPluginRegistrar) {
    let shownScreensListener = FlutterListenerWrapper<BaseEventStreamHandler>(registrar, postfix: eventChannelShownScreens)
    shownScreensListener.register() { self.shownScreensStreamHandler = $0 }
    
    let startedActionsListener = FlutterListenerWrapper<BaseEventStreamHandler>(registrar, postfix: eventChannelStartedActions)
    startedActionsListener.register() { self.startedActionsStreamHandler = $0 }
    
    let failedActionsListener = FlutterListenerWrapper<BaseEventStreamHandler>(registrar, postfix: eventChannelFailedActions)
    failedActionsListener.register() { self.failedActionsStreamHandler = $0 }
    
    let finishedActionsListener = FlutterListenerWrapper<BaseEventStreamHandler>(registrar, postfix: eventChannelFinishedActions)
    finishedActionsListener.register() { self.finishedActionsStreamHandler = $0 }
    
    let finishedAutomationsListener = FlutterListenerWrapper<BaseEventStreamHandler>(registrar, postfix: eventChannelFinishedAutomations)
    finishedAutomationsListener.register() { self.finishedAutomationsStreamHandler = $0 }
    
    Qonversion.Automations.setDelegate(self)
  }
}

extension AutomationsPlugin: Qonversion.AutomationsDelegate {
  public func automationsDidShowScreen(_ screenID: String) {
    shownScreensStreamHandler?.eventSink?(screenID)
  }
  
  public func automationsDidStartExecuting(actionResult: Qonversion.ActionResult) {
    let payload = actionResult.toMap().toJson()
    startedActionsStreamHandler?.eventSink?(payload)
  }
  
  public func automationsDidFailExecuting(actionResult: Qonversion.ActionResult) {
    let payload = actionResult.toMap().toJson()
    failedActionsStreamHandler?.eventSink?(payload)
  }
  
  public func automationsDidFinishExecuting(actionResult: Qonversion.ActionResult) {
    let payload = actionResult.toMap().toJson()
    finishedActionsStreamHandler?.eventSink?(payload)
  }
  
  public func automationsFinished() {
    finishedAutomationsStreamHandler?.eventSink?(nil)
  }
}
