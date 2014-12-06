//
//  AmazonFetcher.h
//  Social Network
//
//  Created by David Hodge on 10/19/14.
//  Copyright (c) 2014 Genesis Apps, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AmazonFetcher : NSObject

#define POST_POSTID @"postID"
#define POST_CONTENT @"content"
#define POST_CREATEDAT @"createdAt"
#define POST_CREATEDBY @"whoPosted"
#define POST_LIKES @"likes"

+ (NSString *)getUUID;
+ (NSArray *)latestPosts;
+ (NSArray *)myPosts;
+ (void)like;
+ (void)unlike;

@end
