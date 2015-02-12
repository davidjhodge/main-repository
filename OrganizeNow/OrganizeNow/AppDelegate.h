//
//  AppDelegate.h
//  OrganizeNow
//
//  Created by David Hodge on 1/7/15.
//  Copyright (c) 2015 Genesis Apps, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) Event *userCreatedEvent;

@end

