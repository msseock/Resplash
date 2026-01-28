//
//  LikeStarTokenView.swift
//  Resplash
//
//  Created by 석민솔 on 1/28/26.
//

import UIKit

import SnapKit

class LikeStarTokenView: UIView {
    // MARK: - Properties
    // ui
    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.spacing = 4
        view.distribution = .equalSpacing
        return view
    }()
    
    let starImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "star.fill")?.withRenderingMode(.alwaysTemplate)
        view.tintColor = .systemYellow
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let countLableView: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: - init
    override init(frame: CGRect) {
        super .init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // custom init
    init(likeCount: Int) {
        super .init(frame: .zero)
        configureHierarchy()
        configureLayout()
        configureView()
        configureData(count: likeCount)
        
    }
    
    // MARK: - View Configure
    func configureHierarchy() {
        addSubview(stackView)
        
        stackView.addArrangedSubview(starImageView)
        stackView.addArrangedSubview(countLableView)
    }
    
    func configureLayout() {
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(self).inset(8)
        }
        
        starImageView.snp.makeConstraints { make in
            make.size.equalTo(20)
        }
    }
    
    func configureView() {
        backgroundColor = .darkGray
        layer.cornerRadius = 8
        clipsToBounds = true
    }
    
    func configureData(count: Int) {
        let countText = NumberFormatManager.shared.getFormattedNumberText(num: count)
        countLableView.text = countText
    }

}
