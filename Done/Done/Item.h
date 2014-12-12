//
//  Item.h
//  Done
//
//  Created by David Hodge on 10/17/14.
//  Copyright (c) 2014 Genesis Apps, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Item : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSNumber * done;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) User *user;

@end
