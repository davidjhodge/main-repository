//
//  LoanTableCell.swift
//  WorkingWithJSON
//
//  Created by David Hodge on 2/13/15.
//  Copyright (c) 2015 Genesis Apps, LLC. All rights reserved.
//

import UIKit

class LoanTableCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
