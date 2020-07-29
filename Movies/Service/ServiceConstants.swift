//
//  ServiceConstants.swift
//  Eventos
//
//  Created by Douglas Hennrich on 22/07/20.
//  Copyright © 2020 Douglas Hennrich. All rights reserved.
//

import Foundation

struct ServiceConstants {
    
    private enum KeysJson: String {
        case config = "Config"
        case baseURL = "BaseURL"
        case apiKey = "APIKey"
    }
    
    // The API's base URL
    static var baseUrl: String {
        guard
            let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
            let dicInfo = NSDictionary(contentsOfFile: path),
            let config = dicInfo[KeysJson.config.rawValue] as? [String: Any],
            let urlBase = config[KeysJson.baseURL.rawValue] as? String
            else { return "" }
        
        return urlBase
    }
    
    static var apiKey: String {
        guard
            let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
            let dicInfo = NSDictionary(contentsOfFile: path),
            let config = dicInfo[KeysJson.config.rawValue] as? [String: Any],
            let apiKey = config[KeysJson.apiKey.rawValue] as? String
            else { return "" }
        
        return apiKey
    }
    
    // The header fields
    enum HttpHeaderField: String {
        case authentication = "Authorization"
        case contentType = "Content-Type"
        case acceptType = "Accept"
        case acceptEncoding = "Accept-Encoding"
    }
    
    // The content type (JSON)
    enum ContentType: String {
        case json = "application/json"
        case formUrlEncode = "application/x-www-form-urlencoded"
    }
    
    // URLEncodingParams
    enum URLEncodingParams: String {
        case apiKey = "api-key"
        
        var value: String {
            switch self {
            case .apiKey:
                return ServiceConstants.apiKey
            }
        }
    }
}
