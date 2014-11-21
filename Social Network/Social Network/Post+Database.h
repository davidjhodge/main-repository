//
//  Post+Database.h
//  Social Network
//
//  Created by David Hodge on 10/19/14.
//  Copyright (c) 2014 Genesis Apps, LLC. All rights reserved.
//

#import "Post.h"

@interface Post (Database)

+ (Post *)postWithInfoFromDatabase:(NSDictionary *)postDictionary inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
