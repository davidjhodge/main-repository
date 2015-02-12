//
//  AmazonFetcher.m
//  Social Network
//
//  Created by David Hodge on 10/19/14.
//  Copyright (c) 2014 Genesis Apps, LLC. All rights reserved.
//

#import "AmazonFetcher.h"

@implementation AmazonFetcher
/*
-(void)uploadPost
{
    NSString *uuid = [AmazonFetcher getUUID];
    
    NSString *urlString = [NSString stringWithFormat:@"http://ec2-54-84-9-63.compute-1.amazonaws.com/php/TestServiceUploadPost.php?content=%@&likes=0&whoPosted=%@",self.content,uuid];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    //Content is dynamic, createdAt is already set, likes start at 0, and the user is entered
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [conn start];
}
*/
+ (NSString *)getUUID
{
    NSString *uuid = [[NSUserDefaults standardUserDefaults] valueForKey:@"uuid"];
    
    if (uuid != nil) {
        return uuid;
        }
    
    NSString *newUUID = [[NSUUID UUID] UUIDString];
    [[NSUserDefaults standardUserDefaults] setValue:newUUID forKey:@"uuid"];
    return newUUID;
}

+ (NSDictionary *)executeAmazonFetch:(NSString *)query
{
    query = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:query] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
    
    return results;
}

//Get 100 most recent posts
+(NSArray *)latestPosts
{
    NSString *requestLink = [NSString stringWithFormat:@"http://ec2-54-84-9-63.compute-1.amazonaws.com/php/TestService.php"];
    //NSString *sql = [NSString stringWithFormat:@"sql=SELECT * FROM Posts LIMIT 100"];
    //requestLink = [requestLink stringByAppendingString:sql];
    return [self executeAmazonFetch:requestLink];
}

//Get user's recent posts (limit 100)
+(NSArray *)myPosts
{
    NSString *requestLink = [NSString stringWithFormat:@"http://genesisappsonline.com/TestServiceMyPosts.php?whoPosted="];
    NSString *uuid = [self getUUID];
    requestLink = [requestLink stringByAppendingString:uuid];
    return [self executeAmazonFetch:requestLink];
}

@end
