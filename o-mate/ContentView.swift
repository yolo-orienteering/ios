//
//  ContentView.swift
//  o-mate
//
//  Created by m1 on 06/04/2025.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var appState: AppState

    @Environment(\.colorScheme) var colorScheme
    
    @StateObject var browser = BrowserModel(request: URLRequest(url: URL(string: Config.startURL)!))

    var body: some View {
        ZStack {
            BrowserView(model: browser)

            if browser.loading {
                SplashView(progress: browser.loadingProgress)
            }
        }.onChange(of: appState.currentURL) { newValue in
            if let url = URL(string: newValue) {
                browser.open(url: url.absoluteString)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(appState: AppState.shared)
    }
}
