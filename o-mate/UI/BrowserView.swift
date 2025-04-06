//
//  BrowserView.swift
//  o-mate
//
//  Created by m1 on 06/04/2025.
//

import SwiftUI

class WebViewState: ObservableObject {
    @Published var showNavigation: Bool = false
}

struct BrowserView: View {
    @ObservedObject var model: BrowserModel
    @StateObject var webViewState = WebViewState()

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(spacing: 0) {
            ProgressView(progress: model.loadingProgress)
            WebView(webView: self.model.webView!, request: self.model.request!, webViewState: webViewState)
            if webViewState.showNavigation {
                HStack {
                    Spacer().frame(width: 30)
                    Button(action: {
                        model.goBack()
                    }) {
                        Image(systemName: "chevron.left").resizable().scaledToFit().frame(width: 20.0, height: 20.0).foregroundColor(model.canGoBack ? (colorScheme == .dark ? .white : .black) : Color.secondary)
                    }.font(.title).disabled(!model.canGoBack).padding([.leading, .trailing, .bottom], 18).padding([.top], 15)
                    Spacer()
                    Button(action: {
                        model.goForward()
                    }) {
                        Image(systemName: "chevron.right").resizable().scaledToFit().frame(width: 20.0, height: 20.0).foregroundColor(model.canGoForward ? (colorScheme == .dark ? .white : .black) : Color.secondary)
                    }.font(.title).disabled(!model.canGoForward).padding([.leading, .trailing, .bottom], 18).padding([.top], 15)
                    Spacer().frame(width: 30)
                }.transition(.move(edge: .bottom))
                    .background(Rectangle()
                        .fill(colorScheme == .dark ? Color.black : Color.white)
                        .shadow(color: Color.black.opacity(0.5), radius: 3, x: 0, y: 0)
                    )
            }
        }.edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    BrowserView(model: BrowserModel(request: URLRequest(url: URL(string: Config.startURL)!)))
}

