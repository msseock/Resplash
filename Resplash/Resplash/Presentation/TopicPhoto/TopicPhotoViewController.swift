//
//  TopicPhotoViewController.swift
//  Resplash
//
//  Created by 석민솔 on 1/26/26.
//

import UIKit

import SnapKit

class TopicPhotoViewController: BaseViewController {
    // MARK: - Properties
    // views
    let topicCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        let inset: CGFloat = 0
        let spacing: CGFloat = 8
        
        let deviceWidth = UIScreen.main.bounds.width
        let deviceHeight = UIScreen.main.bounds.height
        let itemHeight = deviceHeight / 3 - (inset * 2)

        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.itemSize = .init(width: deviceWidth, height: itemHeight)

        layout.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)

        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)

        return view
    }()
    
    // data
    var topicData: [[UnsplashMetaData]]?
    private let topics: [UnsplashTopic] = [.goldenHour, .businessWork, .architectureInterior]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func configureHierarchy() {
        view.addSubview(topicCollectionView)
    }

    override func configureLayout() {
        topicCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }

    override func configureView() {
        super.configureView()
        
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "OUR TOPIC"
        
        configureCollectionView()
        
    }

}

extension TopicPhotoViewController {
    private func configureCollectionView() {
        topicCollectionView.delegate = self
        topicCollectionView.dataSource = self
        
        topicCollectionView.register(TopicCollectionViewCell.self, forCellWithReuseIdentifier: TopicCollectionViewCell.identifier)
        
    }
}

extension TopicPhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        topics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopicCollectionViewCell.identifier, for: indexPath) as! TopicCollectionViewCell
        
        cell.configureData(
            topic: topics[indexPath.item],
            data: topicData?[indexPath.item]
        )
        
        return cell
    }
    
    
}


// MARK: Logic
extension TopicPhotoViewController {
    // TODO: 네트워크 요청
    
}
