//
//  DemoPostTVC.m
//  Social Network
//
//  Created by David Hodge on 10/19/14.
//  Copyright (c) 2014 Genesis Apps, LLC. All rights reserved.
//

#import "DemoPostTVC.h"
#import "AmazonFetcher.h"
#import "Post+Database.h"

@interface DemoPostTVC ()

@end

@implementation DemoPostTVC

#pragma mark - View Controller Lifecycle

// Just sets the Refresh Control's target/action since it can't be set in Xcode (bug?).

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor blackColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.managedObjectContext) [self useContextDocument];
    //[(AppDelegate *)[[UIApplication sharedApplication] delegate] useContextDocument];
}

// Whenever the table is about to appear, if we have not yet opened/created or demo document, do so.

// Either creates, opens or just uses the demo document
//   (actually, it will never "just use" it since it just creates the UIManagedDocument instance here;
//    the "just uses" case is just shown that if someone hands you a UIManagedDocument, it might already
//    be open and so you can just use it if it's documentState is UIDocumentStateNormal).
//
// Creating and opening are asynchronous, so in the completion handler we set our Model (managedObjectContext).

- (void)useContextDocument
{
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"SNTest"];
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
        /*
        [document saveToURL:url
           forSaveOperation:UIDocumentSaveForCreating
          completionHandler:^(BOOL success) {
              if (success) {
                  self.managedObjectContext = nil;
                  [self refresh];
              }
          }];*/
    }
}

#pragma mark - Refreshing

// Fires off a block on a queue to fetch data from Flickr.
// When the data comes back, it is loaded into Core Data by posting a block to do so on
//   self.managedObjectContext's proper queue (using performBlock:).
// Data is loaded into Core Data by calling photoWithFlickrInfo:inManagedObjectContext: category method.

-(IBAction)refresh
{
    [self.refreshControl beginRefreshing];
    dispatch_queue_t fetchQ = dispatch_queue_create("Database Query", NULL);
    dispatch_async(fetchQ, ^{
        NSArray *posts = [AmazonFetcher latestPosts];
        NSLog(@"%@",posts);

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

@end
