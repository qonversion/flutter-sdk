//
//  AutomationsPlugin.swift
//  qonversion_flutter
//
//  Created by Maria on 18.11.2021.
//

import QonversionSandwich

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
  
  private lazy var automationSandwich: AutomationsSandwich = AutomationsSandwich()

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
    
    automationSandwich.subscribe(self)
  }
}

extension AutomationsPlugin: AutomationsEventListener {
  
  public func automationDidTrigger(event: String, payload: [String: Any]?) {
    let handler: BaseEventStreamHandler?
    switch (event) {
   
    case AutomationsEvent.screenShown.rawValue:
      handler = self.shownScreensStreamHandler
      
    case AutomationsEvent.actionStarted.rawValue:
      handler = startedActionsStreamHandler
    
    case AutomationsEvent.actionFailed.rawValue:
      handler = failedActionsStreamHandler
    
    case AutomationsEvent.actionFinished.rawValue:
      handler = finishedActionsStreamHandler
    
    case AutomationsEvent.automationsFinished.rawValue:
      handler = finishedAutomationsStreamHandler

    default:
      handler = nil
    }
    
    handler?.eventSink?(payload?.toJson())
  }
}
