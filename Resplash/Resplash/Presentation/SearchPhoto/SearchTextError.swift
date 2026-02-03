//
//  SearchTextError.swift
//  Resplash
//
//  Created by 석민솔 on 2/3/26.
//

import Foundation

enum SearchTextError: Error, LocalizedError {
    case isEmpty
    case notChanged
    
    var errorDescription: String? {
        switch self {
        case .isEmpty:
            "검색어가 비어있습니다"
        case .notChanged:
            "같은 검색어입니다"
        }
    }
}
