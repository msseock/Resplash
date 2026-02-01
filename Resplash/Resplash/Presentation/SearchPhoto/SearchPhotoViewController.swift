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
    let colorChipScrollView = UIScrollView()
    let colorChipStackView = UIStackView()
    var colorChips: [ColorChipView] = []
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
    var imageData: UnsplashMetaDecodable? = nil
    var selectedColor: UnsplashColor? = nil
    var orderType: UnsplashOrderType = .relevant
    var page = 1
    var latestquery: String? = nil
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Configure View
    override func configureHierarchy() {
        
        view.addSubview(searchBar)
        
        view.addSubview(optionSelectView)
        optionSelectView.addSubview(colorChipScrollView)
        colorChipScrollView.addSubview(colorChipStackView)
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
        
        colorChipScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        colorChipStackView.snp.makeConstraints { make in
            make.height.equalTo(colorChipScrollView.frameLayoutGuide).offset(-16)
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalTo(colorChipScrollView.contentLayoutGuide).inset(UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 120))
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
        configureColorChipScroll()
    }
    
    private func configureColorChipScroll() {
        colorChipStackView.spacing = 16
        
        for color in UnsplashColor.allCases {
            let colorChipView = ColorChipView(color: color, isSelected: selectedColor == color)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(colorChipTapped))
            colorChipView.addGestureRecognizer(tapGesture)
            colorChipView.isUserInteractionEnabled = true
            
            colorChipStackView.addArrangedSubview(colorChipView)
            colorChips.append(colorChipView)
        }
    }
    
    private func refreshColorChipStack() {
        for colorChip in self.colorChips {
            colorChip.configureData(color: colorChip.color, isSelected: selectedColor == colorChip.color)
        }
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
        if imageData == nil {
            statusLabel.isHidden = false
            statusLabel.text = "사진을 검색해보세요"
            
        } else if let imageData, imageData.total == 0 {
            statusLabel.isHidden = false
            statusLabel.text = "검색 결과가 없어요"
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
        imageData?.results.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchImageCollectionViewCell.identifier, for: indexPath) as! SearchImageCollectionViewCell
        
        let cellData = imageData?.results[indexPath.item]
        cell.configureData(with: cellData)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let imageData,
           !(imageData.total_pages <= page),
            indexPath.item == (imageData.results.count - 2) {
            
            // 기존 검색어로 추가검색
            if let latestquery {
                self.page += 1
                fetchSearchData(query: latestquery)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let currentData = imageData?.results[indexPath.item] else {
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
            like: false, // TODO: UserDefaults에서 불러오기
            mainImage: currentData.urls.raw,
            imageWidth: currentData.width,
            imageHeight: currentData.height
        ))
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: SearchBar
extension SearchPhotoViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        if let text = searchBar.text, !text.isEmpty {
            if text != latestquery {
                latestquery = text
                removeResultData()
                fetchSearchData(query: text)
            }
        }
    }
}


// MARK: - Logic
extension SearchPhotoViewController {
    private func fetchSearchData(query: String) {
        NetworkManager.shared.request(
            endpoint: .search(
                query: query,
                page: self.page,
                order: self.orderType,
                color: self.selectedColor
            )
        ) { data in
            guard let data = data as? UnsplashMetaDecodable else { return }
            
            if let imgData = self.imageData, !imgData.results.isEmpty {
                self.imageData?.results.append(contentsOf: data.results)
            } else {
                self.imageData = data
            }
            
            self.configureResultView()
            self.SearchImageCollectionView.reloadData()
        }
    }
    
    @objc func orderButtonTapped() {
        switch self.orderType {
        case .latest:
            self.orderType = .relevant
        case .relevant:
            self.orderType = .latest
        }
        
        // 정렬 방식 바뀔 때는 갱신되도록
        removeResultData()
        
        if let text = searchBar.text, !text.isEmpty {
            fetchSearchData(query: text)
        }
        
        configureOrderButton()
    }
    
    @objc func colorChipTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        let tappedView = gestureRecognizer.view as! ColorChipView
        let color = tappedView.color
        print(#function, color)
        
        if selectedColor == color {
            self.selectedColor = nil
        } else {
            self.selectedColor = color
        }
        
        removeResultData()
        
        if let text = searchBar.text, !text.isEmpty {
            fetchSearchData(query: text)
        }

        refreshColorChipStack()
    }
    
    private func removeResultData() {
        imageData = nil
        page = 1

    }
}
