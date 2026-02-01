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
    // MARK: views
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let profileBarView = UIView()
    let profileImageView = UIImageView()
    let nameLabel = UILabel()
    let dateLabel = UILabel()
    let heartButton = UIButton()
    
    let mainImageView = UIImageView()
    
    let infoSectionView = UIView()
    let infoTitleLabel = UILabel()
    let infoRowStack = UIStackView()
    // TODO: 삭제하고 configure로 옮기기
    let infoRowStackTemp: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .leading
        view.spacing = 8
        view.distribution = .equalSpacing
        return view
    }()
    
    let infoRowViews = [UIView(), UIView(), UIView()]
    let infoRowLabels = [
        [UILabel(), UILabel()],
        [UILabel(), UILabel()],
        [UILabel(), UILabel()]
    ]
    
    let chartSectionView = UIView()
    let chartTitleLabel = UILabel()
    let chartInfoView = UIView()
    let chartSegmentedControl = UISegmentedControl()
    let chartView = UIView() // TODO: Chart로 바꾸기(지금은 레이아웃만 잡아두고)
    
    // MARK: data
    // TODO: width:height 데이터 가져와서 계산하기
    var imageSize: CGSize = .init(width: 3098, height: 3872)
    
    // computed properties
    var mainImageHeight: CGFloat {
        let deviceWidth = UIScreen.main.bounds.width
        let imageViewHeight = deviceWidth * (imageSize.height / imageSize.width)
        return imageViewHeight
    }

    // MARK: - Configure Views
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            make.height.equalTo(200)
        }
        configureInfoSectionViewLayout()
        
        chartSectionView.snp.makeConstraints { make in
            make.top.equalTo(infoSectionView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(300)
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
            make.trailing.top.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(4.0/5.0)
        }
        
        
         for index in 0..<infoRowViews.count {
             
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
            make.trailing.top.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(4.0/5.0)
        }
        
        chartSegmentedControl.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        
        chartView.snp.makeConstraints { make in
            make.top.equalTo(chartSegmentedControl.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(100)
        }
    }
}
