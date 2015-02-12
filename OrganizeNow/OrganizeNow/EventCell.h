//
//  EventCell.h
//  OrganizeNow
//
//  Created by David Hodge on 1/7/15.
//  Copyright (c) 2015 Genesis Apps, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *headcountLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
