//
//  UpdateToDoViewController.h
//  Done
//
//  Created by David Hodge on 10/17/14.
//  Copyright (c) 2014 Genesis Apps, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Item.h"

@interface UpdateToDoViewController : UIViewController

-(void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
-(void)setRecord:(Item *)record;

@end
