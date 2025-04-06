//
//  WebView.swift
//  o-mate
//
//  Created by m1 on 06/04/2025.
//

import SwiftUI
import WebKit
import UIKit

struct WebView: UIViewRepresentable {
    let request: URLRequest
    public let webView: WKWebView
    var webViewState: WebViewState

    init(webView: WKWebView, request: URLRequest, webViewState: WebViewState) {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        self.webView = webView
        self.webView.allowsBackForwardNavigationGestures = true
        self.webView.allowsLinkPreview = true
        self.webView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 17_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Safari/604.1 WePublish/\(appVersion!)"
        self.request = request
        self.webViewState = webViewState
    }

    func makeCoordinator() -> WebView.Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView {
        return self.webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        webView.navigationDelegate = context.coordinator
        webView.scrollView.delegate = context.coordinator
        webView.load(self.request)
    }

    class Coordinator: NSObject, WKNavigationDelegate, UIScrollViewDelegate {
        var parent: WebView
        var lastPos = 0.0
        var lastNavStatus = true

        init(_ parent: WebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping @MainActor (WKNavigationActionPolicy) -> Void) {
            if navigationAction.navigationType == .other {
                let url = navigationAction.request.url
            }
            if navigationAction.navigationType == .linkActivated {
                let host = navigationAction.request.url?.host
                if (host != nil) && !Config.internalDomains.contains(host!) {
                    UIApplication.shared.open(navigationAction.request.url!)
                    decisionHandler(.cancel)
                    return
                } else {
                    parent.webView.load(URLRequest(url: URL(string: navigationAction.request.url!.absoluteString)!))
                }
            }
            decisionHandler(.allow)
        }
    }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        BrowserView(model: BrowserModel(request: URLRequest(url: URL(string: Config.startURL)!)))
    }
}
