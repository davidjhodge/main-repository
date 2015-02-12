//
//  RoundedEdgeButton.swift
//  What's Poppin?
//
//  Created by David Hodge on 2/1/15.
//  Copyright (c) 2015 Genesis Apps, LLC. All rights reserved.
//

import UIKit
import QuartzCore


class RoundedEdgeButton: UIButton {

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        self.layer.cornerRadius = 10
    }
}
