//
//  Loan.swift
//  WorkingWithJSON
//
//  Created by David Hodge on 2/13/15.
//  Copyright (c) 2015 Genesis Apps, LLC. All rights reserved.
//

import UIKit

class Loan: NSObject {
    var name: String
    var location: String
    
    override init()
    {
        name = ""
        location = ""
    }
    
    init(name aName: String, location aLocation: String)
    {
        self.name = aName
        self.location = aLocation
    }
}
