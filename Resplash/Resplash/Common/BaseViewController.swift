//
//  BaseViewController.swift
//  Resplash
//
//  Created by 석민솔 on 1/28/26.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureView()
    }


    /// subview들의 계층구조를 정의
    func configureHierarchy() {
    }

    /// snapkit을 활용해서 constraints를 설정
    func configureLayout() {
    }

    /// view 자체적인 설정
    func configureView() {
        view.backgroundColor = .white
    }

}
