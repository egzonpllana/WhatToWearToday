//
//  APIConfiguration.swift
//  WhatToWearToday
//
//  Created by Egzon Pllana on 3/21/20.
//  Copyright © 2020 Native Coders. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - Platform URL
/* construct the base url with the api */

public struct PlatformURL {
    private init() {}

    private static let baseURL = "https://api.openweathermap.org/data/"
    static let api: String = baseURL + "2.5/"
}

// MARK: - Header Keys

struct HTTPHeaderField {
    static let authentication = "Authorization"
    static let contentType = "Content-Type"
    static let acceptType = "Accept"
    static let acceptEncoding = "Accept-Encoding"
}

// MARK: - Content type

struct ContentType {
    static let json = "application/json"
    static let multipartFormData = "multipart/form-data"
}

// MARK: - API configuration Protocol

protocol APIConfiguration: URLRequestConvertible {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var requiresAuth: Bool { get }
    var multipartFormData: ((MultipartFormData) -> Void)? { get }
}

extension APIConfiguration {
    var method: HTTPMethod { return .get }
    var parameters: Parameters? { return nil }
    var requiresAuth: Bool { return false }
    var multipartFormData: ((MultipartFormData) -> Void)? { return nil }
}

extension APIConfiguration {
    func asURLRequest() throws -> URLRequest {
        // construct URL

        // if api does NOT use question mark, for ex. "/?"
        //let url = try PlatformURL.api.asURL().appendingPathComponent(path)

        // if api USE question mark, for ex. "/?"
        let url = try (PlatformURL.api + path).asURL()

        // construct URLRequest
        var urlRequest = URLRequest(url: url)

        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        //nultipart form data
        if multipartFormData != nil {
            urlRequest.setValue(ContentType.multipartFormData, forHTTPHeaderField: HTTPHeaderField.contentType)
        } else {
            urlRequest.setValue(ContentType.json, forHTTPHeaderField: HTTPHeaderField.contentType)
        }

        /*
         if requiresAuth, let sessionToken = "generatedToken" {
         urlRequest.addValue(sessionToken, forHTTPHeaderField: HTTPHeaderField.authentication)
         }
         */

        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }

        print("URL REQ: \n\n", urlRequest)
        return urlRequest
    }

}
