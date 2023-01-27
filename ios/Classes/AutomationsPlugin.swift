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
  
  private var automationSandwich = AutomationsSandwich()
  
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
  }
  
  public func subscribe() {
    automationSandwich.subscribe(self)
  }
  
  public func setNotificationsToken(_ token: String?, _ result: @escaping FlutterResult) {
    guard let token = token else {
      result(FlutterError.noNecessaryData)
      return
    }
    
    automationSandwich.setNotificationToken(token)
    result(nil)
  }
  
  public func handleNotification(_ args: [AnyHashable: Any], _ result: @escaping FlutterResult) {
    guard let notificationData = args["notificationData"] as? [AnyHashable: Any] else {
      return result(FlutterError.noNecessaryData)
    }
    
    let isPushHandled: Bool = automationSandwich.handleNotification(notificationData)
    result(isPushHandled)
  }
  
  public func getNotificationCustomPayload(_ args: [AnyHashable: Any], _ result: @escaping FlutterResult) {
    guard let notificationData = args["notificationData"] as? [AnyHashable: Any] else {
      return result(FlutterError.noNecessaryData)
    }

    let customPayload: [AnyHashable: Any]? = automationSandwich.getNotificationCustomPayload(notificationData)
    result(customPayload?.toJson())
  }

  public func showScreen(_ screenId: String?, _ result: @escaping FlutterResult) {
    guard let screenId = screenId else {
      result(FlutterError.noNecessaryData)
      return
    }

    automationSandwich.showScreen(screenId) { data, error in
      if let error = error {
        return result(FlutterError.sandwichError(error))
      }
      
      result(data)
    }
  }

  public func setScreenPresentationConfig(_ configData: [String: Any]?, _ screenId: String?,  _ result: @escaping FlutterResult) {
    guard let configData = configData else {
      result(FlutterError.noNecessaryData)
      return
    }

    automationSandwich.setScreenPresentationConfig(configData, forScreenId:screenId)
    result(nil)
  }
}

extension AutomationsPlugin: AutomationsEventListener {
  
  public func automationDidTrigger(event: String, payload: [String: Any]?) {
    guard let resultEvent = AutomationsEvent(rawValue: event) else { return }
    
    let handler: BaseEventStreamHandler?
    switch (resultEvent) {
    case .screenShown:
      handler = shownScreensStreamHandler
    case .actionStarted:
      handler = startedActionsStreamHandler
    case .actionFailed:
      handler = failedActionsStreamHandler
    case .actionFinished:
      handler = finishedActionsStreamHandler
    case .automationsFinished:
      handler = finishedAutomationsStreamHandler
    }
    
    handler?.eventSink?(payload?.toJson())
  }
}
