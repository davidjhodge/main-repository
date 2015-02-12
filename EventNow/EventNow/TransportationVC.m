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
#import "Item+Create.h"
#import "Overview.h"

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
    
    //Adds item to cart
#warning Need to get this from online dictionary of services
    //[Item addToCheckOutWithTitle:@"Uber" price:[self getUberPrice] iconImage:[UIImage imageNamed:@"27-planet.png"]];
    Item *item = [Item itemWithTitle:@"Uber" price:[self getUberPrice] iconImage:[UIImage imageNamed:@"27-planet.png"]];
    [Overview addObjectToArrayInstance:item];
    
    Overview *newInstance = [Overview getInstance];
    NSLog(@"%lu",(unsigned long)newInstance.overviewArray.count);

    Item *test = newInstance.overviewArray[0];
    NSLog(@"%@",test.title);
    
    sender.enabled = NO;
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(double)getUberPrice
{
    return 10.43;
}

#warning openUber
-(void)openUber
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"uber://?action=setPickup&pickup=my_location"]];
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
