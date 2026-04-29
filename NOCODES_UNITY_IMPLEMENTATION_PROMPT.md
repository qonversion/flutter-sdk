# Промпт для реализации NoCodes в Unity SDK

## Контекст
В существующем Unity SDK для Qonversion есть только основная функциональность Qonversion (инициализация, покупки, entitlements и т.д.), но отсутствует модуль NoCodes. Необходимо реализовать NoCodes функциональность, аналогичную той, что реализована во Flutter SDK.

## Архитектура и требования

### 1. Основной API класс `NoCodes`

Создать статический класс `NoCodes` с паттерном Singleton, аналогичный Flutter реализации:

**Основные методы:**
- `Initialize(NoCodesConfig config)` - инициализация NoCodes SDK с конфигурацией
- `InitializeWithProjectKey(string projectKey)` - упрощенная инициализация только с project key (для обратной совместимости)
- `GetSharedInstance()` - получение текущего инициализированного экземпляра (throws exception если не инициализирован)

**События (Events/Callbacks):**
Реализовать систему событий для 6 типов событий NoCodes:
- `ScreenShown` - событие когда NoCodes экран показан
- `Finished` - событие когда NoCodes flow завершен
- `ActionStarted` - событие когда действие начато
- `ActionFailed` - событие когда действие провалилось
- `ActionFinished` - событие когда действие завершено
- `ScreenFailedToLoad` - событие когда экран не смог загрузиться

**Методы управления экраном:**
- `SetScreenPresentationConfig(NoCodesPresentationConfig config, string contextKey = null)` - установка конфигурации презентации экрана
- `ShowScreen(string contextKey)` - показать NoCodes экран с указанным context key
- `Close()` - закрыть текущий NoCodes экран

### 2. Классы конфигурации

**NoCodesConfig:**
```csharp
public class NoCodesConfig
{
    public string ProjectKey { get; }
    public string ProxyUrl { get; }
    
    public NoCodesConfig(string projectKey, string proxyUrl = null)
    {
        ProjectKey = projectKey;
        ProxyUrl = proxyUrl;
    }
}
```

**NoCodesConfigBuilder:**
```csharp
public class NoCodesConfigBuilder
{
    private readonly string _projectKey;
    private string _proxyUrl;
    
    public NoCodesConfigBuilder(string projectKey)
    {
        _projectKey = projectKey;
    }
    
    public NoCodesConfigBuilder SetProxyUrl(string proxyUrl)
    {
        _proxyUrl = proxyUrl;
        return this;
    }
    
    public NoCodesConfig Build()
    {
        return new NoCodesConfig(_projectKey, _proxyUrl);
    }
}
```

**NoCodesPresentationConfig:**
```csharp
public enum NoCodesPresentationStyle
{
    Push,
    FullScreen,
    Popover
}

public class NoCodesPresentationConfig
{
    public bool Animated { get; }
    public NoCodesPresentationStyle PresentationStyle { get; }
    
    public NoCodesPresentationConfig(bool animated = true, 
                                   NoCodesPresentationStyle presentationStyle = NoCodesPresentationStyle.FullScreen)
    {
        Animated = animated;
        PresentationStyle = presentationStyle;
    }
    
    // Метод для конвертации в Dictionary для передачи в нативный код
    public Dictionary<string, object> ToDictionary()
    {
        string styleString = PresentationStyle switch
        {
            NoCodesPresentationStyle.Push => "Push",
            NoCodesPresentationStyle.FullScreen => "FullScreen",
            NoCodesPresentationStyle.Popover => "Popover",
            _ => "FullScreen"
        };
        
        return new Dictionary<string, object>
        {
            { "animated", Animated },
            { "presentationStyle", styleString }
        };
    }
}
```

### 3. Классы событий

**Базовый класс события:**
```csharp
public abstract class NoCodesEvent
{
    public Dictionary<string, object> Payload { get; }
    
    protected NoCodesEvent(Dictionary<string, object> payload = null)
    {
        Payload = payload ?? new Dictionary<string, object>();
    }
}
```

