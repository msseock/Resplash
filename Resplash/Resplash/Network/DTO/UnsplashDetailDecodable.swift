//
//  UnsplashDetailDecodable.swift
//  Resplash
//
//  Created by 석민솔 on 1/27/26.
//

import Foundation

struct UnsplashDetailDecodable: Decodable {
    let id: String
    let downloads: UnsplashDetailInfo
    let views: UnsplashDetailInfo
}

struct UnsplashDetailInfo: Decodable {
    let total: Int
    let historical: UnsplashDetailHistorical
}

struct UnsplashDetailHistorical: Decodable {
    let values: [UnsplashDetailValues]
}

struct UnsplashDetailValues: Decodable {
    let date: String
    let value: Int
}
