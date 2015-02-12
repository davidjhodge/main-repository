//
//  Post.h
//  Social Network
//
//  Created by David Hodge on 10/19/14.
//  Copyright (c) 2014 Genesis Apps, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Post : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * createdAt;
@property (nonatomic, retain) NSString * createdBy;
@property (nonatomic, retain) NSNumber * likes;
@property (nonatomic, retain) NSString * postID;
@property (nonatomic, retain) NSManagedObject *whoPosted;

@end
