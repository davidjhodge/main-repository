//
//  PostCell.h
//  Social Network
//
//  Created by David Hodge on 10/19/14.
//  Copyright (c) 2014 Genesis Apps, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *createdByLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (nonatomic) BOOL likesAreEnabled;

- (IBAction)like:(id)sender;

@end
