//
//  Environment.swift
//  arukita
//

import Foundation

public struct Environment {
    public let cache: AppCache
    public let userDefaults: KeyValueStoreType
    
    public init(cache: AppCache = AppCache(),
                userDefaults: KeyValueStoreType = UserDefaults.standard) {
        self.cache = cache
        self.userDefaults = userDefaults
    }
}
