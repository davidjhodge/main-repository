//
//  Item+Create.h
//  EventNow
//
//  Created by David Hodge on 12/30/14.
//  Copyright (c) 2014 Genesis Apps, LLC. All rights reserved.
//

#import "Item.h"

@interface Item (Create)

+(Item *)itemWithTitle:(NSString *)aTitle price:(double)aPrice iconImage:(UIImage *)anImage;
+(NSString *)getPriceStringFromDouble:(double)aDouble;
//+(void)addToCheckOutWithTitle:(NSString *)aTitle price:(double)aPrice iconImage:(UIImage *)anImage;

@end
