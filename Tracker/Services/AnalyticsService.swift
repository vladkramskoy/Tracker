//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Vladislav Kramskoy on 14.08.2024.
//

import Foundation
import YandexMobileMetrica

protocol AnalyticsServiceProtocol {
    func reportEventOpenViewController(eventName: String, event: String, screen: String, item: String?)
}

final class AnalyticsService: AnalyticsServiceProtocol {
    static let shared: AnalyticsServiceProtocol = AnalyticsService()
    
    func reportEventOpenViewController(eventName: String, event: String, screen: String, item: String?) {
        var params : [AnyHashable : Any] = ["event": event, "screen": screen]
        
        if let item = item {
            params["item"] = item
        }
        
        YMMYandexMetrica.reportEvent(eventName, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
        print("Report event: \(eventName), parameters: \(params)")
    }
    
    private init() {}
}
