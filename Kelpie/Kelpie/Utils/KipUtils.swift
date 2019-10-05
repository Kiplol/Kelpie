//
//  KipUtils.swift
//  Kelpie
//
//  Created by Elliott Kipper on 10/5/19.
//  Copyright © 2019 Kip. All rights reserved.
//

import UIKit

extension CGPoint {
    
    func distance(from otherPoint: CGPoint) -> CGFloat {
        let xDistance = otherPoint.x - self.x
        let yDistance = otherPoint.y - self.y
        return sqrt(pow(xDistance, 2.0) + pow(yDistance, 2.0))
    }
    
}
