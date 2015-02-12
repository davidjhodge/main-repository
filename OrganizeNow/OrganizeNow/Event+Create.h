//
//  Event+Create.h
//  OrganizeNow
//
//  Created by David Hodge on 1/7/15.
//  Copyright (c) 2015 Genesis Apps, LLC. All rights reserved.
//

#import "Event.h"

@interface Event (Create)

+ (Event *)createEventWithName:(NSString *)aName
                     startTime:(NSDate *)aStartTime
                       endTime:(NSDate *)anEndTime
                      location:(NSString *)aLocation
                   description:(NSString *)description
                    goingCount:(NSInteger)aCount;

@end
