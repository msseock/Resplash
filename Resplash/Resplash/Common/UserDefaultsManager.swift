//
//  UserDefaultsManager.swift
//  Resplash
//
//  Created by 석민솔 on 2/2/26.
//

import Foundation

final class UDManager {
    
    private let likePhotoArrayKey: String = "like"

    func addLikedPhoto(_ id: String) {
        var array = self.getLikeArray()
        array.append(id)
        
        setArray(array)
    }
    
    func cancelLike(_ id: String) {
        var array = self.getLikeArray()
        array.removeAll { $0 == id }
        
        setArray(array)
    }
    
    func isLikedPhoto(_ id: String) -> Bool {
        let array = getLikeArray()
        return array.contains(id)
    }

    private func setArray(_ stringArray: [String]) {
        UserDefaults.standard.set(stringArray, forKey: likePhotoArrayKey)
    }
    
    private func getLikeArray() -> [String] {
        UserDefaults.standard.stringArray(forKey: likePhotoArrayKey) ?? []
    }
    
}
