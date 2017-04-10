//
//  AsteroidView.swift
//  Asteroids
//
//  Created by 夏语诚 on 2017/4/10.
//  Copyright © 2017年 Banana Inc. All rights reserved.
//

import UIKit

class AsteroidView: UIImageView
{
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        image = UIImage(named: "asteroid\((arc4random()%9)+1)")
        frame.size = image?.size ?? CGSize.zero
    }
}
