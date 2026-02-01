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
    
    let likeButton = UIButton()
    
    // data
    var id: String? = nil
    var likeCount: Int = 30000
    var like: Bool = false
    
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
        contentView.addSubview(likeButton)
    }
    
    func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }

        likeTokenView.snp.makeConstraints { make in
            make.leading.bottom.equalTo(contentView).inset(8)
        }
        
        likeButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(contentView).inset(8)
            make.size.equalTo(30)
        }
    }
    
    func configureView() {
        configureImageView()
        configureLikeButton()
        backgroundColor = .systemGray6
    }
    
    // subview configure
    private func configureImageView() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    private func configureLikeButton() {
        likeButton.setTitle(nil, for: .normal)
        likeButton.backgroundColor = .white.withAlphaComponent(0.3)
        likeButton.layer.cornerRadius = 15
        likeButton.clipsToBounds = true
        likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
    }
    
    private func refreshLikeButton() {
        likeButton.tintColor = like ? .systemBlue : .white.withAlphaComponent(0.5)
    }
        
    func configureData(with data: UnsplashMetaData?, like: Bool? = nil) {
        if let data {
            self.id = data.id
            imageView.kfImage(url: data.urls.small)
            likeTokenView.configureData(count: data.likes)
        }
        if let like {
            self.like = like
            refreshLikeButton()
        } else {
            likeButton.isHidden = true
        }
    }
    
    @objc func likeButtonTapped(_ sender: UIButton) {
        let udManager = UDManager()
        if like, let id {
            udManager.cancelLike(id)
        } else if let id {
            udManager.addLikedPhoto(id)
        }
        
        like.toggle()
        refreshLikeButton()
    }
}
