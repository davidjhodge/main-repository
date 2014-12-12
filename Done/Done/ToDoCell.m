//
//  ToDoCell.m
//  Done
//
//  Created by David Hodge on 10/15/14.
//  Copyright (c) 2014 Genesis Apps, LLC. All rights reserved.
//

#import "ToDoCell.h"

@implementation ToDoCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    //Setup View
    [self setupView];
}

-(void)setupView
{
    [self.doneButton setTitle:@"" forState:UIControlStateNormal];
    [self.doneButton setTitle:@"" forState:UIControlStateDisabled];
    [self.doneButton setTitle:@"" forState:UIControlStateSelected];
    [self.doneButton setTitle:@"" forState:UIControlStateHighlighted];
    
    UIImage *imageNormal = [UIImage imageNamed:@"button-done-normal"];
    UIImage *imageSelected = [UIImage imageNamed:@"button-done-selected"];
    
    [self.doneButton setImage:imageNormal forState:UIControlStateNormal];
    [self.doneButton setImage:imageNormal forState:UIControlStateDisabled];
    [self.doneButton setImage:imageSelected forState:UIControlStateSelected];
    [self.doneButton setImage:imageSelected forState:UIControlStateHighlighted];
    [self.doneButton addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)didTapButton:(UIButton *)button
{
    if (self.didTapButtonBlock) {
        self.didTapButtonBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
