//
//  PhotoDetailData.swift
//  Resplash
//
//  Created by 석민솔 on 2/2/26.
//

import Foundation

struct PhotoDetailData {
    var id: String
    var profileImage: String
    var profileName: String
    var createdDate: String
    var like: Bool
    var mainImage: String
    var imageWidth: Int
    var imageHeight: Int
    var viewCount: Int? = nil
    var downloadCount: Int? = nil
}
