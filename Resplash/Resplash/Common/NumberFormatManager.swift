//
//  NumberFormatManager.swift
//  Resplash
//
//  Created by 석민솔 on 1/28/26.
//

import Foundation

final class NumberFormatManager {
    static let shared = NumberFormatManager()
        
    private init() { }
    
    func getFormattedNumberText(num: Int) -> String {
        return num.formatted()
    }
}
