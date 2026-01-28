//
//  SearchImageCollectionViewCell.swift
//  Resplash
//
//  Created by 석민솔 on 1/28/26.
//

import UIKit

import SnapKit

class SearchImageCollectionViewCell: UICollectionViewCell {
    static let identifier = "ShoppingResultCollectionViewCell"
    
    // ui views
    let imageView = UIImageView()
    
    lazy var likeTokenView = LikeStarTokenView(likeCount: likeCount)
    
    // data
    var likeCount: Int = 30000
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchImageCollectionViewCell {
    func configureHierarchy() {
        contentView.addSubview(imageView)
        contentView.addSubview(likeTokenView)
    }
    
    func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }

        likeTokenView.snp.makeConstraints { make in
            make.leading.bottom.equalTo(contentView).inset(8)
        }
    }
    
    func configureView() {
        configureImageView()
    }
    
    // subview configure
    private func configureImageView() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
        
    func configureData(with data: UnsplashMetaData?) {
        if let data {
            imageView.kfImage(url: data.urls.small)
            likeTokenView.configureData(count: data.likes)
        }
    }
    
    
}
