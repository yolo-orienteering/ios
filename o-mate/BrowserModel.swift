//
//  BrowserModel.swift
//  o-mate
//
//  Created by m1 on 06/04/2025.
//

import Foundation
import WebKit

class BrowserModel: NSObject, ObservableObject {
    @Published var canGoBack: Bool = false
    @Published var canGoForward: Bool = false
    @Published var loading: Bool = true
    @Published var loadingProgress: Double = 0.0
    @Published var showPaymentOverlay: Bool = false

    @Published public var webView: WKWebView?
    @Published public var request: URLRequest?

    var backObserver: NSKeyValueObservation?
    var forwardObserver: NSKeyValueObservation?
    var loadingObserver: NSKeyValueObservation?
    var urlObserver: NSKeyValueObservation?

    init(request: URLRequest) {
        super.init()

        let configuration = WKWebViewConfiguration()
        self.webView = WKWebView(frame: CGRectZero, configuration: configuration)
        self.request = request

        /// Detect ability to go back for navigation buttons
        self.backObserver = self.webView!.observe(\.canGoBack, options: [.old, .new]) { _, change in
            self.canGoBack = change.newValue!
        }
        
        /// Detect ability to go forward for navigation buttons
        self.forwardObserver = self.webView!.observe(\.canGoForward, options: [.old, .new]) { _, change in
            self.canGoForward = change.newValue!
            // && self.webView!.backForwardList.forwardItem?.url.absoluteString != Config.paymentURL
        }

        /// Detect browser load for splash screen
        self.loadingObserver = self.webView!.observe(\.isLoading, options: [.old, .new]) { _, change in
            if change.oldValue == true && change.newValue == false {
                self.loading = false
            }
        }

        /// Detect loading progress to display a progress bar
        self.webView?.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    deinit {
        self.webView?.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            DispatchQueue.main.async {
                self.loadingProgress = self.webView?.estimatedProgress ?? 0.0
            }
        }
    }

    func goBack() {
        self.webView!.goBack()
    }

    func goForward() {
        self.webView!.goForward()
    }

    func open(url: String) {
        self.webView!.load(URLRequest(url: URL(string: url)!))
    }
}
