//
//  MyPostsTVC.m
//  Social Network
//
//  Created by David Hodge on 11/8/14.
//  Copyright (c) 2014 Genesis Apps, LLC. All rights reserved.
//

#import "MyPostsTVC.h"
#import "AmazonFetcher.h"
#import "Post+Database.h"

@interface MyPostsTVC ()

@end

@implementation MyPostsTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor blackColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
}

// Either creates, opens or just uses the demo document
//   (actually, it will never "just use" it since it just creates the UIManagedDocument instance here;
//    the "just uses" case is just shown that if someone hands you a UIManagedDocument, it might already
//    be open and so you can just use it if it's documentState is UIDocumentStateNormal).
//
// Creating and opening are asynchronous, so in the completion handler we set our Model (managedObjectContext).

- (void)useContextDocument
{
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"Test MyPosts"];
    //Remove All Posts
    //NSError *error = nil;
    //[[NSFileManager defaultManager] removeItemAtPath: [url absoluteString] error: &error];
    
    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
        [document saveToURL:url
           forSaveOperation:UIDocumentSaveForCreating
          completionHandler:^(BOOL success) {
              if (success) {
                  self.managedObjectContext = document.managedObjectContext;
                  [self refresh];
              }
          }];
    } else if (document.documentState == UIDocumentStateClosed) {
        [document openWithCompletionHandler:^(BOOL success) {
            if (success) {
                self.managedObjectContext = document.managedObjectContext;
            }
        }];
    } else {
        self.managedObjectContext = document.managedObjectContext;
    }
    
}

-(IBAction)refresh
{
    [self.refreshControl beginRefreshing];
    dispatch_queue_t fetchQ = dispatch_queue_create("Database Query", NULL);
    dispatch_async(fetchQ, ^{
        NSArray *posts = [AmazonFetcher myPosts];
        
        //Put these photos into Core Data
        [self.managedObjectContext performBlock:^{
            
            for (NSDictionary *post in posts) {
                [Post postWithInfoFromDatabase:post inManagedObjectContext:self.managedObjectContext];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.refreshControl endRefreshing];
            });
        }];
    });
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
