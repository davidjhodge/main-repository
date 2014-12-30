//
//  HomeVC.h
//  EventNow
//
//  Created by David Hodge on 12/29/14.
//  Copyright (c) 2014 Genesis Apps, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndustryCell.h"
#import "Industry+Create.h"

@interface HomeVC : UIViewController <UITableViewDataSource,UITableViewDelegate>

//@property (nonatomic, strong) IndustryCell *cell;
-(void)setTotal;

@end
