//
//  PhotoDetailViewController.swift
//  Resplash
//
//  Created by 석민솔 on 1/26/26.
//

import UIKit

import SnapKit

class PhotoDetailViewController: BaseViewController {
    // MARK: - Properties
    var changeHeartButtonState: (() -> Void)? = { }
    // MARK: views
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    // profile bar
    let profileBarView = UIView()
    let profileImageView = UIImageView()
    let nameLabel = UILabel()
    let dateLabel = UILabel()
    let heartButton = UIButton()
    
    // image
    let mainImageView = UIImageView()
    
    // info section
    let infoSectionView = UIView()
    let infoTitleLabel = UILabel()
    
    let infoRowStack = UIStackView()
    let infoRowViews = [UIView(), UIView(), UIView()]
    let infoRowLabels = [
        [UILabel(), UILabel()],
        [UILabel(), UILabel()],
        [UILabel(), UILabel()]
    ]
    
    // chart section
    let chartSectionView = UIView()
    let chartTitleLabel = UILabel()
    let chartInfoView = UIView()
    let chartSegmentedControl = UISegmentedControl()
    let chartView = LineChartView()
    
    // MARK: data
    private var data: PhotoDetailData?
    
    
    // MARK: computed
    private var profileDateText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        guard let data, let date = formatter.date(from: data.createdDate) else {
            print("날짜 없음")
            return "날짜 없음"
        }
        
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "yyyy년 M월 d일 게시됨"
        return displayFormatter.string(from: date)
    }
    
    private var heartButtonImage: UIImage {
        if let data {
            let heartButtonImageName: String = data.like ? "heart.fill" : "heart"
            return UIImage(systemName: heartButtonImageName)!
        } else {
            return UIImage(systemName: "heart")!
        }
    }
    
    private var mainImageHeight: CGFloat {
        guard let data else { return 0 }
        
        let deviceWidth = UIScreen.main.bounds.width
        let imageViewHeight = deviceWidth * (CGFloat(data.imageHeight) / CGFloat(data.imageWidth))
        
        return imageViewHeight
    }
    
    private var imageSizeText: String {
        if let data {
            return "\(data.imageWidth) x \(data.imageHeight)"
        } else {
            return "이미지 없음"
        }
    }
    
    private var viewCountText: String {
        if let viewCount = data?.viewTotalCount {
            NumberFormatManager.shared.getFormattedNumberText(num: viewCount)
        } else {
            "조회 불가"
        }
    }
    
    private var downloadCountText: String {
        if let downloadCount = data?.downloadTotalCount {
            NumberFormatManager.shared.getFormattedNumberText(num: downloadCount)
        } else {
            "조회 불가"
        }
    }

    // MARK: - Configure Views
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchSearchData()
        refreshView()
    }

    override func configureHierarchy() {
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(profileBarView)
        contentView.addSubview(mainImageView)
        contentView.addSubview(infoSectionView)
        contentView.addSubview(chartSectionView)
        
        configureProfileBarViewHierarchy()
        configureInfoSectionViewHierarchy()
        configureChartSectionViewHierarchy()
    }

    override func configureLayout() {
        // frame layout guide
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        // content layout guide
        contentView.snp.makeConstraints { make in
            make.width.equalTo(scrollView.frameLayoutGuide)
            make.verticalEdges.equalTo(scrollView)
        }
        
        configureContentViewLayout()
    }

    override func configureView() {
        super.configureView()
        
        configureProfileBar()
        configureMainImage()
        configureInfoSection()
        configureChartSection()
    }

}

// MARK: - Configure Subviews
extension PhotoDetailViewController {
    // MARK: Hierarchy
    /// 프로필바 subview 등록
    private func configureProfileBarViewHierarchy() {
        profileBarView.addSubview(profileImageView)
        profileBarView.addSubview(nameLabel)
        profileBarView.addSubview(dateLabel)
        profileBarView.addSubview(heartButton)
    }
    
