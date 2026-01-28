//
//  UnsplashMetaDecodable.swift
//  Resplash
//
//  Created by 석민솔 on 1/27/26.
//

import Foundation

struct UnsplashMetaDecodable: Decodable {
    let total: Int
    let total_pages: Int
    var results: [UnsplashMetaData]
}

struct UnsplashMetaData: Decodable {
    let id: String
    let created_at: String
    let width: Int
    let height: Int
    let urls: UnsplashMetaURL
    let likes: Int
    let user: UnsplashMetaUser
}

struct UnsplashMetaURL: Decodable {
    let raw: String
    let small: String
}

struct UnsplashMetaUser: Decodable {
    let name: String
    let profile_image: UnsplashMetaProfile
}

struct UnsplashMetaProfile: Decodable {
    let medium: String
}
