//
//  ProfileViewController.swift
//  Resplash
//
//  Created by 석민솔 on 2/3/26.
//

import UIKit

import SnapKit

class ProfileViewController: BaseViewController {
    let yearTextField = UITextField()
    let monthTextField = UITextField()
    let dayTextField = UITextField()
    let enterButton = UIButton()
    let resultLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureHierarchy() {
        view.addSubview(yearTextField)
        view.addSubview(monthTextField)
        view.addSubview(dayTextField)
        view.addSubview(enterButton)
        view.addSubview(resultLabel)
    }

    override func configureLayout() {
        yearTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        
        monthTextField.snp.makeConstraints { make in
            make.top.equalTo(yearTextField.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(yearTextField)
            make.height.equalTo(50)
        }
        
        dayTextField.snp.makeConstraints { make in
            make.top.equalTo(monthTextField.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(yearTextField)
            make.height.equalTo(50)
        }
        
        enterButton.snp.makeConstraints { make in
            make.top.equalTo(dayTextField.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(yearTextField)
            make.height.equalTo(90)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(enterButton.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(yearTextField)
        }
    }

    override func configureView() {
        super.configureView()
        yearTextField.placeholder = "출생년도 ex. 2026"
        yearTextField.borderStyle = .roundedRect
        
        monthTextField.placeholder = "출생월 ex. 2"
        monthTextField.borderStyle = .roundedRect
        
        dayTextField.placeholder = "출생일 ex. 3"
        dayTextField.borderStyle = .roundedRect
        
        enterButton.setTitle("입력", for: .normal)
        enterButton.titleLabel?.numberOfLines = 0
        enterButton.titleLabel?.textAlignment = .center
        enterButton.backgroundColor = .systemBlue
        enterButton.addTarget(self, action: #selector(enterButtonTapped), for: .touchUpInside)
        enterButton.layer.cornerRadius = 12
        enterButton.clipsToBounds = true

        resultLabel.text = "생일을 입력해주세요"
        resultLabel.numberOfLines = 0
        resultLabel.textAlignment = .center
    }
}


// MARK: - Logic
extension ProfileViewController {
    enum BirthDateType {
        case year
        case month
        case day
    }
    
    @objc private func enterButtonTapped() {
        print(#function)
        var resultText = ""
        var errorText = ""
        
        do {
            let year = try validateText(text: yearTextField.text!, type: .year)
            resultText += year + "년 "
        } catch {
            errorText += "출생년도가 " + error.localizedDescription + "\n"
        }
        
        do {
            let month = try validateText(text: monthTextField.text!, type: .month)
            resultText += month + "월 "

        } catch {
            errorText += "출생월이 " + error.localizedDescription + "\n"
        }
        
        do {
            let day = try validateText(text: dayTextField.text!, type: .day)
            resultText += day + "일"

        } catch {
            errorText += "출생일이 " + error.localizedDescription
        }
        
        if !errorText.isEmpty {
            enterButton.setTitle(errorText, for: .normal)
            resultLabel.text = "생년월일을 다시 입력해주세요"
        } else {
            enterButton.setTitle("입력", for: .normal)
            resultLabel.text = resultText
        }
    }
    
    private func validateText(text: String, type: BirthDateType) throws(ValidationError) -> String {
        guard !text.isEmpty else {
            throw .emptyString
        }
        
        guard let number = Int(text) else {
            throw .isNotInt
        }
        
        switch type {
        case .year:
            guard number > 1800 && number < 2027 else {
                throw .unavailable
            }
        case .month:
            guard number >= 1 && number <= 12 else {
                throw .unavailable
            }
        case .day:
            guard number >= 1 && number <= 31 else {
                throw .unavailable
            }
        }
        
        return text
    }
}


enum ValidationError: Error, LocalizedError {
    case emptyString
    case isNotInt
    case unavailable
    
    var errorDescription: String? {
        switch self {
        case .emptyString:
            "비어있습니다"
        case .isNotInt:
            "숫자가 아닙니다"
        case .unavailable:
            "불가능합니다"
        }
    }
}
