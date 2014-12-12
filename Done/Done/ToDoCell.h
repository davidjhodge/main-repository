//
//  ToDoCell.h
//  Done
//
//  Created by David Hodge on 10/15/14.
//  Copyright (c) 2014 Genesis Apps, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ToDoCellDidTapButtonBlock)();

@interface ToDoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property (copy, nonatomic) ToDoCellDidTapButtonBlock didTapButtonBlock;

@end
