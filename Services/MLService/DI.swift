//
//  DI.swift
//  MLKitDemoProject
//
//  Created by Иван Юшков on 17.12.2020.
//

import DITranquillity

class DI {
    
    private static let shared = DI()
    fileprivate(set) static var container = DIContainer()
    fileprivate(set) static var backgroundContainer = DIContainer()
    
    private init() {
        // No Constructor
    }
    
    /// Загрузка параметров при запуске
    static func initOnlyConfigurationFetcher() {
        
        // MARK: - UseCases
        
        #if DEBUG
        if !self.container.validate() {
            fatalError("DI not configured successful.")
        }
        #endif
    }
    
    /// Фоновые процессы
    static func initBackgroundDependencies() {
        
        #if DEBUG
        if !self.backgroundContainer.validate() {
            fatalError("DI not configured successful.")
        }
        #endif
    }
    
    /// Проверка версии приложения при старте
    static func initNetworkDependencies(_ appDelegate: AppDelegate) {
        
        //   DI.container = DIContainer(parent: backgroundContainer)
        
    }
    
    /// Основные зависимости
    // swiftlint:disable:next function_body_length
    static func initDependencies(_ appDelegate: AppDelegate) {
        
        DI.container = DIContainer(parent: backgroundContainer)
        
//        self.container.register(DefaultsService.init)
//            .as(DefaultsService.self)
//            .lifetime(.single)
        
        self.container.register(MLService.init)
            .as(MLServiceProtocol.self)
            .lifetime(.single)
//        self.container.register(LocationService.init)
//            .as(LocationServiceProtocol.self)
//            .lifetime(.single)
        
//        self.container.register(UserService.init)
//            .as(UserService.self)
//            .lifetime(.single)
    }
    
    static func resolve<T>() -> T {
        return self.container.resolve()
    }
    
    static func resolveBackground<T>() -> T {
        return self.backgroundContainer.resolve()
    }
    
    static public func getApplication() -> UIApplication {
        return UIApplication.shared
    }
    
    static public func getAppDelegate() -> UIApplicationDelegate? {
        return getApplication().delegate as? AppDelegate
    }
    
    static public func getRootNavigationController() -> UINavigationController? {
        return getAppDelegate()?.window??.rootViewController as? UINavigationController
    }
}

