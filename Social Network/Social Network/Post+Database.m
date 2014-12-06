//
//  Post+Database.m
//  Social Network
//
//  Created by David Hodge on 10/19/14.
//  Copyright (c) 2014 Genesis Apps, LLC. All rights reserved.
//

#import "Post+Database.h"
#import "AmazonFetcher.h"
//#import "User.h"

@implementation Post (Database)

+ (Post *)postWithInfoFromDatabase:(NSDictionary *)postDictionary inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    Post *post = nil;
    
    //NSFetchRequest
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Post"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO]];
    request.predicate = [NSPredicate predicateWithFormat:@"createdAt = %@",[postDictionary[POST_CREATEDAT] description]];
    
    //Fetch
    NSError *fetchError = nil;
    NSArray *matches = [managedObjectContext executeFetchRequest:request error:&fetchError];
    if (matches)
    
    //If result is correct, create post using database attributes
    if (!matches || matches.count > 1) {
        //error
        NSLog(@"An incorrect result was returned from the database.");
        NSLog(@"%@,%@",fetchError,fetchError.localizedDescription);
    } else if (![matches count]) {
        
        //Post does not exist in MOC so create it
        post = [NSEntityDescription insertNewObjectForEntityForName:@"Post" inManagedObjectContext:managedObjectContext];
        //Set Attributes of Post
        post.postID = [postDictionary[POST_POSTID] description];
        post.content = [postDictionary[POST_CONTENT] description];
        post.createdAt = [postDictionary[POST_CREATEDAT] description];
        post.createdBy = [postDictionary[POST_CREATEDBY] description];
        post.likes = [NSNumber numberWithInt:[postDictionary[POST_LIKES] integerValue]];
        
        NSLog(@"CreatedBy: %@, Content: %@, CreatedAt: %@, Likes: %@", post.createdBy, post.content, post.createdAt, [post.likes stringValue]);
        /*
         NSString *userName = [postDictionary[POST_OWNER] description];
         User *user = [User userWithName:userName inManagedObjectContext:managedObjectContext];
         post.whoPosted = user;
         */

    } else {
        
        //We already have the post, so load the match
        NSLog(@"We already have the post.");
        post = matches.lastObject;
    }
    
    matches = nil;
       
    return post;
}

@end
