//
//  FclashProxyProvider.swift
//  Runner
//
//  Created by kingtous on 2023/4/30.
//

import Foundation
import NetworkExtension
import Flutter


class FclashProxyProvider: NSObject {
    var proxySettings: NEProxySettings = NEProxySettings()
    
    func setHttpProxy(port: Int) {
        proxySettings.httpServer = NEProxyServer(address: "127.0.0.1", port: port)
        proxySettings.httpsServer = NEProxyServer(address: "127.0.0.1", port: port)
    }
    
    func startProxy() {
        NEAppProxyProviderManager.shared().protocolConfiguration = proxySettings
    }
    
    func stopProxy() {
        NEAppProxyProviderManager.shared().protocolConfiguration = nil
    }
}
