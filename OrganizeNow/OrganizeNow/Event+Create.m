//
//  Event+Create.m
//  OrganizeNow
//
//  Created by David Hodge on 1/7/15.
//  Copyright (c) 2015 Genesis Apps, LLC. All rights reserved.
//

#import "Event+Create.h"

@implementation Event (Create)

+ (Event *)createEventWithName:(NSString *)aName
                    startTime:(NSDate *)aStartTime
                      endTime:(NSDate *)anEndTime
                     location:(NSString *)aLocation
                  description:(NSString *)aDescription
                   goingCount:(NSInteger)aCount;
{
    Event *event = [[Event alloc] init];
    event.name = aName;
    event.startTime = aStartTime;
    event.endTime = anEndTime;
    event.location = aLocation;
    event.description = aDescription;
    event.goingCount = aCount;
    
    return event;
}

@end
