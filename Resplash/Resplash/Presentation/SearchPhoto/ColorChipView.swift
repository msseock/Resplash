//
//  ColorChipView.swift
//  Resplash
//
//  Created by 석민솔 on 1/28/26.
//

import UIKit

import SnapKit

final class ColorChipView: UIView {
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
    
    let colorCircleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        return view
    }()
        
    let colorNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    // data
    var color: UnsplashColor = .black
    var isSelected: Bool = false
    
    // MARK: - init
    override init(frame: CGRect) {
        super .init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // custom init
    init(color: UnsplashColor, isSelected: Bool) {
        super .init(frame: .zero)
        configureData(color: color, isSelected: isSelected)
        configureHierarchy()
        configureLayout()
        configureView()
        
    }
    
    // MARK: - View Configure
    func configureHierarchy() {
        addSubview(stackView)
        
        stackView.addArrangedSubview(colorCircleView)
        stackView.addArrangedSubview(colorNameLabel)
    }
    
    func configureLayout() {
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(self).inset(8)
        }
        
        colorCircleView.snp.makeConstraints { make in
            make.size.equalTo(20)
        }
    }
    
    func configureView() {
        layer.cornerRadius = 17
        clipsToBounds = true
    }
    
    func configureData(color: UnsplashColor, isSelected: Bool) {
        self.color = color
        self.isSelected = isSelected

        backgroundColor = isSelected ? .systemBlue : .secondarySystemBackground
        colorNameLabel.text = color.desc
        colorNameLabel.textColor = isSelected ? .white : .black
        colorCircleView.backgroundColor = color.color
    }

}
