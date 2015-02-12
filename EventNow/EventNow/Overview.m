//
//  Overview.m
//  EventNow
//
//  Created by David Hodge on 12/31/14.
//  Copyright (c) 2014 Genesis Apps, LLC. All rights reserved.
//

#import "Overview.h"

@implementation Overview

static Overview *instance = nil;

+(Overview *)getInstance
{
    @synchronized(self)
    {
        if(instance==nil)
        {
            instance= [Overview new];
        }
    }
    return instance;
}

+(void)addObjectToArrayInstance:(Item *)anItem
{
    [instance.overviewArray addObject:anItem];
}

@end
