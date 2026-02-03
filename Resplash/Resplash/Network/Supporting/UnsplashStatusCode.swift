//
//  UnsplashStatusCode.swift
//  Resplash
//
//  Created by 석민솔 on 1/27/26.
//

import Foundation

enum UnsplashStatusCode: Int, Error, LocalizedError {
    case ok = 200
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case internalServerError = 500
    case serviceUnavailable = 503
    case undefinedError
    
    var errorDescription: String? {
        switch self {
        case .ok:
            "good"
        case .badRequest:
            "The request was unacceptable, often due to missing a required parameter"
        case .unauthorized:
            "Invalid Access Token"
        case .forbidden:
            "Missing permissions to perform request"
        case .notFound:
            "The requested resource doesn't exist"
        case .internalServerError, .serviceUnavailable:
            "Something went wrong on our end"
        case .undefinedError:
            "undefined"
        }
    }
}
