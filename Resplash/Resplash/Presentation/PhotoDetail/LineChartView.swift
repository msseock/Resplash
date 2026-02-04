//
//  LineChartView.swift
//  Resplash
//
//  Created by 석민솔 on 2/2/26.
//

import UIKit

final class LineChartView: UIView {
    var dataPoints: [CGFloat] = [] {
        didSet {
            setNeedsLayout()
        }
    }
    
    // 그라데이션 레이어
    let gradientLayer = CAGradientLayer()

    // 선 레이어
    let lineLayer = CAShapeLayer()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
                
        layer.addSublayer(gradientLayer)
        layer.addSublayer(lineLayer)

        // 그라데이션 레이어 속성
        gradientLayer.colors = [UIColor.systemBlue.cgColor, UIColor.white.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0) // 위에서
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0) // 아래로

        // 선 레이어 속성
        lineLayer.fillColor = UIColor.clear.cgColor
        lineLayer.strokeColor = UIColor.systemBlue.cgColor
        lineLayer.lineWidth = 3.0
        lineLayer.lineCap = .round
        lineLayer.lineJoin = .round

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard dataPoints.count >= 2 else { return }

        let rect = bounds

        // 데이터를 뷰 높이에 맞게 정규화
        let maxValue = dataPoints.max() ?? 1
        let minValue = dataPoints.min() ?? 0
        let range = maxValue - minValue

        // 선과 그라데이션 마스크 공용 경로
        let linePath = UIBezierPath()

        // 포인트 간 가로 간격 계산
        let horizontalGap = rect.width / CGFloat(dataPoints.count - 1)

        // 데이터 값을 y좌표로 변환 (위 = 최대값, 아래 = 최소값)
        func yPosition(for value: CGFloat) -> CGFloat {
            guard range > 0 else { return rect.height / 2 }
            return rect.height - ((value - minValue) / range) * rect.height
        }

        // 첫 번째 데이터 포인트에서 시작
        var startPoint = CGPoint(x: 0, y: yPosition(for: dataPoints[0]))
        linePath.move(to: startPoint)

        // 포인트들을 선으로 연결
        for i in 0..<dataPoints.count {
            let nextPoint = CGPoint(x: CGFloat(i) * horizontalGap, y: yPosition(for: dataPoints[i]))
            linePath.addLine(to: nextPoint)
            startPoint = nextPoint
        }

        // 선 레이어 경로 설정
        lineLayer.path = linePath.cgPath
        
        // 선 아래 영역을 채우기 위해 경로 닫기 (선 레이어에는 영향 없음)
        linePath.addLine(to: CGPoint(x: rect.width, y: rect.height))
        linePath.addLine(to: CGPoint(x: 0, y: rect.height))
        
        // 그라데이션 마스크용 셰이프 레이어 생성
        let gradientMaskLayer = CAShapeLayer()
        gradientMaskLayer.path = linePath.cgPath
        
        gradientLayer.frame = CGRect(x: 0, y: 0, width: rect.width, height: rect.height)

        // 그라데이션 레이어에 마스크 적용
        gradientLayer.mask = gradientMaskLayer
        
    }
}
