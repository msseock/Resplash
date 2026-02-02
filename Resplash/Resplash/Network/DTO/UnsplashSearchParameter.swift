//
//  UnsplashSearchParameter.swift
//  Resplash
//
//  Created by 석민솔 on 2/2/26.
//

import Foundation
import Alamofire

struct UnsplashSearchParameter {
    let query: String
    let page: Int
    let order: UnsplashOrderType
    let color: UnsplashColor?
    
    var parameters: Parameters {
        var params: Parameters = [
            "query": query,
            "page": page,
            "per_page": 20,
            "order_by": order.rawValue
        ]
        
        if let color {
            params["color"] = color.colorQuery
        }
        
        return params
    }
}
