//
//  BrowserView.swift
//  o-mate
//
//  Created by m1 on 06/04/2025.
//

import SwiftUI

class WebViewState: ObservableObject {}

struct BrowserView: View {
    @ObservedObject var model: BrowserModel
    @StateObject var webViewState = WebViewState()

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(spacing: 0) {
            ProgressView(progress: model.loadingProgress)
            WebView(webView: self.model.webView!, request: self.model.request!, webViewState: webViewState)
        }
    }
}

#Preview {
    BrowserView(model: BrowserModel(request: URLRequest(url: URL(string: Config.startURL)!)))
}