**Конкретные классы событий:**
```csharp
public class NoCodesScreenShownEvent : NoCodesEvent
{
    public NoCodesScreenShownEvent(Dictionary<string, object> payload = null) 
        : base(payload) { }
}

public class NoCodesFinishedEvent : NoCodesEvent
{
    public NoCodesFinishedEvent(Dictionary<string, object> payload = null) 
        : base(payload) { }
}

public class NoCodesActionStartedEvent : NoCodesEvent
{
    public NoCodesActionStartedEvent(Dictionary<string, object> payload = null) 
        : base(payload) { }
}

public class NoCodesActionFailedEvent : NoCodesEvent
{
    public NoCodesActionFailedEvent(Dictionary<string, object> payload = null) 
        : base(payload) { }
}

public class NoCodesActionFinishedEvent : NoCodesEvent
{
    public NoCodesActionFinishedEvent(Dictionary<string, object> payload = null) 
        : base(payload) { }
}

public class NoCodesScreenFailedToLoadEvent : NoCodesEvent
{
    public NoCodesScreenFailedToLoadEvent(Dictionary<string, object> payload = null) 
        : base(payload) { }
}
```

### 4. Нативная интеграция

**Android (Java/Kotlin):**
- Создать класс `NoCodesUnityPlugin` аналогичный `NoCodesPlugin` из Flutter SDK
- Использовать `NoCodesSandwich` из библиотеки `io.qonversion:sandwich`
- Реализовать `NoCodesEventListener` для обработки событий
- Методы для вызова из Unity:
  - `initializeNoCodes(String projectKey, String version, String source, String proxyUrl)`
  - `setScreenPresentationConfig(Map<String, Object> config, String contextKey)`
  - `showNoCodesScreen(String contextKey)`
  - `closeNoCodes()`
- Отправка событий в Unity через UnitySendMessage для каждого типа события

**iOS (Objective-C/Swift):**
- Создать класс `NoCodesUnityPlugin` аналогичный `NoCodesPlugin` из Flutter SDK
- Использовать `NoCodesSandwich` из QonversionSandwich framework
- Реализовать `NoCodesEventListener` протокол
- Методы для вызова из Unity:
  - `initializeNoCodes(projectKey:version:source:proxyUrl:)`
  - `setScreenPresentationConfig(_:forContextKey:)`
  - `showScreen(_:)`
  - `close()`
- Отправка событий в Unity через UnitySendMessage для каждого типа события

### 5. Константы и имена методов

**Методы для MethodChannel/Unity:**
- `initializeNoCodes` - инициализация
- `setScreenPresentationConfig` - установка конфигурации презентации
- `showNoCodesScreen` - показать экран
- `closeNoCodes` - закрыть экран

**Имена событий для передачи в Unity:**
- `nocodes_screen_shown`
- `nocodes_finished`
- `nocodes_action_started`
- `nocodes_action_failed`
- `nocodes_action_finished`
- `nocodes_screen_failed_to_load`

**Параметры:**
- `projectKey` - ключ проекта Qonversion
- `version` - версия SDK (например, "10.0.3")
- `source` - источник SDK (например, "unity")
- `proxyUrl` - опциональный URL прокси
- `config` - конфигурация презентации (Dictionary с `animated` и `presentationStyle`)
- `contextKey` - ключ контекста для показа экрана
- `payload` - данные события (Dictionary)

### 6. Особенности реализации

**Платформенная поддержка:**
- ✅ iOS: Полная поддержка
- ✅ Android: Полная поддержка
- ❌ Другие платформы: No-op методы (ничего не делают, не выбрасывают ошибки)

**Обработка ошибок:**
- Все методы должны быть безопасными и не выбрасывать исключения в Unity
- При ошибках инициализации логировать ошибку, но не крашить приложение
- События должны обрабатываться асинхронно

**Потокобезопасность:**
- Singleton должен быть потокобезопасным
- События должны обрабатываться на главном потоке Unity

### 7. Пример использования

