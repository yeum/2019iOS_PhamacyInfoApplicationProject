//
//  StardustView.swift
//  Anagrams
//
//  Created by kpugame on 2019. 5. 23..
//  Copyright © 2019년 Caroline. All rights reserved.
//

import Foundation
import UIKit

// ExplodeView와 매우 비슷하다.
class StardustView: UIView {
    private var emitter: CAEmitterLayer!
    
    override class var layerClass: AnyClass {
        return CAEmitterLayer.self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init(frame: ")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        emitter = self.layer as! CAEmitterLayer
        emitter.emitterPosition = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
        emitter.emitterSize = self.bounds.size
        emitter.emitterMode = CAEmitterLayerEmitterMode.volume
        emitter.emitterShape = CAEmitterLayerEmitterShape.rectangle
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if self.superview == nil {
            return
        }
        
        let texture: UIImage? = UIImage(named: "particle")
        assert(texture != nil, "particle image not found")
        
        let emitterCell = CAEmitterCell()
        
        emitterCell.name = "cell"
        emitterCell.contents = texture?.cgImage
        emitterCell.birthRate = 200
        // ExplodeView보다 lifetime이 길다.
        emitterCell.lifetime = 1.5
        emitterCell.redRange = 0.99
        emitterCell.redSpeed = -0.99
        // 오른쪽으로 이동할 때 파티클이 왼쪽으로 흩날린다.
        emitterCell.xAcceleration = -200
        // 파티클이 아래로 떨어진다. 중력효과
        emitterCell.yAcceleration = 100
        emitterCell.velocity = 100
        emitterCell.velocityRange = 40
        emitterCell.scaleRange = 0.5
        emitterCell.scaleSpeed = -0.2
        emitterCell.emissionRange = CGFloat(Double.pi * 2)
        emitter.emitterCells = [emitterCell]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.removeFromSuperview()
        })
    }
}
