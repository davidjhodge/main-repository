//
//  Item.h
//  EventNow
//
//  Created by David Hodge on 12/30/14.
//  Copyright (c) 2014 Genesis Apps, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Item : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic) double price;
@property (nonatomic, strong) UIImage *image;

@end
