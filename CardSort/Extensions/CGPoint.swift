//
//  CGPoint.swift
//  CardSort
//
//  Created by Omer Karayel on 16.11.2018.
//  Copyright © 2018 Omer Karayel. All rights reserved.
//

import UIKit

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        // there is already a function for sqrt(x * x + y * y)
        return hypot(self.x - point.x, self.y - point.y)
    }
}
