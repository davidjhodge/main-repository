//
//  CustomVC.m
//  OrganizeNow
//
//  Created by David Hodge on 1/7/15.
//  Copyright (c) 2015 Genesis Apps, LLC. All rights reserved.
//

#import "CustomVC.h"

@implementation CustomVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                   [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                   [UIFont fontWithName:@"GillSans-Light" size:25], NSFontAttributeName, nil];
    
    //Change nav bar font to white
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

@end
