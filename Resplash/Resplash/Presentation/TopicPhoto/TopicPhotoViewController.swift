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
    private let topics: [UnsplashTopic] = {
        var array: [UnsplashTopic] = []
        for _ in 0..<3 {
            let randomTopic = UnsplashTopic(rawValue: Int.random(in: 0..<UnsplashTopic.allCases.count))!
            array.append(randomTopic)
        }
        return array
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchSearchData()
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
            data: topicData?[indexPath.item],
            navigatingAction: { data in
                guard let currentData = data else {
                    print("이미지 데이터 없음")
                    return
                }
                let currentUser = currentData.user
                
                let vc = PhotoDetailViewController()
                vc.configurePhotoDetailView(.init(
                    id: currentData.id,
                    profileImage: currentData.user.profile_image.medium,
                    profileName: currentUser.name,
                    createdDate: currentData.created_at,
                    like: false,    // TODO: UserDefaults에서 불러오기
                    mainImage: currentData.urls.small,
                    imageWidth: currentData.width,
                    imageHeight: currentData.height
                ))

                self.navigationController?.pushViewController(vc, animated: true)
            }
        )
        
        return cell
    }
    
    
}


// MARK: Logic
extension TopicPhotoViewController {
    private func fetchSearchData() {
        self.topicData = Array(repeating: [], count: topics.count)
        
        let group = DispatchGroup()

        for (index, topic) in topics.enumerated() {
            group.enter()
            print("group\(index) enter")
            NetworkManager.shared.request(
                endpoint: .topic(id: topic)
            ) { data in
                guard let data = data as? [UnsplashMetaData] else {
                    group.leave()
                    return
                }
                self.topicData?[index] = data
                group.leave()
                print("group\(index) leave")
            }
        }
        
        group.notify(queue: .main) {
            print("group end - reloadData")
            self.topicCollectionView.reloadData()
        }
        
    }

    
}
