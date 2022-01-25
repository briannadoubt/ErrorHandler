//
//  ErrorObserver.swift
//  ErrorHandler
//
//  Created by Bri on 12/17/21.
//

import SwiftUI

#if canImport(FirebaseCrashlytics)
import FirebaseCrashlytics
#endif

public actor ErrorObserver: ObservableObject {
    
    public static var shared = ErrorObserver()
    
    @Published public nonisolated var error: Error?
    @Published public nonisolated var showingError = false
    @Published public nonisolated var message: String?
    
    @MainActor fileprivate func show<E: Error>(_ error: E, _ message: String?) async {
        withAnimation {
            self.error = error
            self.showingError = true
            self.message = message
        }
    }
    
    @MainActor public func handleError<E: Error>(_ error: E, message: String? = nil, showAlert: Bool = true) async {
        print(message ?? "Unknown error")
        print(error)
        if showAlert {
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
