//
//  Overview.h
//  EventNow
//
//  Created by David Hodge on 12/31/14.
//  Copyright (c) 2014 Genesis Apps, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"

@interface Overview : NSObject

@property (nonatomic, strong) NSMutableArray *overviewArray;

+(Overview *)getInstance;
+(void)addObjectToArrayInstance:(Item *)anItem;

@end
