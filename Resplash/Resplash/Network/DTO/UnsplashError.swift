//
//  UnsplashError.swift
//  Resplash
//
//  Created by 석민솔 on 1/27/26.
//

import Foundation

struct UnsplashError: Decodable, Error, LocalizedError {
    let errors: [String]
    
    var errorDescription: String? {
        return errors.joined(separator: ", ")
    }
}
