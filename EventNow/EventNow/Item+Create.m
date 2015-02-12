//
//  Item+Create.m
//  EventNow
//
//  Created by David Hodge on 12/30/14.
//  Copyright (c) 2014 Genesis Apps, LLC. All rights reserved.
//

#import "Item+Create.h"
#import "OverviewVC.h"

@implementation Item (Create)

+(Item *)itemWithTitle:(NSString *)aTitle price:(double)aPrice iconImage:(UIImage *)anImage
{
    Item *item = [[Item alloc] init];
    
    item.title = aTitle;
    item.price = aPrice;
    item.image = anImage;
    
    return item;
}

//Formats a double in price format.
+(NSString *)getPriceStringFromDouble:(double)aDouble
{
    NSNumber *number = [NSNumber numberWithDouble:aDouble];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSString *groupingSeperator = [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator];
    [formatter setGroupingSeparator:groupingSeperator];
    [formatter setGroupingSize:3];
    [formatter setAlwaysShowsDecimalSeparator:NO];
    [formatter setUsesGroupingSeparator:YES];
    
    return [NSString stringWithFormat:@" %@",[formatter stringFromNumber:number]];
}
/*
+(void)addToCheckOutWithTitle:(NSString *)aTitle price:(double)aPrice iconImage:(UIImage *)anImage
{
#warning This needs to reference the actual vc, not a new instance of it
    OverviewVC *vc = [[OverviewVC alloc]init];
    
    Item *item = [Item itemWithTitle:aTitle price:aPrice iconImage:anImage];
    
    [vc.items addObject:item];
    
}
*/
@end
