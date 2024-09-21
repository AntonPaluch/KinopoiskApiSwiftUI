//
//  WebView.swift
//  KinopoiskApiSwiftUI
//
//  Created by Павлов Дмитрий on 21.09.2024.
//

import Foundation

import SwiftUI
import WebKit

struct TrailerWebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.configuration.mediaTypesRequiringUserActionForPlayback = .all
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
