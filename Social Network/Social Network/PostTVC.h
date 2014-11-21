//
//  PostTVC.h
//  Social Network
//
//  Created by David Hodge on 10/19/14.
//  Copyright (c) 2014 Genesis Apps, LLC. All rights reserved.
//

#import "CoreDataTVC.h"

@interface PostTVC : CoreDataTVC

//Specifies which database to look in to display all the recent posts in this table
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
