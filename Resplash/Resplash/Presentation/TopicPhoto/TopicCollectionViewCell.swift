//
//  TopicCollectionViewCell.swift
//  Resplash
//
//  Created by 석민솔 on 1/29/26.
//

import UIKit
import SnapKit

class TopicCollectionViewCell: UICollectionViewCell {
    static let identifier = "TopicCollectionViewCell"
    
    // uiviews
    let titleLabel = UILabel()
    lazy var imageCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        let inset: CGFloat = 20
        let spacing: CGFloat = 8
        
        let deviceHeight = UIScreen.main.bounds.height
        let itemHeight = deviceHeight / 3 - labelHeight

        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.itemSize = .init(width: itemHeight * 3 / 4, height: itemHeight)

        layout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)

        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)

        return view
    }()
    
    private let labelHeight: CGFloat = 50
    
    // data
    var sectionTopic: UnsplashTopic?
    var topicSectionData: [UnsplashMetaData]?
    
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

extension TopicCollectionViewCell {
    func configureHierarchy() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(imageCollectionView)
    }
    
    func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.horizontalEdges.equalTo(contentView).inset(20)
            make.height.equalTo(labelHeight)
        }

        imageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.horizontalEdges.bottom.equalTo(contentView)
        }
    }
    
    func configureView() {
        configureLabel()
        configureCollectionView()
    }
    
    // subview configure
    private func configureLabel() {
        titleLabel.text = sectionTopic?.koreanName
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textColor = .black
        
        print("sectionTopic:", sectionTopic)
    }
    
    private func configureCollectionView() {
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
        imageCollectionView.register(SearchImageCollectionViewCell.self, forCellWithReuseIdentifier: SearchImageCollectionViewCell.identifier)
        
    }
        
    func configureData(topic: UnsplashTopic, data: [UnsplashMetaData]?) {
        self.sectionTopic = topic
        self.topicSectionData = data
        titleLabel.text = topic.koreanName
        imageCollectionView.reloadData()
    }
    
    
}


extension TopicCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchImageCollectionViewCell.identifier, for: indexPath) as! SearchImageCollectionViewCell
        
        cell.configureData(with: self.topicSectionData?[indexPath.item])
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
        
        return cell
    }
    
    
}
