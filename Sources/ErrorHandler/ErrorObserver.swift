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

actor ErrorObserver: ObservableObject {
    
    static var shared = ErrorObserver()
    
    @Published var error: Error?
    
    @Published var showingError = false
    @Published var message: String?
    
    private func set<E: Error>(_ error: E, _ message: String?) {
        withAnimation {
            self.error = error
            self.showingError = true
            self.message = message
        }
    }
    
    @MainActor private func show<E: Error>(_ error: E, _ message: String?) {
        Task {
            await set(error, message)
        }
    }
    
    func handleError<E: Error>(_ error: E, message: String? = nil) {
        Task {
            await show(error, message)
        }
        #if canImport(FirebaseCrashlytics)
        record(error)
        #endif
    }
    
    #if canImport(FirebaseCrashlytics)
    func record<E: Error>(_ error: E) {
        Crashlytics.crashlytics().record(error: error)
    }
    #endif
}
