//
//  Hours.swift
//  What's Poppin?
//
//  Created by David Hodge on 2/11/15.
//  Copyright (c) 2015 Genesis Apps, LLC. All rights reserved.
//

import UIKit

class Hours: NSObject {
    let openingTime: String
    let closingTime: String
    
    override init() {
            
            openingTime = "-1"
            closingTime = "-1"
    }
    
    init(openingTime theOpeningTime: String, closingTime theClosingTime: String)
    {
        openingTime = theOpeningTime
        closingTime = theClosingTime
    }
    
    
}
