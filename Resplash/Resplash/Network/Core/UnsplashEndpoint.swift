//
//  UnsplashEndpoint.swift
//  Resplash
//
//  Created by 석민솔 on 1/27/26.
//

import Foundation

import Alamofire

enum UnsplashEndpoint {
    case search(query: String, page: Int, order: UnsplashOrderType, color: UnsplashColor?)
    case topic(id: UnsplashTopic)
    case detail(id: String)
}

extension UnsplashEndpoint {
    var path: String {
        switch self {
        case .search:
            return "/search/photos"
        case .topic(let id):
            return "/topics/\(id.englishName)/photos"
        case .detail(let id):
            return "/photos/\(id)/statistics"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: Parameters? {
        switch self {
        case .search(let query, let page, let order, let color):
            if let color {
                [
                    "query": query,
                    "page": page,
                    "per_page": 20,
                    "order_by": order.rawValue,
                    "color": color.colorQuery
                ]
            } else {
                [
                    "query": query,
                    "page": page,
                    "per_page": 20,
                    "order_by": order.rawValue
                ]
            }
        default: nil
        }
    }
    
    var reponseType: any Decodable.Type {
        switch self {
        case .search:
            UnsplashMetaDecodable.self
        case .topic:
            [UnsplashMetaData].self
        case .detail:
            UnsplashDetailDecodable.self
        }
    }
}

