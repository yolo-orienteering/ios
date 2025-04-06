//
//  BrowserModel.swift
//  o-mate
//
//  Created by m1 on 06/04/2025.
//

import Foundation
import WebKit

class BrowserModel: NSObject, ObservableObject {
    @Published var loading: Bool = true
    @Published var loadingProgress: Double = 0.0
    @Published var showPaymentOverlay: Bool = false

    @Published public var webView: WKWebView?
    @Published public var request: URLRequest?

    var loadingObserver: NSKeyValueObservation?
    var urlObserver: NSKeyValueObservation?

    init(request: URLRequest) {
        super.init()

        let configuration = WKWebViewConfiguration()
        self.webView = WKWebView(frame: CGRectZero, configuration: configuration)
        self.request = request

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

    func open(url: String) {
        self.webView!.load(URLRequest(url: URL(string: url)!))
    }
}
