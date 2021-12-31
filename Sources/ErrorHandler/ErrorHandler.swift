//
//  ErrorHandler.swift
//  ErrorHandler
//
//  Created by Bri on 12/20/21.
//

@_exported import SwiftUI
import AlertToast

public struct ErrorHandler<Content: View>: View {
    
    @StateObject fileprivate var errorObserver = ErrorObserver.shared
    
    @ViewBuilder fileprivate var content: () -> Content
    
    public init(content: @escaping () -> Content) {
        self.content = content
    }
    
    public var body: some View {
        content()
            .toast(
                isPresenting: $errorObserver.showingError,
                duration: 3,
                tapToDismiss: true
            ) {
                AlertToast(
                    displayMode: .banner(.pop),
                    type: .error(.white),
                    title: errorObserver.message,
                    subTitle: errorObserver.error?.localizedDescription ?? "Unknown Error",
                    style: .style(
                        backgroundColor: .red,
                        titleColor: .white,
                        subTitleColor: .white
                    )
                )
            }
    }
}

struct ErrorHandler_Previews: PreviewProvider {
    enum PreviewError: Error {
        case preview
        var localizedDescription: String {
             return "Preview Error"
        }
    }
    static var previews: some View {
        NavigationView {
            ErrorHandler {
                List {
                    Button {
                        Task {
                            await ErrorObserver.shared.handleError(PreviewError.preview, message: "This is a preview, all is well.")
                        }
                    } label: {
                        Text("Show Error")
                            .foregroundColor(.accentColor)
                    }
                }
            }
            .navigationTitle("Error Test")
        }
    }
}