    /// 정보 구역 subview 등록
    private func configureInfoSectionViewHierarchy() {
        infoSectionView.addSubview(infoTitleLabel)
        infoSectionView.addSubview(infoRowStack)
        
        for index in 0..<infoRowViews.count {
            let currentRow = infoRowViews[index]
            // row view
            infoRowStack.addArrangedSubview(currentRow)
            
            // 2 labels for each row
            for rowLabel in infoRowLabels[index] {
                currentRow.addSubview(rowLabel)
            }
        }
    }
    
    /// 차트 구역 subview 등록
    private func configureChartSectionViewHierarchy() {
        chartSectionView.addSubview(chartTitleLabel)
        chartSectionView.addSubview(chartInfoView)
        chartInfoView.addSubview(chartSegmentedControl)
        chartInfoView.addSubview(chartView)
    }
    
    // MARK: Layout
    private func configureContentViewLayout() {
        profileBarView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(contentView)
            make.height.equalTo(80)
        }
        configureProfileBarViewLayout()
        
        mainImageView.snp.makeConstraints { make in
            make.top.equalTo(profileBarView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(self.mainImageHeight)
        }
        
        infoSectionView.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        configureInfoSectionViewLayout()
        
        chartSectionView.snp.makeConstraints { make in
            make.top.equalTo(infoSectionView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
        configureChartSectionViewLayout()
    }
    
    private func configureProfileBarViewLayout() {
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(48)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.bottom.equalTo(profileBarView.snp.centerY).offset(2)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.leading)
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
        }
        
        heartButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(48)
        }
    }
    
    private func configureInfoSectionViewLayout() {
        infoTitleLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(1.0/5.0)
            
        }
        
        infoRowStack.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.leading.equalTo(infoTitleLabel.snp.trailing)
        }
        
        
        for index in 0..<infoRowViews.count {
            infoRowViews[index].snp.makeConstraints { make in
                make.height.equalTo(30)
            }
            
            let leftLabel = infoRowLabels[index][0]
            leftLabel.snp.makeConstraints { make in
                make.leading.equalToSuperview()
                make.verticalEdges.equalToSuperview()
            }
            
            let rightLabel = infoRowLabels[index][1]
            rightLabel.snp.makeConstraints { make in
                make.trailing.equalToSuperview()
                make.verticalEdges.equalToSuperview()
            }
        }
        
    }
    
    private func configureChartSectionViewLayout() {
        chartTitleLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(1.0/5.0)
        }
        
        chartInfoView.snp.makeConstraints { make in
            make.trailing.verticalEdges.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(4.0/5.0)
        }
        
        chartSegmentedControl.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        
        chartView.snp.makeConstraints { make in
            make.top.equalTo(chartSegmentedControl.snp.bottom).offset(16)
            make.horizontalEdges.bottom.equalToSuperview()
            make.height.equalTo(200)
        }
    }
    
    // MARK: View
    
    // profile bar
    private func configureProfileBar(){
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 24
        profileImageView.clipsToBounds = true
        profileImageView.backgroundColor = .systemGray6
        profileImageView.tintColor = .systemYellow
        
        nameLabel.textAlignment = .left
        nameLabel.numberOfLines = 1
        
        dateLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        
        heartButton.setTitle(nil, for: .normal)
        refreshHeartButton()
        heartButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
    }

    
    private func refreshProfileBar() {
        profileImageView.kfImage(url: self.data?.profileImage ?? "")
        nameLabel.text = self.data?.profileName
        dateLabel.text = self.profileDateText
        refreshHeartButton()
    }
    
    private func refreshHeartButton() {
        heartButton.setImage(self.heartButtonImage, for: .normal)
    }
    
    // main img
    private func configureMainImage() {
        mainImageView.contentMode = .scaleAspectFit
        mainImageView.backgroundColor = .systemGray6
        mainImageView.tintColor = .systemYellow
    }
    
    func refreshMainImage() {
        if let data {
            mainImageView.kfImage(url: data.mainImage)
        }
    }
    
    // info section
    private func configureInfoSection(){
        infoTitleLabel.text = "정보"
        infoTitleLabel.font = .systemFont(ofSize: 17, weight: .bold)
        
        configureInfoRowStack()
        configureInfoRowLabels()
    }
    
    private func configureInfoRowStack() {
        infoRowStack.axis = .vertical
        infoRowStack.alignment = .fill
        infoRowStack.spacing = 8
        infoRowStack.distribution = .equalSpacing
    }
    
    private func configureInfoRowLabels() {
        let infoSubtitles: [String] = [
            "크기", "조회수", "다운로드"
        ]
        
        for index in 0..<infoRowLabels.count {
            let left = infoRowLabels[index][0]
            left.text = infoSubtitles[index]
            left.font = .systemFont(ofSize: 15, weight: .semibold)
            
            let right = infoRowLabels[index][1]
            right.font = .systemFont(ofSize: 15, weight: .regular)
        }
    }
    
    private func refreshInfoSection() {
        infoRowLabels[0][1].text = self.imageSizeText
        infoRowLabels[1][1].text = self.viewCountText
        infoRowLabels[2][1].text = self.downloadCountText
    }
    
    // chart section
    private func configureChartSection() {
        chartTitleLabel.text = "차트"
        chartTitleLabel.font = .systemFont(ofSize: 17, weight: .bold)
        
        configureChartSegmentedControl()
        configureChart()
    }
    
    private func configureChartSegmentedControl() {
        chartSegmentedControl.insertSegment(withTitle: "조회", at: 0, animated: true)
        chartSegmentedControl.insertSegment(withTitle: "다운로드", at: 1, animated: true)
        chartSegmentedControl.selectedSegmentIndex = 0
        chartSegmentedControl.addTarget(self, action: #selector(chartSegmentChanged), for: .valueChanged)
    }
    
    private func configureChart() {
        var data: [Int]
        switch chartSegmentedControl.selectedSegmentIndex {
        case 0:
            data = self.data?.viewValues ?? []
        case 1:
            data = self.data?.downloadValues ?? []
        default:
            return
        }
        self.chartView.dataPoints = data.map { CGFloat($0) }
    }
}

