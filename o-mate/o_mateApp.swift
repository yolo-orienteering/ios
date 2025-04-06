//
//  o_mateApp.swift
//  o-mate
//
//  Created by m1 on 06/04/2025.
//

import SwiftUI

@main
struct o_mateApp: App {
    @StateObject private var appState = AppState.shared

    var body: some Scene {
        WindowGroup {
            ContentView(appState: appState)
                .onOpenURL(perform: { url in
                    appState.currentURL = url.absoluteString
                })
        }
    }
}

class AppState: ObservableObject {
    @Published var currentURL: String = Config.startURL
    
    static let shared = AppState()
    
    private init() {}
}
