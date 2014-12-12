//
//  CreateNewPostVC.h
//  Social Network
//
//  Created by David Hodge on 11/7/14.
//  Copyright (c) 2014 Genesis Apps, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DemoPostTVC.h"

@interface CreateNewPostVC : UIViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end
