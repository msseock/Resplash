//
//  SearchPhotoViewController.swift
//  Resplash
//
//  Created by 석민솔 on 1/26/26.
//

import UIKit

import SnapKit

class SearchPhotoViewController: BaseViewController {
    // MARK: - Properties
    // views
    let searchBar = UISearchBar()

    let optionSelectView = UIView()
    let orderButton = UIButton()
    
    let resultView = UIView()
    let statusLabel = UILabel()
    let SearchImageCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        let inset: CGFloat = 0
        let spacing: CGFloat = 4
        
        let deviceWidth = UIScreen.main.bounds.width
        let itemWidth = (deviceWidth - (inset * 2) - spacing) / 2

        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.itemSize = .init(width: itemWidth, height: itemWidth * 4/3)

        layout.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)

        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)

        return view
    }()
    
    
    // logic / datas
//    var imageData: UnsplashMetaDecodable?
    var imageData: [String] = []
    var orderType: UnsplashOrderType = .relevant
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: 네트워킹으로 임시로 채운거 정식으로 데이터 입력해넣기
        imageData = [
        ]
    }

    // MARK: - Configure View
    override func configureHierarchy() {
        
        view.addSubview(searchBar)
        
        view.addSubview(optionSelectView)
        optionSelectView.addSubview(orderButton)
        
        view.addSubview(resultView)
        resultView.addSubview(SearchImageCollectionView)
        resultView.addSubview(statusLabel)
    }

    override func configureLayout() {
        // 검색창
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
        
        // 검색옵션바
        optionSelectView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }
        
        orderButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(80)
        }
        
        // 결과 표시하는 뷰
        resultView.snp.makeConstraints { make in
            make.top.equalTo(optionSelectView.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        statusLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        SearchImageCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override func configureView() {
        super.configureView()
        navigationItem.title = "SEARCH PHOTO"
        
        configureSearchBar()
        configureOptionSelectView()
        configureResultView()
    }

}

// MARK: Subview Configure
extension SearchPhotoViewController {
    private func configureSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "키워드 검색"
    }
    
    private func configureOptionSelectView() {
        configureOrderButton()
    }
    
    private func configureOrderButton() {
        orderButton.setTitle(self.orderType.buttonText, for: .normal)
        orderButton.backgroundColor = .black
        orderButton.setTitleColor(.white, for: .normal)
        orderButton.layer.cornerRadius = 15
        orderButton.clipsToBounds = true
        orderButton.addTarget(
            self,
            action: #selector(orderButtonTapped),
            for: .touchUpInside
        )
    }
    
    private func configureResultView() {
        if imageData.isEmpty {
            statusLabel.isHidden = false
            // TODO: 네트워킹 결과에 따라 안내문구 다르게 띄우기
            statusLabel.text = "사진을 검색해보세요"
            
        } else {
            statusLabel.isHidden = true
        }
        configureResultLabel()
        configureCollectionView()
    }
    
    private func configureResultLabel() {
        statusLabel.font = .boldSystemFont(ofSize: 20)
        statusLabel.numberOfLines = 0
        statusLabel.textAlignment = .center
    }
        
    
    private func configureCollectionView() {
        SearchImageCollectionView.delegate = self
        SearchImageCollectionView.dataSource = self
        
        SearchImageCollectionView.register(SearchImageCollectionViewCell.self, forCellWithReuseIdentifier: SearchImageCollectionViewCell.identifier)
        
    }
}


// MARK: CollectionView
extension SearchPhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageData.count
//        imageData?.results.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchImageCollectionViewCell.identifier, for: indexPath) as! SearchImageCollectionViewCell
        
        cell.configureData(with: imageData[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = PhotoDetailViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: SearchBar
extension SearchPhotoViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(#function)
        view.endEditing(true)
    }
}


// MARK: - Logic
extension SearchPhotoViewController {
    @objc func orderButtonTapped() {
        switch self.orderType {
        case .latest:
            self.orderType = .relevant
        case .relevant:
            self.orderType = .latest
        }
        // TODO: 바뀐 정렬로 검색 요청하기
        
        configureOrderButton()
    }
}
