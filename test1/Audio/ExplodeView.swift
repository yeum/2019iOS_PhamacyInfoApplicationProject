//
//  ExplodeView.swift
//  Anagrams
//
//  Created by kpugame on 2019. 5. 23..
//  Copyright © 2019년 Caroline. All rights reserved.
//

import Foundation
import UIKit

class ExplodeView: UIView {
    // CAEmitterLayer 변수
    private var emitter: CAEmitterLayer!
    // UIView class 메소드: CALayer가 아니라 CAEmitterLayer 리턴
    override class var layerClass: AnyClass {
        return CAEmitterLayer.self
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init(frame: ")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 파이클 표현을 위해서 emitter cell을 생성하고 설정
        emitter = self.layer as! CAEmitterLayer
        emitter.emitterPosition = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
        emitter.emitterSize = self.bounds.size
        emitter.emitterMode = CAEmitterLayerEmitterMode.volume
        emitter.emitterShape = CAEmitterLayerEmitterShape.rectangle
    }
    
    override func didMoveToSuperview() {
        // 1. 부모의 didMoveToSuperView()를 호출하고 superView가 없다면 exit
        super.didMoveToSuperview()
        if self.superview == nil {
            return
        }
        // 2. particle.png 파일 UIImage로 로딩
        let texture: UIImage? = UIImage(named: "particle")
        assert(texture != nil, "particle image not found")
        // 3. emitterCell 생성, 뒤에는 설정
        let emitterCell = CAEmitterCell()
        
        // name 설정
        emitterCell.name = "cell"
        // contents는 texture 이미지로
        emitterCell.contents = texture?.cgImage
        // 1초에 200개 생성
        emitterCell.birthRate = 200
        // 1개 particle은 0.75초 동안 생존
        emitterCell.lifetime = 0.75
        // 랜덤색깔 rgb(1,1,1) ~ (1,0.01,1) white~purple
        emitterCell.greenRange = 0.99
        // 시간이 지나면서 blue 색을 줄인다
        emitterCell.greenSpeed = -0.99
        // 셀의 속도 범위 160-40 ~ 160+40
        emitterCell.velocity = 160
        emitterCell.velocityRange = 40
        // 셀크기 1.0-0.5 ~ 1.0+0.5
        emitterCell.scaleRange = 0.5
        // 셀크기 감소 속도
        emitterCell.scaleSpeed = -0.2
        // 셀 생성 방향 360도
        emitterCell.emissionRange = CGFloat(Double.pi * 2)
        // emitterCell 배열에 넣는다.
        emitter.emitterCells = [emitterCell]
        
        // 2초 후에 파티클 remove
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.removeFromSuperview()
        })
    }
}
