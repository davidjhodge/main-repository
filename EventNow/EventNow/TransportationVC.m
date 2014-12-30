//
//  TransportationVC.m
//  EventNow
//
//  Created by David Hodge on 12/29/14.
//  Copyright (c) 2014 Genesis Apps, LLC. All rights reserved.
//

#import "TransportationVC.h"
#import "AppDelegate.h"
#import "HomeVC.h"

@interface TransportationVC ()

@end

@implementation TransportationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Uber";
}

- (IBAction)payUber:(UIButton*)sender {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.price += [self getUberPrice];
    
    sender.enabled = NO;
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(double)getUberPrice
{
    return 10.43;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
