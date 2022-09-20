//
//  AppEnvironment.swift
//  arukita
//

import Foundation

public struct AppEnvironment {
    private static let environmentStorageKey = "com.restir.AppEnvironment.current"
    private static let oauthTokenStorageKey = "com.restir.AppEnvironment.oauthToken"

    private static var stack = [Environment()]
    
//    static func login(_ token: String, user: User) {
//        replaceCurrentEnvironment(
//            apiService: current.apiService.login(token),
//            currentUser: user
//        )
//    }
//
//    // Invoke when you want to end the user's session.
//    static func logout() {
////        let storage = AppEnvironment.current.cookieStorage
////        storage.cookies?.forEach(storage.deleteCookie)
//
//        replaceCurrentEnvironment(
//            apiService: AppEnvironment.current.apiService.logout(),
//            cache: AppCache(),
//            currentUser: nil
//        )
//    }
    
    /**
     Invoke when we have acquired a fresh current user and you want to replace the current environment's
     current user with the fresh one.
     
     - parameter user: A user model.
     */
//    public static func updateCurrentUser(_ user: UserInfo) {
//        replaceCurrentEnvironment(
//            currentUser: user
//        )
//    }
    
    // The most recent environment on the stack.
    public static var current: Environment! {
        return stack.last
    }
    
    // Replace the current environment with a new environment.
    public static func replaceCurrentEnvironment(_ env: Environment) {
        pushEnvironment(env)
        stack.remove(at: stack.count - 2)
    }
    
    // Push a new environment onto the stack.
    public static func pushEnvironment(_ env: Environment) {
        saveEnvironment(environment: env, userDefaults: env.userDefaults)
        stack.append(env)
    }
    
    // Pushes a new environment onto the stack that changes only a subset of the current global dependencies.
    public static func pushEnvironment(
        cache: AppCache = AppEnvironment.current.cache,
        userDefaults: KeyValueStoreType = AppEnvironment.current.userDefaults) {
        pushEnvironment(
            Environment(
                cache: cache,
                userDefaults: userDefaults
            )
        )
    }
    
    // Replaces the current environment onto the stack with an environment that changes only a subset
    // of current global dependencies.
    public static func replaceCurrentEnvironment(
        cache: AppCache = AppEnvironment.current.cache,
        userDefaults: KeyValueStoreType = AppEnvironment.current.userDefaults) {
        replaceCurrentEnvironment(
            Environment(
                cache: cache,
                userDefaults: userDefaults
            )
        )
    }
    
    // Returns the last saved environment from user defaults.
    public static func fromStorage(userDefaults: KeyValueStoreType) -> Environment {
        let data = userDefaults.dictionary(forKey: environmentStorageKey) ?? [:]
        
        return Environment()
    }
    
    // Saves some key data for the current environment
    private static func saveEnvironment(environment env: Environment = AppEnvironment.current, userDefaults: KeyValueStoreType) {
        
        var data: [String: Any] = [:]
        
//        data["apiService.oauthToken.token"] = env.apiService.oauthToken?.token
//        data["apiService.serverConfig.apiBaseUrl"] = env.apiService.serverConfig.apiBaseUrl.absoluteString
//        // swiftlint:disable line_length
//        data["apiService.serverConfig.apiClientAuth.clientId"] = env.apiService.serverConfig.apiClientAuth.clientId
//        data["apiService.serverConfig.basicHTTPAuth.username"] = env.apiService.serverConfig.basicHTTPAuth?.username
//        data["apiService.serverConfig.basicHTTPAuth.password"] = env.apiService.serverConfig.basicHTTPAuth?.password
//        // swiftlint:enable line_length
//        data["apiService.serverConfig.webBaseUrl"] = env.apiService.serverConfig.webBaseUrl.absoluteString
//        data["apiService.serverConfig.environment"] = env.apiService.serverConfig.environment.rawValue
//        data["apiService.language"] = env.apiService.language
//        data["apiService.currency"] = env.apiService.currency
//        data["config"] = env.config?.encode()
//        data["currentUser"] = env.currentUser?.encode()
        
        userDefaults.set(data, forKey: environmentStorageKey)
    }
    
    // Pop an environment off the stack.
    @discardableResult
    public static func popEnvironment() -> Environment? {
        let last = stack.popLast()
        let next = current ?? Environment()
        saveEnvironment(environment: next,
                        userDefaults: next.userDefaults)
        return last
    }
}
