//
//  CustomSearchDisplayVC.m
//  OrganizeNow
//
//  Created by David Hodge on 1/8/15.
//  Copyright (c) 2015 Genesis Apps, LLC. All rights reserved.
//

#import "CustomSearchDisplayVC.h"

@implementation CustomSearchDisplayVC

- (void)setActive:(BOOL)visible animated:(BOOL)animated;
{
    if(self.active == visible) return;
    [self.searchContentsController.navigationController setNavigationBarHidden:YES animated:NO];
    [super setActive:visible animated:animated];
    [self.searchContentsController.navigationController setNavigationBarHidden:NO animated:NO];
    if (visible) {
        [self.searchBar becomeFirstResponder];
    } else {
        [self.searchBar resignFirstResponder];
    }
}

@end
