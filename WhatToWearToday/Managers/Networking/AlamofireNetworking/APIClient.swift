//
//  APIClient.swift
//  WhatToWearToday
//
//  Created by Egzon Pllana on 3/21/20.
//  Copyright © 2020 Native Coders. All rights reserved.
//

import Foundation
import Alamofire

enum ResultValue<Value> {
    case success(Value)
    case failure(Error)
}

struct APIError: Codable, LocalizedError {
    let error: String

    var errorDescription: String? {
        return error
    }
}

class APIClient {

    private static let decoder = JSONDecoder()

    /**
     **PERFORM REQUEST**
     - Main method for making network requests
     - Parameters:
     - type: the type you are expecting back as a response. Must be of type Decodable
     - route: contains the details for the request. Is of type APIConfiguration
     - decoder: custom decoder for decoding JSON
     - completion: Result with associated type of Decodable
     */
    static func performRequest<T: Decodable>(type: T.Type, withRoute route: APIConfiguration, andDecoder decoder: JSONDecoder = decoder, completion: @escaping (ResultValue<T>) -> Void) {

        // RESPONSE HANDLER
        func jsonHandler(response: DataResponse<Any>) {
            // switch on the dataResponse
            switch response.result {
            case .failure(let error):
                if let data = response.data, let apiError = try? decoder.decode(APIError.self, from: data) {
                    completion(ResultValue.failure(apiError))
                } else {
                    completion(ResultValue.failure(error))
                }
            case .success(let json):
                #if DEBUG
                print(json)
                #endif
                // get data from JSON
                let data: Data
                // convert the foundation object from the response to json object and then to data
                do {
                    data = try JSONSerialization.data(withJSONObject: json)
                } catch {
                    completion(ResultValue.failure(error)); return
                }
                // get Object from data
                let object: T
                do {
                    object = try decoder.decode(T.self, from: data)
                } catch {
                    #if DEBUG
                    print("Decoding Error in route: -->", route.urlRequest ?? "no route found")
                    print("Decoding error: -->", error)
                    #endif
                    completion(ResultValue.failure(error)); return
                }
                completion(ResultValue.success(object))
            }
        }

        // MARK: MultipartFormData

        if let multipartFormData = route.multipartFormData {
            Alamofire.upload(multipartFormData: multipartFormData, with: route) { result in
                switch result {
                case .failure(let error):
                    completion(ResultValue.failure(error))
                case .success(let encodingResult):
                    encodingResult.request
                        .validate()
                        .responseJSON(completionHandler: jsonHandler)
                }
            }
        } else {
            Alamofire.request(route)
                .validate()
                .responseJSON(completionHandler: jsonHandler)
        }
    }
}
