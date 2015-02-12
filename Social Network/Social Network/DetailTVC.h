//
//  DetailTVC.h
//  Social Network
//
//  Created by David Hodge on 10/19/14.
//  Copyright (c) 2014 Genesis Apps, LLC. All rights reserved.
//

#import "DemoPostTVC.h"

@interface DetailTVC : UITableViewController //Should not technically inherit from DemoPostTVC

@property (nonatomic, strong) NSString *createdBy;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *likes;
@property (nonatomic, strong) NSIndexPath *selectedIndex;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end