// MARK: - Logics
extension PhotoDetailViewController {
    @objc private func chartSegmentChanged() {
        configureChart()
    }

    @objc private func likeButtonTapped() {
        if let data {
            self.data!.like.toggle()
            
            let udManager = UDManager()
            if data.like {
                udManager.cancelLike(data.id)
            } else {
                udManager.addLikedPhoto(data.id)
            }
            
            refreshHeartButton()
            changeHeartButtonState?()
            
        } else {
            print(#function)
        }
    }
    
    func configurePhotoDetailView(_ data: PhotoDetailData) {
        self.data = data
    }
    
    private func refreshView() {
        refreshProfileBar()
        refreshMainImage()
        refreshInfoSection()
    }
    
    private func fetchSearchData() {
        guard let id = self.data?.id else {
            print("데이터 없음")
            return
        }
        
        NetworkManager.shared.request(
            endpoint: .detail(id: id)
        ) { data in
            guard let data = data as? UnsplashDetailDecodable else {
                print("UnsplashDetailDecodable casting fail")
                return
            }
            
            self.data?.viewTotalCount = data.views.total
            self.data?.downloadTotalCount = data.downloads.total
            self.data?.viewValues = data.views.historical.values.map { $0.value }
            self.data?.downloadValues = data.downloads.historical.values.map { $0.value }
            
            self.refreshInfoSection()
            self.configureChart()
        } errorHandler: { error in
            self.showDefaultAlert(title: error.localizedDescription)
        }
        
    }
}