```csharp
using Qonversion.Unity;

public class NoCodesExample : MonoBehaviour
{
    void Start()
    {
        // Инициализация через builder
        var config = new NoCodesConfigBuilder("your_project_key")
            .SetProxyUrl("https://proxy.example.com")
            .Build();
        
        NoCodes.Initialize(config);
        
        // Подписка на события
        NoCodes.ScreenShown += OnScreenShown;
        NoCodes.Finished += OnFinished;
        NoCodes.ActionStarted += OnActionStarted;
        NoCodes.ActionFailed += OnActionFailed;
        NoCodes.ActionFinished += OnActionFinished;
        NoCodes.ScreenFailedToLoad += OnScreenFailedToLoad;
    }
    
    void OnScreenShown(NoCodesScreenShownEvent evt)
    {
        Debug.Log($"Screen shown with payload: {JsonUtility.ToJson(evt.Payload)}");
    }
    
    void OnFinished(NoCodesFinishedEvent evt)
    {
        Debug.Log($"Finished with payload: {JsonUtility.ToJson(evt.Payload)}");
    }
    
    // ... другие обработчики событий
    
    public async void ShowNoCodesScreen()
    {
        // Установка конфигурации презентации
        var presentationConfig = new NoCodesPresentationConfig(
            animated: true,
            presentationStyle: NoCodesPresentationStyle.FullScreen
        );
        
        await NoCodes.GetSharedInstance().SetScreenPresentationConfig(
            presentationConfig, 
            contextKey: "my_context_key"
        );
        
        // Показ экрана
        await NoCodes.GetSharedInstance().ShowScreen("my_context_key");
    }
    
    public async void CloseNoCodesScreen()
    {
        await NoCodes.GetSharedInstance().Close();
    }
    
    void OnDestroy()
    {
        // Отписка от событий
        NoCodes.ScreenShown -= OnScreenShown;
        NoCodes.Finished -= OnFinished;
        // ... остальные отписки
    }
}
```

### 8. Структура файлов

```
QonversionUnity/
├── Runtime/
│   ├── NoCodes/
│   │   ├── NoCodes.cs (основной API класс)
│   │   ├── NoCodesConfig.cs
│   │   ├── NoCodesConfigBuilder.cs
│   │   ├── NoCodesPresentationConfig.cs
│   │   ├── Events/
│   │   │   ├── NoCodesEvent.cs (базовый класс)
│   │   │   ├── NoCodesScreenShownEvent.cs
│   │   │   ├── NoCodesFinishedEvent.cs
│   │   │   ├── NoCodesActionStartedEvent.cs
│   │   │   ├── NoCodesActionFailedEvent.cs
│   │   │   ├── NoCodesActionFinishedEvent.cs
│   │   │   └── NoCodesScreenFailedToLoadEvent.cs
│   │   └── Internal/
│   │       └── NoCodesInternal.cs (внутренняя реализация)
├── Plugins/
│   ├── Android/
│   │   └── NoCodesUnityPlugin.java (или .kt)
│   └── iOS/
│       └── NoCodesUnityPlugin.m (или .swift)
```

### 9. Зависимости

**Android:**
- Использовать существующую зависимость `io.qonversion:sandwich` (уже должна быть в проекте для основного Qonversion SDK)
- `NoCodesSandwich` класс из этой библиотеки

**iOS:**
- Использовать существующий QonversionSandwich framework (уже должен быть в проекте)
- `NoCodesSandwich` класс из этого framework

### 10. Тестирование

Реализовать:
- Unit тесты для C# классов
- Интеграционные тесты для нативной интеграции
- Пример сцены в Unity с UI для демонстрации функциональности

### 11. Документация

Добавить:
- XML комментарии для всех публичных методов и классов
- README с примерами использования
- Миграционный гайд для пользователей, переходящих с других SDK

## Важные замечания

1. **Совместимость**: Реализация должна быть совместима с существующим Qonversion SDK в Unity и не ломать существующую функциональность

2. **Асинхронность**: Все методы, которые вызывают нативный код, должны быть асинхронными (async/await)

3. **События**: Использовать C# события (events) для подписки на события NoCodes, аналогично тому как это сделано в основном Qonversion SDK

4. **JSON сериализация**: Использовать Unity JsonUtility или Newtonsoft.Json для сериализации/десериализации payload событий

5. **Версионирование**: Версия SDK должна передаваться в нативный код при инициализации (например, "10.0.3")

6. **Source идентификация**: При инициализации передавать `source: "unity"` для идентификации SDK в аналитике Qonversion

## Референсная реализация

Для понимания деталей реализации можно использовать:
- Flutter SDK: `/lib/src/nocodes.dart` и связанные файлы
- Android нативная часть: `/android/src/main/kotlin/.../NoCodesPlugin.kt`
- iOS нативная часть: `/ios/Classes/NoCodesPlugin.swift`

Все эти файлы содержат полную реализацию, которую можно адаптировать для Unity.

