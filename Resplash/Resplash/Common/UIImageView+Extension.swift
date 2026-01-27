//
//  UIImageView+Extension.swift
//  NetworkingStart
//
//  Created by 석민솔 on 1/27/26.
//

import UIKit
import Kingfisher

extension UIImageView {
    func kfImage(url: String) {
        let url = URL(string: url)
        self.kf.setImage(with: url) { result in
            switch result {
            case .failure:
                self.image = UIImage(systemName: "exclamationmark.triangle")?.withTintColor(.systemYellow)
            default: return
            }
        }
    }
}
