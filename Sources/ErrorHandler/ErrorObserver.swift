//
//  ErrorObserver.swift
//  Curiqi
//
//  Created by Bri on 12/17/21.
//

import SwiftUI

#if canImport(FirebaseCrashlytics)
import FirebaseCrashlytics
#endif

public actor ErrorObserver: ObservableObject {
    
    public static var shared = ErrorObserver()
    
    @Published var error: Error?
    
    @Published var showingError = false
    @Published var message: String?
    
    fileprivate func set<E: Error>(_ error: E, _ message: String?) {
        withAnimation {
            self.error = error
            self.showingError = true
            self.message = message
        }
    }
    
    @MainActor fileprivate func show<E: Error>(_ error: E, _ message: String?) {
        Task {
            await set(error, message)
        }
    }
    
    public func handleError<E: Error>(_ error: E, message: String? = nil) {
        Task {
            await show(error, message)
        }
        #if canImport(FirebaseCrashlytics)
        record(error)
        #endif
    }
    
    #if canImport(FirebaseCrashlytics)
    fileprivate func record<E: Error>(_ error: E) {
        Crashlytics.crashlytics().record(error: error)
    }
    #endif
}
